/**
 * Growth features (owner, 2026-09-25):
 * - Weekly leaderboards (Mon–Sun, India time): top companions by coins callers spent
 *   on them (calls, lives, groups, gifts) and top fans by gift coins sent. The top N
 *   of last week get a badge for the following week (worker: awardWeeklyBadges).
 * - Festival events: admin-set dates, theme and featured gifts, with their own
 *   leaderboards; winners get event badges when the event ends.
 * - Caller levels by lifetime coins spent (users.coins_spent, kept by a DB trigger);
 *   the worker announces level-ups.
 * - Companion invites companion: the referral pays once the new companion has
 *   completed N paid hours (worker: rewardCompanionInvites).
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type Db, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { ApiError, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import type { UserEvents } from "../billing/ports.js";
import type { PushSender } from "../push.js";
import { notify } from "../notifications.js";
import { numberSetting } from "../settings.js";
import { PHOTO_V_SQL, photoUrl } from "./photos.js";

type Board = "companions" | "fans";
type Deps = { db: Db; events: UserEvents; push: PushSender };

/** Start of this week (Monday 00:00 India time) as SQL. */
const WEEK_START_SQL = `(date_trunc('week', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata')`;

/** Scores for a board between two times: [{ user_id, score }] best first. */
async function scores(db: Db | DbClient, board: Board, from: Date, to: Date, limit: number) {
  const sql = board === "companions"
    ? `WITH spend AS (
         SELECT companion_id AS uid, coins_charged::bigint AS coins FROM calls WHERE started_at >= $1 AND started_at < $2
         UNION ALL SELECT l.host_id, t.coins FROM live_ticks t JOIN lives l ON l.id = t.live_id WHERE t.created_at >= $1 AND t.created_at < $2
         UNION ALL SELECT g.host_id, t.coins FROM group_ticks t JOIN group_sessions g ON g.id = t.session_id WHERE t.created_at >= $1 AND t.created_at < $2
         UNION ALL SELECT receiver_id, coins FROM all_gifts WHERE created_at >= $1 AND created_at < $2)
       SELECT s.uid AS user_id, sum(s.coins)::bigint AS score FROM spend s JOIN users u ON u.id = s.uid
        WHERE u.role = 'companion' AND u.status = 'active' GROUP BY s.uid HAVING sum(s.coins) > 0
        ORDER BY score DESC, s.uid LIMIT $3`
    : `SELECT g.sender_id AS user_id, sum(g.coins)::bigint AS score FROM all_gifts g JOIN users u ON u.id = g.sender_id
        WHERE g.created_at >= $1 AND g.created_at < $2 AND u.role = 'caller' AND u.status = 'active'
        GROUP BY g.sender_id ORDER BY score DESC, g.sender_id LIMIT $3`;
  return (await db.query<{ user_id: string; score: string }>(sql, [from, to, limit])).rows
    .map((r) => ({ userId: r.user_id, score: Number(r.score) }));
}

async function weekBounds(db: Db | DbClient, offsetWeeks: number) {
  const r = (await db.query<{ from: Date; to: Date }>(
    `SELECT ${WEEK_START_SQL} - make_interval(weeks => $1) AS from, ${WEEK_START_SQL} - make_interval(weeks => $1 - 1) AS to`,
    [offsetWeeks])).rows[0]!;
  return r;
}

/** Best active badge per user (lowest rank wins; event badges beat weekly ones). */
export async function activeBadges(db: Db | DbClient, ids: string[]) {
  if (!ids.length) return new Map<string, { label: string; rank: number | null; kind: string }>();
  const rows = (await db.query<{ user_id: string; label: string; rank: number | null; kind: string }>(
    `SELECT DISTINCT ON (user_id) user_id, label, rank, kind FROM user_badges
      WHERE user_id = ANY($1::uuid[]) AND expires_at > now()
      ORDER BY user_id, (kind LIKE 'event_%') DESC, rank NULLS LAST, created_at DESC`, [ids])).rows;
  return new Map(rows.map((r) => [r.user_id, { label: r.label, rank: r.rank, kind: r.kind }]));
}

