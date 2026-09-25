/**
 * Admin: companion KYC review queue, KYC images, video unlock, payouts.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type DbClient } from "../db/pool.js";
import { bearer, me } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { maskPhone } from "../auth/phone.js";
import { ApiError, conflict, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import { ageOn } from "../kyc/aadhaar.js";
import { goOffline } from "../presence.js";
import { maskUpi } from "./companion.js";
import { academyProgress } from "./academy.js";
import { notify, rupeesText } from "../notifications.js";
import { finishPayout } from "../payouts/finish.js";
import { KYC_ITEMS, voiceRequired } from "./companion.js";
import { ensureWallets } from "../billing/ledger.js";
import { numberSetting } from "../settings.js";

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
  declared: z.object({ birthDate: z.string().nullable(), age: z.number().int().nullable() })
    .describe("Date of birth the companion entered (18+ confirmed); Aadhaar is no longer collected"),
  selfieBlinks: z.number().int().nullable(),
  panLast4: z.string().nullable(),
  upi: z.string().nullable(),
  rejectReason: z.string().nullable(),
  videoEnabled: z.boolean(),
  academy: z.object({ passed: z.number().int(), total: z.number().int() }),
  documents: z.array(z.enum(["aadhaar_photo", "selfie", "pan", "voice"])),
  redo: z.array(z.enum(KYC_ITEMS)).describe("Items the last rejection asked them to send again"),
  voice: z.object({ needed: z.boolean(), sentence: z.string().nullable(), submittedAt: z.date().nullable(),
    checkedAt: z.date().nullable().describe("An admin already listened and it was fine (clip deleted)") })
    .describe("Women companions: play GET /admin/kyc/:userId/files/voice and check it matches the sentence and the selfie"),
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
  const { db, redis, store } = app.deps;
  const base = { tags: ["admin"], security: bearer };

  // -------------------------------------------------------------------------
  app.get("/admin/kyc", {
    preHandler: can("kyc.review"),
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
              to_char(p.aadhaar_dob, 'YYYY-MM-DD') AS dob, to_char(p.birth_date, 'YYYY-MM-DD') AS birth,
              (SELECT count(*) FROM academy_progress a WHERE a.user_id = u.id)::int AS academy_passed,
              (SELECT count(*) FROM academy_lessons)::int AS academy_total,
              ARRAY(SELECT doc_type FROM kyc_documents d WHERE d.user_id = u.id AND doc_type IN ('aadhaar_photo', 'selfie', 'pan', 'voice') ORDER BY doc_type) AS docs
         FROM companion_profiles p JOIN users u ON u.id = p.user_id
        WHERE ${where} ORDER BY p.kyc_submitted_at ${req.query.status === "submitted" ? "ASC" : "DESC"} NULLS LAST LIMIT 200`,
    )).rows;
    return rows.map((r) => ({
      userId: r.id, displayName: r.display_name, phone: maskPhone(r.phone), gender: r.gender, primaryLanguage: r.primary_language,
      status: r.kyc_status === "pending" ? (r.kyc_submitted_at ? "submitted" as const : "in_progress" as const) : r.kyc_status,
      submittedAt: r.kyc_submitted_at,
      aadhaar: { name: r.aadhaar_name, dob: r.dob, age: r.dob ? ageOn(r.dob) : null, gender: r.aadhaar_gender, last4: r.aadhaar_last4,
        generatedAt: r.aadhaar_generated_at },
      declared: { birthDate: r.birth, age: r.birth ? ageOn(r.birth) : null },
      selfieBlinks: r.selfie_blinks, panLast4: r.pan_last4, upi: r.upi_id ? maskUpi(r.upi_id) : null,
      rejectReason: r.kyc_reject_reason, videoEnabled: r.video_enabled, documents: r.docs,
      redo: r.kyc_redo,
      voice: { needed: voiceRequired(r.gender), sentence: r.voice_sentence, submittedAt: r.voice_submitted_at, checkedAt: r.voice_verified_at },
      academy: { passed: r.academy_passed, total: r.academy_total },
    }));
  });

  app.get("/admin/kyc/:userId/files/:doc", {
    preHandler: can("kyc.review"),
    schema: {
      ...base,
      summary: "Decrypted KYC image for side-by-side review. Every view is audit-logged.",
      params: z.object({ userId: z.uuid(), doc: z.enum(["aadhaar_photo", "selfie", "pan", "voice"]) }),
    },
  }, async (req, reply) => {
    const doc = (await db.query<{ storage_key: string }>(
      `SELECT storage_key FROM kyc_documents WHERE user_id = $1 AND doc_type = $2`, [req.params.userId, req.params.doc],
    )).rows[0];
    if (!doc) throw notFound("DOCUMENT_NOT_FOUND");
    const bytes = await store.get(doc.storage_key);
    await tx(db, (c) => audit(c, me(req).userId, "kyc.view", "user", req.params.userId, { doc: req.params.doc }));
    const png = bytes[0] === 0x89 && bytes[1] === 0x50;
    const head = bytes.subarray(0, 8).toString("latin1");
    const type = req.params.doc === "voice"
      ? head.slice(4, 8) === "ftyp" ? "audio/mp4" : head.startsWith("OggS") ? "audio/ogg" : head.startsWith("RIFF") ? "audio/wav" : "audio/webm"
      : png ? "image/png" : "image/jpeg";
    return reply
      .header("cache-control", "no-store, private")
      .type(type)
      .send(bytes);
  });

  app.post("/admin/kyc/:userId/decision", {
    preHandler: can("kyc.review"),
    schema: {
      ...base,
      summary: "Approve (companion can go online) or reject with a reason the companion will see",
      params: z.object({ userId: z.uuid() }),
      body: z.object({
        decision: z.enum(["approve", "reject"]),
        reason: z.string().trim().min(3).max(500),
        redo: z.array(z.enum(KYC_ITEMS)).nullish()
          .describe("Reject only: what they must send again (only these reset). Empty = they fix it and press Submit."),
      }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { decision, reason } = req.body;
    const redo = decision === "reject" ? [...new Set(req.body.redo ?? [])] : [];
    const bonus = await tx(db, async (c) => {
      const p = (await c.query<{ kyc_status: string; kyc_submitted_at: Date | null; aadhaar_dob: string | null }>(
        `SELECT kyc_status, kyc_submitted_at, to_char(COALESCE(birth_date, aadhaar_dob), 'YYYY-MM-DD') AS aadhaar_dob
           FROM companion_profiles WHERE user_id = $1 FOR UPDATE`, [req.params.userId])).rows[0];
      if (!p) throw notFound("NOT_A_COMPANION");
      if (p.kyc_status !== "pending" || !p.kyc_submitted_at) throw conflict("KYC_NOT_SUBMITTED", "This companion has nothing waiting for review");
      if (decision === "approve" && (!p.aadhaar_dob || ageOn(p.aadhaar_dob) < 18)) {
        throw new ApiError(400, "UNDER_18", "Can't approve: no date of birth, or under 18");
      }
      await c.query(
        decision === "approve"
          ? `UPDATE companion_profiles SET kyc_status = 'approved', kyc_verified_at = now(), kyc_reviewed_at = now(), kyc_reviewed_by = $2, kyc_reject_reason = NULL WHERE user_id = $1`
          : `UPDATE companion_profiles SET kyc_status = 'rejected', kyc_reviewed_at = now(), kyc_reviewed_by = $2, kyc_reject_reason = $3,
                    kyc_submitted_at = NULL, kyc_redo = $4,
                    -- Only what the admin asked for resets.
                    age_confirmed_at = CASE WHEN 'age' = ANY($4) THEN NULL ELSE age_confirmed_at END,
                    selfie_blinks = CASE WHEN 'selfie' = ANY($4) THEN NULL ELSE selfie_blinks END,
                    pan_last4 = CASE WHEN 'pan' = ANY($4) THEN NULL ELSE pan_last4 END,
                    pan_encrypted = CASE WHEN 'pan' = ANY($4) THEN NULL ELSE pan_encrypted END,
                    upi_id = CASE WHEN 'upi' = ANY($4) THEN NULL ELSE upi_id END
              WHERE user_id = $1`,
        decision === "approve" ? [req.params.userId, me(req).userId] : [req.params.userId, me(req).userId, reason, redo],
      );
      await c.query(`UPDATE kyc_documents SET status = $2, reviewed_by = $3 WHERE user_id = $1`,
        [req.params.userId, decision === "approve" ? "approved" : "rejected", me(req).userId]);
      await audit(c, me(req).userId, `kyc.${decision}`, "user", req.params.userId, { reason, ...(redo.length ? { redo } : {}) });

      // The voice intro is only kept until the decision (privacy); a rejection needs a new one.
      const voice = (await c.query<{ storage_key: string }>(
        `DELETE FROM kyc_documents WHERE user_id = $1 AND doc_type = 'voice' RETURNING storage_key`, [req.params.userId])).rows[0];
      if (voice) await store.delete(voice.storage_key);
      await c.query(
        decision === "approve"
          ? `UPDATE companion_profiles SET voice_verified_at = CASE WHEN voice_submitted_at IS NOT NULL THEN now() END WHERE user_id = $1`
          : `UPDATE companion_profiles SET
               voice_submitted_at = CASE WHEN $2 THEN NULL ELSE voice_submitted_at END,
               voice_sentence = CASE WHEN $2 THEN NULL ELSE voice_sentence END,
               -- Not asked to redo: the admin heard it and it was fine.
               voice_verified_at = CASE WHEN $2 OR voice_submitted_at IS NULL THEN voice_verified_at ELSE now() END
             WHERE user_id = $1`,
        decision === "approve" ? [req.params.userId] : [req.params.userId, redo.includes("voice")]);

      // Joining bonus for women companions, once, when first approved.
      if (decision !== "approve") return 0;
      const who = (await c.query<{ gender: string; paid: boolean }>(
        `SELECT u.gender, p.joining_bonus_paid_at IS NOT NULL AS paid FROM users u JOIN companion_profiles p ON p.user_id = u.id WHERE u.id = $1`,
        [req.params.userId])).rows[0]!;
      if (!voiceRequired(who.gender) || who.paid) return 0;
      const paise = await numberSetting(c, "companion.joining_bonus_paise", 1000);
      if (paise <= 0) return 0;
      await ensureWallets(c, req.params.userId);
      await post(c, req.params.userId, "earnings", "bonus", paise, `joining-bonus:${req.params.userId}`, { note: "Joining bonus" });
      await c.query(`UPDATE companion_profiles SET joining_bonus_paid_at = now() WHERE user_id = $1`, [req.params.userId]);
      return paise;
    });
    if (decision === "reject") await goOffline(redis, req.params.userId);
    await notify(app.deps, req.params.userId, decision === "approve"
      ? { type: "kyc_decided", title: "You're verified 🎉",
          body: `${bonus ? `₹${bonus / 100} joining bonus added to your earnings. ` : ""}Finish the academy lessons, then go online to take calls.` }
      : { type: "kyc_decided", title: "KYC needs another look", body: reason });
    return reply.status(204).send(null);
  });

  app.post("/admin/companions/:userId/video", {
    preHandler: can("companions.video"),
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
        // Locking video again switches voice back on, so a "video only" companion still gets calls.
        `UPDATE companion_profiles SET video_enabled = $2, takes_audio = takes_audio OR NOT $2
          WHERE user_id = $1 AND kyc_status = 'approved'`,
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
    preHandler: can("payouts.view"),
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
    preHandler: can("payouts.decide"),
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
    const result = await app.deps.payouts.send({ payoutId: claimed.id, upiId: claimed.upi_id, amountPaise: Number(claimed.net_paise), name })
      .catch((e: Error) => ({ status: "failed" as const, reason: `Provider error: ${e.message}` }));

    // 2. Record the outcome (paid / failed now, or processing until the webhook or worker confirms).
    await finishPayout(app.deps, claimed.id, result);
    const row = (await db.query(
      `SELECT p.*, u.display_name, cp.kyc_status FROM payouts p JOIN users u ON u.id = p.companion_id
         JOIN companion_profiles cp ON cp.user_id = p.companion_id WHERE p.id = $1`, [claimed.id])).rows[0];
    return toPayout(row);
  });

  app.post("/admin/payouts/:id/reject", {
    preHandler: can("payouts.decide"),
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
