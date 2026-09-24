import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, getCall, resetState, setRate, ticks } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, signUp, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { BillingEngine } from "../billing/engine.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); h.rooms.identities.clear(); });

async function ringing() {
  await setRate(h, "ta", "audio", 10, 300);
  const caller = await createCaller(h, 100);
  const companion = await createCompanion(h);
  const callerToken = await tokenFor(h, caller, "caller");
  const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", { token: callerToken, body: { companionId: companion, type: "audio" } }));
  return { caller, companion, callerToken, companionToken: await tokenFor(h, companion, "companion"), ...start };
}

describe("LiveKit Cloud without webhooks", () => {
  it("verify-connected asks LiveKit, never the app: one person → nothing; both → minute 1 once; outsiders refused", async () => {
    const c = await ringing();
    const verify = (token: string) => call(h, "POST", `/v1/calls/${c.callId}/verify-connected`, { token });

    h.rooms.identities.set(c.room, new Set([c.caller])); // only the caller is in the room
    expect(json(await verify(c.callerToken))).toEqual({ connected: false });
    expect(await ticks(h, c.callId)).toEqual([]);
    expect((await getCall(h, c.callId)).status).toBe("ringing");

    h.rooms.identities.set(c.room, new Set([c.caller, c.companion]));
    expect(json(await verify(c.companionToken))).toEqual({ connected: true });
    expect(json(await verify(c.callerToken))).toEqual({ connected: true }); // twice: still one tick
    expect(await ticks(h, c.callId)).toEqual([1]);

    const outsider = await tokenFor(h, await createCaller(h, 0), "caller");
    expect(errorCode(await verify(outsider))).toBe("NOT_YOUR_CALL");
  });

  it("polling sweep connects calls LiveKit reports full, and ends them when someone leaves", async () => {
    const polling = new BillingEngine({ db: h.db, redis: h.redis, rooms: h.rooms, events: h.events, pollRooms: true });
    const c = await ringing();
    h.rooms.identities.set(c.room, new Set([c.caller, c.companion]));
    await polling.sweep();
    expect(await getCall(h, c.callId)).toMatchObject({ status: "active" });
    expect(await ticks(h, c.callId)).toEqual([1]);

    h.rooms.identities.set(c.room, new Set([c.caller]));
    await h.db.query(`UPDATE calls SET started_at = now() - interval '1 minute' WHERE id = $1`, [c.callId]);
    await polling.sweep();
    expect(await getCall(h, c.callId)).toMatchObject({ status: "ended", end_reason: "companion_hangup" });
  });

  it("without polling, the sweep leaves connecting to the webhook (default behaviour unchanged)", async () => {
    const c = await ringing();
    h.rooms.identities.set(c.room, new Set([c.caller, c.companion]));
    await h.engine.sweep();
    expect((await getCall(h, c.callId)).status).toBe("ringing");
  });
});

describe("home screen fixes", () => {
  it("Random: match with no language finds anyone free", async () => {
    await setRate(h, "hi", "audio", 12, 300);
    const companion = await createCompanion(h, { language: "hi" });
    const caller = await tokenFor(h, await createCaller(h, 100), "caller"); // caller's language is Tamil
    const r = json<{ companion: { id: string } }>(await call(h, "POST", "/v1/calls/match", { token: caller, body: { type: "audio" } }));
    expect(r.companion.id).toBe(companion);
  });

  it("Online tab: leaving out the language lists everyone online, in every language", async () => {
    const ta = await createCompanion(h);
    const hi = await createCompanion(h, { language: "hi" });
    const caller = await tokenFor(h, await createCaller(h, 100), "caller");
    const all = json<{ companions: { id: string }[] }>(await call(h, "GET", "/v1/companions/online", { token: caller }));
    expect(all.companions.map((c) => c.id).sort()).toEqual([ta, hi].sort());
    const tamil = json<{ companions: { id: string }[] }>(await call(h, "GET", "/v1/companions/online?language=ta", { token: caller }));
    expect(tamil.companions.map((c) => c.id)).toEqual([ta]);
  });

  it("changing language works even though the app sends an empty languages list", async () => {
    const me = await signUp(h, "9877700001");
    const r = await call(h, "PATCH", "/v1/me", { token: me.accessToken, body: { primaryLanguage: "hi", languages: [] } });
    expect(r.statusCode).toBe(200);
    expect(json<{ primaryLanguage: string; languages: string[] }>(r)).toMatchObject({ primaryLanguage: "hi" });
    expect(json<{ languages: string[] }>(r).languages).toContain("hi");
  });
});
