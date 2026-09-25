import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, signUp, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { tx } from "../db/pool.js";
import { post } from "../billing/ledger.js";
import { announceLevelUps, awardBadges, rewardCompanionInvites } from "./leaderboards.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`TRUNCATE user_badges, leaderboard_awards, events CASCADE`);
  await setRate(h, "ta", "audio", 10, 300);
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

const deps = () => ({ db: h.db, events: h.events, push: h.push });

/** A gift in a (fake) call, at `at`. */
async function gift(from: string, to: string, coins: number, at = new Date()) {
  const callId = (await h.db.query<{ id: string }>(
    `INSERT INTO calls (caller_id, companion_id, type, status, room_name, coins_per_min, companion_paise_per_min, language_code, rate_id)
     VALUES ($1, $2, 'audio', 'ended', $3, 10, 300, 'ta', (SELECT id FROM call_rates LIMIT 1)) RETURNING id`, [from, to, `room-${randomUUID()}`])).rows[0]!.id;
  const giftId = (await h.db.query<{ id: number }>(`SELECT id FROM gifts ORDER BY id LIMIT 1`)).rows[0]!.id;
  await h.db.query(
    `INSERT INTO call_gifts (call_id, sender_id, receiver_id, gift_id, coins, paise_credited, client_ref, created_at)
     VALUES ($1, $2, $3, $4, $5, 0, $6, $7)`, [callId, from, to, giftId, coins, randomUUID(), at]);
}

type Board = { items: { rank: number; user: { id: string }; score: number }[]; me: { rank: number } | null };

describe("leaderboards", () => {
  it("ranks companions by coins spent on them and fans by gift coins, with my rank", async () => {
    const [a, b] = [await createCompanion(h), await createCompanion(h)];
    const [x, y] = [await createCaller(h, 0), await createCaller(h, 0)];
    await gift(x, a, 100);
    await gift(y, b, 300);
    await gift(x, b, 50);
    const token = await tokenFor(h, x, "caller");
    const comps = json<Board>(await call(h, "GET", "/v1/leaderboards?board=companions", { token }));
    expect(comps.items.map((i) => [i.user.id, i.score])).toEqual([[b, 350], [a, 100]]);
    const fans = json<Board>(await call(h, "GET", "/v1/leaderboards?board=fans", { token }));
    expect(fans.items.map((i) => [i.user.id, i.score])).toEqual([[y, 300], [x, 150]]);
    expect(fans.me).toMatchObject({ rank: 2 });
  });

  it("hands out last week's badges once, and they show on companion cards", async () => {
    const comp = await createCompanion(h);
    const fan = await createCaller(h, 0);
    const lastWeek = new Date(Date.now() - 8 * 86_400_000);
    await gift(fan, comp, 200, lastWeek);
    expect(await awardBadges(deps())).toBe(2);
    expect(await awardBadges(deps())).toBe(0); // once per week
    const card = json<{ companion: { badge: { label: string; rank: number } | null } }>(
      await call(h, "GET", `/v1/companions/${comp}`, { token: await tokenFor(h, fan, "caller") }));
    expect(card.companion.badge).toMatchObject({ label: "#1 companion this week", rank: 1 });
    expect((await h.db.query(`SELECT 1 FROM notifications WHERE user_id = $1 AND type = 'badge_won'`, [fan])).rowCount).toBe(1);
  });

  it("events: admin creates one, it has its own board, winners get event badges when it ends", async () => {
    const comp = await createCompanion(h);
    const fan = await createCaller(h, 0);
    const start = new Date(Date.now() - 3 * 86_400_000), end = new Date(Date.now() - 3_600_000);
    const bad = await call(h, "POST", "/v1/admin/events", { token: admin, body: { name: "Pongal", theme: "pongal", startsAt: end, endsAt: start } });
    expect(errorCode(bad)).toBe("VALIDATION");
    const e = json<{ id: string }>(await call(h, "POST", "/v1/admin/events",
      { token: admin, body: { name: "Pongal week", theme: "pongal", startsAt: start, endsAt: end, giftIds: [] } }));
    await gift(fan, comp, 120, new Date(Date.now() - 86_400_000));
    const board = json<Board>(await call(h, "GET", `/v1/leaderboards?board=fans&period=event&eventId=${e.id}`, { token: await tokenFor(h, fan, "caller") }));
    expect(board.items[0]).toMatchObject({ rank: 1, score: 120 });
    await awardBadges(deps());
    const labels = (await h.db.query<{ label: string }>(`SELECT label FROM user_badges WHERE event_id = $1 ORDER BY label`, [e.id])).rows;
    expect(labels.map((l) => l.label)).toEqual(["Pongal week · #1 companion", "Pongal week · #1 fan"]);
    // A current event shows to the apps.
    await call(h, "POST", "/v1/admin/events", { token: admin, body: {
      name: "Diwali", theme: "diwali", startsAt: new Date(Date.now() - 1000), endsAt: new Date(Date.now() + 86_400_000) } });
    expect(json<{ event: { name: string } }>(await call(h, "GET", "/v1/events/current", { token: await tokenFor(h, fan, "caller") })).event.name)
      .toBe("Diwali");
  });
});

