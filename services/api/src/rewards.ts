/**
 * Companion rewards (design: Rewards.dc.html; CLAUDE.md "v2 rules"):
 * - Level from talk hours this month (or last month, whichever is higher) and
 *   rating; the level's boost % is added to per-minute earnings at call start.
 * - Online minutes per IST day, counted from the 60 s presence heartbeat; they
 *   drive the online streak and time-window bonus campaigns.
 */
import type { Redis } from "ioredis";
import { tx, type Db, type DbClient } from "./db/pool.js";
import { post } from "./billing/ledger.js";
import { numberSetting } from "./settings.js";
import { notify, rupeesText, type NotifyDeps } from "./notifications.js";

const IST_TODAY = `(now() AT TIME ZONE 'Asia/Kolkata')::date`;
const IST_MINUTE = `(EXTRACT(HOUR FROM now() AT TIME ZONE 'Asia/Kolkata') * 60 + EXTRACT(MINUTE FROM now() AT TIME ZONE 'Asia/Kolkata'))::int`;
const IST_WEEKDAY = `EXTRACT(ISODOW FROM now() AT TIME ZONE 'Asia/Kolkata')::int`;

export interface Level { level: number; name: string; minHours: number; minRating: number; boostPct: number }

export async function levels(db: Db | DbClient): Promise<Level[]> {
  return (await db.query<{ level: number; name: string; min_hours: number; min_rating: string; boost_pct: number }>(
    `SELECT * FROM companion_levels ORDER BY level`)).rows
    .map((l) => ({ level: l.level, name: l.name, minHours: l.min_hours, minRating: Number(l.min_rating), boostPct: l.boost_pct }));
}

export interface Standing { level: Level; next: Level | null; monthHours: number; bestHours: number; rating: number | null; ratingCount: number }

/** Where a companion stands. Hours = connected call time. */
export async function standing(db: Db | DbClient, companionId: string): Promise<Standing> {
  const [all, stats] = await Promise.all([
    levels(db),
    db.query<{ this_month: number; last_month: number; rating_sum: number; rating_count: number }>(
      `SELECT COALESCE((SELECT sum(EXTRACT(EPOCH FROM (ended_at - started_at))) FROM calls
                         WHERE companion_id = $1 AND started_at IS NOT NULL AND ended_at IS NOT NULL
                           AND started_at >= date_trunc('month', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata'), 0)::int AS this_month,
              COALESCE((SELECT sum(EXTRACT(EPOCH FROM (ended_at - started_at))) FROM calls
                         WHERE companion_id = $1 AND started_at IS NOT NULL AND ended_at IS NOT NULL
                           AND started_at >= (date_trunc('month', now() AT TIME ZONE 'Asia/Kolkata') - interval '1 month') AT TIME ZONE 'Asia/Kolkata'
                           AND started_at < date_trunc('month', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata'), 0)::int AS last_month,
              COALESCE(p.rating_sum, 0) AS rating_sum, COALESCE(p.rating_count, 0) AS rating_count
         FROM companion_profiles p WHERE p.user_id = $1`, [companionId]),
  ]);
  const s = stats.rows[0] ?? { this_month: 0, last_month: 0, rating_sum: 0, rating_count: 0 };
  const monthHours = Math.round((s.this_month / 3600) * 10) / 10;
  const bestHours = Math.max(s.this_month, s.last_month) / 3600;
  const rating = s.rating_count ? Math.round((s.rating_sum / s.rating_count) * 10) / 10 : null;
  const qualifies = (l: Level) => bestHours >= l.minHours && (l.minRating === 0 || (rating ?? 0) >= l.minRating);
  const reached = all.filter(qualifies);
  const level = reached.at(-1) ?? all[0] ?? { level: 1, name: "New voice", minHours: 0, minRating: 0, boostPct: 0 };
  const next = all.find((l) => l.level === level.level + 1) ?? null;
  return { level, next, monthHours, bestHours, rating, ratingCount: s.rating_count };
}

/** Per-minute earnings with the companion's level boost (used by pricing.ts at call start). */
export async function boostedPaise(db: Db | DbClient, companionId: string, basePaise: number): Promise<number> {
  const { level } = await standing(db, companionId);
  return level.boostPct ? Math.round((basePaise * (100 + level.boostPct)) / 100) : basePaise;
}

/**
 * Counts one online minute (called on each presence heartbeat). A Redis key per
 * minute makes a double heartbeat harmless. Also feeds any bonus window open now.
 */
