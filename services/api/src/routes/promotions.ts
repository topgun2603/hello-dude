/**
 * App-open offers popup: admins set up promotions; the app asks for the one to
 * show each time it opens and draws it as a bottom sheet with confetti.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type Db, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { notFound } from "../errors.js";
import { IST_TODAY_SQL } from "../growth.js";

const CtaAction = z.enum(["wallet", "vip", "checkin", "referral", "online", "rooms", "rewards", "none"])
  .describe("Where the button goes inside the app");
const Theme = z.enum(["brand", "gold", "green"]);
const Audience = z.enum(["all", "callers", "companions", "never_paid", "paid"])
  .describe("never_paid / paid = callers with no / at least one credited coin purchase");
const Frequency = z.enum(["every_open", "daily", "once"])
  .describe("every_open = each time the app opens; daily = once per IST day; once = only ever once");

/** What the app draws. */
export const Promotion = z.object({
  id: z.number().int(),
  title: z.string(),
  body: z.string(),
  highlight: z.string().nullable(),
  badge: z.string().nullable(),
  emoji: z.string().nullable(),
  ctaLabel: z.string(),
  ctaAction: CtaAction,
  theme: Theme,
  confetti: z.boolean(),
  endsAt: z.date().nullable().describe("Show a countdown when set"),
}).meta({ id: "Promotion" });

const AdminPromotion = Promotion.extend({
  audience: Audience,
  frequency: Frequency,
  priority: z.number().int(),
  isActive: z.boolean(),
  startsAt: z.date(),
  status: z.enum(["live", "scheduled", "ended", "off"]),
  shown: z.number().int(),
  clicked: z.number().int(),
  shownToday: z.number().int(),
  clickedToday: z.number().int(),
  reach: z.number().int().describe("Different people who saw it"),
  createdAt: z.date(),
}).meta({ id: "AdminPromotion" });

const PromotionInput = z.object({
  title: z.string().trim().min(3).max(60),
  body: z.string().trim().max(200).default(""),
  highlight: z.string().trim().max(24).nullish(),
  badge: z.string().trim().max(24).nullish(),
  emoji: z.string().trim().max(8).nullish(),
  ctaLabel: z.string().trim().min(2).max(24),
  ctaAction: CtaAction,
  theme: Theme,
  audience: Audience,
  frequency: Frequency,
  confetti: z.boolean(),
  priority: z.number().int().min(0).max(1000),
  isActive: z.boolean(),
  startsAt: z.coerce.date(),
  endsAt: z.coerce.date().nullish(),
}).refine((b) => !b.endsAt || b.endsAt > b.startsAt, { message: "The end must be after the start", path: ["endsAt"] });
type PromotionInput = z.infer<typeof PromotionInput>;

// eslint-disable-next-line @typescript-eslint/no-explicit-any -- pg row
type Row = Record<string, any>;

const toApp = (r: Row): z.infer<typeof Promotion> => ({
  id: r.id, title: r.title, body: r.body, highlight: r.highlight || null, badge: r.badge || null, emoji: r.emoji || null,
  ctaLabel: r.cta_label, ctaAction: r.cta_action, theme: r.theme, confetti: r.confetti, endsAt: r.ends_at,
});

const STATS_SQL = `
  SELECT p.*,
         CASE WHEN NOT p.is_active THEN 'off'
              WHEN p.ends_at IS NOT NULL AND p.ends_at <= now() THEN 'ended'
              WHEN p.starts_at > now() THEN 'scheduled' ELSE 'live' END AS status,
         COALESCE(s.shown, 0)::int AS shown, COALESCE(s.clicked, 0)::int AS clicked,
         COALESCE(s.shown_today, 0)::int AS shown_today, COALESCE(s.clicked_today, 0)::int AS clicked_today,
         COALESCE(s.reach, 0)::int AS reach
    FROM promotions p
    LEFT JOIN LATERAL (
      SELECT count(*) FILTER (WHERE action = 'shown') AS shown,
             count(*) FILTER (WHERE action = 'clicked') AS clicked,
             count(*) FILTER (WHERE action = 'shown' AND (at AT TIME ZONE 'Asia/Kolkata')::date = ${IST_TODAY_SQL}) AS shown_today,
             count(*) FILTER (WHERE action = 'clicked' AND (at AT TIME ZONE 'Asia/Kolkata')::date = ${IST_TODAY_SQL}) AS clicked_today,
             count(DISTINCT user_id) FILTER (WHERE action = 'shown') AS reach
        FROM promotion_views v WHERE v.promotion_id = p.id
    ) s ON true`;