export const Badge = z.object({ label: z.string(), rank: z.number().int().nullable(), kind: z.string() }).meta({ id: "UserBadge" });

/** Caller level for `coins` spent. */
export async function levelFor(db: Db | DbClient, coins: number) {
  const rows = (await db.query<{ level: number; name: string; min_coins: number; perk: string | null }>(
    `SELECT level, name, min_coins, perk FROM caller_levels ORDER BY level`)).rows;
  const current = [...rows].reverse().find((l) => coins >= l.min_coins) ?? rows[0]!;
  const next = rows.find((l) => l.min_coins > coins) ?? null;
  return { current, next };
}

// --- worker jobs --------------------------------------------------------------------------

/** Hand out last week's badges once (top N of each board), and finished events' badges. */
export async function awardBadges(deps: Deps): Promise<number> {
  const { db } = deps;
  const topN = await numberSetting(db, "leaderboard.badge_top_n", 10);
  let given = 0;
  const week = await weekBounds(db, 1);
  const fresh = (await db.query(`INSERT INTO leaderboard_awards (week_start) VALUES ($1) ON CONFLICT DO NOTHING`, [week.from])).rowCount;
  if (fresh) {
    for (const board of ["companions", "fans"] as const) {
      for (const [i, s] of (await scores(db, board, week.from, week.to, topN)).entries()) {
        const label = board === "companions" ? `#${i + 1} companion this week` : `#${i + 1} fan this week`;
        await db.query(
          `INSERT INTO user_badges (user_id, kind, rank, label, period_start, expires_at) VALUES ($1, $2, $3, $4, $5, $6::timestamptz + interval '7 days')
           ON CONFLICT DO NOTHING`, [s.userId, board === "companions" ? "top_companion" : "top_fan", i + 1, label, week.from, week.to]);
        await notify(deps, s.userId, {
          type: "badge_won", title: `You're #${i + 1} ${board === "companions" ? "companion" : "fan"} of the week! 🏆`,
          body: "Your badge shows on your profile all this week.",
        });
        given++;
      }
    }
  }
  const ended = (await db.query<{ id: string; name: string; starts_at: Date; ends_at: Date }>(
    `SELECT id, name, starts_at, ends_at FROM events WHERE active AND ends_at <= now() AND badges_awarded_at IS NULL`)).rows;
  for (const e of ended) {
    await tx(db, async (c) => {
      const claimed = await c.query(`UPDATE events SET badges_awarded_at = now() WHERE id = $1 AND badges_awarded_at IS NULL`, [e.id]);
      if (!claimed.rowCount) return;
      for (const board of ["companions", "fans"] as const) {
        for (const [i, s] of (await scores(c, board, e.starts_at, e.ends_at, topN)).entries()) {
          await c.query(
            `INSERT INTO user_badges (user_id, kind, rank, label, period_start, event_id, expires_at)
             VALUES ($1, $2, $3, $4, $5, $6, now() + interval '30 days') ON CONFLICT DO NOTHING`,
            [s.userId, board === "companions" ? "event_companion" : "event_fan", i + 1,
              `${e.name} · #${i + 1} ${board === "companions" ? "companion" : "fan"}`, e.starts_at, e.id]);
          given++;
        }
      }
    });
  }
  return given;
}

/** Tell callers who moved up a level (users.coins_spent is kept by a trigger). */
export async function announceLevelUps(deps: Deps): Promise<number> {
  const ups = (await deps.db.query<{ id: string; level: number; name: string }>(
    `WITH lv AS (
       SELECT u.id, (SELECT max(level) FROM caller_levels l WHERE l.min_coins <= u.coins_spent) AS level
         FROM users u WHERE u.role = 'caller' AND u.status = 'active')
     UPDATE users u SET caller_level = lv.level FROM lv
      WHERE u.id = lv.id AND lv.level > u.caller_level
     RETURNING u.id, lv.level, (SELECT name FROM caller_levels WHERE level = lv.level) AS name`)).rows;
  for (const u of ups) {
    await notify(deps, u.id, { type: "level_up", title: `Level ${u.level} — ${u.name}! 🎉`, body: "Companions can see your new level badge." });
  }
  return ups.length;
}

