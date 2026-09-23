import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import {
  backdateStart, balance, createCaller, createCompanion, getCall, resetState, setRate, ticks,
} from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";
import { busyKey, ONLINE_SET } from "../billing/engine.js";
import { dropStalePresence } from "../presence.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); h.push.sent.length = 0; });

async function world(coins = 100) {
  await setRate(h, "ta", "audio", 10, 300);
  await setRate(h, "ta", "video", 25, 700);
  const caller = await createCaller(h, coins);
  const companion = await createCompanion(h);
  return {
    caller, companion,
    callerToken: await tokenFor(h, caller, "caller"),
    companionToken: await tokenFor(h, companion, "companion"),
  };
}

/** Rings, answers and connects a call through the API + webhooks. */
async function connected(w: Awaited<ReturnType<typeof world>>) {
  const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
    token: w.callerToken, body: { companionId: w.companion, type: "audio" },
  }));
  await call(h, "POST", `/v1/calls/${start.callId}/accept`, { token: w.companionToken });
  await webhook(h, { event: "participant_joined", room: start.room, identity: w.caller });
  await webhook(h, { event: "participant_joined", room: start.room, identity: w.companion });
  return start;
}

describe("home: online companions", () => {
  it("lists online, approved companions who speak the language, with their rates, free ones first", async () => {
    const w = await world();
    const busy = await createCompanion(h);
    await createCompanion(h, { language: "te" });          // wrong language
    await createCompanion(h, { kyc: "pending" });          // not verified
    await createCompanion(h, { online: false });           // offline
    await h.redis.set(busyKey(busy), "someone");

    const r = json<{ companions: { id: string; busy: boolean; rates: unknown }[] }>(
      await call(h, "GET", "/v1/companions/online?language=ta", { token: w.callerToken }));
    expect(r.companions.map((c) => [c.id, c.busy])).toEqual([[w.companion, false], [busy, true]]);
    expect(r.companions[0]!.rates).toEqual({ audioCoinsPerMin: 10, videoCoinsPerMin: 25 });
  });

  it("hides companions who blocked me or whom I blocked", async () => {
    const w = await world();
    await h.db.query(`INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2)`, [w.companion, w.caller]);
    const r = json<{ companions: unknown[] }>(
      await call(h, "GET", "/v1/companions/online?language=ta", { token: w.callerToken }));
    expect(r.companions).toEqual([]);
  });
});

describe("companion presence", () => {
  it("only approved companions can go online; the heartbeat keeps them there", async () => {
    const w = await world();
    await h.redis.srem(ONLINE_SET, w.companion);

    expect(errorCode(await call(h, "POST", "/v1/companion/presence", { token: w.callerToken, body: { online: true } })))
      .toBe("WRONG_ROLE");
    const pending = await createCompanion(h, { kyc: "pending", online: false });
    const pendingToken = await tokenFor(h, pending, "companion");
    expect(errorCode(await call(h, "POST", "/v1/companion/presence", { token: pendingToken, body: { online: true } })))
      .toBe("KYC_NOT_APPROVED");

    await call(h, "POST", "/v1/companion/presence", { token: w.companionToken, body: { online: true } });
    expect(await h.redis.sismember(ONLINE_SET, w.companion)).toBe(1);
    expect(await dropStalePresence(h.redis)).toBe(0);

    await h.redis.del(`presence:hb:${w.companion}`);        // app crashed, heartbeat expired
    expect(await dropStalePresence(h.redis)).toBe(1);
    expect(await h.redis.sismember(ONLINE_SET, w.companion)).toBe(0);
  });
});

