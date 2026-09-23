import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, notFound } from "../errors.js";

const UserParams = z.object({ userId: z.uuid() });

export const safetyRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, recorder } = app.deps;

  async function assertUser(id: string, self: string) {
    if (id === self) throw new ApiError(400, "CANNOT_TARGET_SELF");
    if (!(await db.query(`SELECT 1 FROM users WHERE id = $1`, [id])).rowCount) throw notFound("USER_NOT_FOUND");
  }

  app.post("/blocks", {
    preHandler: requireAuth(),
    schema: {
      tags: ["safety"],
      security: bearer,
      summary: "Block someone: neither side can see or call the other",
      body: z.object({ userId: z.uuid() }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    await assertUser(req.body.userId, userId);
    await db.query(`INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2) ON CONFLICT DO NOTHING`,
      [userId, req.body.userId]);
    return reply.status(204).send(null);
  });

  app.delete("/blocks/:userId", {
    preHandler: requireAuth(),
    schema: { tags: ["safety"], security: bearer, params: UserParams, response: { 204: z.null() } },
  }, async (req, reply) => {
    await db.query(`DELETE FROM blocks WHERE blocker_id = $1 AND blocked_id = $2`, [me(req).userId, req.params.userId]);
    return reply.status(204).send(null);
  });

  app.get("/blocks", {
    preHandler: requireAuth(),
    schema: {
      tags: ["safety"],
      security: bearer,
      response: { 200: z.array(z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int(), blockedAt: z.date() })) },
    },
  }, async (req) => (await db.query<{ id: string; display_name: string; avatar_id: number; created_at: Date }>(
    `SELECT u.id, u.display_name, u.avatar_id, b.created_at
       FROM blocks b JOIN users u ON u.id = b.blocked_id
      WHERE b.blocker_id = $1 ORDER BY b.created_at DESC`, [me(req).userId],
  )).rows.map((r) => ({ id: r.id, displayName: r.display_name, avatarId: r.avatar_id, blockedAt: r.created_at })));

  app.post("/reports", {
    preHandler: requireAuth(),
    schema: {
      tags: ["safety"],
      security: bearer,
      summary: "Report someone (also blocks them). Pass callId when reporting a call.",
      body: z.object({
        userId: z.uuid(),
        callId: z.uuid().nullish(),
        reason: z.enum(["abuse", "sexual_content", "spam", "underage", "fraud", "other"]),
        details: z.string().trim().max(1000).nullish(),
        alsoBlock: z.boolean().default(true),
      }),
      response: { 201: z.object({ reportId: z.uuid(), recording: z.enum(["started", "not_live", "disabled"]) }) },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    const { userId: reported, callId, reason, details, alsoBlock } = req.body;
    await assertUser(reported, userId);
    if (callId) {
      const inCall = await db.query(
        `SELECT 1 FROM calls WHERE id = $1 AND ((caller_id = $2 AND companion_id = $3) OR (caller_id = $3 AND companion_id = $2))`,
        [callId, userId, reported],
      );
      if (!inCall.rowCount) throw new ApiError(400, "CALL_MISMATCH", "That call was not between you two");
    }
    const reportId = await tx(db, async (c) => {
      const id = (await c.query<{ id: string }>(
        `INSERT INTO reports (reporter_id, reported_id, call_id, reason, details) VALUES ($1, $2, $3, $4, $5) RETURNING id`,
        [userId, reported, callId ?? null, reason, details ?? null],
      )).rows[0]!.id;
      if (alsoBlock) await c.query(`INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2) ON CONFLICT DO NOTHING`, [userId, reported]);
      return id;
    });

    // Keep the call's audio for the safety team while the call is still live.
    let recording: "started" | "not_live" | "disabled" = "not_live";
    const live = callId ? (await db.query<{ room_name: string }>(
      `SELECT room_name FROM calls WHERE id = $1 AND status = 'active'`, [callId])).rows[0] : undefined;
    if (live && !recorder.enabled) {
      recording = "disabled";
      await db.query(`INSERT INTO report_recordings (report_id, call_id, status) VALUES ($1, $2, 'disabled')`, [reportId, callId]);
    } else if (live) {
      try {
        const r = await recorder.start(live.room_name, reportId);
        await db.query(`INSERT INTO report_recordings (report_id, call_id, egress_id, storage_key) VALUES ($1, $2, $3, $4)`,
          [reportId, callId, r.egressId, r.storageKey]);
        recording = "started";
      } catch (err) {
        req.log.error({ err, reportId }, "report recording failed to start");
        await db.query(`INSERT INTO report_recordings (report_id, call_id, status) VALUES ($1, $2, 'failed')`, [reportId, callId]);
      }
    }
    reply.status(201);
    return { reportId, recording };
  });
};
