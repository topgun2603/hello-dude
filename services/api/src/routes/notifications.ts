/** The in-app Notifications screen (inbox rows are written by notifications.ts). */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { NOTICE_TYPES } from "../notifications.js";

const NotificationItem = z.object({
  id: z.number().int(),
  type: z.enum(NOTICE_TYPES),
  title: z.string(),
  body: z.string(),
  data: z.record(z.string(), z.string()),
  read: z.boolean(),
  createdAt: z.date(),
}).meta({ id: "NotificationItem" });

export const notificationRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const base = { tags: ["notifications"], security: bearer };

  app.get("/notifications", {
    preHandler: requireAuth(),
    schema: {
      ...base,
      summary: "My notifications, newest first (page with ?before=<id>)",
      querystring: z.object({
        before: z.coerce.number().int().positive().optional(),
        limit: z.coerce.number().int().min(1).max(100).default(40),
      }),
      response: { 200: z.object({ items: z.array(NotificationItem), unread: z.number().int() }) },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const [items, unread] = await Promise.all([
      db.query<{ id: number; type: (typeof NOTICE_TYPES)[number]; title: string; body: string; data: Record<string, string>;
        read_at: Date | null; created_at: Date }>(
        `SELECT id, type, title, body, data, read_at, created_at FROM notifications
          WHERE user_id = $1 AND ($2::bigint IS NULL OR id < $2) ORDER BY id DESC LIMIT $3`,
        [userId, req.query.before ?? null, req.query.limit]),
      db.query<{ n: number }>(`SELECT count(*)::int AS n FROM notifications WHERE user_id = $1 AND read_at IS NULL`, [userId]),
    ]);
    return {
      unread: unread.rows[0]!.n,
      items: items.rows
        .filter((n) => (NOTICE_TYPES as readonly string[]).includes(n.type))
        .map((n) => ({ id: n.id, type: n.type, title: n.title, body: n.body, data: n.data, read: n.read_at !== null, createdAt: n.created_at })),
    };
  });

  app.get("/notifications/unread-count", {
    preHandler: requireAuth(),
    schema: { ...base, summary: "Number for the bell badge", response: { 200: z.object({ unread: z.number().int() }) } },
  }, async (req) => ({
    unread: (await db.query<{ n: number }>(
      `SELECT count(*)::int AS n FROM notifications WHERE user_id = $1 AND read_at IS NULL`, [me(req).userId])).rows[0]!.n,
  }));

  app.post("/notifications/read", {
    preHandler: requireAuth(),
    schema: {
      ...base,
      summary: "Mark some notifications read (ids), or every one with all: true (\"Read all\")",
      body: z.object({ ids: z.array(z.number().int()).max(200).default([]), all: z.boolean().default(false) }),
      response: { 200: z.object({ unread: z.number().int() }) },
    },
  }, async (req) => {
    const userId = me(req).userId;
    await db.query(
      `UPDATE notifications SET read_at = now()
        WHERE user_id = $1 AND read_at IS NULL AND ($2 OR id = ANY($3::bigint[]))`,
      [userId, req.body.all, req.body.ids]);
    return {
      unread: (await db.query<{ n: number }>(
        `SELECT count(*)::int AS n FROM notifications WHERE user_id = $1 AND read_at IS NULL`, [userId])).rows[0]!.n,
    };
  });
};