describe("caller levels", () => {
  it("coins spent move the level (refunds take it back); level-ups are announced once", async () => {
    const caller = await createCaller(h, 5000);
    const token = await tokenFor(h, caller, "caller");
    expect(json<{ level: number }>(await call(h, "GET", "/v1/me/level", { token })).level).toBe(1);
    await tx(h.db, (c) => post(c, caller, "coins", "call_debit", -1200, `t:${randomUUID()}`));
    const l = json<{ level: number; name: string; coinsSpent: number; next: { level: number } }>(await call(h, "GET", "/v1/me/level", { token }));
    expect(l).toMatchObject({ level: 3, name: "Regular", coinsSpent: 1200, next: { level: 4 } });
    expect(await announceLevelUps(deps())).toBe(1);
    expect(await announceLevelUps(deps())).toBe(0);
    await tx(h.db, (c) => post(c, caller, "coins", "refund", 500, `t:${randomUUID()}`));
    expect(json<{ coinsSpent: number }>(await call(h, "GET", "/v1/me/level", { token })).coinsSpent).toBe(700);
  });

  it("admin edits levels but keeps them in order", async () => {
    expect(errorCode(await call(h, "PUT", "/v1/admin/caller-levels/3", { token: admin, body: { name: "Regular", minCoins: 50 } }))).toBe("LEVEL_ORDER");
    expect((await call(h, "PUT", "/v1/admin/caller-levels/3", { token: admin, body: { name: "Regular", minCoins: 1500 } })).statusCode).toBe(200);
  });
});

describe("companion invites companion", () => {
  it("pays the inviting companion once the new companion completes the paid hours", async () => {
    const inviter = await createCompanion(h);
    const code = json<{ code: string }>(await call(h, "GET", "/v1/referral", { token: await tokenFor(h, inviter, "companion") })).code;
    const newbie = await signUp(h, "9810000001", { gender: "female", referralCode: code });
    const caller = await createCaller(h, 0);
    await h.db.query(
      `INSERT INTO calls (caller_id, companion_id, type, status, room_name, coins_per_min, companion_paise_per_min, language_code, minutes_charged, started_at, rate_id)
       VALUES ($1, $2, 'audio', 'ended', 'r-1', 10, 300, 'ta', 300, now(), (SELECT id FROM call_rates LIMIT 1))`, [caller, newbie.userId]);
    expect(await rewardCompanionInvites(deps())).toBe(0); // 5 h < 10 h
    await h.db.query(`UPDATE calls SET minutes_charged = 600 WHERE companion_id = $1`, [newbie.userId]);
    expect(await rewardCompanionInvites(deps())).toBe(1);
    expect(await rewardCompanionInvites(deps())).toBe(0);
    const bal = (await h.db.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'earnings'`, [inviter])).rows[0]!.balance;
    expect(bal).toBe(10_000);
  });
});
