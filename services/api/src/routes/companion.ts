/**
 * Companion onboarding (apply → Aadhaar → selfie → PAN + UPI → submit),
 * companion home and earnings/withdrawals.
 *
 * Files arrive base64 in JSON (small, and simple for the generated Dart
 * client) and are stored only encrypted. KYC fields lock once submitted.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, conflict, forbidden } from "../errors.js";
import { post } from "../billing/ledger.js";
import { ageOn, verifyOfflineKyc } from "../kyc/aadhaar.js";
import { seal } from "../storage.js";
import { numberSetting } from "../settings.js";
import { isOnline } from "../presence.js";
import { loadProfile, Profile, TokenPair } from "./profile.js";

const UPI_RE = /^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z][a-zA-Z0-9.]{1,63}$/;
const PAN_RE = /^[A-Z]{3}P[A-Z][0-9]{4}[A-Z]$/; // 4th letter P = individual
const MAX_IMAGE_BYTES = 3 * 1024 * 1024;

export const base64File = (maxBytes: number) => z.string().min(8).max(Math.ceil(maxBytes * 1.4)).transform((s, ctx) => {
  const buf = Buffer.from(s.replace(/^data:[^;]+;base64,/, ""), "base64");
  if (!buf.length || buf.length > maxBytes) {
    ctx.addIssue({ code: "custom", message: "File is empty or too large" });
    return z.NEVER;
  }
  return buf;
});

export const isJpegOrPng = (b: Buffer) =>
  (b[0] === 0xff && b[1] === 0xd8) || (b[0] === 0x89 && b[1] === 0x50 && b[2] === 0x4e && b[3] === 0x47);

export const maskUpi = (upi: string) => {
  const [name, bank] = upi.split("@");
  return `${name!.slice(0, Math.min(4, Math.max(1, name!.length - 2)))}••••@${bank}`;
};

const KycState = z.object({
  status: z.enum(["in_progress", "submitted", "approved", "rejected"]),
  rejectReason: z.string().nullable(),
  aadhaar: z.object({ done: z.boolean(), name: z.string().nullable(), last4: z.string().nullable(), age: z.number().int().nullable() }),
  selfie: z.object({ done: z.boolean() }),
  pan: z.object({ done: z.boolean(), last4: z.string().nullable() }),
  upi: z.object({ done: z.boolean(), masked: z.string().nullable() }),
  videoEnabled: z.boolean(),
}).meta({ id: "KycState" });

interface ProfileRow {
  kyc_status: "pending" | "approved" | "rejected"; kyc_submitted_at: Date | null; kyc_reject_reason: string | null;
  aadhaar_name: string | null; aadhaar_last4: string | null; aadhaar_dob: string | null;
  selfie_blinks: number | null; pan_last4: string | null; upi_id: string | null; video_enabled: boolean;
  takes_audio: boolean; takes_video: boolean;
}

async function profileRow(c: { query: DbClient["query"] }, userId: string, lock = false): Promise<ProfileRow> {
  const row = (await c.query<ProfileRow>(
    `SELECT kyc_status, kyc_submitted_at, kyc_reject_reason, aadhaar_name, aadhaar_last4, to_char(aadhaar_dob, 'YYYY-MM-DD') AS aadhaar_dob,
            selfie_blinks, pan_last4, upi_id, video_enabled, takes_audio, takes_video
       FROM companion_profiles WHERE user_id = $1 ${lock ? "FOR UPDATE" : ""}`, [userId],
  )).rows[0];
  if (!row) throw forbidden("NOT_A_COMPANION");
  return row;
}

function kycState(p: ProfileRow): z.infer<typeof KycState> {
  const status = p.kyc_status === "pending" ? (p.kyc_submitted_at ? "submitted" : "in_progress") : p.kyc_status;
  return {
    status,
    rejectReason: p.kyc_status === "rejected" ? p.kyc_reject_reason : null,
    aadhaar: { done: !!p.aadhaar_last4, name: p.aadhaar_name, last4: p.aadhaar_last4, age: p.aadhaar_dob ? ageOn(p.aadhaar_dob) : null },
    selfie: { done: p.selfie_blinks !== null },
    pan: { done: !!p.pan_last4, last4: p.pan_last4 },
    upi: { done: !!p.upi_id, masked: p.upi_id ? maskUpi(p.upi_id) : null },
    videoEnabled: p.video_enabled,
  };
}

/** KYC can be edited while in progress or after a rejection, not while under review or once approved. */
function assertEditable(p: ProfileRow) {
  if (p.kyc_status === "approved") throw conflict("KYC_LOCKED", "Your verification is already approved");
  if (p.kyc_status === "pending" && p.kyc_submitted_at) throw conflict("KYC_LOCKED", "Your documents are being reviewed");
}

