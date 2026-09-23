/**
 * Admin: companion KYC review queue, KYC images, video unlock, payouts.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { maskPhone } from "../auth/phone.js";
import { ApiError, conflict, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import { ageOn } from "../kyc/aadhaar.js";
import { goOffline } from "../presence.js";
import { maskUpi } from "./companion.js";
import { academyProgress } from "./academy.js";
import { notify, rupeesText } from "../notifications.js";

async function audit(c: DbClient, actorId: string, action: string, targetType: string, targetId: string, details: object) {
  await c.query(
    `INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, $2, $3, $4, $5)`,
    [actorId, action, targetType, targetId, JSON.stringify(details)],
  );
}

const KycCase = z.object({
  userId: z.uuid(),
  displayName: z.string(),
  phone: z.string(),
  gender: z.string(),
  primaryLanguage: z.string(),
  status: z.enum(["submitted", "approved", "rejected", "in_progress"]),
  submittedAt: z.date().nullable(),
  aadhaar: z.object({ name: z.string().nullable(), dob: z.string().nullable(), age: z.number().int().nullable(),
    gender: z.string().nullable(), last4: z.string().nullable(), generatedAt: z.date().nullable() }),
  selfieBlinks: z.number().int().nullable(),
  panLast4: z.string().nullable(),
  upi: z.string().nullable(),
  rejectReason: z.string().nullable(),
  videoEnabled: z.boolean(),
  academy: z.object({ passed: z.number().int(), total: z.number().int() }),
  documents: z.array(z.enum(["aadhaar_photo", "selfie", "pan"])),
}).meta({ id: "AdminKycCase" });

const AdminPayout = z.object({
  id: z.uuid(),
  companion: z.object({ id: z.uuid(), displayName: z.string(), kycStatus: z.string() }),
  grossPaise: z.number().int(), tdsPaise: z.number().int(), netPaise: z.number().int(),
  upi: z.string(), status: z.enum(["requested", "processing", "paid", "failed", "rejected"]),
  flags: z.array(z.string()), failureReason: z.string().nullable(), providerRef: z.string().nullable(),
  createdAt: z.date(), processedAt: z.date().nullable(),
}).meta({ id: "AdminPayout" });

export const adminCompanionRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, store, payouts: provider } = app.deps;
  const admin = requireAuth("admin");
  const base = { tags: ["admin"], security: bearer };

  // -------------------------------------------------------------------------
  app.get("/admin/kyc", {
    preHandler: admin,
    schema: {
      ...base,
      summary: "KYC review queue (oldest first) or decided cases",
      querystring: z.object({ status: z.enum(["submitted", "approved", "rejected"]).default("submitted") }),
      response: { 200: z.array(KycCase) },
    },
  }, async (req) => {
    const where = req.query.status === "submitted"
      ? `p.kyc_status = 'pending' AND p.kyc_submitted_at IS NOT NULL`
      : `p.kyc_status = '${req.query.status === "approved" ? "approved" : "rejected"}'`;
    const rows = (await db.query(
      `SELECT u.id, u.display_name, u.phone, u.gender, u.primary_language, p.*,
              to_char(p.aadhaar_dob, 'YYYY-MM-DD') AS dob,
              (SELECT count(*) FROM academy_progress a WHERE a.user_id = u.id)::int AS academy_passed,
              (SELECT count(*) FROM academy_lessons)::int AS academy_total,
              ARRAY(SELECT doc_type FROM kyc_documents d WHERE d.user_id = u.id AND doc_type IN ('aadhaar_photo', 'selfie', 'pan') ORDER BY doc_type) AS docs
         FROM companion_profiles p JOIN users u ON u.id = p.user_id
        WHERE ${where} ORDER BY p.kyc_submitted_at ${req.query.status === "submitted" ? "ASC" : "DESC"} NULLS LAST LIMIT 200`,
    )).rows;
    return rows.map((r) => ({
      userId: r.id, displayName: r.display_name, phone: maskPhone(r.phone), gender: r.gender, primaryLanguage: r.primary_language,
      status: r.kyc_status === "pending" ? (r.kyc_submitted_at ? "submitted" as const : "in_progress" as const) : r.kyc_status,
      submittedAt: r.kyc_submitted_at,
      aadhaar: { name: r.aadhaar_name, dob: r.dob, age: r.dob ? ageOn(r.dob) : null, gender: r.aadhaar_gender, last4: r.aadhaar_last4,
        generatedAt: r.aadhaar_generated_at },
      selfieBlinks: r.selfie_blinks, panLast4: r.pan_last4, upi: r.upi_id ? maskUpi(r.upi_id) : null,
      rejectReason: r.kyc_reject_reason, videoEnabled: r.video_enabled, documents: r.docs,
      academy: { passed: r.academy_passed, total: r.academy_total },
    }));
  });

  app.get("/admin/kyc/:userId/files/:doc", {
    preHandler: admin,
    schema: {
      ...base,
      summary: "Decrypted KYC image for side-by-side review. Every view is audit-logged.",
      params: z.object({ userId: z.uuid(), doc: z.enum(["aadhaar_photo", "selfie", "pan"]) }),
    },
  }, async (req, reply) => {
    const doc = (await db.query<{ storage_key: string }>(
      `SELECT storage_key FROM kyc_documents WHERE user_id = $1 AND doc_type = $2`, [req.params.userId, req.params.doc],
    )).rows[0];
    if (!doc) throw notFound("DOCUMENT_NOT_FOUND");
    const bytes = await store.get(doc.storage_key);
    await tx(db, (c) => audit(c, me(req).userId, "kyc.view", "user", req.params.userId, { doc: req.params.doc }));
    const png = bytes[0] === 0x89 && bytes[1] === 0x50;
    return reply
      .header("cache-control", "no-store, private")
      .type(png ? "image/png" : "image/jpeg")
      .send(bytes);
  });

  app.post("/admin/kyc/:userId/decision", {
    preHandler: admin,
    schema: {
      ...base,
      summary: "Approve (companion can go online) or reject with a reason the companion will see",
      params: z.object({ userId: z.uuid() }),
      body: z.object({ decision: z.enum(["approve", "reject"]), reason: z.string().trim().min(3).max(500) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { decision, reason } = req.body;
    await tx(db, async (c) => {
      const p = (await c.query<{ kyc_status: string; kyc_submitted_at: Date | null; aadhaar_dob: string | null }>(
        `SELECT kyc_status, kyc_submitted_at, to_char(aadhaar_dob, 'YYYY-MM-DD') AS aadhaar_dob
           FROM companion_profiles WHERE user_id = $1 FOR UPDATE`, [req.params.userId])).rows[0];
      if (!p) throw notFound("NOT_A_COMPANION");
      if (p.kyc_status !== "pending" || !p.kyc_submitted_at) throw conflict("KYC_NOT_SUBMITTED", "This companion has nothing waiting for review");
      if (decision === "approve" && (!p.aadhaar_dob || ageOn(p.aadhaar_dob) < 18)) {
        throw new ApiError(400, "AADHAAR_UNDER_18", "Can't approve: under 18 per Aadhaar");
      }
      await c.query(
        decision === "approve"
          ? `UPDATE companion_profiles SET kyc_status = 'approved', kyc_verified_at = now(), kyc_reviewed_at = now(), kyc_reviewed_by = $2, kyc_reject_reason = NULL WHERE user_id = $1`
          : `UPDATE companion_profiles SET kyc_status = 'rejected', kyc_reviewed_at = now(), kyc_reviewed_by = $2, kyc_reject_reason = $3, kyc_submitted_at = NULL WHERE user_id = $1`,
        decision === "approve" ? [req.params.userId, me(req).userId] : [req.params.userId, me(req).userId, reason],
      );
      await c.query(`UPDATE kyc_documents SET status = $2, reviewed_by = $3 WHERE user_id = $1`,
        [req.params.userId, decision === "approve" ? "approved" : "rejected", me(req).userId]);
      await audit(c, me(req).userId, `kyc.${decision}`, "user", req.params.userId, { reason });
    });
    if (decision === "reject") await goOffline(redis, req.params.userId);
    await notify(app.deps, req.params.userId, decision === "approve"
      ? { type: "kyc_decided", title: "You're verified 🎉", body: "Your KYC is approved. Finish the academy lessons, then go online to take calls." }
      : { type: "kyc_decided", title: "KYC needs another look", body: reason });
    return reply.status(204).send(null);
  });

  app.post("/admin/companions/:userId/video", {
    preHandler: admin,
    schema: {
      ...base,
      summary: "Unlock or lock video calls for a companion (after academy + clean record)",
      params: z.object({ userId: z.uuid() }),
      body: z.object({ enabled: z.boolean(), reason: z.string().trim().min(3).max(300) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const kyc = (await db.query<{ kyc_status: string }>(
      `SELECT kyc_status FROM companion_profiles WHERE user_id = $1`, [req.params.userId])).rows[0];
    if (kyc?.kyc_status !== "approved") throw conflict("KYC_NOT_APPROVED", "Only verified companions can have video");
    if (req.body.enabled) {
      const { passed, total } = await academyProgress(db, req.params.userId);
      if (passed < total) throw conflict("ACADEMY_INCOMPLETE", `Academy not finished (${passed} of ${total} lessons)`);
    }
    await tx(db, async (c) => {
      const r = await c.query(
        `UPDATE companion_profiles SET video_enabled = $2 WHERE user_id = $1 AND kyc_status = 'approved'`,
        [req.params.userId, req.body.enabled]);
      if (!r.rowCount) throw conflict("KYC_NOT_APPROVED", "Only verified companions can have video");
      await audit(c, me(req).userId, "companion.video", "user", req.params.userId, { ...req.body });
    });
    return reply.status(204).send(null);
  });

  // -------------------------------------------------------------------------
  const toPayout = (r: Record<string, any>) => ({ // eslint-disable-line @typescript-eslint/no-explicit-any
    id: r.id, companion: { id: r.companion_id, displayName: r.display_name, kycStatus: r.kyc_status },
    grossPaise: Number(r.gross_paise), tdsPaise: Number(r.tds_paise), netPaise: Number(r.net_paise),
    upi: maskUpi(r.upi_id), status: r.status, flags: r.flags, failureReason: r.failure_reason, providerRef: r.provider_ref,
    createdAt: r.created_at, processedAt: r.processed_at,
  });

  app.get("/admin/payouts", {
    preHandler: admin,
    schema: {
      ...base,
      querystring: z.object({ status: z.enum(["requested", "processing", "paid", "failed", "rejected"]).default("requested") }),
      response: {
        200: z.object({
          payouts: z.array(AdminPayout),
          totals: z.object({ requestedPaise: z.number().int(), requestedCount: z.number().int(), flaggedCount: z.number().int(),
            paidThisWeekPaise: z.number().int(), tdsThisMonthPaise: z.number().int() }),
        }),
      },
    },
  }, async (req) => {
    const [rows, totals] = await Promise.all([
      db.query(
        `SELECT p.*, u.display_name, cp.kyc_status FROM payouts p JOIN users u ON u.id = p.companion_id
           JOIN companion_profiles cp ON cp.user_id = p.companion_id
          WHERE p.status = $1 ORDER BY cardinality(p.flags) DESC, p.created_at ASC LIMIT 500`, [req.query.status]),
      db.query<{ rp: number; rc: number; fc: number; pw: number; tm: number }>(
        `SELECT COALESCE(sum(gross_paise) FILTER (WHERE status = 'requested'), 0)::bigint AS rp,
                count(*) FILTER (WHERE status = 'requested')::int AS rc,
                count(*) FILTER (WHERE status = 'requested' AND cardinality(flags) > 0)::int AS fc,
                COALESCE(sum(net_paise) FILTER (WHERE status = 'paid' AND processed_at > now() - interval '7 days'), 0)::bigint AS pw,
                COALESCE(sum(tds_paise) FILTER (WHERE status = 'paid' AND processed_at >= date_trunc('month', now())), 0)::bigint AS tm
           FROM payouts`),
    ]);
    const t = totals.rows[0]!;
    return {
      payouts: rows.rows.map(toPayout),
      totals: { requestedPaise: t.rp, requestedCount: t.rc, flaggedCount: t.fc, paidThisWeekPaise: t.pw, tdsThisMonthPaise: t.tm },
    };
  });

  /** Credits a payout back to the earnings balance (failed at the bank, or rejected by admin). */
  async function reverse(c: DbClient, p: { id: string; companion_id: string; gross_paise: number }, why: string) {
    await post(c, p.companion_id, "earnings", "payout_reversal", Number(p.gross_paise), `payout:${p.id}:reversal`,
      { payoutId: p.id, note: why });
  }

  app.post("/admin/payouts/:id/approve", {
    preHandler: admin,
    schema: {
      ...base,
      summary: "Approve and send to UPI. Failures are credited back to the companion automatically.",
      params: z.object({ id: z.uuid() }),
      response: { 200: AdminPayout },
    },
  }, async (req) => {
    // 1. Claim it (so two admins can't pay twice), then call the provider outside the transaction.
    const claimed = await tx(db, async (c) => {
      const p = (await c.query(
        `UPDATE payouts SET status = 'processing', approved_by = $2, approved_at = now()
          WHERE id = $1 AND status = 'requested' RETURNING *`, [req.params.id, me(req).userId])).rows[0];
      if (!p) throw conflict("PAYOUT_NOT_PENDING", "This withdrawal was already handled");
      await audit(c, me(req).userId, "payout.approve", "payout", p.id, { netPaise: Number(p.net_paise), flags: p.flags });
      return p;
    });
    const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [claimed.companion_id])).rows[0]!.display_name;
    const result = await provider.send({ payoutId: claimed.id, upiId: claimed.upi_id, amountPaise: Number(claimed.net_paise), name })
      .catch((e: Error) => ({ status: "failed" as const, reason: `Provider error: ${e.message}` }));

    // 2. Record the outcome.
    await tx(db, async (c) => {
      if (result.status === "failed") {
        await c.query(`UPDATE payouts SET status = 'failed', failure_reason = $2, processed_at = now() WHERE id = $1`, [claimed.id, result.reason]);
        await reverse(c, claimed, "Withdrawal failed, returned to balance");
      } else {
        await c.query(
          `UPDATE payouts SET status = $2::payout_status, provider_ref = $3,
                  processed_at = CASE WHEN $2::text = 'paid' THEN now() END WHERE id = $1`,
          [claimed.id, result.status, result.providerRef]);
      }
    });
    const net = Number(claimed.net_paise);
    if (result.status === "failed") {
      await notify(app.deps, claimed.companion_id, { type: "payout_failed", title: "Withdrawal failed",
        body: `${rupeesText(Number(claimed.gross_paise))} is back in your earnings. Check your UPI ID and try again.` });
    } else if (result.status === "paid") {
      await notify(app.deps, claimed.companion_id, { type: "payout_paid", title: `${rupeesText(net)} sent to your UPI`, body: "Your withdrawal is complete." });
    }
    const row = (await db.query(
      `SELECT p.*, u.display_name, cp.kyc_status FROM payouts p JOIN users u ON u.id = p.companion_id
         JOIN companion_profiles cp ON cp.user_id = p.companion_id WHERE p.id = $1`, [claimed.id])).rows[0];
    return toPayout(row);
  });

  app.post("/admin/payouts/:id/reject", {
    preHandler: admin,
    schema: {
      ...base,
      summary: "Reject a withdrawal; the amount goes back to the companion's balance",
      params: z.object({ id: z.uuid() }),
      body: z.object({ reason: z.string().trim().min(3).max(500) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const p = await tx(db, async (c) => {
      const p = (await c.query(
        `UPDATE payouts SET status = 'rejected', failure_reason = $2, processed_at = now(), approved_by = $3
          WHERE id = $1 AND status = 'requested' RETURNING *`, [req.params.id, req.body.reason, me(req).userId])).rows[0];
      if (!p) throw conflict("PAYOUT_NOT_PENDING", "This withdrawal was already handled");
      await reverse(c, p, `Withdrawal rejected: ${req.body.reason}`);
      await audit(c, me(req).userId, "payout.reject", "payout", p.id, { reason: req.body.reason });
      return p;
    });
    await notify(app.deps, p.companion_id, { type: "payout_failed", title: "Withdrawal not approved",
      body: `${rupeesText(Number(p.gross_paise))} is back in your earnings. ${req.body.reason}` });
    return reply.status(204).send(null);
  });
};
