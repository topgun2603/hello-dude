import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { balance, createCaller, createCompanion, resetState } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, signUp, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { tx } from "../db/pool.js";
import { rewardReferral } from "../growth.js";
import { sendDailyBonusReminders } from "../reminders.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); });

type CheckIn = { day: number; claimedToday: boolean; todayCoins: number; streak: number; days: { day: number; coins: number; state: string }[] };

/** Pretend the user claimed on each of these days ago (1 = yesterday), with these streak days. */
async function history(userId: string, entries: [daysAgo: number, streakDay: number][]) {
  for (const [ago, day] of entries) {
    await h.db.query(
      `INSERT INTO checkins (user_id, day, streak_day, coins) VALUES ($1, (now() AT TIME ZONE 'Asia/Kolkata')::date - $2::int, $3, 1)`,
      [userId, ago, day]);
  }
}

describe("daily check-in", () => {
  it("claims once a day and pays the ladder", async () => {
    const user = await createCaller(h, 0);
    const token = await tokenFor(h, user, "caller");
    const before = json<CheckIn>(await call(h, "GET", "/v1/checkin", { token }));
    expect(before).toMatchObject({ day: 1, claimedToday: false, todayCoins: 2, streak: 0 });
    expect(before.days.map((d) => d.coins)).toEqual([2, 2, 3, 3, 5, 5, 10]);
    expect(before.days[0]!.state).toBe("today");

    const first = json<{ credited: number; coins: number; checkin: CheckIn }>(await call(h, "POST", "/v1/checkin/claim", { token }));
    expect(first).toMatchObject({ credited: 2, coins: 2, checkin: { day: 1, claimedToday: true, streak: 1 } });
    const again = json<{ credited: number }>(await call(h, "POST", "/v1/checkin/claim", { token }));
    expect(again.credited).toBe(0);
    expect(await balance(h, user, "coins")).toBe(2);
  });

  it("continues a streak, resets after a missed day, and restarts after Day 7", async () => {
    const continuing = await createCaller(h, 0);
    await history(continuing, [[1, 3], [2, 2], [3, 1]]);
    expect(json<CheckIn>(await call(h, "GET", "/v1/checkin", { token: await tokenFor(h, continuing, "caller") })))
      .toMatchObject({ day: 4, todayCoins: 3, streak: 3 });

    const missed = await createCaller(h, 0);
    await history(missed, [[2, 5], [3, 4]]);
    expect(json<CheckIn>(await call(h, "GET", "/v1/checkin", { token: await tokenFor(h, missed, "caller") })))
      .toMatchObject({ day: 1, streak: 0 });

    const week = await createCaller(h, 0);
    await history(week, [[1, 7], [2, 6]]);
    const token = await tokenFor(h, week, "caller");
    expect(json<CheckIn>(await call(h, "GET", "/v1/checkin", { token }))).toMatchObject({ day: 1, todayCoins: 2 });
    expect(json<{ credited: number }>(await call(h, "POST", "/v1/checkin/claim", { token })).credited).toBe(2);
  });

  it("reminds once a day from 10 AM IST to recent users who haven't claimed", async () => {
    const recent = await signUp(h, "9800000001"); // has a session
    const claimed = await signUp(h, "9800000002");
    await call(h, "POST", "/v1/checkin/claim", { token: claimed.accessToken });
    const deps = { db: h.db, push: h.push, events: h.events };
    const morning = new Date("2026-09-24T03:00:00Z"); // 08:30 IST
    const noon = new Date("2026-09-24T06:30:00Z"); // 12:00 IST
    expect(await sendDailyBonusReminders(deps, morning)).toBe(0);
    expect(await sendDailyBonusReminders(deps, noon)).toBe(1);
    expect(await sendDailyBonusReminders(deps, noon)).toBe(0);
    const n = (await h.db.query<{ user_id: string; body: string }>(`SELECT user_id, body FROM notifications WHERE type = 'daily_bonus'`)).rows;
    expect(n).toEqual([{ user_id: recent.userId, body: "Claim 2 coins, Day 1" }]);
  });
});

