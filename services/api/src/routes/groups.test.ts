import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { groupSettings, sweepGroups } from "./groups.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`TRUNCATE group_sessions, group_members, group_ticks, group_gifts CASCADE`);
  await setRate(h, "ta", "audio", 10, 300);
  h.rooms.identities.clear();
  (h.rooms as unknown as { removed: unknown[] }).removed.length = 0;
});

type Card = { id: string; status: string; members: number; mySeat: string };
type HostState = { group: Card; room: { livekitRoom: string; token: string } | null; waiting: number; paidMinutes: number };
type Join = { group: Card; room: { livekitRoom: string; token: string } | null; minutes: number; coinsLeft: number };
type Member = { id: string; token: string };

async function host(body: Record<string, unknown> = {}) {
  const hostId = await createCompanion(h);
  const token = await tokenFor(h, hostId, "companion");
  const r = await call(h, "POST", "/v1/groups", { token, body: { title: "Tamil evening hangout", language: null, ...body } });
  expect(r.statusCode).toBe(201);
  const s = json<HostState>(r);
  return { hostId, token, groupId: s.group.id, state: s };
}
async function members(n: number, coins = 500): Promise<Member[]> {
  const out: Member[] = [];
  for (let i = 0; i < n; i++) {
    const id = await createCaller(h, coins);
    out.push({ id, token: await tokenFor(h, id, "caller") });
  }
  return out;
}
const join = (groupId: string, m: Member, agree = true) => call(h, "POST", `/v1/groups/${groupId}/join`, { token: m.token, body: { agree } });
const balance = async (userId: string, kind: "coins" | "earnings") =>
  (await h.db.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = $2`, [userId, kind])).rows[0]!.balance;
const status = async (id: string) => (await h.db.query<{ status: string; end_reason: string | null }>(
  `SELECT status, end_reason FROM group_sessions WHERE id = $1`, [id])).rows[0]!;
const room = async (id: string) => (await h.db.query<{ livekit_room: string }>(`SELECT livekit_room FROM group_sessions WHERE id = $1`, [id])).rows[0]!.livekit_room;
const sweep = () => sweepGroups({ db: h.db, events: h.events, rooms: h.rooms, push: h.push });
/** A minute passes, with these users in the LiveKit room. */
async function nextMinute(groupId: string, hostId: string, present: Member[]) {
  await h.db.query(`UPDATE group_members SET last_charged_at = now() - interval '61 seconds' WHERE session_id = $1`, [groupId]);
  h.rooms.identities.set(await room(groupId), new Set([hostId, ...present.map((m) => m.id)]));
  return sweep();
}
/** Host with three members in the lobby → the group is live. */
async function liveGroup(coins = 500) {
  const g = await host();
  const ms = await members(3, coins);
  for (const m of ms) expect((await join(g.groupId, m)).statusCode).toBe(200);
  return { ...g, ms };
}

describe("hosting", () => {
  it("instant group opens a lobby; video must be unlocked; one open group; no 1:1 calls or lives meanwhile", async () => {
    const g = await host();
    expect(g.state.group.status).toBe("lobby");
    expect(g.state.room).not.toBeNull();
    expect(errorCode(await call(h, "POST", "/v1/groups", { token: g.token, body: { title: "Second one" } }))).toBe("GROUP_OPEN");
    expect(errorCode(await call(h, "POST", "/v1/lives", { token: g.token, body: { title: "Live too" } }))).toBe("GROUP_OPEN");
    const [c] = await members(1);
    await h.redis.sadd("online:companions", g.hostId);
    await expect(h.engine.startCall(c!.id, g.hostId, "audio")).rejects.toMatchObject({ code: "BUSY" });
    const locked = await tokenFor(h, await createCompanion(h, { video: false }), "companion");
    expect(errorCode(await call(h, "POST", "/v1/groups", { token: locked, body: { title: "No video yet" } }))).toBe("VIDEO_LOCKED");
  });
});

describe("lobby and start", () => {
  it("nobody pays in the lobby; the third member starts it and everyone pays minute 1", async () => {
    const g = await host();
    const ms = await members(3);
    expect(errorCode(await join(g.groupId, ms[0]!, false))).toBe("AGREE_REQUIRED");
    const first = json<Join>(await join(g.groupId, ms[0]!));
    expect(first.room).toBeNull();
    await join(g.groupId, ms[1]!);
    expect(await balance(ms[0]!.id, "coins")).toBe(500);
    expect((await status(g.groupId)).status).toBe("lobby");

    const third = json<Join>(await join(g.groupId, ms[2]!));
    expect(third.group.status).toBe("live");
    expect(third.room?.token).toBeTruthy();
    expect(third.minutes).toBe(1);
    const s = await groupSettings(h.db);
    for (const m of ms) expect(await balance(m.id, "coins")).toBe(500 - s.coinsPerMin);
    expect(await balance(g.hostId, "earnings")).toBe(3 * s.paisePerMin);
    // Members waiting in the lobby join again to get the room — without paying twice.
    const again = json<Join>(await join(g.groupId, ms[0]!));
    expect(again.room).not.toBeNull();
    expect(await balance(ms[0]!.id, "coins")).toBe(500 - s.coinsPerMin);
  });

  it("the lobby closes if not enough people come", async () => {
    const g = await host();
    const [m] = await members(1);
    await join(g.groupId, m!);
    await h.db.query(`UPDATE group_sessions SET lobby_at = now() - interval '11 minutes' WHERE id = $1`, [g.groupId]);
    expect((await sweep()).ended).toBe(1);
    expect(await status(g.groupId)).toMatchObject({ status: "ended", end_reason: "not_enough_members" });
    expect(await balance(m!.id, "coins")).toBe(500);
  });

  it("a caller who can't pay one minute can't join", async () => {
    const g = await host();
    const [poor] = await members(1, 5);
    expect(errorCode(await join(g.groupId, poor!))).toBe("INSUFFICIENT_BALANCE");
  });

  it("at most 10 members", async () => {
    await h.db.query(`UPDATE app_settings SET value = '20' WHERE key = 'group.min_members'`); // keep it in the lobby
    try {
      const g = await host();
      for (const m of await members(10)) expect((await join(g.groupId, m)).statusCode).toBe(200);
      const [late] = await members(1);
      expect(errorCode(await join(g.groupId, late!))).toBe("GROUP_FULL");
    } finally {
      await h.db.query(`UPDATE app_settings SET value = '3' WHERE key = 'group.min_members'`);
    }
  });
});

describe("per-minute billing", () => {
  it("charges each member present once per minute — never twice for the same minute", async () => {
    const g = await liveGroup();
    const s = await groupSettings(h.db);
    h.rooms.identities.set(await room(g.groupId), new Set([g.hostId, ...g.ms.map((m) => m.id)]));
    expect((await sweep()).charged).toBe(0); // minute 1 still running
    expect((await nextMinute(g.groupId, g.hostId, g.ms)).charged).toBe(3);
    expect((await sweep()).charged).toBe(0);
    for (const m of g.ms) expect(await balance(m.id, "coins")).toBe(500 - 2 * s.coinsPerMin);
    const t = (await h.db.query<{ n: number }>(`SELECT count(*)::int AS n FROM group_ticks WHERE session_id = $1`, [g.groupId])).rows[0]!.n;
    expect(t).toBe(6);
  });

  it("a late joiner pays minute 1 when joining", async () => {
    const g = await liveGroup();
    const [late] = await members(1);
    const j = json<Join>(await join(g.groupId, late!));
    expect(j.room).not.toBeNull();
    expect(j.coinsLeft).toBe(500 - (await groupSettings(h.db)).coinsPerMin);
  });

  it("members who run out are removed; balances never go negative", async () => {
    const s = await groupSettings(h.db);
    const g = await liveGroup(s.coinsPerMin + 3); // one minute, then short
    const r = await nextMinute(g.groupId, g.hostId, g.ms);
    expect(r.charged).toBe(0);
    expect(r.removed).toBe(3);
    for (const m of g.ms) expect(await balance(m.id, "coins")).toBe(3);
    expect(h.rooms.removed.length).toBeGreaterThanOrEqual(3);
  });
});

describe("ending", () => {
  it("ends after a grace period once fewer than 2 members are in the room", async () => {
    const g = await liveGroup();
    await nextMinute(g.groupId, g.hostId, [g.ms[0]!]); // only one left in the room
    expect((await status(g.groupId)).status).toBe("live");
    await h.db.query(`UPDATE group_sessions SET few_since = now() - interval '61 seconds' WHERE id = $1`, [g.groupId]);
    h.rooms.identities.set(await room(g.groupId), new Set([g.hostId, g.ms[0]!.id]));
    expect((await sweep()).ended).toBe(1);
    expect(await status(g.groupId)).toMatchObject({ status: "ended", end_reason: "too_few" });
  });

  it("members coming back clear the warning", async () => {
    const g = await liveGroup();
    await nextMinute(g.groupId, g.hostId, [g.ms[0]!]);
    await nextMinute(g.groupId, g.hostId, g.ms);
    const few = (await h.db.query<{ few_since: Date | null }>(`SELECT few_since FROM group_sessions WHERE id = $1`, [g.groupId])).rows[0]!;
    expect(few.few_since).toBeNull();
  });

  it("ends when the host goes quiet, and the host can end it", async () => {
    const g = await liveGroup();
    await h.db.query(`UPDATE group_sessions SET host_seen_at = now() - interval '2 minutes' WHERE id = $1`, [g.groupId]);
    await sweep();
    expect(await status(g.groupId)).toMatchObject({ status: "ended", end_reason: "host_lost" });
    const g2 = await host();
    expect((await call(h, "POST", `/v1/groups/${g2.groupId}/end`, { token: g2.token })).statusCode).toBe(204);
    expect((await status(g2.groupId)).status).toBe("ended");
  });
});

describe("scheduled groups", () => {
  it("book a seat, reminder, host opens the lobby, booked members are told", async () => {
    const at = new Date(Date.now() + 60 * 60_000);
    const g = await host({ scheduledAt: at.toISOString() });
    expect(g.state.group.status).toBe("scheduled");
    const [m] = await members(1);
    expect(errorCode(await join(g.groupId, m!))).toBe("NOT_OPEN_YET");
    const booked = json<Card>(await call(h, "POST", `/v1/groups/${g.groupId}/book`, { token: m!.token }));
    expect(booked.mySeat).toBe("booked");
    expect(await balance(m!.id, "coins")).toBe(500);
    expect(errorCode(await call(h, "POST", `/v1/groups/${g.groupId}/open`, { token: g.token }))).toBe("TOO_EARLY");

    await h.db.query(`UPDATE group_sessions SET scheduled_at = now() + interval '5 minutes' WHERE id = $1`, [g.groupId]);
    await sweep();
    const notes = (await h.db.query<{ type: string; user_id: string }>(`SELECT type, user_id FROM notifications WHERE type = 'group_reminder'`)).rows;
    expect(notes.map((n) => n.user_id).sort()).toEqual([g.hostId, m!.id].sort());

    const opened = json<HostState>(await call(h, "POST", `/v1/groups/${g.groupId}/open`, { token: g.token }));
    expect(opened.group.status).toBe("lobby");
    expect((await h.db.query(`SELECT 1 FROM notifications WHERE type = 'group_open' AND user_id = $1`, [m!.id])).rowCount).toBe(1);
  });

  it("host no-show cancels it and tells booked members; nothing is charged", async () => {
    const g = await host({ scheduledAt: new Date(Date.now() + 60 * 60_000).toISOString() });
    const [m] = await members(1);
    await call(h, "POST", `/v1/groups/${g.groupId}/book`, { token: m!.token });
    await h.db.query(`UPDATE group_sessions SET scheduled_at = now() - interval '16 minutes', reminded_at = now() WHERE id = $1`, [g.groupId]);
    await sweep();
    expect(await status(g.groupId)).toMatchObject({ status: "ended", end_reason: "host_no_show" });
    expect((await h.db.query(`SELECT 1 FROM notifications WHERE type = 'group_cancelled' AND user_id = $1`, [m!.id])).rowCount).toBe(1);
    expect(await balance(m!.id, "coins")).toBe(500);
  });
});

describe("in the group", () => {
  it("gifts go to the host once per clientRef; chat and reports need to be in the group", async () => {
    const g = await liveGroup();
    const gift = (await h.db.query<{ id: number; coins: number }>(`SELECT id, coins FROM gifts WHERE is_active ORDER BY coins LIMIT 1`)).rows[0]!;
    const ref = randomUUID();
    const before = await balance(g.ms[0]!.id, "coins");
    for (let i = 0; i < 2; i++) {
      expect((await call(h, "POST", `/v1/groups/${g.groupId}/gifts`, { token: g.ms[0]!.token, body: { giftId: gift.id, clientRef: ref } })).statusCode).toBe(201);
    }
    expect(await balance(g.ms[0]!.id, "coins")).toBe(before - gift.coins);

    const [outsider] = await members(1);
    expect(errorCode(await call(h, "POST", `/v1/groups/${g.groupId}/messages`, { token: outsider!.token, body: { body: "hi" } }))).toBe("NOT_IN_GROUP");
    expect((await call(h, "POST", `/v1/groups/${g.groupId}/messages`, { token: g.ms[1]!.token, body: { body: "vanakkam" } })).statusCode).toBe(204);

    // The host reports and removes a member.
    const r = await call(h, "POST", `/v1/groups/${g.groupId}/report`, {
      token: g.token, body: { userId: g.ms[2]!.id, reason: "abuse", details: null, remove: true },
    });
    expect(r.statusCode).toBe(204);
    expect((await h.db.query(`SELECT 1 FROM reports WHERE group_id = $1 AND reported_id = $2`, [g.groupId, g.ms[2]!.id])).rowCount).toBe(1);
    expect(errorCode(await call(h, "POST", `/v1/groups/${g.groupId}/messages`, { token: g.ms[2]!.token, body: { body: "hey" } }))).toBe("NOT_IN_GROUP");
  });

  it("each phone can flag its own camera; frames from outsiders are refused", async () => {
    const g = await liveGroup();
    const jpeg = Buffer.from([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]).toString("base64");
    const own = await call(h, "POST", `/v1/groups/${g.groupId}/moderation`, { token: g.ms[0]!.token, body: { frameBase64: jpeg, score: 0.9, subjectId: null } });
    expect(own.statusCode).toBe(201);
    const f = (await h.db.query<{ subject_id: string; detected_by: string }>(`SELECT subject_id, detected_by FROM moderation_flags WHERE group_id = $1`, [g.groupId])).rows[0]!;
    expect(f).toEqual({ subject_id: g.ms[0]!.id, detected_by: g.ms[0]!.id });
    const [outsider] = await members(1);
    expect(errorCode(await call(h, "POST", `/v1/groups/${g.groupId}/moderation`, { token: outsider!.token, body: { frameBase64: jpeg, score: 0.9 } }))).toBe("NOT_IN_GROUP");
  });
});
