/** Companion Rewards screen, and the admin controls for levels and bonus campaigns. */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { notFound } from "../errors.js";
import { levels, onlineStreak, standing, todaysBonuses } from "../rewards.js";
import { numberSetting } from "../settings.js";
import { academyProgress } from "./academy.js";

const LevelZ = z.object({ level: z.number().int(), name: z.string(), minHours: z.number().int(), minRating: z.number(), boostPct: z.number().int() })
  .meta({ id: "CompanionLevel" });

const Bonus = z.object({
  id: z.number().int(), title: z.string(), rewardPaise: z.number().int(), requiredMinutes: z.number().int(),
  windowStart: z.number().int().describe("Minutes after IST midnight"), windowEnd: z.number().int(), doneMinutes: z.number().int(),
  status: z.enum(["upcoming", "active", "earned", "paid", "missed"]),
}).meta({ id: "CompanionBonus" });

const Campaign = z.object({
  id: z.number().int(), title: z.string(), rewardPaise: z.number().int(), requiredMinutes: z.number().int(),
  windowStart: z.number().int(), windowEnd: z.number().int(), weekdays: z.array(z.number().int()),
  startsOn: z.string(), endsOn: z.string().nullable(), isActive: z.boolean(),
}).meta({ id: "BonusCampaign" });

const CampaignInput = z.object({
  title: z.string().trim().min(3).max(60),
  rewardPaise: z.number().int().min(100).max(1_000_000),
  requiredMinutes: z.number().int().min(10).max(1440),
  windowStart: z.number().int().min(0).max(1439),
  windowEnd: z.number().int().min(1).max(1440),
  weekdays: z.array(z.number().int().min(1).max(7)).min(1).max(7),
  startsOn: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  endsOn: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).nullish(),
  isActive: z.boolean(),
}).refine((c) => c.windowEnd > c.windowStart && c.requiredMinutes <= c.windowEnd - c.windowStart,
  "The window must end after it starts and be at least as long as the required minutes");

type CampaignRow = { id: number; title: string; reward_paise: number; required_minutes: number; window_start: number; window_end: number;
  weekdays: number[]; starts_on: string; ends_on: string | null; is_active: boolean };
const toCampaign = (c: CampaignRow) => ({
  id: c.id, title: c.title, rewardPaise: c.reward_paise, requiredMinutes: c.required_minutes, windowStart: c.window_start,
  windowEnd: c.window_end, weekdays: c.weekdays, startsOn: c.starts_on, endsOn: c.ends_on, isActive: c.is_active,
});
const CAMPAIGN_COLS = `id, title, reward_paise, required_minutes, window_start, window_end, weekdays,
  to_char(starts_on, 'YYYY-MM-DD') AS starts_on, to_char(ends_on, 'YYYY-MM-DD') AS ends_on, is_active`;

