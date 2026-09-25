/**
 * Daily check-in bonus and referrals (CLAUDE.md "v2 rules"). Amounts live in
 * app_settings (checkin.day1..7, referral.*) and are edited in the admin panel.
 */
import { randomInt } from "node:crypto";
import type { Db, DbClient } from "./db/pool.js";
import { post } from "./billing/ledger.js";
import { numberSetting } from "./settings.js";

export const IST_TODAY_SQL = `(now() AT TIME ZONE 'Asia/Kolkata')::date`;
const CYCLE = 7;

export async function checkinRewards(db: Db | DbClient): Promise<number[]> {
  const rows = (await db.query<{ key: string; value: unknown }>(
    `SELECT key, value FROM app_settings WHERE key LIKE 'checkin.day%'`)).rows;
  const fallback = [2, 2, 3, 3, 5, 5, 10];
  return fallback.map((d, i) => {
    const v = Number(rows.find((r) => r.key === `checkin.day${i + 1}`)?.value);
    return Number.isFinite(v) ? v : d;
  });
}

export interface CheckinState {
  /** The streak day today's claim is (or was) for, 1..7. */
  day: number;
  claimedToday: boolean;
  rewards: number[];
  /** Consecutive days claimed including today if claimed. */
  streak: number;
}

/** Where the user stands today. A missed day resets to Day 1; after Day 7 the cycle restarts. */
export async function checkinState(db: Db | DbClient, userId: string): Promise<CheckinState> {
  const rows = (await db.query<{ streak_day: number; ago: number }>(
    `SELECT streak_day, (${IST_TODAY_SQL} - day)::int AS ago FROM checkins
      WHERE user_id = $1 AND day > ${IST_TODAY_SQL} - 60 ORDER BY day DESC`, [userId])).rows;
  const rewards = await checkinRewards(db);
  const last = rows[0];
  if (!last || last.ago > 1) return { day: 1, claimedToday: false, rewards, streak: 0 };
  // Consecutive days back from the latest claim.
  let streak = 1;
  while (streak < rows.length && rows[streak]!.ago === last.ago + streak) streak++;
  return last.ago === 0
    ? { day: last.streak_day, claimedToday: true, rewards, streak }
    : { day: (last.streak_day % CYCLE) + 1, claimedToday: false, rewards, streak };
}

/** Claims today's bonus once. Returns the coins credited, or 0 if already claimed today. */
export async function claimCheckin(c: DbClient, userId: string): Promise<{ coins: number; day: number; balance: number | null }> {
  await c.query(`SELECT pg_advisory_xact_lock(hashtext('checkin:' || $1))`, [userId]);
  const s = await checkinState(c, userId);
  if (s.claimedToday) return { coins: 0, day: s.day, balance: null };
  const coins = s.rewards[s.day - 1] ?? 0;
  const today = (await c.query<{ d: string }>(`SELECT to_char(${IST_TODAY_SQL}, 'YYYY-MM-DD') AS d`)).rows[0]!.d;
  await c.query(`INSERT INTO checkins (user_id, day, streak_day, coins) VALUES ($1, $2, $3, $4)`, [userId, today, s.day, coins]);
  const balance = coins > 0
    ? await post(c, userId, "coins", "daily_bonus", coins, `checkin:${userId}:${today}`, { note: `Daily bonus, Day ${s.day}` })
    : null;
  return { coins, day: s.day, balance };
}

// ---------------------------------------------------------------------------
// Referrals

const codeBase = (name: string) => {
  const letters = name.toUpperCase().replace(/[^A-Z]/g, "").slice(0, 8);
  return letters.length >= 3 ? letters : "FRIEND";
};

