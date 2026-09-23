/**
 * "Delete my account" (DPDP Act 2023: right to erasure).
 *
 * Removed: name, phone number, languages, devices, sessions, favourites, chat messages they sent, notifications,
 * KYC files (Aadhaar ZIP/photo, selfie, PAN card image) and Aadhaar fields.
 * Kept, because the law or safety requires it: the money ledger, calls and
 * payouts (tax records), reports and blocks (safety), and — for companions who
 * were paid — the encrypted PAN and name used for TDS filings.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, conflict } from "../errors.js";
import { goOffline } from "../presence.js";
import { numberSetting } from "../settings.js";

export const accountRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, store } = app.deps;

  app.post("/me/delete", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      tags: ["profile"],
      security: bearer,
      summary: "Permanently delete my account. Unused coins are forfeited; companions must withdraw earnings first.",
      body: z.object({ confirm: z.literal("DELETE") }),
      response: { 200: z.object({ deleted: z.literal(true), kept: z.array(z.string()) }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    const minPaise = await numberSetting(db, "payout.min_paise", 10_000);
    const docs = await tx(db, async (c) => {
      const u = (await c.query<{ role: "caller" | "companion"; status: string }>(
        `SELECT role, status FROM users WHERE id = $1 FOR UPDATE`, [userId])).rows[0];
      if (!u || u.status === "deleted") throw new ApiError(404, "USER_NOT_FOUND");
      const busy = await c.query(`SELECT 1 FROM calls WHERE (caller_id = $1 OR companion_id = $1) AND status IN ('ringing', 'active')`, [userId]);
      if (busy.rowCount) throw conflict("IN_A_CALL", "End your call first");
      const w = (await c.query<{ coins: number; earnings: number }>(
        `SELECT COALESCE(max(balance) FILTER (WHERE kind = 'coins'), 0)::bigint AS coins,
                COALESCE(max(balance) FILTER (WHERE kind = 'earnings'), 0)::bigint AS earnings
           FROM wallets WHERE user_id = $1`, [userId])).rows[0]!;
      if (u.role === "companion") {
        const open = await c.query(`SELECT 1 FROM payouts WHERE companion_id = $1 AND status IN ('requested', 'processing')`, [userId]);
        if (open.rowCount) throw conflict("PAYOUT_PENDING", "Wait for your withdrawal to finish first");
        if (w.earnings >= minPaise) throw conflict("EARNINGS_LEFT", "Withdraw your earnings before deleting your account");
      }
      const paid = (await c.query(`SELECT 1 FROM payouts WHERE companion_id = $1 AND status = 'paid' LIMIT 1`, [userId])).rowCount;

      const kept = ["money ledger, calls and payouts (tax law)", "reports and blocks (safety)"];
      if (paid) kept.push("encrypted PAN and legal name (TDS filings)");

      const files = (await c.query<{ storage_key: string }>(`SELECT storage_key FROM kyc_documents WHERE user_id = $1`, [userId])).rows;
      await c.query(`DELETE FROM kyc_documents WHERE user_id = $1`, [userId]);
      await c.query(`DELETE FROM user_languages WHERE user_id = $1`, [userId]);
      await c.query(`DELETE FROM devices WHERE user_id = $1`, [userId]);
      await c.query(`DELETE FROM sessions WHERE user_id = $1`, [userId]);
      await c.query(`DELETE FROM favourites WHERE user_id = $1 OR companion_id = $1`, [userId]);
      await c.query(`DELETE FROM academy_progress WHERE user_id = $1`, [userId]);
      await c.query(`DELETE FROM messages WHERE sender_id = $1`, [userId]);
      await c.query(`DELETE FROM notifications WHERE user_id = $1`, [userId]);
      await c.query(
        `UPDATE companion_profiles SET bio = NULL, upi_id = NULL, aadhaar_dob = NULL, aadhaar_gender = NULL,
                aadhaar_generated_at = NULL, selfie_blinks = NULL,
                aadhaar_name = CASE WHEN $2 THEN aadhaar_name END,
                pan_encrypted = CASE WHEN $2 THEN pan_encrypted END,
                pan_last4 = CASE WHEN $2 THEN pan_last4 END
          WHERE user_id = $1`, [userId, !!paid]);
      // The number is freed so the person can sign up again later as a new account.
      await c.query(
        `UPDATE users SET status = 'deleted', display_name = 'Deleted user', avatar_id = 1,
                phone = 'deleted:' || id::text WHERE id = $1`, [userId]);
      await c.query(`INSERT INTO account_deletions (user_id, role, forfeited_coins, kept) VALUES ($1, $2, $3, $4)`,
        [userId, u.role, w.coins, kept]);
      return { files, kept };
    });
    await goOffline(redis, userId);
    for (const f of docs.files) await store.delete(f.storage_key).catch(() => {});
    return { deleted: true as const, kept: docs.kept };
  });
};
