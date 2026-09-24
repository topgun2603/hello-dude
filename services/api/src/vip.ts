/**
 * VIP (CLAUDE.md "v2 rules"): 10% off call minutes paid by the platform (the
 * companion still earns the full rate), first pick in instant match, a gold
 * badge, and one free Rose per IST week (used within that week).
 */
import type { Db, DbClient } from "./db/pool.js";
import { numberSetting } from "./settings.js";

export const FREE_GIFT_CODE = "rose";

export async function activeVip(db: Db | DbClient, userId: string): Promise<{ expiresAt: Date; source: string } | null> {
  const r = (await db.query<{ expires_at: Date; source: string }>(
    `SELECT expires_at, source FROM vip_subscriptions
      WHERE user_id = $1 AND cancelled_at IS NULL AND starts_at <= now() AND expires_at > now()
      ORDER BY expires_at DESC LIMIT 1`, [userId])).rows[0];
  return r ? { expiresAt: r.expires_at, source: r.source } : null;
}

export async function vipDiscountPct(db: Db | DbClient): Promise<number> {
  return Math.min(90, Math.max(0, await numberSetting(db, "vip.discount_pct", 10)));
}

/** The per-minute coin price a VIP pays: rounded down in their favour, never below 1. */
export const discounted = (coinsPerMin: number, pct: number) => Math.max(1, Math.floor((coinsPerMin * (100 - pct)) / 100));

const WEEK_START_SQL = `date_trunc('week', now() AT TIME ZONE 'Asia/Kolkata')::date`;

/** This week's free gift for a VIP, created on first look. Null when not VIP or the gift is gone. */
export async function weeklyGift(db: Db | DbClient, userId: string): Promise<{ giftId: number; used: boolean; weekStart: string } | null> {
  if (!(await activeVip(db, userId))) return null;
  const gift = (await db.query<{ id: number }>(`SELECT id FROM gifts WHERE code = $1 AND is_active`, [FREE_GIFT_CODE])).rows[0];
  if (!gift) return null;
  await db.query(
    `INSERT INTO vip_gift_credits (user_id, week_start, gift_id) VALUES ($1, ${WEEK_START_SQL}, $2) ON CONFLICT DO NOTHING`,
    [userId, gift.id]);
  const r = (await db.query<{ gift_id: number; used: boolean; week_start: string }>(
    `SELECT gift_id, used_at IS NOT NULL AS used, to_char(week_start, 'YYYY-MM-DD') AS week_start
       FROM vip_gift_credits WHERE user_id = $1 AND week_start = ${WEEK_START_SQL}`, [userId])).rows[0]!;
  return { giftId: r.gift_id, used: r.used, weekStart: r.week_start };
}

/** Uses this week's free gift for a call gift, if it's that gift and still unused. True if it was free. */
export async function spendWeeklyGift(c: DbClient, userId: string, giftId: number, callGiftId: string): Promise<boolean> {
  const credit = await weeklyGift(c, userId);
  if (!credit || credit.used || credit.giftId !== giftId) return false;
  const r = await c.query(
    `UPDATE vip_gift_credits SET used_at = now(), call_gift_id = $3
      WHERE user_id = $1 AND week_start = $2::date AND used_at IS NULL`, [userId, credit.weekStart, callGiftId]);
  return r.rowCount === 1;
}