/**
 * Companion invites companion: once the woman who joined with the code has N paid
 * hours of calls, the inviter is rewarded — ₹ to a companion's earnings, or the
 * usual invite coins to a caller.
 */
export async function rewardCompanionInvites(deps: Deps): Promise<number> {
  const { db } = deps;
  const [hours, paise, coins, max] = await Promise.all([
    numberSetting(db, "referral.companion_invite_hours", 10), numberSetting(db, "referral.companion_invite_paise", 10_000),
    numberSetting(db, "referral.referrer_coins", 50), numberSetting(db, "referral.max_rewarded", 50),
  ]);
  const due = (await db.query<{ id: string; referrer_id: string; referrer_role: string; name: string }>(
    `SELECT r.id, r.referrer_id, ref.role AS referrer_role, u.display_name AS name
       FROM referrals r JOIN users u ON u.id = r.referee_id JOIN users ref ON ref.id = r.referrer_id
      WHERE r.status = 'joined' AND u.role = 'companion' AND ref.status = 'active'
        AND (SELECT COALESCE(sum(minutes_charged), 0) FROM calls c WHERE c.companion_id = u.id) >= $1 * 60`, [hours])).rows;
  let paid = 0;
  for (const r of due) {
    await tx(db, async (c) => {
      const row = (await c.query(`SELECT 1 FROM referrals WHERE id = $1 AND status = 'joined' FOR UPDATE`, [r.id])).rowCount;
      if (!row) return;
      const rewarded = (await c.query<{ n: number }>(
        `SELECT count(*)::int AS n FROM referrals WHERE referrer_id = $1 AND status = 'rewarded'`, [r.referrer_id])).rows[0]!.n;
      if (rewarded >= max) {
        await c.query(`UPDATE referrals SET status = 'capped', rewarded_at = now() WHERE id = $1`, [r.id]);
        return;
      }
      const companion = r.referrer_role === "companion";
      if (companion) {
        await post(c, r.referrer_id, "earnings", "referral_bonus", paise, `referral:${r.id}:companion-invite`,
          { note: `Invite bonus: ${r.name} completed ${hours} paid hours` });
      } else {
        await post(c, r.referrer_id, "coins", "referral_bonus", coins, `referral:${r.id}:companion-invite`,
          { note: `Invite bonus: ${r.name} completed ${hours} paid hours` });
      }
      await c.query(`UPDATE referrals SET status = 'rewarded', referrer_paise = $2, referrer_coins = $3, rewarded_at = now() WHERE id = $1`,
        [r.id, companion ? paise : 0, companion ? 0 : coins]);
      paid++;
    });
    await notify(deps, r.referrer_id, {
      type: "referral_rewarded", title: "Invite bonus earned 🎉",
      body: r.referrer_role === "companion" ? `₹${paise / 100} added — ${r.name} completed ${hours} paid hours.` : `${coins} coins added — ${r.name} completed ${hours} paid hours.`,
    });
  }
  return paid;
}

// --- routes -------------------------------------------------------------------------------

const Entry = z.object({
  rank: z.number().int(),
  user: z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int(), photoUrl: z.string().nullable() }),
  score: z.number().int().describe("Coins"),
}).meta({ id: "LeaderboardEntry" });

const EventZ = z.object({
  id: z.uuid(), name: z.string(), tagline: z.string().nullable(), theme: z.string(),
  startsAt: z.date(), endsAt: z.date(), giftIds: z.array(z.number().int()),
}).meta({ id: "AppEvent" });

type EventRow = { id: string; name: string; tagline: string | null; theme: string; starts_at: Date; ends_at: Date; gift_ids: number[];
  active: boolean; badges_awarded_at: Date | null };
const toEvent = (e: EventRow) => ({ id: e.id, name: e.name, tagline: e.tagline, theme: e.theme, startsAt: e.starts_at, endsAt: e.ends_at, giftIds: e.gift_ids });