const toAdmin = (r: Row): z.infer<typeof AdminPromotion> => ({
  ...toApp(r), audience: r.audience, frequency: r.frequency, priority: r.priority, isActive: r.is_active,
  startsAt: r.starts_at, status: r.status, shown: r.shown, clicked: r.clicked, shownToday: r.shown_today,
  clickedToday: r.clicked_today, reach: r.reach, createdAt: r.created_at,
});

async function adminRow(db: Db | DbClient, id: number) {
  const r = (await db.query(`${STATS_SQL} WHERE p.id = $1`, [id])).rows[0];
  if (!r) throw notFound("PROMOTION_NOT_FOUND");
  return toAdmin(r);
}

const values = (b: PromotionInput) => [
  b.title, b.body, b.highlight || null, b.badge || null, b.emoji || null, b.ctaLabel, b.ctaAction, b.theme,
  b.audience, b.frequency, b.confetti, b.priority, b.isActive, b.startsAt, b.endsAt ?? null,
];

async function audit(c: DbClient, actorId: string, action: string, id: number, details: Record<string, unknown>) {
  await c.query(
    `INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, $2, 'promotion', $3, $4)`,
    [actorId, action, String(id), JSON.stringify(details)],
  );
}

/**
 * The promotion to show `userId` right now, or null: live, meant for them, not
 * used up by its frequency. Highest priority wins, newest breaks ties.
 */
export async function currentPromotion(db: Db, userId: string, role: string) {
  const r = (await db.query(
    `SELECT p.* FROM promotions p
      WHERE p.is_active AND p.starts_at <= now() AND (p.ends_at IS NULL OR p.ends_at > now())
        AND CASE p.audience
              WHEN 'all' THEN true
              WHEN 'companions' THEN $2 = 'companion'
              WHEN 'callers' THEN $2 = 'caller'
              WHEN 'never_paid' THEN $2 = 'caller'
                AND NOT EXISTS (SELECT 1 FROM purchases pu WHERE pu.user_id = $1 AND pu.status = 'credited')
              WHEN 'paid' THEN $2 = 'caller'
                AND EXISTS (SELECT 1 FROM purchases pu WHERE pu.user_id = $1 AND pu.status = 'credited')
            END
        AND CASE p.frequency
              WHEN 'every_open' THEN true
              WHEN 'once' THEN NOT EXISTS (SELECT 1 FROM promotion_views v
                                            WHERE v.promotion_id = p.id AND v.user_id = $1 AND v.action = 'shown')
              WHEN 'daily' THEN NOT EXISTS (SELECT 1 FROM promotion_views v
                                             WHERE v.promotion_id = p.id AND v.user_id = $1 AND v.action = 'shown'
                                               AND (v.at AT TIME ZONE 'Asia/Kolkata')::date = ${IST_TODAY_SQL})
            END
      ORDER BY p.priority DESC, p.id DESC LIMIT 1`,
    [userId, role],
  )).rows[0];
  return r ? toApp(r) : null;
}