describe("a full call through the API", () => {
  it("ring → push → accept → both join → charged per minute → hang up → details → rating", async () => {
    const w = await world();
    await h.db.query(`INSERT INTO devices (fcm_token, user_id) VALUES ('fcm-companion-token-000000', $1)`, [w.companion]);

    const startRes = await call(h, "POST", "/v1/calls", { token: w.callerToken, body: { companionId: w.companion, type: "audio" } });
    expect(startRes.statusCode).toBe(201);
    const start = json<{ callId: string; room: string; token: string; liveKitUrl: string; coinsPerMin: number }>(startRes);
    expect(start).toMatchObject({ liveKitUrl: "wss://livekit.test", coinsPerMin: 10 });
    expect(start.token).toContain(w.caller);
    expect(start.token).not.toContain(w.companion);          // the caller never gets the companion's token
    expect(h.push.sent).toEqual([{
      tokens: ["fcm-companion-token-000000"],
      push: { callId: start.callId, callType: "audio", callerName: "Test caller", callerAvatarId: 1 },
    }]);

    const accept = json<{ token: string }>(await call(h, "POST", `/v1/calls/${start.callId}/accept`, { token: w.companionToken }));
    expect(accept.token).toContain(w.companion);

    await webhook(h, { event: "participant_joined", room: start.room, identity: w.caller });
    expect(await balance(h, w.caller, "coins")).toBe(100);   // one side joined: nothing charged
    await webhook(h, { event: "participant_joined", room: start.room, identity: w.companion });
    await webhook(h, { event: "participant_joined", room: start.room, identity: w.companion }); // retry
    expect(await balance(h, w.caller, "coins")).toBe(90);
    expect(await ticks(h, start.callId)).toEqual([1]);

    await backdateStart(h, start.callId, 40);
    const end = await call(h, "POST", `/v1/calls/${start.callId}/end`, { token: w.callerToken });
    expect(json(end)).toMatchObject({
      status: "ended", endReason: "caller_hangup", direction: "outgoing", minutesCharged: 1,
      coinsCharged: 10, coinsRefunded: 0, other: { id: w.companion, displayName: "Test companion" },
    });

    const details = json<{ minutes: unknown[] }>(await call(h, "GET", `/v1/calls/${start.callId}`, { token: w.callerToken }));
    expect(details.minutes).toEqual([expect.objectContaining({ minuteNo: 1, coins: 10, paise: 0 })]);
    const companionView = json<{ direction: string; paiseEarned: number; minutes: unknown[] }>(
      await call(h, "GET", `/v1/calls/${start.callId}`, { token: w.companionToken }));
    expect(companionView).toMatchObject({ direction: "incoming", paiseEarned: 300 });
    expect(companionView.minutes).toEqual([expect.objectContaining({ coins: 0, paise: 300 })]);

    expect((await call(h, "POST", `/v1/calls/${start.callId}/rating`, { token: w.callerToken, body: { stars: 5 } })).statusCode).toBe(204);
    expect(errorCode(await call(h, "POST", `/v1/calls/${start.callId}/rating`, { token: w.callerToken, body: { stars: 1 } })))
      .toBe("ALREADY_RATED");
    const listed = json<{ companions: { rating: number; ratingCount: number }[] }>(
      await call(h, "GET", "/v1/companions/online?language=ta", { token: w.callerToken }));
    expect(listed.companions[0]).toMatchObject({ rating: 5, ratingCount: 1 });
  });

  it("shows a grace-period refund in the call details", async () => {
    const w = await world();
    const start = await connected(w);
    const end = json(await call(h, "POST", `/v1/calls/${start.callId}/end`, { token: w.companionToken }));
    expect(end).toMatchObject({ endReason: "companion_hangup", coinsCharged: 10, coinsRefunded: 10 });
    expect(json(await call(h, "GET", `/v1/calls/${start.callId}`, { token: w.companionToken })))
      .toMatchObject({ paiseEarned: 0 });
  });

  it("maps billing refusals to clear HTTP errors", async () => {
    const w = await world(5);
    const r = await call(h, "POST", "/v1/calls", { token: w.callerToken, body: { companionId: w.companion, type: "audio" } });
    expect([r.statusCode, errorCode(r)]).toEqual([402, "INSUFFICIENT_BALANCE"]);

    const rich = await tokenFor(h, await createCaller(h, 500), "caller");
    await call(h, "POST", "/v1/calls", { token: rich, body: { companionId: w.companion, type: "audio" } });
    const busy = await call(h, "POST", "/v1/calls", {
      token: await tokenFor(h, await createCaller(h, 500), "caller"), body: { companionId: w.companion, type: "audio" },
    });
    expect([busy.statusCode, errorCode(busy)]).toEqual([409, "BUSY"]);
  });

  it("companions can't start calls, and only the called companion can accept", async () => {
    const w = await world();
    expect(errorCode(await call(h, "POST", "/v1/calls", { token: w.companionToken, body: { companionId: w.companion, type: "audio" } })))
      .toBe("WRONG_ROLE");

    const start = json<{ callId: string }>(await call(h, "POST", "/v1/calls", {
      token: w.callerToken, body: { companionId: w.companion, type: "audio" },
    }));
    const other = await tokenFor(h, await createCompanion(h), "companion");
    expect((await call(h, "POST", `/v1/calls/${start.callId}/accept`, { token: other })).statusCode).toBe(404);
  });

  it("companion declines: the call is rejected and nothing is charged", async () => {
    const w = await world();
    const start = json<{ callId: string }>(await call(h, "POST", "/v1/calls", {
      token: w.callerToken, body: { companionId: w.companion, type: "audio" },
    }));
    expect((await call(h, "POST", `/v1/calls/${start.callId}/reject`, { token: w.companionToken })).statusCode).toBe(204);
    expect((await getCall(h, start.callId)).status).toBe("rejected");
    expect(errorCode(await call(h, "POST", `/v1/calls/${start.callId}/accept`, { token: w.companionToken })))
      .toBe("CALL_NOT_RINGING");
    expect(errorCode(await call(h, "POST", `/v1/calls/${start.callId}/rating`, { token: w.callerToken, body: { stars: 4 } })))
      .toBe("CALL_NOT_RATEABLE");
    expect(await balance(h, w.caller, "coins")).toBe(100);
  });

  it("lists call history newest first for both sides", async () => {
    const w = await world();
    for (let i = 0; i < 3; i++) {
      const s = json<{ callId: string }>(await call(h, "POST", "/v1/calls", {
        token: w.callerToken, body: { companionId: w.companion, type: "audio" },
      }));
      await call(h, "POST", `/v1/calls/${s.callId}/end`, { token: w.callerToken });
    }
    const page = json<{ calls: { status: string; direction: string }[]; nextBefore: string }>(
      await call(h, "GET", "/v1/calls?limit=2", { token: w.callerToken }));
    expect(page.calls).toHaveLength(2);
    expect(page.calls[0]).toMatchObject({ status: "missed", direction: "outgoing" });
    const rest = json<{ calls: unknown[] }>(await call(h, "GET", `/v1/calls?limit=2&before=${page.nextBefore}`, { token: w.callerToken }));
    expect(rest.calls).toHaveLength(1);
    const theirs = json<{ calls: { direction: string }[] }>(await call(h, "GET", "/v1/calls", { token: w.companionToken }));
    expect(theirs.calls.map((c) => c.direction)).toEqual(["incoming", "incoming", "incoming"]);
  });

  it("a stranger can't see or end someone else's call", async () => {
    const w = await world();
    const start = json<{ callId: string }>(await call(h, "POST", "/v1/calls", {
      token: w.callerToken, body: { companionId: w.companion, type: "audio" },
    }));
    const stranger = await tokenFor(h, await createCaller(h, 0), "caller");
    expect((await call(h, "GET", `/v1/calls/${start.callId}`, { token: stranger })).statusCode).toBe(404);
    expect((await call(h, "POST", `/v1/calls/${start.callId}/end`, { token: stranger })).statusCode).toBe(404);
    expect((await getCall(h, start.callId)).status).toBe("ringing");
  });
});