export const leaderboardRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const base = { tags: ["growth"], security: bearer };
  const signedIn = requireAuth("caller", "companion");

  app.get("/leaderboards", {
    preHandler: signedIn,
    schema: {
      ...base,
      summary: "Top companions (coins spent on them) or top fans (gift coins sent): this week, last week, or an event",
      querystring: z.object({
        board: z.enum(["companions", "fans"]),
        period: z.enum(["this_week", "last_week", "event"]).default("this_week"),
        eventId: z.uuid().optional(),
      }),
      response: { 200: z.object({ from: z.date(), to: z.date(), items: z.array(Entry), me: Entry.nullable() }) },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const { board, period, eventId } = req.query;
    let from: Date, to: Date;
    if (period === "event") {
      const e = (await db.query<EventRow>(`SELECT * FROM events WHERE id = $1`, [eventId ?? null])).rows[0];
      if (!e) throw notFound("EVENT_NOT_FOUND");
      ({ starts_at: from, ends_at: to } = e);
    } else {
      ({ from, to } = await weekBounds(db, period === "this_week" ? 0 : 1));
    }
    const all = await scores(db, board, from, to, 500);
    const top = all.slice(0, 50);
    const mine = all.findIndex((s) => s.userId === userId);
    const ids = [...new Set([...top.map((s) => s.userId), ...(mine >= 0 ? [userId] : [])])];
    const users = new Map((await db.query<{ id: string; display_name: string; avatar_id: number; photo_v: number | null }>(
      `SELECT id, display_name, avatar_id, ${PHOTO_V_SQL("u")} AS photo_v FROM users u WHERE id = ANY($1::uuid[])`, [ids])).rows
      .map((u) => [u.id, u]));
    const entry = (s: { userId: string; score: number }, rank: number) => {
      const u = users.get(s.userId)!;
      return {
        rank, score: s.score,
        user: { id: u.id, displayName: u.display_name, avatarId: u.avatar_id,
          // Callers stay avatar-only; companions may have an approved photo.
          photoUrl: board === "companions" ? photoUrl(app.deps.kycKey, u.id, u.photo_v) : null },
      };
    };
    return { from, to, items: top.map((s, i) => entry(s, i + 1)), me: mine >= 0 ? entry(all[mine]!, mine + 1) : null };
  });

  app.get("/events/current", {
    preHandler: signedIn,
    schema: { ...base, summary: "The festival event running now, if any", response: { 200: z.object({ event: EventZ.nullable() }) } },
  }, async () => {
    const e = (await db.query<EventRow>(
      `SELECT * FROM events WHERE active AND starts_at <= now() AND ends_at > now() ORDER BY starts_at DESC LIMIT 1`)).rows[0];
    return { event: e ? toEvent(e) : null };
  });

  app.get("/me/level", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "My caller level, from lifetime coins spent",
      response: {
        200: z.object({
          level: z.number().int(), name: z.string(), perk: z.string().nullable(), coinsSpent: z.number().int(),
          next: z.object({ level: z.number().int(), name: z.string(), minCoins: z.number().int() }).nullable(),
        }),
      },
    },
  }, async (req) => {
    const spent = Number((await db.query<{ s: string }>(`SELECT coins_spent AS s FROM users WHERE id = $1`, [me(req).userId])).rows[0]!.s);
    const { current, next } = await levelFor(db, spent);
    return {
      level: current.level, name: current.name, perk: current.perk, coinsSpent: spent,
      next: next ? { level: next.level, name: next.name, minCoins: next.min_coins } : null,
    };
  });

  // --- admin ------------------------------------------------------------------------------
  const EventBody = z.object({
    name: z.string().trim().min(3).max(60),
    tagline: z.string().trim().max(120).nullish(),
    theme: z.enum(["festive", "pongal", "diwali", "onam", "holi", "love", "cricket"]),
    startsAt: z.coerce.date(),
    endsAt: z.coerce.date(),
    giftIds: z.array(z.number().int()).max(12).default([]),
    active: z.boolean().default(true),
  }).refine((b) => b.endsAt > b.startsAt, { message: "The event must end after it starts" });
  const AdminEvent = EventZ.extend({ active: z.boolean(), badgesAwarded: z.boolean() }).meta({ id: "AdminEvent" });
  const toAdmin = (e: EventRow) => ({ ...toEvent(e), active: e.active, badgesAwarded: !!e.badges_awarded_at });

  app.get("/admin/events", {
    preHandler: can("engagement.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "Festival events, newest first", response: { 200: z.array(AdminEvent) } },
  }, async () => (await db.query<EventRow>(`SELECT * FROM events ORDER BY starts_at DESC LIMIT 100`)).rows.map(toAdmin));

  app.post("/admin/events", {
    preHandler: can("engagement.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "Create a festival event", body: EventBody, response: { 201: AdminEvent } },
  }, async (req, reply) => {
    const b = req.body;
    const e = (await db.query<EventRow>(
      `INSERT INTO events (name, tagline, theme, starts_at, ends_at, gift_ids, active, created_by) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
      [b.name, b.tagline ?? null, b.theme, b.startsAt, b.endsAt, b.giftIds, b.active, me(req).userId])).rows[0]!;
    await db.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, 'event.create', 'event', $2, $3)`,
      [me(req).userId, e.id, JSON.stringify(b)]);
    reply.status(201);
    return toAdmin(e);
  });

  app.put("/admin/events/:id", {
    preHandler: can("engagement.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "Edit an event", params: z.object({ id: z.uuid() }), body: EventBody,
      response: { 200: AdminEvent } },
  }, async (req) => {
    const b = req.body;
    const e = (await db.query<EventRow>(
      `UPDATE events SET name = $2, tagline = $3, theme = $4, starts_at = $5, ends_at = $6, gift_ids = $7, active = $8 WHERE id = $1 RETURNING *`,
      [req.params.id, b.name, b.tagline ?? null, b.theme, b.startsAt, b.endsAt, b.giftIds, b.active])).rows[0];
    if (!e) throw notFound("EVENT_NOT_FOUND");
    await db.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, 'event.update', 'event', $2, $3)`,
      [me(req).userId, e.id, JSON.stringify(b)]);
    return toAdmin(e);
  });

  const Level = z.object({ level: z.number().int(), name: z.string(), minCoins: z.number().int(), perk: z.string().nullable() })
    .meta({ id: "CallerLevel" });

  app.get("/admin/caller-levels", {
    preHandler: can("engagement.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "Caller levels (by lifetime coins spent)", response: { 200: z.array(Level) } },
  }, async () => (await db.query<{ level: number; name: string; min_coins: number; perk: string | null }>(
    `SELECT * FROM caller_levels ORDER BY level`)).rows.map((l) => ({ level: l.level, name: l.name, minCoins: l.min_coins, perk: l.perk })));

  app.put("/admin/caller-levels/:level", {
    preHandler: can("engagement.manage"),
    schema: {
      tags: ["admin"], security: bearer, summary: "Edit a caller level",
      params: z.object({ level: z.coerce.number().int().min(1) }),
      body: z.object({ name: z.string().trim().min(2).max(30), minCoins: z.number().int().min(0), perk: z.string().trim().max(80).nullish() }),
      response: { 200: Level },
    },
  }, async (req) => {
    const { level } = req.params;
    const b = req.body;
    // Thresholds must keep rising with the level.
    const clash = (await db.query(
      `SELECT 1 FROM caller_levels WHERE (level < $1 AND min_coins >= $2) OR (level > $1 AND min_coins <= $2)`, [level, b.minCoins])).rowCount;
    if (clash || (level === 1 && b.minCoins !== 0)) throw new ApiError(400, "LEVEL_ORDER", "Each level needs more coins than the one before (level 1 starts at 0)");
    const l = (await db.query<{ level: number; name: string; min_coins: number; perk: string | null }>(
      `UPDATE caller_levels SET name = $2, min_coins = $3, perk = $4 WHERE level = $1 RETURNING *`,
      [level, b.name, b.minCoins, b.perk ?? null])).rows[0];
    if (!l) throw notFound("LEVEL_NOT_FOUND");
    await db.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, 'caller_level.update', 'caller_level', $2, $3)`,
      [me(req).userId, String(level), JSON.stringify(b)]);
    return { level: l.level, name: l.name, minCoins: l.min_coins, perk: l.perk };
  });
};
