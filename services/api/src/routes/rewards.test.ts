import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { balance, createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";
import { countOnlineMinute, payBonuses } from "../rewards.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`DELETE FROM bonus_progress`);
  await h.db.query(`UPDATE bonus_campaigns SET is_active = false`);
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

type Rewards = {
  level: { level: number; name: string; boostPct: number }; next: { level: number; minHours: number } | null;
  monthHours: number; streakDays: number; dailyGoalPaise: number; bonuses: { title: string; status: string; doneMinutes: number }[];
};

/** Past talk time for a companion: one ended call of `hours` that started `daysAgo` days ago. */
async function pastCall(caller: string, companion: string, hours: number, daysAgo: number) {
  const rate = (await h.db.query<{ id: number }>(`SELECT id FROM call_rates LIMIT 1`)).rows[0]!.id;
  await h.db.query(
    `INSERT INTO calls (caller_id, companion_id, type, language_code, rate_id, coins_per_min, companion_paise_per_min, room_name, status, started_at, ended_at)
     VALUES ($1, $2, 'audio', 'ta', $3, 10, 300, gen_random_uuid()::text, 'ended',
             now() - make_interval(days => $4), now() - make_interval(days => $4) + make_interval(secs => $5))`,
    [caller, companion, rate, daysAgo, hours * 3600]);
}

describe("companion rewards", () => {
  it("levels by hours and rating; the boost is frozen onto new calls", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    const token = await tokenFor(h, companion, "companion");
    expect(json<Rewards>(await call(h, "GET", "/v1/companion/rewards", { token })).level).toMatchObject({ level: 1, boostPct: 0 });

    await pastCall(caller, companion, 16, 0);
    await h.db.query(`UPDATE companion_profiles SET rating_sum = 42, rating_count = 10 WHERE user_id = $1`, [companion]); // 4.2
    const r = json<Rewards>(await call(h, "GET", "/v1/companion/rewards", { token }));
    expect(r.level).toMatchObject({ level: 2, name: "Friendly voice", boostPct: 2 });
    expect(r.next).toMatchObject({ level: 3, minHours: 30 });
    expect(r.monthHours).toBe(16);

    // Level 2 earns +2%: 300 paise → 306 per minute on the next call.
    const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
      token: await tokenFor(h, caller, "caller"), body: { companionId: companion, type: "audio" } }));
    await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
    await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
    expect((await h.db.query(`SELECT coins_per_min, companion_paise_per_min FROM calls WHERE id = $1`, [start.callId])).rows[0])
      .toEqual({ coins_per_min: 10, companion_paise_per_min: 306 });
    expect(await balance(h, companion, "earnings")).toBe(306);
  });

  it("counts online minutes once, keeps a streak, and pays an earned bonus exactly once", async () => {
    const companion = await createCompanion(h);
    const token = await tokenFor(h, companion, "companion");
    const campaign = json<{ id: number }>(await call(h, "POST", "/v1/admin/bonus-campaigns", {
      token: admin, body: { title: "All-day bonus", rewardPaise: 5000, requiredMinutes: 10, windowStart: 0, windowEnd: 1440,
        weekdays: [1, 2, 3, 4, 5, 6, 7], startsOn: "2020-01-01", isActive: true } }));

    await countOnlineMinute(h.db, h.redis, companion);
    await countOnlineMinute(h.db, h.redis, companion); // same minute: ignored
    expect((await h.db.query(`SELECT minutes FROM companion_online_minutes WHERE user_id = $1`, [companion])).rows).toEqual([{ minutes: 1 }]);
    expect((await h.db.query(`SELECT minutes FROM bonus_progress WHERE user_id = $1`, [companion])).rows).toEqual([{ minutes: 1 }]);

    // Streak: yesterday and today with ≥30 minutes.
    await h.db.query(
      `INSERT INTO companion_online_minutes (user_id, day, minutes) VALUES ($1, (now() AT TIME ZONE 'Asia/Kolkata')::date - 1, 45)`, [companion]);
    await h.db.query(`UPDATE companion_online_minutes SET minutes = 40 WHERE user_id = $1 AND day = (now() AT TIME ZONE 'Asia/Kolkata')::date`, [companion]);
    let r = json<Rewards>(await call(h, "GET", "/v1/companion/rewards", { token }));
    expect(r.streakDays).toBe(2);
    expect(r.bonuses).toEqual([expect.objectContaining({ title: "All-day bonus", status: "active", doneMinutes: 1 })]);

    const deps = { db: h.db, push: h.push, events: h.events };
    expect(await payBonuses(deps)).toBe(0); // not enough minutes yet
    await h.db.query(`UPDATE bonus_progress SET minutes = 10 WHERE campaign_id = $1`, [campaign.id]);
    expect(await payBonuses(deps)).toBe(1);
    expect(await payBonuses(deps)).toBe(0);
    expect(await balance(h, companion, "earnings")).toBe(5000);
    r = json<Rewards>(await call(h, "GET", "/v1/companion/rewards", { token }));
    expect(r.bonuses[0]!.status).toBe("paid");
    expect((await h.db.query(`SELECT title FROM notifications WHERE user_id = $1`, [companion])).rows).toEqual([{ title: "You earned ₹50 🎉" }]);
  });

  it("admin edits levels and validates campaigns", async () => {
    const levels = json<{ level: number }[]>(await call(h, "GET", "/v1/admin/companion-levels", { token: admin }));
    expect(levels.map((l) => l.level)).toEqual([1, 2, 3, 4, 5]);
    const updated = await call(h, "PUT", "/v1/admin/companion-levels/4", { token: admin, body: { name: "Star", minHours: 50, minRating: 4.5, boostPct: 6 } });
    expect(json(updated)).toMatchObject({ level: 4, minHours: 50, boostPct: 6 });
    await call(h, "PUT", "/v1/admin/companion-levels/4", { token: admin, body: { name: "Star", minHours: 60, minRating: 4.5, boostPct: 5 } });
    const bad = await call(h, "POST", "/v1/admin/bonus-campaigns", {
      token: admin, body: { title: "Too long", rewardPaise: 5000, requiredMinutes: 200, windowStart: 1200, windowEnd: 1380,
        weekdays: [1], startsOn: "2026-01-01", isActive: true } });
    expect(bad.statusCode).toBe(400);
    expect(errorCode(await call(h, "GET", "/v1/admin/companion-levels", { token: await tokenFor(h, await createCompanion(h), "companion") })))
      .toBe("WRONG_ROLE");
  });
});
