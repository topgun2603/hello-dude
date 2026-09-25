/**
 * Companion onboarding (apply → date of birth (18+) → live selfie → UPI → submit;
 * PAN optional, any time), companion home and earnings/withdrawals. No Aadhaar
 * (owner, 2026-09-24): an admin approves from the selfie; without a PAN on file
 * withdrawals carry the higher TDS rate.
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
import { ageOn } from "../kyc/aadhaar.js";
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

export const KYC_ITEMS = ["age", "selfie", "voice", "pan", "upi"] as const;
export type KycItem = (typeof KYC_ITEMS)[number];

const KycState = z.object({
  status: z.enum(["in_progress", "submitted", "approved", "rejected"]),
  rejectReason: z.string().nullable(),
  redo: z.array(z.enum(KYC_ITEMS)).describe("After a rejection: what to send again. Once all are sent, it goes back to review by itself."),
  age: z.object({ done: z.boolean(), birthDate: z.string().nullable().describe("YYYY-MM-DD"), age: z.number().int().nullable() }),
  selfie: z.object({ done: z.boolean() }),
  voice: z.object({
    needed: z.boolean().describe("Women companions record a voice intro; an admin listens to it"),
    done: z.boolean(),
    sentence: z.string().nullable().describe("Read this aloud (random each time)"),
  }),
  pan: z.object({ done: z.boolean(), last4: z.string().nullable() }).describe("Optional; without it TDS on withdrawals is higher"),
  upi: z.object({ done: z.boolean(), masked: z.string().nullable() }),
  videoEnabled: z.boolean(),
}).meta({ id: "KycState" });

interface ProfileRow {
  kyc_status: "pending" | "approved" | "rejected"; kyc_submitted_at: Date | null; kyc_reject_reason: string | null;
  birth_date: string | null; age_confirmed_at: Date | null;
  gender: string; language: string; voice_sentence: string | null; voice_submitted_at: Date | null; kyc_redo: KycItem[];
  selfie_blinks: number | null; pan_last4: string | null; upi_id: string | null; video_enabled: boolean;
  takes_audio: boolean; takes_video: boolean;
}

async function profileRow(c: { query: DbClient["query"] }, userId: string, lock = false): Promise<ProfileRow> {
  const row = (await c.query<ProfileRow>(
    `SELECT kyc_status, kyc_submitted_at, kyc_reject_reason, to_char(birth_date, 'YYYY-MM-DD') AS birth_date, age_confirmed_at,
            (SELECT gender FROM users WHERE id = $1) AS gender, (SELECT primary_language FROM users WHERE id = $1) AS language,
            voice_sentence, voice_submitted_at, kyc_redo,
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
    redo: p.kyc_status === "rejected" ? p.kyc_redo : [],
    age: { done: !!p.age_confirmed_at, birthDate: p.birth_date, age: p.birth_date ? ageOn(p.birth_date) : null },
    selfie: { done: p.selfie_blinks !== null },
    voice: { needed: voiceRequired(p.gender), done: !!p.voice_submitted_at, sentence: p.voice_sentence },
    pan: { done: !!p.pan_last4, last4: p.pan_last4 },
    upi: { done: !!p.upi_id, masked: p.upi_id ? maskUpi(p.upi_id) : null },
    videoEnabled: p.video_enabled,
  };
}

/** Women (and transgender) companions verify with a voice intro. */
export const voiceRequired = (gender: string) => gender !== "male";

/**
 * Voice-intro lines in each launch language (owner: in her own language, not English).
 * Each ends with "my number/code" and the random digits follow. Placeholder wording —
 * have a native speaker check each before launch.
 */