async function audit(c: DbClient, actorId: string, action: string, targetId: string | number, details: Record<string, unknown>) {
  await c.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, $2, 'rewards', $3, $4)`,
    [actorId, action, String(targetId), JSON.stringify(details)]);
}

export const rewardsRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const adminBase = { tags: ["admin"], security: bearer };

  app.get("/companion/rewards", {
    preHandler: requireAuth("companion"),
    schema: {
      tags: ["companion"],
      security: bearer,
      summary: "Rewards screen: level, today's goal, online streak and bonuses",
      response: {
        200: z.object({
          level: LevelZ, next: LevelZ.nullable(),
          monthHours: z.number(), rating: z.number().nullable(), ratingCount: z.number().int(),
          todayEarnedPaise: z.number().int(), dailyGoalPaise: z.number().int(),
          streakDays: z.number().int(),
          bonuses: z.array(Bonus),
          academy: z.object({ passed: z.number().int(), total: z.number().int() }),
          videoEnabled: z.boolean(),
        }),
      },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const [s, goal, streak, bonuses, today, academy, video] = await Promise.all([
      standing(db, userId),
      numberSetting(db, "companion.daily_goal_paise", 30000),
      onlineStreak(db, userId),
      todaysBonuses(db, userId),
      db.query<{ paise: number }>(
        `SELECT COALESCE(sum(l.amount), 0)::int AS paise FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.user_id = $1 AND w.kind = 'earnings' AND l.amount > 0 AND l.type IN ('call_credit', 'gift_credit', 'bonus')
            AND (l.created_at AT TIME ZONE 'Asia/Kolkata')::date = (now() AT TIME ZONE 'Asia/Kolkata')::date`, [userId]),
      academyProgress(db, userId),
      db.query<{ video_enabled: boolean }>(`SELECT video_enabled FROM companion_profiles WHERE user_id = $1`, [userId]),
    ]);
    return {
      level: s.level, next: s.next, monthHours: s.monthHours, rating: s.rating, ratingCount: s.ratingCount,
      todayEarnedPaise: today.rows[0]!.paise, dailyGoalPaise: goal, streakDays: streak, bonuses,
      academy, videoEnabled: video.rows[0]?.video_enabled ?? false,
    };
  });

  // --- admin -------------------------------------------------------------------
  app.get("/admin/companion-levels", {
    preHandler: can("engagement.manage"),
    schema: { ...adminBase, summary: "Companion levels", response: { 200: z.array(LevelZ) } },
  }, async () => levels(db));

  app.put("/admin/companion-levels/:level", {
    preHandler: can("engagement.manage"),
    schema: {
      ...adminBase,
      summary: "Change a level's name, thresholds or earnings boost (applies to calls that start after this)",
      params: z.object({ level: z.coerce.number().int().min(1) }),
      body: z.object({ name: z.string().trim().min(2).max(30), minHours: z.number().int().min(0).max(744),
        minRating: z.number().min(0).max(5), boostPct: z.number().int().min(0).max(50) }),
      response: { 200: LevelZ },
    },
  }, async (req) => tx(db, async (c) => {
    const before = (await c.query(`SELECT * FROM companion_levels WHERE level = $1 FOR UPDATE`, [req.params.level])).rows[0];
    if (!before) throw notFound("LEVEL_NOT_FOUND");
    const b = req.body;
    await c.query(`UPDATE companion_levels SET name = $2, min_hours = $3, min_rating = $4, boost_pct = $5 WHERE level = $1`,
      [req.params.level, b.name, b.minHours, b.minRating, b.boostPct]);
    await audit(c, me(req).userId, "level.update", req.params.level, { before, after: b });
    return { level: req.params.level, ...b };
  }));

  app.get("/admin/bonus-campaigns", {
    preHandler: can("engagement.manage"),
    schema: { ...adminBase, summary: "Time-window bonus campaigns for companions", response: { 200: z.array(Campaign) } },
  }, async () => (await db.query<CampaignRow>(`SELECT ${CAMPAIGN_COLS} FROM bonus_campaigns ORDER BY is_active DESC, window_start`)).rows.map(toCampaign));

  app.post("/admin/bonus-campaigns", {
    preHandler: can("engagement.manage"),
    schema: { ...adminBase, summary: "Create a bonus campaign", body: CampaignInput, response: { 201: Campaign } },
  }, async (req, reply) => {
    const b = req.body;
    const row = await tx(db, async (c) => {
      const r = (await c.query<CampaignRow>(
        `INSERT INTO bonus_campaigns (title, reward_paise, required_minutes, window_start, window_end, weekdays, starts_on, ends_on, is_active)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING ${CAMPAIGN_COLS}`,
        [b.title, b.rewardPaise, b.requiredMinutes, b.windowStart, b.windowEnd, b.weekdays, b.startsOn, b.endsOn ?? null, b.isActive])).rows[0]!;
      await audit(c, me(req).userId, "bonus.create", r.id, { ...b });
      return r;
    });
    reply.status(201);
    return toCampaign(row);
  });

  app.put("/admin/bonus-campaigns/:id", {
    preHandler: can("engagement.manage"),
    schema: { ...adminBase, summary: "Edit or switch off a bonus campaign", params: z.object({ id: z.coerce.number().int() }), body: CampaignInput, response: { 200: Campaign } },
  }, async (req) => tx(db, async (c) => {
    const b = req.body;
    const r = (await c.query<CampaignRow>(
      `UPDATE bonus_campaigns SET title = $2, reward_paise = $3, required_minutes = $4, window_start = $5, window_end = $6,
              weekdays = $7, starts_on = $8, ends_on = $9, is_active = $10 WHERE id = $1 RETURNING ${CAMPAIGN_COLS}`,
      [req.params.id, b.title, b.rewardPaise, b.requiredMinutes, b.windowStart, b.windowEnd, b.weekdays, b.startsOn, b.endsOn ?? null, b.isActive])).rows[0];
    if (!r) throw notFound("CAMPAIGN_NOT_FOUND");
    await audit(c, me(req).userId, "bonus.update", r.id, { ...b });
    return toCampaign(r);
  }));
};
