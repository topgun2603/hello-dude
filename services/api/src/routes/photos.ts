/**
 * Companion profile photos. A companion uploads a photo; the server strips all
 * metadata (EXIF/GPS) and re-encodes it, then it waits for an admin, who compares
 * it with the KYC selfie. Only approved photos are shown, and only through signed
 * URLs handed to signed-in users (they expire, so scraped links stop working).
 * Callers stay avatar-only.
 */
import { createHmac, randomUUID, timingSafeEqual } from "node:crypto";
import sharp from "sharp";
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { ApiError, notFound } from "../errors.js";
import { notify } from "../notifications.js";
import { base64File } from "./companion.js";

const MAX_UPLOAD_BYTES = 6 * 1024 * 1024;
const SIZE = 720;          // stored as a 720×720 JPEG
const MIN_SIDE = 200;
const UPLOADS_PER_DAY = 5;

const signingKey = (kycKey: Buffer) => createHmac("sha256", kycKey).update("photo-url-v1").digest();
const sign = (kycKey: Buffer, payload: string) =>
  createHmac("sha256", signingKey(kycKey)).update(payload).digest("base64url").slice(0, 32);

/** Signs `payload` for a URL that expires at `exp` (unix seconds, rounded to the day). */
export function signedQuery(kycKey: Buffer, payload: string) {
  const exp = (Math.floor(Date.now() / 86_400_000) + 2) * 86_400;
  return `exp=${exp}&sig=${sign(kycKey, `${payload}.${exp}`)}`;
}

/** Checks a signature made by signedQuery (constant time; expired = invalid). */
export function checkSigned(kycKey: Buffer, payload: string, exp: number, sig: string) {
  const want = Buffer.from(sign(kycKey, `${payload}.${exp}`));
  const got = Buffer.from(sig);
  return exp * 1000 >= Date.now() && want.length === got.length && timingSafeEqual(want, got);
}

/**
 * A signed, expiring URL path for a user's approved photo (`version`), or the
 * pending one. Expiry is rounded to the day so the same URL (and the phone's
 * image cache) is reused all day. Null when there is no photo.
 */
export function photoUrl(kycKey: Buffer, userId: string, version: number | null | undefined, which: "approved" | "pending" = "approved") {
  if (version === null || version === undefined) return null;
  const exp = (Math.floor(Date.now() / 86_400_000) + 2) * 86_400;
  const file = which === "pending" ? `pending-${version}` : String(version);
  return `/v1/photos/${userId}/${file}.jpg?exp=${exp}&sig=${sign(kycKey, `${userId}.${file}.${exp}`)}`;
}

/** SQL for the version to pass to photoUrl (null without an approved photo); `u` is the users alias. */
export const PHOTO_V_SQL = (u: string) => `CASE WHEN ${u}.photo_key IS NOT NULL THEN ${u}.photo_version END`;

/** Re-encodes an upload: applies EXIF rotation, crops square, drops all metadata. */
export async function cleanPhoto(input: Buffer) {
  let meta: sharp.Metadata;
  try {
    meta = await sharp(input).metadata();
  } catch {
    throw new ApiError(400, "NOT_AN_IMAGE", "That file isn't a photo we can read");
  }
  if (!meta.format || !["jpeg", "png", "webp", "heif"].includes(meta.format)) {
    throw new ApiError(400, "NOT_AN_IMAGE", "Upload a JPEG, PNG, WebP or HEIC photo");
  }
  if ((meta.width ?? 0) < MIN_SIDE || (meta.height ?? 0) < MIN_SIDE) {
    throw new ApiError(400, "PHOTO_TOO_SMALL", `The photo must be at least ${MIN_SIDE}×${MIN_SIDE} pixels`);
  }
  // sharp writes no metadata unless asked (withMetadata), so EXIF/GPS is gone.
  return sharp(input).rotate().resize(SIZE, SIZE, { fit: "cover", position: "attention" })
    .jpeg({ quality: 82, mozjpeg: true }).toBuffer();
}

const MyPhoto = z.object({
  status: z.enum(["none", "pending", "approved", "rejected"]),
  photoUrl: z.string().nullable().describe("The approved photo others see"),
  pendingUrl: z.string().nullable().describe("Waiting for review"),
  rejectReason: z.string().nullable(),
}).meta({ id: "MyPhoto" });