const VOICE_LINES: Record<string, string[]> = {
  ta: ["வணக்கம்! நான் புதிய நண்பர்களுடன் பேச விரும்புகிறேன். என் எண்", "இது Hello Dude-க்கான என் குரல். என் எண்"],
  te: ["నమస్కారం! నాకు కొత్త స్నేహితులతో మాట్లాడటం ఇష్టం. నా సంఖ్య", "ఇది Hello Dude కోసం నా గొంతు. నా సంఖ్య"],
  kn: ["ನಮಸ್ಕಾರ! ನನಗೆ ಹೊಸ ಸ್ನೇಹಿತರೊಂದಿಗೆ ಮಾತನಾಡಲು ಇಷ್ಟ. ನನ್ನ ಸಂಖ್ಯೆ", "ಇದು Hello Dude ಗಾಗಿ ನನ್ನ ಧ್ವನಿ. ನನ್ನ ಸಂಖ್ಯೆ"],
  ml: ["നമസ്കാരം! പുതിയ സുഹൃത്തുക്കളോട് സംസാരിക്കാൻ എനിക്ക് ഇഷ്ടമാണ്. എന്റെ നമ്പർ", "ഇത് Hello Dude-നായുള്ള എന്റെ ശബ്ദമാണ്. എന്റെ നമ്പർ"],
  hi: ["नमस्ते! मुझे नए दोस्तों से बात करना पसंद है। मेरा नंबर है", "यह Hello Dude के लिए मेरी आवाज़ है। मेरा नंबर है"],
  bn: ["নমস্কার! নতুন বন্ধুদের সাথে কথা বলতে আমার ভালো লাগে। আমার নম্বর", "এটা Hello Dude-এর জন্য আমার কণ্ঠ। আমার নম্বর"],
  mr: ["नमस्कार! मला नवीन मित्रांशी बोलायला आवडते. माझा क्रमांक", "हा Hello Dude साठी माझा आवाज आहे. माझा क्रमांक"],
  en: ["Hello! I love talking to new friends. My number is", "This is my voice for Hello Dude. My number is"],
};
/** A random line in `language` (English if unknown) with random digits, so an old recording can't be reused. */
export function voiceSentence(language: string) {
  const lines = VOICE_LINES[language] ?? VOICE_LINES.en!;
  const digits = Array.from({ length: 4 }, () => Math.floor(Math.random() * 10)).join(" ");
  return `${lines[Math.floor(Math.random() * lines.length)]} ${digits}.`;
}
const MAX_VOICE_BYTES = 2 * 1024 * 1024;
/** m4a/mp4/3gp (ftyp), Ogg, WAV or WebM. */
export const isAudio = (b: Buffer) =>
  b.subarray(4, 8).toString("latin1") === "ftyp" || b.subarray(0, 4).toString("latin1") === "OggS" ||
  b.subarray(0, 4).toString("latin1") === "RIFF" || (b[0] === 0x1a && b[1] === 0x45 && b[2] === 0xdf && b[3] === 0xa3);

/** Every required step is done (PAN is optional). */
const complete = (p: ProfileRow) =>
  !!p.age_confirmed_at && p.selfie_blinks !== null && !!p.upi_id && (!voiceRequired(p.gender) || !!p.voice_submitted_at);

/**
 * After a rejection, sending an item the admin asked for ticks it off; when the
 * last one is in (and every step is done) the case goes back to review by itself.
 * Returns true when it was resubmitted.
 */
async function resubmitIfFixed(c: DbClient, userId: string, item: KycItem) {
  const r = await c.query(
    `UPDATE companion_profiles SET kyc_redo = array_remove(kyc_redo, $2)
      WHERE user_id = $1 AND kyc_status = 'rejected' AND $2 = ANY(kyc_redo) RETURNING kyc_redo`, [userId, item]);
  if (!r.rowCount || r.rows[0].kyc_redo.length) return false;
  const p = await profileRow(c, userId);
  if (!complete(p) || (p.birth_date && ageOn(p.birth_date) < 18)) return false;
  await c.query(
    `UPDATE companion_profiles SET kyc_status = 'pending', kyc_submitted_at = now(), kyc_reject_reason = NULL WHERE user_id = $1`,
    [userId]);
  return true;
}