describe("instant match", () => {
  it("rings a free companion who speaks the language", async () => {
    const w = await world();
    const busy = await createCompanion(h);
    await h.redis.set(busyKey(busy), "someone");

    const r = await call(h, "POST", "/v1/calls/match", { token: w.callerToken, body: { language: "ta", type: "audio" } });
    expect(r.statusCode).toBe(201);
    expect(json(r)).toMatchObject({ companion: { id: w.companion }, coinsPerMin: 10 });
  });

  it("only matches video-enabled companions for video", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    await setRate(h, "ta", "video", 25, 700);
    const caller = await tokenFor(h, await createCaller(h, 100), "caller");
    await createCompanion(h, { video: false });
    const r = await call(h, "POST", "/v1/calls/match", { token: caller, body: { language: "ta", type: "video" } });
    expect([r.statusCode, errorCode(r)]).toEqual([404, "NO_COMPANION_AVAILABLE"]);
  });
});

describe("safety", () => {
  it("reporting blocks the person and records the report against the call", async () => {
    const w = await world();
    const start = await connected(w);
    const r = await call(h, "POST", "/v1/reports", {
      token: w.callerToken, body: { userId: w.companion, callId: start.callId, reason: "abuse", details: "shouted" },
    });
    expect(r.statusCode).toBe(201);
    const report = (await h.db.query(`SELECT reason, call_id FROM reports`)).rows[0];
    expect(report).toEqual({ reason: "abuse", call_id: start.callId });

    const blocks = json<{ id: string }[]>(await call(h, "GET", "/v1/blocks", { token: w.callerToken }));
    expect(blocks.map((b) => b.id)).toEqual([w.companion]);
    expect(errorCode(await call(h, "POST", "/v1/calls/match", { token: w.callerToken, body: { language: "ta", type: "audio" } })))
      .toBe("NO_COMPANION_AVAILABLE");
  });

  it("accepts a report with null optional fields (Dart client)", async () => {
    const w = await world();
    const r = await call(h, "POST", "/v1/reports", {
      token: w.callerToken, body: { userId: w.companion, callId: null, reason: "spam", details: null },
    });
    expect(r.statusCode).toBe(201);
  });

  it("refuses a report that names a call between other people", async () => {
    const w = await world();
    const start = await connected(w);
    const outsider = await tokenFor(h, await createCaller(h, 0), "caller");
    const r = await call(h, "POST", "/v1/reports", {
      token: outsider, body: { userId: w.companion, callId: start.callId, reason: "spam" },
    });
    expect(errorCode(r)).toBe("CALL_MISMATCH");
  });

  it("unblocking makes the companion visible again", async () => {
    const w = await world();
    await call(h, "POST", "/v1/blocks", { token: w.callerToken, body: { userId: w.companion } });
    await call(h, "DELETE", `/v1/blocks/${w.companion}`, { token: w.callerToken });
    const r = json<{ companions: unknown[] }>(await call(h, "GET", "/v1/companions/online?language=ta", { token: w.callerToken }));
    expect(r.companions).toHaveLength(1);
  });
});

describe("LiveKit webhooks", () => {
  it("rejects a bad signature", async () => {
    const r = await webhook(h, { event: "room_finished", room: "call_x", identity: null }, "forged");
    expect(r.statusCode).toBe(401);
  });

  it("participant_left ends the call with the right reason", async () => {
    const w = await world();
    const start = await connected(w);
    await webhook(h, { event: "participant_left", room: start.room, identity: w.companion });
    expect(await getCall(h, start.callId)).toMatchObject({ status: "ended", end_reason: "companion_hangup" });
  });

  it("ignores rooms that aren't calls and identities that aren't in the call", async () => {
    const w = await world();
    const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
      token: w.callerToken, body: { companionId: w.companion, type: "audio" },
    }));
    expect((await webhook(h, { event: "room_finished", room: "voice_room_1", identity: null })).statusCode).toBe(200);
    await webhook(h, { event: "participant_joined", room: start.room, identity: w.caller });
    await webhook(h, { event: "participant_joined", room: start.room, identity: "intruder" });
    expect((await getCall(h, start.callId)).status).toBe("ringing");
  });
});
