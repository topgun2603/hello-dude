/**
 * Refund requests: a caller asks from Call details, an admin decides.
 * Approved coins go back as a 'refund' ledger row. Optionally the companion's
 * share is reversed too (when the call was their fault).
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { ApiError, conflict, forbidden, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import { numberSetting } from "../settings.js";
import { coinsText, notify } from "../notifications.js";

export const RefundReason = z.enum(["call_dropped", "couldnt_hear", "wrong_language", "other"]);

export const RefundRequest = z.object({
  id: z.uuid(), status: z.enum(["requested", "approved", "rejected"]), reason: RefundReason,
  coinsEligible: z.number().int(), coinsRefunded: z.number().int(), note: z.string().nullable(), createdAt: z.date(),
}).meta({ id: "RefundRequest" });

const AdminRefund = RefundRequest.extend({
  details: z.string().nullable(),
  call: z.object({ id: z.uuid(), type: z.string(), startedAt: z.date().nullable(), durationSeconds: z.number().int().nullable(),
    minutesCharged: z.number().int(), endReason: z.string().nullable() }),
  caller: z.object({ id: z.uuid(), displayName: z.string(), refundsBefore: z.number().int() }),
  companion: z.object({ id: z.uuid(), displayName: z.string() }),
}).meta({ id: "AdminRefund" });

async function audit(c: DbClient, actorId: string, action: string, targetId: string, details: object) {
  await c.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, $2, 'refund', $3, $4)`,
    [actorId, action, targetId, JSON.stringify(details)]);
}

export const refundRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;

  app.post("/calls/:id/refund-request", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Ask for a refund on a finished call (once per call)",
      params: z.object({ id: z.uuid() }),
      body: z.object({ reason: RefundReason, details: z.string().trim().max(500).nullish() }),
      response: { 201: RefundRequest },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    const windowDays = await numberSetting(db, "refund.window_days", 7);
    const row = await tx(db, async (c) => {
      const call = (await c.query<{ caller_id: string; status: string; started_at: Date | null; coins_charged: number; recent: boolean; refunded: number }>(
        `SELECT caller_id, status, started_at, coins_charged, created_at > now() - $2 * interval '1 day' AS recent,
                COALESCE((SELECT sum(l.amount) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
                   WHERE l.call_id = calls.id AND l.type = 'refund' AND w.kind = 'coins'), 0)::bigint AS refunded
           FROM calls WHERE id = $1 FOR UPDATE`, [req.params.id, windowDays])).rows[0];
      if (!call) throw notFound("CALL_NOT_FOUND");
      if (call.caller_id !== userId) throw forbidden("NOT_YOUR_CALL");
      if (call.status !== "ended" || !call.started_at) throw conflict("CALL_NOT_REFUNDABLE", "Only finished calls can be refunded");
      if (!call.recent) throw conflict("REFUND_WINDOW_OVER", `Refunds can be requested within ${windowDays} days`);
      const eligible = call.coins_charged - call.refunded;
      if (eligible <= 0) throw conflict("NOTHING_TO_REFUND", "This call was already refunded");
      const r = (await c.query(
        `INSERT INTO refund_requests (call_id, user_id, reason, details, coins_eligible) VALUES ($1, $2, $3, $4, $5)
         ON CONFLICT (call_id) DO NOTHING RETURNING *`,
        [req.params.id, userId, req.body.reason, req.body.details ?? null, eligible])).rows[0];
      if (!r) throw conflict("REFUND_ALREADY_REQUESTED", "You already asked for a refund on this call");
      return r;
    });
    reply.status(201);
    return {
      id: row.id, status: row.status, reason: row.reason, coinsEligible: row.coins_eligible,
      coinsRefunded: row.coins_refunded, note: row.note, createdAt: row.created_at,
    };
  });

  // -------------------------------------------------------------------------
  const base = { tags: ["admin"], security: bearer };

  app.get("/admin/refunds", {
    preHandler: can("refunds.review"),
    schema: {
      ...base,
      querystring: z.object({ status: z.enum(["requested", "approved", "rejected"]).default("requested") }),
      response: { 200: z.array(AdminRefund) },
    },
  }, async (req) => (await db.query(
    `SELECT r.*, c.type, c.started_at, c.minutes_charged, c.end_reason,
            EXTRACT(EPOCH FROM (c.ended_at - c.started_at))::int AS secs,
            cu.id AS caller_id, cu.display_name AS caller_name,
            (SELECT count(*) FROM refund_requests x WHERE x.user_id = r.user_id AND x.status = 'approved')::int AS refunds_before,
            co.id AS companion_id, co.display_name AS companion_name
       FROM refund_requests r JOIN calls c ON c.id = r.call_id
       JOIN users cu ON cu.id = r.user_id JOIN users co ON co.id = c.companion_id
      WHERE r.status = $1 ORDER BY r.created_at ${req.query.status === "requested" ? "ASC" : "DESC"} LIMIT 300`,
    [req.query.status])).rows.map((r) => ({
      id: r.id, status: r.status, reason: r.reason, details: r.details, coinsEligible: r.coins_eligible,
      coinsRefunded: r.coins_refunded, note: r.note, createdAt: r.created_at,
      call: { id: r.call_id, type: r.type, startedAt: r.started_at, durationSeconds: r.secs, minutesCharged: r.minutes_charged, endReason: r.end_reason },
      caller: { id: r.caller_id, displayName: r.caller_name, refundsBefore: r.refunds_before },
      companion: { id: r.companion_id, displayName: r.companion_name },
    })));

  app.post("/admin/refunds/:id/decide", {
    preHandler: can("refunds.review"),
    schema: {
      ...base,
      summary: "Approve (all or part of the coins) or reject a refund request",
      params: z.object({ id: z.uuid() }),
      body: z.object({
        decision: z.enum(["approve", "reject"]),
        coins: z.number().int().positive().nullish().describe("Default: everything eligible"),
        reverseCompanion: z.boolean().default(false).describe("Also take the companion's share back"),
        note: z.string().trim().min(3).max(500),
      }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const b = req.body;
    const outcome = await tx(db, async (c): Promise<{ callerId: string; callId: string; coins: number }> => {
      const r = (await c.query(
        `SELECT r.*, c.caller_id, c.companion_id, c.coins_charged, c.paise_credited
           FROM refund_requests r JOIN calls c ON c.id = r.call_id WHERE r.id = $1 FOR UPDATE OF r`, [req.params.id])).rows[0];
      if (!r) throw notFound("REFUND_NOT_FOUND");
      if (r.status !== "requested") throw conflict("REFUND_DECIDED", "This request was already decided");

      if (b.decision === "reject") {
        await c.query(`UPDATE refund_requests SET status = 'rejected', decided_by = $2, decided_at = now(), note = $3 WHERE id = $1`,
          [r.id, me(req).userId, b.note]);
        await audit(c, me(req).userId, "refund.reject", r.id, { note: b.note });
        return { callerId: r.caller_id, callId: r.call_id, coins: 0 };
      }
      const coins = b.coins ?? r.coins_eligible;
      if (coins > r.coins_eligible) throw new ApiError(400, "TOO_MANY_COINS", `At most ${r.coins_eligible} coins can be refunded`);
      await post(c, r.caller_id, "coins", "refund", coins, `refund_request:${r.id}`, { callId: r.call_id, note: "Refund request approved" });
      if (b.reverseCompanion && Number(r.coins_charged) > 0) {
        const paise = Math.round((Number(r.paise_credited) * coins) / Number(r.coins_charged));
        if (paise > 0) {
          const ok = await post(c, r.companion_id, "earnings", "refund_reversal", -paise, `refund_request:${r.id}:reverse`,
            { callId: r.call_id, note: "Refund approved" });
          if (ok === null) {
            await c.query(`INSERT INTO billing_exceptions (call_id, user_id, kind, amount) VALUES ($1, $2, 'refund_reversal_failed', $3)`,
              [r.call_id, r.companion_id, paise]);
          }
        }
      }
      await c.query(`UPDATE refund_requests SET status = 'approved', coins_refunded = $2, decided_by = $3, decided_at = now(), note = $4 WHERE id = $1`,
        [r.id, coins, me(req).userId, b.note]);
      await audit(c, me(req).userId, "refund.approve", r.id, { coins, reverseCompanion: b.reverseCompanion, note: b.note });
      return { callerId: r.caller_id, callId: r.call_id, coins };
    });
    await notify(app.deps, outcome.callerId, outcome.coins
      ? { type: "refund_decided", title: "Refund approved", body: `+${coinsText(outcome.coins)} back in your wallet`, data: { callId: outcome.callId } }
      : { type: "refund_decided", title: "Refund not approved", body: b.note, data: { callId: outcome.callId } });
    return reply.status(204).send(null);
  });
};