/** KYC can be edited while in progress or after a rejection, not while under review or once approved. */
function assertEditable(p: ProfileRow) {
  if (p.kyc_status === "approved") throw conflict("KYC_LOCKED", "Your verification is already approved");
  if (p.kyc_status === "pending" && p.kyc_submitted_at) throw conflict("KYC_LOCKED", "Your documents are being reviewed");
}

export const companionOnboardingRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, store, kycKey, tokens } = app.deps;
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
  }, async (req) => {
    const userId = me(req).userId;
    const p = await profileRow(db, userId);
    if (voiceRequired(p.gender) && !p.voice_sentence && !p.voice_submitted_at) {
      await db.query(`UPDATE companion_profiles SET voice_sentence = $2 WHERE user_id = $1 AND voice_sentence IS NULL`, [userId, voiceSentence(p.language)]);
      return kycState(await profileRow(db, userId));
    }
    return kycState(p);
  });

  app.post("/companion/kyc/voice", {
    preHandler: companion,
    bodyLimit: 4 * 1024 * 1024,
    schema: {
      ...base,
      summary: "Voice intro: a recording of the sentence from GET /companion/kyc (m4a/ogg/wav, up to 2 MB). An admin listens to it; " +
        "it's deleted after the decision.",
      body: z.object({ audioBase64: base64File(MAX_VOICE_BYTES) }),
      response: { 200: KycState },
    },
  }, async (req) => {
    const { userId } = me(req);
    if (!isAudio(req.body.audioBase64)) throw new ApiError(400, "AUDIO_INVALID", "Send the recording as m4a, ogg or wav");
    await tx(db, async (c) => {
      const p = await profileRow(c, userId, true);
      assertEditable(p);
      if (!voiceRequired(p.gender)) throw new ApiError(400, "VOICE_NOT_NEEDED", "A voice intro isn't needed for your account");
      if (!p.voice_sentence) throw conflict("NO_SENTENCE", "Open verification again to get your sentence");
      await saveDoc(c, userId, "voice", req.body.audioBase64);
      await c.query(`UPDATE companion_profiles SET voice_submitted_at = now() WHERE user_id = $1`, [userId]);
      await resubmitIfFixed(c, userId, "voice");
    });
    return kycState(await profileRow(db, userId));
  });

  app.post("/companion/kyc/age", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Step 1: date of birth and a confirmation that you are 18 or older. Under 18 is rejected.",
      body: z.object({
        birthDate: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Use YYYY-MM-DD"),
        confirm18: z.literal(true).describe("I confirm I am 18 or older"),
      }),
      response: { 200: KycState },
    },
  }, async (req) => {
    const { userId } = me(req);
    const d = new Date(`${req.body.birthDate}T00:00:00Z`);
    if (Number.isNaN(d.getTime()) || d.getUTCFullYear() < 1900 || d > new Date()) {
      throw new ApiError(400, "BAD_DATE", "Enter your real date of birth");
    }
    const age = ageOn(req.body.birthDate);
    await tx(db, async (c) => {
      assertEditable(await profileRow(c, userId, true));
      await c.query(`UPDATE companion_profiles SET birth_date = $2, age_confirmed_at = now() WHERE user_id = $1`, [userId, req.body.birthDate]);
      if (age >= 18) await resubmitIfFixed(c, userId, "age");
      if (age < 18) {
        await c.query(`UPDATE companion_profiles SET kyc_status = 'rejected', kyc_reject_reason = 'Under 18' WHERE user_id = $1`, [userId]);
      }
    });
    if (age < 18) throw forbidden("UNDER_18");
    return kycState(await profileRow(db, userId));
  });

  app.post("/companion/kyc/selfie", {
    preHandler: companion,
    bodyLimit: 5 * 1024 * 1024,
    schema: {
      ...base,
      summary: "Step 2: live selfie (the admin reviews it). The app runs the blink check (ML Kit) before sending.",
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
      await resubmitIfFixed(c, userId, "selfie");
    });
    return kycState(await profileRow(db, userId));
  });

  app.post("/companion/kyc/pan", {
    preHandler: companion,
    bodyLimit: 5 * 1024 * 1024,
    schema: {
      ...base,
      summary: "Optional, any time: PAN number + photo of the card. Without it, withdrawals carry the higher TDS (20%).",
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
      const p = await profileRow(c, userId, true);
      if (p.kyc_status === "pending" && p.kyc_submitted_at) throw conflict("KYC_LOCKED", "Your details are being reviewed");
      const open = await c.query(`SELECT 1 FROM payouts WHERE companion_id = $1 AND status IN ('requested', 'processing')`, [userId]);
      if (open.rowCount) throw conflict("PAYOUT_PENDING", "You can change your PAN after the current withdrawal finishes");
      await saveDoc(c, userId, "pan", req.body.imageBase64);
      await c.query(`UPDATE companion_profiles SET pan_last4 = $2, pan_encrypted = $3 WHERE user_id = $1`,
        [userId, req.body.panNumber.slice(-4), seal(kycKey, Buffer.from(req.body.panNumber))]);
      await resubmitIfFixed(c, userId, "pan");
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
      await resubmitIfFixed(c, userId, "upi");
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
      if (!complete(p)) throw new ApiError(400, "KYC_INCOMPLETE", "Finish every step before submitting");
      if (s.redo.length) throw new ApiError(400, "KYC_INCOMPLETE", "Send again what the review asked for first");
      if (p.birth_date && ageOn(p.birth_date) < 18) throw forbidden("UNDER_18");
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
          availablePaise: z.number().int(), upi: z.string().nullable(), minWithdrawalPaise: z.number().int(),
          tdsBps: z.number().int().describe("TDS on your withdrawals now (higher without a PAN)"),
          panOnFile: z.boolean(), tdsWithPanBps: z.number().int(), tdsNoPanBps: z.number().int(),
          canWithdraw: z.boolean(), blockedReason: z.string().nullable(),
          week: z.array(z.object({ date: z.string(), paise: z.number().int() })),
          payouts: z.array(Payout),
        }),
      },
    },
  }, async (req) => {
    const { userId } = me(req);
    const p = await profileRow(db, userId);
    const [bal, week, list, minPaise, withPan, noPan] = await Promise.all([
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
      numberSetting(db, "payout.tds_no_pan_bps", 2000),
    ]);
    const tdsBps = p.pan_last4 ? withPan : noPan;
    const available = bal.rows[0]?.balance ?? 0;
    const open = list.rows.some((r) => r.status === "requested" || r.status === "processing");
    const blockedReason = p.kyc_status !== "approved" ? "Finish verification to withdraw"
      : !p.upi_id ? "Add a UPI ID to withdraw"
      : open ? "Your last withdrawal is still being processed"
      : available < minPaise ? `You can withdraw once you have ₹${minPaise / 100}` : null;
    return {
      availablePaise: available, upi: p.upi_id ? maskUpi(p.upi_id) : null, minWithdrawalPaise: minPaise, tdsBps,
      panOnFile: !!p.pan_last4, tdsWithPanBps: withPan, tdsNoPanBps: noPan,
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
    const [minPaise, withPan, noPan] = await Promise.all([
      numberSetting(db, "payout.min_paise", 10_000), numberSetting(db, "payout.tds_bps", 100), numberSetting(db, "payout.tds_no_pan_bps", 2000),
    ]);
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
      // Without a PAN on file the higher TDS rate applies (Income Tax Act s.206AA).
      const tds = Math.round((gross * (p.pan_last4 ? withPan : noPan)) / 10_000);

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
  // Tried to share a number / UPI / other app in chat (chat-safety.ts strikes).
  const strikes = (await c.query<{ n: number }>(
    `SELECT count(*)::int AS n FROM chat_violations WHERE sender_id = $1 AND created_at > now() - interval '30 days'`, [userId])).rows[0]!.n;
  if (strikes >= 3) flags.push("contact_sharing");
  return flags;
}
