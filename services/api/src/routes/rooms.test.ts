import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { balance, createCaller, createCompanion, resetState } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";
import { sweepRooms } from "./rooms.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); });

type Join = { room: { id: string; me: string; members: { id: string; role: string; handRaised: boolean }[] }; token: string; livekitRoom: string };
const roomEvents = (userId: string) => h.events.of(userId, "room_event").map((e) => (e.event as { event: { kind: string } }).event.kind);

async function hostRoom() {
  const host = await createCompanion(h);
  const hostToken = await tokenFor(h, host, "companion");
  const r = await call(h, "POST", "/v1/rooms", { token: hostToken, body: { title: "Tamil movie talk", category: "movies", language: "ta" } });
  expect(r.statusCode).toBe(201);
  return { host, hostToken, join: json<Join>(r) };
}

describe("voice rooms", () => {
  it("only approved companions host, one room at a time", async () => {
    const caller = await tokenFor(h, await createCaller(h, 0), "caller");
    expect(errorCode(await call(h, "POST", "/v1/rooms", { token: caller, body: { title: "Hello all", category: "music", language: "ta" } })))
      .toBe("WRONG_ROLE");
    const pending = await tokenFor(h, await createCompanion(h, { kyc: "pending" }), "companion");
    expect(errorCode(await call(h, "POST", "/v1/rooms", { token: pending, body: { title: "Hello all", category: "music", language: "ta" } })))
      .toBe("KYC_NOT_APPROVED");
    const { hostToken, join } = await hostRoom();
    expect(join.room.me).toBe("host");
    expect(join.token).not.toContain(":listen");
    expect(errorCode(await call(h, "POST", "/v1/rooms", { token: hostToken, body: { title: "Another one", category: "music", language: "ta" } })))
      .toBe("ALREADY_HOSTING");
  });

  it("listen free, raise a hand, come on stage, gift the host, chat safely, and the room ends when the host leaves", async () => {
    const { host, hostToken, join } = await hostRoom();
    const roomId = join.room.id;
    const listener = await createCaller(h, 100);
    const lt = await tokenFor(h, listener, "caller");

    const list = json<{ id: string; title: string; listeners: number; host: { id: string } }[]>(await call(h, "GET", "/v1/rooms?language=ta", { token: lt }));
    expect(list).toEqual([expect.objectContaining({ id: roomId, title: "Tamil movie talk", listeners: 1, host: expect.objectContaining({ id: host }) })]);

    const j = json<Join>(await call(h, "POST", `/v1/rooms/${roomId}/join`, { token: lt }));
    expect(j.room.me).toBe("listener");
    expect(j.token).toContain(":listen"); // can't publish audio
    expect(roomEvents(host)).toContain("join");

    await call(h, "POST", `/v1/rooms/${roomId}/hand`, { token: lt, body: { raised: true } });
    let state = json<Join["room"]>(await call(h, "GET", `/v1/rooms/${roomId}`, { token: hostToken }));
    expect(state.members.find((m) => m.id === listener)).toMatchObject({ role: "listener", handRaised: true });
    expect(errorCode(await call(h, "POST", `/v1/rooms/${roomId}/stage/${listener}`, { token: await tokenFor(h, await createCompanion(h), "companion"), body: { action: "invite" } })))
      .toBe("NOT_THE_HOST");
    state = json<Join["room"]>(await call(h, "POST", `/v1/rooms/${roomId}/stage/${listener}`, { token: hostToken, body: { action: "invite" } }));
    expect(state.members.find((m) => m.id === listener)).toMatchObject({ role: "speaker", handRaised: false });
    const fresh = json<{ token: string; role: string }>(await call(h, "POST", `/v1/rooms/${roomId}/token`, { token: lt }));
    expect(fresh).toMatchObject({ role: "speaker" });
    expect(fresh.token).not.toContain(":listen");

    // Gifts: to the companion host, yes; to a caller on stage, no.
    const rose = (await h.db.query<{ id: number; coins: number }>(`SELECT id, coins FROM gifts WHERE code = 'rose'`)).rows[0]!;
    const gift = (to: string) => call(h, "POST", `/v1/rooms/${roomId}/gifts`, { token: lt, body: { giftId: rose.id, toUserId: to, clientRef: randomUUID() } });
    expect(json<{ coinsLeft: number }>(await gift(host)).coinsLeft).toBe(100 - rose.coins);
    expect(await balance(h, host, "earnings")).toBeGreaterThan(0);
    const self = await createCaller(h, 50);
    const st = await tokenFor(h, self, "caller");
    await call(h, "POST", `/v1/rooms/${roomId}/join`, { token: st });
    await call(h, "POST", `/v1/rooms/${roomId}/stage/${self}`, { token: hostToken, body: { action: "invite" } });
    expect(errorCode(await gift(self))).toBe("GIFT_RECEIVER_INVALID");

    expect(errorCode(await call(h, "POST", `/v1/rooms/${roomId}/messages`, { token: lt, body: { body: "call me 9876543210" } }))).toBe("MESSAGE_BLOCKED");
    expect((await call(h, "POST", `/v1/rooms/${roomId}/messages`, { token: lt, body: { body: "That climax scene though" } })).statusCode).toBe(204);
    expect(errorCode(await call(h, "POST", `/v1/rooms/${roomId}/messages`, { token: lt, body: { body: "again" } }))).toBe("TOO_FAST");
    expect(roomEvents(host)).toEqual(expect.arrayContaining(["hand", "role", "gift", "chat"]));

    await call(h, "POST", `/v1/rooms/${roomId}/leave`, { token: hostToken });
    expect(roomEvents(listener).at(-1)).toBe("ended");
    expect(json<unknown[]>(await call(h, "GET", "/v1/rooms", { token: lt }))).toEqual([]);
    expect(errorCode(await call(h, "POST", `/v1/rooms/${roomId}/join`, { token: lt }))).toBe("ROOM_ENDED");
    expect(h.rooms.closed).toContain(join.livekitRoom);
  });

  it("the sweep drops silent members and ends rooms whose host vanished", async () => {
    const { join } = await hostRoom();
    await h.db.query(`UPDATE voice_rooms SET created_at = now() - interval '5 minutes' WHERE id = $1`, [join.room.id]);
    await h.db.query(`UPDATE voice_room_members SET last_seen_at = now() - interval '5 minutes' WHERE room_id = $1`, [join.room.id]);
    expect(await sweepRooms({ db: h.db, events: h.events, rooms: h.rooms })).toEqual({ left: 1, ended: 1 });
    expect((await h.db.query(`SELECT status, end_reason FROM voice_rooms WHERE id = $1`, [join.room.id])).rows[0])
      .toEqual({ status: "ended", end_reason: "host_left" });
  });

  it("LiveKit webhooks for voice rooms are ignored — rooms never start per-minute billing", async () => {
    const { host, join } = await hostRoom();
    const listener = await createCaller(h, 100);
    await call(h, "POST", `/v1/rooms/${join.room.id}/join`, { token: await tokenFor(h, listener, "caller") });
    const before = (await h.db.query<{ n: number }>(`SELECT count(*)::int AS n FROM ledger_entries`)).rows[0]!.n;
    for (const identity of [host, listener]) {
      const r = await webhook(h, { event: "participant_joined", room: join.livekitRoom, identity });
      expect(r.statusCode).toBe(200);
    }
    expect((await h.db.query<{ n: number }>(`SELECT count(*)::int AS n FROM ledger_entries`)).rows[0]!.n).toBe(before);
    expect((await h.db.query<{ n: number }>(`SELECT count(*)::int AS n FROM calls`)).rows[0]!.n).toBe(0);
    expect(await balance(h, listener, "coins")).toBe(100);
  });
});