export const companionOnboardingRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, store, kycKey, uidaiCerts, tokens } = app.deps;
  const companion = requireAuth("companion");
  const base = { tags: ["companion"], security: bearer };

  async function saveDoc(c: DbClient, userId: string, docType: string, data: Buffer) {
    const key = `kyc/${userId}/${docType}`;
    await store.put(key, data);
    await c.query(
      `INSERT INTO kyc_documents (user_id, doc_type, storage_key) VALUES ($1, $2, $3)
       ON CONFLICT (user_id, doc_type) DO UPDATE SET storage_key = EXCLUDED.storage_key, status = 'pending', created_at = now()`,
      [userId, docType, key],
    );
  }

  // -------------------------------------------------------------------------
  app.post("/companion/apply", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Become a companion. Switches the account to companion mode and returns new tokens.",
      body: z.object({ firstName: z.string().trim().min(2).max(30), bio: z.string().trim().max(300).nullish() }),
      response: { 200: z.object({ tokens: TokenPair, profile: Profile }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    await tx(db, async (c) => {
      const busy = await c.query(`SELECT 1 FROM calls WHERE caller_id = $1 AND status IN ('ringing', 'active')`, [userId]);
      if (busy.rowCount) throw conflict("IN_A_CALL", "Finish your call first");
      await c.query(`UPDATE users SET role = 'companion', display_name = $2 WHERE id = $1`, [userId, req.body.firstName]);
      await c.query(`INSERT INTO companion_profiles (user_id, bio) VALUES ($1, $2) ON CONFLICT (user_id) DO NOTHING`, [userId, req.body.bio ?? null]);
      // Old tokens carry the caller role.
      await c.query(`UPDATE sessions SET revoked_at = now() WHERE user_id = $1 AND revoked_at IS NULL`, [userId]);
    });
    return { tokens: await tokens.issue(userId, "companion"), profile: await loadProfile(db, userId) };
  });

  app.get("/companion/kyc", {
    preHandler: companion,
    schema: { ...base, summary: "Verification progress", response: { 200: KycState } },
  }, async (req) => kycState(await profileRow(db, me(req).userId)));

  app.post("/companion/kyc/aadhaar", {
    preHandler: companion,
    bodyLimit: 8 * 1024 * 1024,
    schema: {
      ...base,
      summary: "Step 1: Aadhaar offline e-KYC ZIP (from myaadhaar.uidai.gov.in) + its 4-character share code",
      body: z.object({ zipBase64: base64File(5 * 1024 * 1024), shareCode: z.string().trim().min(4).max(8) }),
      response: { 200: KycState },
    },
  }, async (req) => {
    const { userId } = me(req);
    const current = await profileRow(db, userId);
    assertEditable(current);

    const kyc = await verifyOfflineKyc(req.body.zipBase64, req.body.shareCode, uidaiCerts);
    const maxAgeH = await numberSetting(db, "kyc.aadhaar_max_age_hours", 72);
    if (Date.now() - kyc.generatedAt.getTime() > maxAgeH * 3600_000) {
      throw new ApiError(400, "AADHAAR_ZIP_TOO_OLD", `Download a fresh file from the UIDAI site — it must be less than ${maxAgeH / 24} days old`);
    }
    const age = ageOn(kyc.dob);

    await tx(db, async (c) => {
      await profileRow(c, userId, true);
      // The same Aadhaar can't back two companion accounts.
      const dup = await c.query(
        `SELECT 1 FROM companion_profiles WHERE user_id <> $1 AND aadhaar_last4 = $2 AND aadhaar_dob = $3 AND lower(aadhaar_name) = lower($4)`,
        [userId, kyc.last4, kyc.dob, kyc.name],
      );
      if (dup.rowCount) throw conflict("AADHAAR_ALREADY_USED", "This Aadhaar is already linked to another account");

      await saveDoc(c, userId, "aadhaar_offline", req.body.zipBase64);
      await saveDoc(c, userId, "aadhaar_photo", kyc.photoJpeg);
      await c.query(
        `UPDATE companion_profiles SET aadhaar_name = $2, aadhaar_dob = $3, aadhaar_gender = $4, aadhaar_last4 = $5,
                aadhaar_generated_at = $6 WHERE user_id = $1`,
        [userId, kyc.name, kyc.dob, kyc.gender, kyc.last4, kyc.generatedAt],
      );
      if (age < 18) {
        // Kit rule: auto-reject under 18.
        await c.query(`UPDATE companion_profiles SET kyc_status = 'rejected', kyc_reject_reason = 'Under 18' WHERE user_id = $1`, [userId]);
      }
    });
    if (age < 18) throw forbidden("AADHAAR_UNDER_18");
    return kycState(await profileRow(db, userId));
  });

  app.post("/companion/kyc/selfie", {
    preHandler: companion,
    bodyLimit: 5 * 1024 * 1024,
    schema: {
      ...base,
      summary: "Step 2: live selfie. The app runs the blink check (ML Kit) before sending.",
      body: z.object({ imageBase64: base64File(MAX_IMAGE_BYTES), blinks: z.number().int().min(2).max(20) }),
      response: { 200: KycState },
    },
  }, async (req) => {
    const { userId } = me(req);
    if (!isJpegOrPng(req.body.imageBase64)) throw new ApiError(400, "IMAGE_INVALID", "Send a JPEG or PNG photo");
    await tx(db, async (c) => {
      assertEditable(await profileRow(c, userId, true));
      await saveDoc(c, userId, "selfie", req.body.imageBase64);
      await c.query(`UPDATE companion_profiles SET selfie_blinks = $2 WHERE user_id = $1`, [userId, req.body.blinks]);
    });
    return kycState(await profileRow(db, userId));
  });

  app.post("/companion/kyc/pan", {
    preHandler: companion,
    bodyLimit: 5 * 1024 * 1024,
    schema: {
      ...base,
      summary: "Step 3a: PAN number + photo of the card (needed for TDS)",
      body: z.object({
        panNumber: z.string().trim().toUpperCase().regex(PAN_RE, "Enter a valid individual PAN, like ABCPE1234F"),
        imageBase64: base64File(MAX_IMAGE_BYTES),
      }),
      response: { 200: KycState },
    },
  }, async (req) => {
    const { userId } = me(req);
    if (!isJpegOrPng(req.body.imageBase64)) throw new ApiError(400, "IMAGE_INVALID", "Send a JPEG or PNG photo");
    await tx(db, async (c) => {
      assertEditable(await profileRow(c, userId, true));
      await saveDoc(c, userId, "pan", req.body.imageBase64);
      await c.query(`UPDATE companion_profiles SET pan_last4 = $2, pan_encrypted = $3 WHERE user_id = $1`,
        [userId, req.body.panNumber.slice(-4), seal(kycKey, Buffer.from(req.body.panNumber))]);
    });
    return kycState(await profileRow(db, userId));
  });

  app.put("/companion/upi", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Step 3b / later: UPI ID for withdrawals",
      body: z.object({ upiId: z.string().trim().regex(UPI_RE, "Enter a UPI ID like name@okaxis") }),
      response: { 200: KycState },
    },
  }, async (req) => {
    const { userId } = me(req);
    await tx(db, async (c) => {
      await profileRow(c, userId, true);
      const open = await c.query(`SELECT 1 FROM payouts WHERE companion_id = $1 AND status IN ('requested', 'processing')`, [userId]);
      if (open.rowCount) throw conflict("PAYOUT_PENDING", "You can change your UPI ID after the current withdrawal finishes");
      await c.query(
        `UPDATE companion_profiles SET upi_updated_at = CASE WHEN upi_id IS DISTINCT FROM $2 THEN now() ELSE upi_updated_at END,
                upi_id = $2 WHERE user_id = $1`,
        [userId, req.body.upiId.toLowerCase()],
      );
    });
    return kycState(await profileRow(db, userId));
  });

  app.post("/companion/kyc/submit", {
    preHandler: companion,
    schema: { ...base, summary: "Send everything for review", response: { 200: KycState } },
  }, async (req) => {
    const { userId } = me(req);
    await tx(db, async (c) => {
      const p = await profileRow(c, userId, true);
      assertEditable(p);
      const s = kycState(p);
      if (!s.aadhaar.done || !s.selfie.done || !s.pan.done || !s.upi.done) {
        throw new ApiError(400, "KYC_INCOMPLETE", "Finish every step before submitting");
      }
      if (p.aadhaar_dob && ageOn(p.aadhaar_dob) < 18) throw forbidden("AADHAAR_UNDER_18");
      await c.query(
        `UPDATE companion_profiles SET kyc_status = 'pending', kyc_submitted_at = now(), kyc_reject_reason = NULL WHERE user_id = $1`,
        [userId],
      );
    });
    return kycState(await profileRow(db, userId));
  });

  // -------------------------------------------------------------------------
  app.get("/companion/home", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Companion home: status and today's numbers (India time)",
      response: {
        200: z.object({
          kycStatus: KycState.shape.status,
          videoEnabled: z.boolean().describe("Video is unlocked (KYC + academy + clean record)"),
          takesAudio: z.boolean().describe("The companion's own switch: takes voice calls"),
          takesVideo: z.boolean().describe("The companion's own switch: takes video calls (only counts when unlocked)"),
          online: z.boolean(),
          today: z.object({ earnedPaise: z.number().int(), calls: z.number().int(), talkSeconds: z.number().int() }),
          recent: z.array(z.object({
            callId: z.uuid(), callerName: z.string(), callerAvatarId: z.number().int(), type: z.enum(["audio", "video"]),
            status: z.string(), startedAt: z.date().nullable(), durationSeconds: z.number().int().nullable(), earnedPaise: z.number().int(),
          })),
        }),
      },
    },
  }, async (req) => {
    const { userId } = me(req);
    const p = await profileRow(db, userId);
    const today = `date_trunc('day', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata'`;
    const [stats, recent] = await Promise.all([
      db.query<{ paise: number; calls: number; secs: number }>(
        `SELECT COALESCE((SELECT sum(l.amount) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
                   WHERE w.user_id = $1 AND w.kind = 'earnings' AND l.type IN ('call_credit', 'refund_reversal') AND l.created_at >= ${today}), 0)::bigint AS paise,
                (SELECT count(*) FROM calls WHERE companion_id = $1 AND started_at >= ${today})::int AS calls,
                COALESCE((SELECT sum(EXTRACT(EPOCH FROM (ended_at - started_at))) FROM calls
                   WHERE companion_id = $1 AND started_at >= ${today} AND ended_at IS NOT NULL), 0)::int AS secs`, [userId]),
      db.query<{ id: string; name: string; avatar: number; type: "audio" | "video"; status: string; started_at: Date | null; secs: number | null; paise: number }>(
        `SELECT c.id, u.display_name AS name, u.avatar_id AS avatar, c.type, c.status, c.started_at,
                EXTRACT(EPOCH FROM (c.ended_at - c.started_at))::int AS secs,
                c.paise_credited - COALESCE((SELECT -sum(amount) FROM ledger_entries WHERE call_id = c.id AND type = 'refund_reversal'), 0)::bigint AS paise
           FROM calls c JOIN users u ON u.id = c.caller_id
          WHERE c.companion_id = $1 ORDER BY c.created_at DESC LIMIT 8`, [userId]),
    ]);
    const s = stats.rows[0]!;
    return {
      kycStatus: kycState(p).status,
      videoEnabled: p.video_enabled,
      takesAudio: p.takes_audio,
      takesVideo: p.takes_video,
      online: await isOnline(redis, userId),
      today: { earnedPaise: s.paise, calls: s.calls, talkSeconds: s.secs },
      recent: recent.rows.map((r) => ({
        callId: r.id, callerName: r.name, callerAvatarId: r.avatar, type: r.type, status: r.status,
        startedAt: r.started_at, durationSeconds: r.secs, earnedPaise: r.paise,
      })),
    };
  });

  app.put("/companion/call-types", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Choose which calls to take: voice, video or both (video only once it's unlocked)",
      body: z.object({ audio: z.boolean(), video: z.boolean() })
        .refine((b) => b.audio || b.video, { message: "Take at least one kind of call" }),
      response: { 200: z.object({ takesAudio: z.boolean(), takesVideo: z.boolean() }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    const p = await profileRow(db, userId);
    if (req.body.video && !p.video_enabled) {
      throw new ApiError(409, "VIDEO_LOCKED", "Video calls unlock after KYC approval and the academy lessons");
    }
    // Voice-only while video is locked keeps the video switch as it was (default on),
    // so video starts working the moment it's unlocked unless they turned it off.
    const takesVideo = p.video_enabled ? req.body.video : p.takes_video;
    const r = (await db.query<{ takes_audio: boolean; takes_video: boolean }>(
      `UPDATE companion_profiles SET takes_audio = $2, takes_video = $3 WHERE user_id = $1 RETURNING takes_audio, takes_video`,
      [userId, req.body.audio, takesVideo])).rows[0]!;
    return { takesAudio: r.takes_audio, takesVideo: r.takes_video };
  });

  // -------------------------------------------------------------------------
  const Payout = z.object({
    id: z.uuid(), grossPaise: z.number().int(), tdsPaise: z.number().int(), netPaise: z.number().int(),
    upi: z.string(), status: z.enum(["requested", "processing", "paid", "failed", "rejected"]),
    failureReason: z.string().nullable(), createdAt: z.date(), processedAt: z.date().nullable(),
  }).meta({ id: "Payout" });

  app.get("/companion/earnings", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Balance, last 7 days and withdrawals",
      response: {
        200: z.object({
          availablePaise: z.number().int(), upi: z.string().nullable(), minWithdrawalPaise: z.number().int(), tdsBps: z.number().int(),
          canWithdraw: z.boolean(), blockedReason: z.string().nullable(),
          week: z.array(z.object({ date: z.string(), paise: z.number().int() })),
          payouts: z.array(Payout),
        }),
      },
    },
  }, async (req) => {
    const { userId } = me(req);
    const p = await profileRow(db, userId);
    const [bal, week, list, minPaise, tdsBps] = await Promise.all([
      db.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'earnings'`, [userId]),
      db.query<{ date: string; paise: number }>(
        `SELECT to_char(d, 'YYYY-MM-DD') AS date,
                COALESCE((SELECT sum(l.amount) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
                   WHERE w.user_id = $1 AND w.kind = 'earnings' AND l.type IN ('call_credit', 'refund_reversal')
                     AND (l.created_at AT TIME ZONE 'Asia/Kolkata')::date = d), 0)::bigint AS paise
           FROM generate_series((now() AT TIME ZONE 'Asia/Kolkata')::date - 6, (now() AT TIME ZONE 'Asia/Kolkata')::date, interval '1 day') AS d
          ORDER BY d`, [userId]),
      db.query(`SELECT * FROM payouts WHERE companion_id = $1 ORDER BY created_at DESC LIMIT 20`, [userId]),
      numberSetting(db, "payout.min_paise", 10_000),
      numberSetting(db, "payout.tds_bps", 100),
    ]);
    const available = bal.rows[0]?.balance ?? 0;
    const open = list.rows.some((r) => r.status === "requested" || r.status === "processing");
    const blockedReason = p.kyc_status !== "approved" ? "Finish verification to withdraw"
      : !p.upi_id ? "Add a UPI ID to withdraw"
      : open ? "Your last withdrawal is still being processed"
      : available < minPaise ? `You can withdraw once you have ₹${minPaise / 100}` : null;
    return {
      availablePaise: available, upi: p.upi_id ? maskUpi(p.upi_id) : null, minWithdrawalPaise: minPaise, tdsBps,
      canWithdraw: blockedReason === null, blockedReason,
      week: week.rows,
      payouts: list.rows.map((r) => ({
        id: r.id, grossPaise: Number(r.gross_paise), tdsPaise: Number(r.tds_paise), netPaise: Number(r.net_paise),
        upi: maskUpi(r.upi_id), status: r.status, failureReason: r.failure_reason, createdAt: r.created_at, processedAt: r.processed_at,
      })),
    };
  });

  app.post("/companion/payouts", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Withdraw to UPI. The amount leaves the balance now; a failed payout is credited back.",
      body: z.object({ amountPaise: z.number().int().positive().nullish().describe("Default: everything available") }),
      response: { 201: Payout },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    const [minPaise, tdsBps] = await Promise.all([numberSetting(db, "payout.min_paise", 10_000), numberSetting(db, "payout.tds_bps", 100)]);
    const row = await tx(db, async (c) => {
      const p = await profileRow(c, userId, true);
      if (p.kyc_status !== "approved") throw forbidden("KYC_NOT_APPROVED");
      if (!p.upi_id) throw new ApiError(400, "UPI_MISSING", "Add a UPI ID first");
      const open = await c.query(`SELECT 1 FROM payouts WHERE companion_id = $1 AND status IN ('requested', 'processing')`, [userId]);
      if (open.rowCount) throw conflict("PAYOUT_PENDING", "Your last withdrawal is still being processed");
      const balance = (await c.query<{ balance: number }>(
        `SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'earnings' FOR UPDATE`, [userId])).rows[0]?.balance ?? 0;
      const gross = req.body.amountPaise ?? balance;
      if (gross < minPaise) throw new ApiError(400, "BELOW_MINIMUM", `The minimum withdrawal is ₹${minPaise / 100}`);
      if (gross > balance) throw new ApiError(400, "INSUFFICIENT_EARNINGS", "That's more than your balance");
      const tds = Math.round((gross * tdsBps) / 10_000);

      const flags = await riskFlags(c, userId);
      let payout;
      try {
        payout = (await c.query(
          `INSERT INTO payouts (companion_id, gross_paise, tds_paise, net_paise, upi_id, flags)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
          [userId, gross, tds, gross - tds, p.upi_id, flags],
        )).rows[0];
      } catch (e) {
        if ((e as { code?: string }).code === "23505") throw conflict("PAYOUT_PENDING", "Your last withdrawal is still being processed");
        throw e;
      }
      await post(c, userId, "earnings", "payout", -gross, `payout:${payout.id}:debit`, { payoutId: payout.id, note: "Withdrawal to UPI" });
      return payout;
    });
    reply.status(201);
    return {
      id: row.id, grossPaise: Number(row.gross_paise), tdsPaise: Number(row.tds_paise), netPaise: Number(row.net_paise),
      upi: maskUpi(row.upi_id), status: row.status, failureReason: null, createdAt: row.created_at, processedAt: null,
    };
  });
};

