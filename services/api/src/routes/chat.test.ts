import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); h.push.notices.length = 0; });

type Conv = { id: string; other: { id: string; displayName: string }; unread: number; canMessage: boolean; lastMessage: string | null };
type Item = { kind: string; id: string; senderId: string | null; body: string | null; callType: string | null; callMinutes: number | null };

async function pairWithCall() {
  await setRate(h, "ta", "audio", 10, 300);
  const caller = await createCaller(h, 100);
  const companion = await createCompanion(h);
  const callerToken = await tokenFor(h, caller, "caller");
  const companionToken = await tokenFor(h, companion, "companion");
  return { caller, companion, callerToken, companionToken };
}

async function connectAndEnd(callerToken: string, caller: string, companion: string) {
  const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", { token: callerToken, body: { companionId: companion, type: "audio" } }));
  await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
  await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
  await h.db.query(`UPDATE calls SET started_at = now() - interval '12 minutes' WHERE id = $1`, [start.callId]);
  await call(h, "POST", `/v1/calls/${start.callId}/end`, { token: callerToken });
  return start.callId;
}

describe("chat", () => {
  it("needs a connected call first", async () => {
    const { companion, callerToken } = await pairWithCall();
    expect(errorCode(await call(h, "POST", `/v1/chats/with/${companion}`, { token: callerToken }))).toBe("CHAT_NEEDS_CALL");
  });

  it("messages flow both ways with unread counts, live events, one push per burst, and calls in the thread", async () => {
    const { caller, companion, callerToken, companionToken } = await pairWithCall();
    await h.db.query(`INSERT INTO devices (fcm_token, user_id) VALUES ('tok-comp', $1)`, [companion]);
    const callId = await connectAndEnd(callerToken, caller, companion);

    const conv = json<Conv>(await call(h, "POST", `/v1/chats/with/${companion}`, { token: callerToken }));
    expect(conv.canMessage).toBe(true);
    // Opening again gives the same conversation, from either side.
    expect(json<Conv>(await call(h, "POST", `/v1/chats/with/${caller}`, { token: companionToken })).id).toBe(conv.id);

    const send = (token: string, body: string, clientRef = randomUUID()) =>
      call(h, "POST", `/v1/chats/${conv.id}/messages`, { token, body: { body, clientRef } });
    const ref = randomUUID();
    expect((await send(callerToken, "Thanks for listening today", ref)).statusCode).toBe(201);
    expect((await send(callerToken, "Thanks for listening today", ref)).statusCode).toBe(201); // retried: same message
    await send(callerToken, "Talk tomorrow?");

    expect(h.events.of(companion, "chat_message")).toHaveLength(2);
    expect(h.push.notices.map((n) => [n.tokens, n.notice.title, n.notice.data?.type])).toEqual([[["tok-comp"], "Test caller", "chat_message"]]);
    expect((await h.db.query(`SELECT count(*)::int AS n FROM notifications`)).rows[0]).toEqual({ n: 0 }); // chat doesn't flood the inbox

    const list = json<{ items: Conv[]; unread: number }>(await call(h, "GET", "/v1/chats", { token: companionToken }));
    expect(list.unread).toBe(2);
    expect(list.items[0]).toMatchObject({ id: conv.id, other: { id: caller }, lastMessage: "Talk tomorrow?", unread: 2 });
    await call(h, "POST", `/v1/chats/${conv.id}/read`, { token: companionToken });
    expect(json<{ unread: number }>(await call(h, "GET", "/v1/chats", { token: companionToken })).unread).toBe(0);
    expect(json<{ unread: number }>(await call(h, "GET", "/v1/chats", { token: callerToken })).unread).toBe(0); // own messages aren't unread

    const thread = json<{ items: Item[] }>(await call(h, "GET", `/v1/chats/${conv.id}/messages`, { token: companionToken }));
    expect(thread.items.map((i) => [i.kind, i.body ?? `${i.callType} ${i.callMinutes}m`])).toEqual([
      ["message", "Talk tomorrow?"], ["message", "Thanks for listening today"], ["call", "audio 12m"],
    ]);
    expect(thread.items[2]!.id).toBe(callId);

    // Outsiders can't read it.
    const outsider = await tokenFor(h, await createCaller(h, 0), "caller");
    expect(errorCode(await call(h, "GET", `/v1/chats/${conv.id}/messages`, { token: outsider }))).toBe("NOT_YOUR_CONVERSATION");
  });

  it("refuses phone numbers and payment talk, and records the attempt", async () => {
    const { caller, companion, callerToken, companionToken } = await pairWithCall();
    await connectAndEnd(callerToken, caller, companion);
    const conv = json<Conv>(await call(h, "POST", `/v1/chats/with/${companion}`, { token: callerToken }));
    const r = await call(h, "POST", `/v1/chats/${conv.id}/messages`, { token: companionToken, body: { body: "whatsapp me 98765 43210", clientRef: randomUUID() } });
    expect(r.statusCode).toBe(422);
    expect(errorCode(r)).toBe("MESSAGE_BLOCKED");
    expect((await h.db.query(`SELECT sender_id, reason FROM chat_violations`)).rows).toEqual([{ sender_id: companion, reason: "phone_number" }]);
    expect(json<{ items: Item[] }>(await call(h, "GET", `/v1/chats/${conv.id}/messages`, { token: callerToken })).items
      .filter((i) => i.kind === "message")).toEqual([]);
  });

  it("a block closes the chat", async () => {
    const { caller, companion, callerToken } = await pairWithCall();
    await connectAndEnd(callerToken, caller, companion);
    const conv = json<Conv>(await call(h, "POST", `/v1/chats/with/${companion}`, { token: callerToken }));
    await h.db.query(`INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2)`, [companion, caller]);
    expect(errorCode(await call(h, "POST", `/v1/chats/${conv.id}/messages`, { token: callerToken, body: { body: "hi", clientRef: randomUUID() } })))
      .toBe("CHAT_CLOSED");
    expect(errorCode(await call(h, "POST", `/v1/chats/with/${companion}`, { token: callerToken }))).toBe("CHAT_BLOCKED");
  });

  it("looks up one companion's live rates for the chat's Call button", async () => {
    const { caller, companion, callerToken } = await pairWithCall();
    const r = json<{ online: boolean; companion: { id: string; rates: { audioCoinsPerMin: number } } }>(
      await call(h, "GET", `/v1/companions/${companion}`, { token: callerToken }));
    expect(r).toMatchObject({ online: true, companion: { id: companion, rates: { audioCoinsPerMin: 10 } } });
    await h.db.query(`INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2)`, [caller, companion]);
    expect(errorCode(await call(h, "GET", `/v1/companions/${companion}`, { token: callerToken }))).toBe("COMPANION_NOT_FOUND");
  });
});