export async function countOnlineMinute(db: Db, redis: Redis, companionId: string): Promise<void> {
  const minute = Math.floor(Date.now() / 60_000);
  if (!(await redis.set(`online:min:${companionId}:${minute}`, "1", "EX", 120, "NX"))) return;
  await db.query(
    `INSERT INTO companion_online_minutes (user_id, day, minutes) VALUES ($1, ${IST_TODAY}, 1)
     ON CONFLICT (user_id, day) DO UPDATE SET minutes = companion_online_minutes.minutes + 1`, [companionId]);
  await db.query(
    `INSERT INTO bonus_progress (campaign_id, user_id, day, minutes)
     SELECT b.id, $1, ${IST_TODAY}, 1 FROM bonus_campaigns b
      WHERE b.is_active AND ${IST_TODAY} >= b.starts_on AND (b.ends_on IS NULL OR ${IST_TODAY} <= b.ends_on)
        AND ${IST_WEEKDAY} = ANY(b.weekdays) AND ${IST_MINUTE} >= b.window_start AND ${IST_MINUTE} < b.window_end
     ON CONFLICT (campaign_id, user_id, day) DO UPDATE SET minutes = bonus_progress.minutes + 1`, [companionId]);
}

/** Consecutive IST days (ending today or yesterday) with at least the streak minimum online. */
export async function onlineStreak(db: Db | DbClient, companionId: string): Promise<number> {
  const min = await numberSetting(db, "companion.streak_min_minutes", 30);
  const days = (await db.query<{ ago: number }>(
    `SELECT (${IST_TODAY} - day)::int AS ago FROM companion_online_minutes
      WHERE user_id = $1 AND minutes >= $2 AND day > ${IST_TODAY} - 60 ORDER BY day DESC`, [companionId, min])).rows.map((r) => r.ago);
  if (!days.length || days[0]! > 1) return 0;
  let streak = 1;
  while (streak < days.length && days[streak] === days[0]! + streak) streak++;
  return streak;
}

export interface BonusView {
  id: number; title: string; rewardPaise: number; requiredMinutes: number; windowStart: number; windowEnd: number;
  doneMinutes: number; status: "upcoming" | "active" | "earned" | "paid" | "missed";
}

/** Today's bonus campaigns for a companion, with progress. */
export async function todaysBonuses(db: Db | DbClient, companionId: string): Promise<BonusView[]> {
  const rows = (await db.query<{ id: number; title: string; reward_paise: number; required_minutes: number; window_start: number;
    window_end: number; minutes: number | null; paid_at: Date | null; now_minute: number }>(
    `SELECT b.id, b.title, b.reward_paise, b.required_minutes, b.window_start, b.window_end, p.minutes, p.paid_at, ${IST_MINUTE} AS now_minute
       FROM bonus_campaigns b
       LEFT JOIN bonus_progress p ON p.campaign_id = b.id AND p.user_id = $1 AND p.day = ${IST_TODAY}
      WHERE b.is_active AND ${IST_TODAY} >= b.starts_on AND (b.ends_on IS NULL OR ${IST_TODAY} <= b.ends_on)
        AND ${IST_WEEKDAY} = ANY(b.weekdays)
      ORDER BY b.window_start`, [companionId])).rows;
  return rows.map((b) => {
    const done = b.minutes ?? 0;
    const status = b.paid_at ? "paid" : done >= b.required_minutes ? "earned"
      : b.now_minute >= b.window_end ? "missed" : b.now_minute >= b.window_start ? "active" : "upcoming";
    return { id: b.id, title: b.title, rewardPaise: b.reward_paise, requiredMinutes: b.required_minutes,
      windowStart: b.window_start, windowEnd: b.window_end, doneMinutes: done, status };
  });
}

/** Worker: pays every bonus someone has earned and not been paid (earnings wallet, ledger type 'bonus'). */
export async function payBonuses(deps: NotifyDeps & { db: Db }): Promise<number> {
  const due = (await deps.db.query<{ campaign_id: number; user_id: string; day: string; reward_paise: number; title: string }>(
    `SELECT p.campaign_id, p.user_id, to_char(p.day, 'YYYY-MM-DD') AS day, b.reward_paise, b.title
       FROM bonus_progress p JOIN bonus_campaigns b ON b.id = p.campaign_id
       JOIN users u ON u.id = p.user_id AND u.status = 'active'
      WHERE p.paid_at IS NULL AND p.minutes >= b.required_minutes
      LIMIT 1000`)).rows;
  let paid = 0;
  for (const d of due) {
    const ok = await tx(deps.db, async (c) => {
      const r = await c.query(
        `UPDATE bonus_progress SET paid_at = now() WHERE campaign_id = $1 AND user_id = $2 AND day = $3 AND paid_at IS NULL`,
        [d.campaign_id, d.user_id, d.day]);
      if (!r.rowCount) return false;
      await post(c, d.user_id, "earnings", "bonus", d.reward_paise, `bonus:${d.campaign_id}:${d.user_id}:${d.day}`, { note: d.title });
      return true;
    });
    if (ok) {
      paid++;
      await notify(deps, d.user_id, { type: "bonus_earned", title: `You earned ${rupeesText(d.reward_paise)} 🎉`, body: `${d.title} complete. Added to your earnings.` });
    }
  }
  return paid;
}