/** The user's code, created on first use (e.g. KARTHIK47). */
export async function referralCode(db: Db, userId: string): Promise<string> {
  const u = (await db.query<{ referral_code: string | null; display_name: string }>(
    `SELECT referral_code, display_name FROM users WHERE id = $1`, [userId])).rows[0]!;
  if (u.referral_code) return u.referral_code;
  for (let attempt = 0; attempt < 8; attempt++) {
    const digits = attempt < 4 ? randomInt(10, 100) : randomInt(1000, 10_000);
    const code = `${codeBase(u.display_name)}${digits}`;
    const r = await db.query<{ referral_code: string }>(
      `UPDATE users SET referral_code = $2 WHERE id = $1 AND referral_code IS NULL
         AND NOT EXISTS (SELECT 1 FROM users WHERE referral_code = $2)
       RETURNING referral_code`, [userId, code]);
    if (r.rowCount) return r.rows[0]!.referral_code;
    const now = (await db.query<{ referral_code: string | null }>(`SELECT referral_code FROM users WHERE id = $1`, [userId])).rows[0]!;
    if (now.referral_code) return now.referral_code; // set by a parallel request
  }
  throw new Error("could not allocate a referral code");
}

export const normaliseCode = (code: string) => code.trim().toUpperCase().replace(/\s+/g, "");

/**
 * Called in the same transaction that credits a purchase: on the referee's
 * first credited recharge, both sides get their reward (once; capped per
 * referrer). A caller who invited gets coins; a companion who invited gets a
 * bonus in their earnings (referral.companion_bonus_paise).
 */
export async function rewardReferral(c: DbClient, refereeId: string):
  Promise<{ referrerId: string; referrerCoins: number; referrerPaise: number; refereeCoins: number; refereeName: string } | null> {
  const r = (await c.query<{ id: string; referrer_id: string; referrer_role: string; referee_name: string }>(
    `SELECT r.id, r.referrer_id, ref.role AS referrer_role, u.display_name AS referee_name
       FROM referrals r JOIN users u ON u.id = r.referee_id JOIN users ref ON ref.id = r.referrer_id
      WHERE r.referee_id = $1 AND r.status = 'joined' FOR UPDATE OF r`, [refereeId])).rows[0];
  if (!r) return null;
  const firstRecharge = (await c.query<{ n: number }>(
    `SELECT count(*)::int AS n FROM purchases WHERE user_id = $1 AND status = 'credited'`, [refereeId])).rows[0]!.n === 1;
  if (!firstRecharge) return null;

  const max = await numberSetting(c, "referral.max_rewarded", 50);
  const rewarded = (await c.query<{ n: number }>(
    `SELECT count(*)::int AS n FROM referrals WHERE referrer_id = $1 AND status = 'rewarded'`, [r.referrer_id])).rows[0]!.n;
  const companion = r.referrer_role === "companion";
  const underCap = rewarded < max;
  const referrerCoins = underCap && !companion ? await numberSetting(c, "referral.referrer_coins", 50) : 0;
  const referrerPaise = underCap && companion ? await numberSetting(c, "referral.companion_bonus_paise", 2500) : 0;
  const refereeCoins = await numberSetting(c, "referral.referee_coins", 50);
  if (referrerCoins > 0) {
    await post(c, r.referrer_id, "coins", "referral_bonus", referrerCoins, `referral:${r.id}:referrer`, { note: `Invite bonus: ${r.referee_name} joined` });
  }
  if (referrerPaise > 0) {
    await post(c, r.referrer_id, "earnings", "referral_bonus", referrerPaise, `referral:${r.id}:referrer`,
      { note: `Invite bonus: ${r.referee_name} made their first recharge` });
  }
  if (refereeCoins > 0) {
    await post(c, refereeId, "coins", "referral_bonus", refereeCoins, `referral:${r.id}:referee`, { note: "Welcome bonus for joining with an invite code" });
  }
  await c.query(
    `UPDATE referrals SET status = $2, referrer_coins = $3, referrer_paise = $4, referee_coins = $5, rewarded_at = now() WHERE id = $1`,
    [r.id, referrerCoins > 0 || referrerPaise > 0 ? "rewarded" : "capped", referrerCoins, referrerPaise, refereeCoins]);
  return { referrerId: r.referrer_id, referrerCoins, referrerPaise, refereeCoins, refereeName: r.referee_name };
}