export const photoRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, store, kycKey } = app.deps;
  const base = { tags: ["photos"], security: bearer };

  type Row = { photo_key: string | null; photo_version: number; photo_pending_key: string | null; photo_status: "none" | "pending" | "approved" | "rejected";
    photo_reject_reason: string | null };
  const row = async (userId: string) => (await db.query<Row>(
    `SELECT photo_key, photo_version, photo_pending_key, photo_status, photo_reject_reason FROM users WHERE id = $1`, [userId])).rows[0]!;
  const mine = (userId: string, r: Row) => ({
    status: r.photo_status,
    photoUrl: r.photo_key ? photoUrl(kycKey, userId, r.photo_version) : null,
    pendingUrl: r.photo_pending_key ? photoUrl(kycKey, userId, r.photo_version, "pending") : null,
    rejectReason: r.photo_status === "rejected" ? r.photo_reject_reason : null,
  });

  app.get("/me/photo", {
    preHandler: requireAuth("companion"),
    schema: { ...base, summary: "My profile photo and its review status", response: { 200: MyPhoto } },
  }, async (req) => { const id = me(req).userId; return mine(id, await row(id)); });

  app.put("/me/photo", {
    preHandler: requireAuth("companion"),
    bodyLimit: 9 * 1024 * 1024,
    schema: {
      ...base,
      summary: "Upload a profile photo (companions). It's cleaned (metadata removed) and shown after an admin approves it; " +
        "until then your current photo or avatar stays.",
      body: z.object({ imageBase64: base64File(MAX_UPLOAD_BYTES) }),
      response: { 200: MyPhoto },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const day = new Date().toISOString().slice(0, 10);
    const n = await redis.incr(`photo:uploads:${userId}:${day}`);
    await redis.expire(`photo:uploads:${userId}:${day}`, 86_400);
    if (n > UPLOADS_PER_DAY) throw new ApiError(429, "TOO_MANY_UPLOADS", "You can upload 5 photos a day. Try again tomorrow.");
    const clean = await cleanPhoto(req.body.imageBase64);
    const key = `photos/${userId}/${randomUUID()}`;
    await store.put(key, clean);
    const old = (await db.query<{ photo_pending_key: string | null }>(
      `SELECT photo_pending_key FROM users WHERE id = $1`, [userId])).rows[0]?.photo_pending_key;
    await db.query(
      `UPDATE users SET photo_pending_key = $2, photo_status = 'pending', photo_reject_reason = NULL,
                        photo_submitted_at = now(), photo_version = photo_version + 1 WHERE id = $1`, [userId, key]);
    if (old) await store.delete(old).catch(() => {});
    return mine(userId, await row(userId));
  });

  app.delete("/me/photo", {
    preHandler: requireAuth("companion"),
    schema: { ...base, summary: "Remove my photo (and any waiting for review); the avatar shows again", response: { 200: MyPhoto } },
  }, async (req) => {
    const userId = me(req).userId;
    const r = await row(userId);
    await db.query(
      `UPDATE users SET photo_key = NULL, photo_pending_key = NULL, photo_status = 'none', photo_reject_reason = NULL,
                        photo_version = photo_version + 1 WHERE id = $1`, [userId]);
    for (const k of [r.photo_key, r.photo_pending_key]) if (k) await store.delete(k).catch(() => {});
    return mine(userId, await row(userId));
  });

  // The signature is the permission: URLs are only handed to signed-in users and expire.
  app.get("/photos/:userId/:file", {
    schema: {
      tags: ["photos"],
      summary: "A profile photo, through a signed URL from the API (never linked directly)",
      params: z.object({ userId: z.uuid(), file: z.string().regex(/^(pending-)?\d+\.jpg$/) }),
      querystring: z.object({ exp: z.coerce.number().int(), sig: z.string().max(64) }),
    },
  }, async (req, reply) => {
    const { userId } = req.params;
    const file = req.params.file.replace(/\.jpg$/, "");
    const { exp, sig } = req.query;
    const want = Buffer.from(sign(kycKey, `${userId}.${file}.${exp}`));
    const got = Buffer.from(sig);
    if (exp * 1000 < Date.now() || want.length !== got.length || !timingSafeEqual(want, got)) throw notFound("PHOTO_NOT_FOUND");
    const r = await row(userId).catch(() => null);
    const pending = file.startsWith("pending-");
    const version = Number(pending ? file.slice("pending-".length) : file);
    // Replaced, removed or rejected photos are gone (404), even with a valid link.
    const key = !r || r.photo_version !== version ? null : pending ? r.photo_pending_key : r.photo_key;
    if (!key) throw notFound("PHOTO_NOT_FOUND");
    const bytes = await store.get(key);
    return reply
      .header("cache-control", pending ? "no-store, private" : "private, max-age=86400")
      .type("image/jpeg")
      .send(bytes);
  });

  // --- admin -----------------------------------------------------------------------
  const PendingPhoto = z.object({
    user: z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int(), kycStatus: z.string().nullable() }),
    submittedAt: z.date(),
    pendingUrl: z.string(),
    currentUrl: z.string().nullable(),
    hasSelfie: z.boolean().describe("KYC selfie to compare: GET /admin/kyc/:userId/files/selfie"),
  }).meta({ id: "PendingPhoto" });

  app.get("/admin/photos", {
    preHandler: can("kyc.review"),
    schema: { tags: ["admin"], security: bearer, summary: "Companion photos waiting for review, oldest first", response: { 200: z.array(PendingPhoto) } },
  }, async () => (await db.query<{ id: string; display_name: string; avatar_id: number; kyc_status: string | null; submitted: Date;
    version: number; has_current: boolean; has_selfie: boolean }>(
    `SELECT u.id, u.display_name, u.avatar_id, p.kyc_status, u.photo_submitted_at AS submitted, u.photo_version AS version,
            u.photo_key IS NOT NULL AS has_current,
            EXISTS (SELECT 1 FROM kyc_documents d WHERE d.user_id = u.id AND d.doc_type = 'selfie') AS has_selfie
       FROM users u LEFT JOIN companion_profiles p ON p.user_id = u.id
      WHERE u.photo_status = 'pending' AND u.photo_pending_key IS NOT NULL
      ORDER BY u.photo_submitted_at`)).rows.map((r) => ({
    user: { id: r.id, displayName: r.display_name, avatarId: r.avatar_id, kycStatus: r.kyc_status },
    submittedAt: r.submitted,
    pendingUrl: photoUrl(kycKey, r.id, r.version, "pending")!,
    currentUrl: r.has_current ? photoUrl(kycKey, r.id, r.version) : null,
    hasSelfie: r.has_selfie,
  })));

  app.post("/admin/photos/:userId/decision", {
    preHandler: can("kyc.review"),
    schema: {
      tags: ["admin"], security: bearer,
      summary: "Approve (it replaces their avatar everywhere) or reject with a reason they'll see",
      params: z.object({ userId: z.uuid() }),
      body: z.object({ decision: z.enum(["approve", "reject"]), reason: z.string().trim().max(300).nullish() }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { userId } = req.params;
    const { decision, reason } = req.body;
    if (decision === "reject" && (!reason || reason.length < 3)) throw new ApiError(400, "REASON_REQUIRED", "Say why, so they can fix it");
    const done = await tx(db, async (c) => {
      const r = (await c.query<{ photo_key: string | null; photo_pending_key: string | null }>(
        `SELECT photo_key, photo_pending_key FROM users WHERE id = $1 AND photo_status = 'pending' FOR UPDATE`, [userId])).rows[0];
      if (!r?.photo_pending_key) throw notFound("NO_PHOTO_PENDING");
      if (decision === "approve") {
        await c.query(
          `UPDATE users SET photo_key = photo_pending_key, photo_pending_key = NULL, photo_status = 'approved',
                            photo_reject_reason = NULL, photo_version = photo_version + 1 WHERE id = $1`, [userId]);
      } else {
        await c.query(
          `UPDATE users SET photo_pending_key = NULL, photo_reject_reason = $2,
                            photo_status = CASE WHEN photo_key IS NOT NULL THEN 'approved' ELSE 'rejected' END,
                            photo_version = photo_version + 1 WHERE id = $1`, [userId, reason]);
      }
      await c.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, $2, 'user', $3, $4)`,
        [me(req).userId, `photo.${decision}`, userId, JSON.stringify({ reason: reason ?? null })]);
      return r;
    });
    // Approve: the old photo goes. Reject: the rejected upload goes.
    const gone = decision === "approve" ? done.photo_key : done.photo_pending_key;
    if (gone) await store.delete(gone).catch(() => {});
    await notify(app.deps, userId, decision === "approve"
      ? { type: "photo_decided", title: "Your photo is live", body: "Callers now see your photo instead of your avatar." }
      : { type: "photo_decided", title: "Photo not approved", body: reason ?? "Please upload a different photo." });
    return reply.status(204).send(null);
  });
};