describe("referrals", () => {
  it("friend signs up with a code; both get coins on the friend's first recharge only", async () => {
    const inviter = await signUp(h, "9811111111", { displayName: "Karthik" });
    const ref = json<{ code: string; referrerCoins: number; refereeCoins: number; joined: number }>(
      await call(h, "GET", "/v1/referral", { token: inviter.accessToken }));
    expect(ref.code).toMatch(/^KARTHIK\d{2}$/);
    expect(ref).toMatchObject({ referrerCoins: 50, refereeCoins: 50, joined: 0 });
    // Same code every time.
    expect(json<{ code: string }>(await call(h, "GET", "/v1/referral", { token: inviter.accessToken })).code).toBe(ref.code);

    // A wrong code blocks sign-up with a clear error; a right one (any case/spaces) works.
    const otp = await call(h, "POST", "/v1/auth/otp/send", { body: { phone: "9822222222" } });
    expect(otp.statusCode).toBe(200);
    const e164 = [...h.otpCodes.codes.keys()].at(-1)!;
    const { signupToken } = json<{ signupToken: string }>(await call(h, "POST", "/v1/auth/otp/verify", { body: { phone: "9822222222", code: h.otpCodes.codes.get(e164) } }));
    expect(errorCode(await call(h, "POST", "/v1/auth/signup", {
      body: { signupToken, gender: "male", language: "ta", ageConfirmed: true, referralCode: "NOPE99" } }))).toBe("INVALID_REFERRAL_CODE");
    const friend = await signUp(h, "9833333333", { displayName: "Arun", referralCode: ` ${ref.code.toLowerCase()} ` });

    const joinedNote = (await h.db.query<{ title: string; body: string }>(
      `SELECT title, body FROM notifications WHERE user_id = $1`, [inviter.userId])).rows;
    expect(joinedNote).toEqual([{ title: "Arun joined with your code", body: "You'll both get 50 coins after their first recharge" }]);
    expect(json<{ joined: number; rewarded: number }>(await call(h, "GET", "/v1/referral", { token: inviter.accessToken })))
      .toMatchObject({ joined: 1, rewarded: 0 });

    // No purchase yet → nothing.
    expect(await tx(h.db, (c) => rewardReferral(c, friend.userId))).toBeNull();
    // First credited recharge → both paid, once.
    const pack = (await h.db.query<{ id: number }>(`SELECT id FROM coin_packages LIMIT 1`)).rows[0]!.id;
    await h.db.query(`INSERT INTO purchases (user_id, package_id, purchase_token, coins_credited, status) VALUES ($1, $2, 'tok-1', 100, 'credited')`,
      [friend.userId, pack]);
    expect(await tx(h.db, (c) => rewardReferral(c, friend.userId))).toMatchObject({ referrerCoins: 50, refereeCoins: 50, refereeName: "Arun" });
    expect(await tx(h.db, (c) => rewardReferral(c, friend.userId))).toBeNull();
    expect(await balance(h, inviter.userId, "coins")).toBe(50);
    expect(await balance(h, friend.userId, "coins")).toBe(50);
    expect(json<{ rewarded: number; coinsEarned: number }>(await call(h, "GET", "/v1/referral", { token: inviter.accessToken })))
      .toMatchObject({ rewarded: 1, coinsEarned: 50 });
  });

  it("a companion's code: the caller gets coins, the companion gets ₹ in earnings after the first recharge", async () => {
    const companionId = await createCompanion(h);
    const companion = await tokenFor(h, companionId, "companion");
    const ref = json<{ code: string; referrerPaise: number; referrerCoins: number }>(await call(h, "GET", "/v1/referral", { token: companion }));
    expect(ref).toMatchObject({ referrerPaise: 2500, referrerCoins: 0 });
    const friend = await signUp(h, "9877777777", { displayName: "Ravi", referralCode: ref.code });
    const note = (await h.db.query<{ body: string }>(`SELECT body FROM notifications WHERE user_id = $1`, [companionId])).rows;
    expect(note).toEqual([{ body: "You'll get ₹25 after their first recharge" }]);

    const pack = (await h.db.query<{ id: number }>(`SELECT id FROM coin_packages LIMIT 1`)).rows[0]!.id;
    await h.db.query(`INSERT INTO purchases (user_id, package_id, purchase_token, coins_credited, status) VALUES ($1, $2, 'tok-c', 100, 'credited')`,
      [friend.userId, pack]);
    expect(await tx(h.db, (c) => rewardReferral(c, friend.userId))).toMatchObject({ referrerCoins: 0, referrerPaise: 2500, refereeCoins: 50 });
    expect(await balance(h, companionId, "earnings")).toBe(2500);
    expect(await balance(h, companionId, "coins")).toBe(0);
    expect(await balance(h, friend.userId, "coins")).toBe(50);
    expect(json(await call(h, "GET", "/v1/referral", { token: companion }))).toMatchObject({ rewarded: 1, paiseEarned: 2500 });
  });

  it("stops paying the inviter past the cap (the friend still gets theirs)", async () => {
    await h.db.query(`UPDATE app_settings SET value = '0' WHERE key = 'referral.max_rewarded'`);
    try {
      const inviter = await signUp(h, "9844444444", { displayName: "Meena" });
      const { code } = json<{ code: string }>(await call(h, "GET", "/v1/referral", { token: inviter.accessToken }));
      const friend = await signUp(h, "9855555555", { referralCode: code });
      const pack = (await h.db.query<{ id: number }>(`SELECT id FROM coin_packages LIMIT 1`)).rows[0]!.id;
      await h.db.query(`INSERT INTO purchases (user_id, package_id, purchase_token, coins_credited, status) VALUES ($1, $2, 'tok-2', 100, 'credited')`,
        [friend.userId, pack]);
      expect(await tx(h.db, (c) => rewardReferral(c, friend.userId))).toMatchObject({ referrerCoins: 0, refereeCoins: 50 });
      expect(await balance(h, inviter.userId, "coins")).toBe(0);
    } finally {
      await h.db.query(`UPDATE app_settings SET value = '50' WHERE key = 'referral.max_rewarded'`);
    }
  });

  it("share card shows today's minutes, language and code — nothing about who", async () => {
    const me = await signUp(h, "9866666666", { displayName: "Karthik" });
    const card = json<Record<string, unknown>>(await call(h, "GET", "/v1/share-card", { token: me.accessToken }));
    expect(card).toMatchObject({ todayMinutes: 0, language: "ta", refereeCoins: 50 });
    expect(Object.keys(card).sort()).toEqual(["code", "language", "link", "refereeCoins", "todayMinutes"]);
  });
});