export const promotionRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const base = { tags: ["promotions"], security: bearer };
  const adminBase = { tags: ["admin"], security: bearer };

  app.get("/promotions/current", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      ...base,
      summary: "The offer to show in the app-open bottom sheet, if any",
      response: { 200: z.object({ promotion: Promotion.nullable() }) },
    },
  }, async (req) => ({ promotion: await currentPromotion(db, me(req).userId, me(req).role) }));

  app.post("/promotions/:id/events", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      ...base,
      summary: "The app showed the sheet, or the user tapped its button (drives frequency and admin stats)",
      params: z.object({ id: z.coerce.number().int() }),
      body: z.object({ action: z.enum(["shown", "clicked"]) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const ok = await db.query(
      `INSERT INTO promotion_views (promotion_id, user_id, action)
       SELECT id, $2, $3 FROM promotions WHERE id = $1`,
      [req.params.id, me(req).userId, req.body.action]);
    if (!ok.rowCount) throw notFound("PROMOTION_NOT_FOUND");
    return reply.status(204).send(null);
  });

  // --- admin -----------------------------------------------------------------------
  app.get("/admin/promotions", {
    preHandler: can("promotions.manage"),
    schema: { ...adminBase, summary: "Offers popup: every promotion with its reach and taps", response: { 200: z.array(AdminPromotion) } },
  }, async () => (await db.query(`${STATS_SQL} ORDER BY p.is_active DESC, p.priority DESC, p.id DESC`)).rows.map(toAdmin));

  app.post("/admin/promotions", {
    preHandler: can("promotions.manage"),
    schema: { ...adminBase, body: PromotionInput, response: { 201: AdminPromotion } },
  }, async (req, reply) => {
    const out = await tx(db, async (c) => {
      const id = (await c.query<{ id: number }>(
        `INSERT INTO promotions (title, body, highlight, badge, emoji, cta_label, cta_action, theme, audience,
                                 frequency, confetti, priority, is_active, starts_at, ends_at)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15) RETURNING id`,
        values(req.body))).rows[0]!.id;
      await audit(c, me(req).userId, "promotion.create", id, { ...req.body });
      return adminRow(c, id);
    });
    return reply.status(201).send(out);
  });

  app.put("/admin/promotions/:id", {
    preHandler: can("promotions.manage"),
    schema: { ...adminBase, params: z.object({ id: z.coerce.number().int() }), body: PromotionInput, response: { 200: AdminPromotion } },
  }, async (req) => tx(db, async (c) => {
    const before = (await c.query(`SELECT * FROM promotions WHERE id = $1 FOR UPDATE`, [req.params.id])).rows[0];
    if (!before) throw notFound("PROMOTION_NOT_FOUND");
    await c.query(
      `UPDATE promotions SET title = $1, body = $2, highlight = $3, badge = $4, emoji = $5, cta_label = $6,
              cta_action = $7, theme = $8, audience = $9, frequency = $10, confetti = $11, priority = $12,
              is_active = $13, starts_at = $14, ends_at = $15, updated_at = now()
        WHERE id = $16`,
      [...values(req.body), req.params.id]);
    await audit(c, me(req).userId, "promotion.update", req.params.id,
      { before: { title: before.title, isActive: before.is_active }, after: req.body });
    return adminRow(c, req.params.id);
  }));

  app.post("/admin/promotions/:id/active", {
    preHandler: can("promotions.manage"),
    schema: {
      ...adminBase,
      summary: "Switch a promotion on or off",
      params: z.object({ id: z.coerce.number().int() }),
      body: z.object({ isActive: z.boolean() }),
      response: { 200: AdminPromotion },
    },
  }, async (req) => tx(db, async (c) => {
    const r = await c.query(`UPDATE promotions SET is_active = $2, updated_at = now() WHERE id = $1`, [req.params.id, req.body.isActive]);
    if (!r.rowCount) throw notFound("PROMOTION_NOT_FOUND");
    await audit(c, me(req).userId, req.body.isActive ? "promotion.on" : "promotion.off", req.params.id, {});
    return adminRow(c, req.params.id);
  }));

  app.delete("/admin/promotions/:id", {
    preHandler: can("promotions.manage"),
    schema: { ...adminBase, summary: "Delete a promotion and its view stats", params: z.object({ id: z.coerce.number().int() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    await tx(db, async (c) => {
      const r = (await c.query(`DELETE FROM promotions WHERE id = $1 RETURNING title`, [req.params.id])).rows[0];
      if (!r) throw notFound("PROMOTION_NOT_FOUND");
      await audit(c, me(req).userId, "promotion.delete", req.params.id, { title: r.title });
    });
    return reply.status(204).send(null);
  });
};