/**
 * Kit fraud rules, evaluated when a withdrawal is requested:
 * UPI changed right before payout, many sub-70-second calls, earnings far above normal.
 */
export async function riskFlags(c: DbClient, userId: string): Promise<string[]> {
  const r = (await c.query<{ upi_recent: boolean; short_calls: number; last_day: number; daily_avg: number }>(
    `SELECT COALESCE((SELECT upi_updated_at > now() - interval '24 hours' FROM companion_profiles WHERE user_id = $1), false) AS upi_recent,
            (SELECT count(*) FROM calls WHERE companion_id = $1 AND started_at > now() - interval '24 hours'
               AND ended_at - started_at < interval '70 seconds')::int AS short_calls,
            COALESCE((SELECT sum(l.amount) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
               WHERE w.user_id = $1 AND w.kind = 'earnings' AND l.type = 'call_credit' AND l.created_at > now() - interval '24 hours'), 0)::bigint AS last_day,
            COALESCE((SELECT sum(l.amount) / 14.0 FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
               WHERE w.user_id = $1 AND w.kind = 'earnings' AND l.type = 'call_credit'
                 AND l.created_at BETWEEN now() - interval '15 days' AND now() - interval '24 hours'), 0)::float8 AS daily_avg`,
    [userId],
  )).rows[0]!;
  const flags: string[] = [];
  if (r.upi_recent) flags.push("upi_changed_recently");
  if (r.short_calls >= 10) flags.push("many_short_calls");
  if (r.daily_avg > 0 && r.last_day > 4 * r.daily_avg && r.last_day > 50_000) flags.push("earnings_spike");
  return flags;
}
