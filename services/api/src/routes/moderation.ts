/**
 * Video moderation. The app checks the other person's video on the phone every
 * few seconds (on-device model; video never leaves the phone for this). When a
 * frame looks like nudity it blurs the video at once and sends that one frame
 * here for a human to review in the admin Moderation queue.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, forbidden, notFound } from "../errors.js";
import { base64File } from "./companion.js";

const MAX_FRAME_BYTES = 400 * 1024;
/** At most one frame per person per call in this window; the blur itself is instant on the phone. */
const FLAG_COOLDOWN_S = 30;
/** Frames can still arrive a little after hang-up (slow network). */
const LATE_GRACE_S = 120;

export const moderationRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, store } = app.deps;

  app.post("/calls/:id/moderation", {
    preHandler: requireAuth("caller", "companion"),
    bodyLimit: 1024 * 1024,
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Report a video frame the app's on-device check flagged as nudity (own camera, or the other person's video)",
      params: z.object({ id: z.uuid() }),
      body: z.object({
        frameBase64: base64File(MAX_FRAME_BYTES).describe("JPEG of the flagged frame, at most 400 KB"),
        score: z.number().min(0).max(1).describe("On-device model confidence"),
        own: z.boolean().optional().describe("true = the frame is from the sender's own camera (the app checks its own video)"),
      }),
      response: {
        201: z.object({ accepted: z.literal(true) }),
        202: z.object({ accepted: z.literal(false) }).describe("A frame from this call was sent moments ago; this one is not stored"),
      },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const call = (await db.query<{ caller_id: string; companion_id: string; type: string; status: string; ended_ago: number | null }>(
      `SELECT caller_id, companion_id, type, status, EXTRACT(EPOCH FROM (now() - ended_at))::int AS ended_ago
         FROM calls WHERE id = $1`, [req.params.id])).rows[0];
    if (!call) throw notFound("CALL_NOT_FOUND");
    if (call.caller_id !== userId && call.companion_id !== userId) throw forbidden("NOT_YOUR_CALL");
    if (call.type !== "video") throw new ApiError(400, "NOT_A_VIDEO_CALL", "Only video calls are checked");
    const live = call.status === "active" || (call.status === "ended" && (call.ended_ago ?? Infinity) <= LATE_GRACE_S);
    if (!live) throw new ApiError(400, "CALL_NOT_ACTIVE", "This call is over");
    const b = req.body.frameBase64;
    if (!(b[0] === 0xff && b[1] === 0xd8)) throw new ApiError(400, "NOT_A_JPEG", "The frame must be a JPEG");

    const first = await redis.set(`mod:${req.params.id}:${userId}`, "1", "EX", FLAG_COOLDOWN_S, "NX");
    if (!first) return reply.status(202).send({ accepted: false });

    const subject = req.body.own ? userId : call.caller_id === userId ? call.companion_id : call.caller_id;
    const id = (await db.query<{ id: string }>(`SELECT gen_random_uuid() AS id`)).rows[0]!.id;
    const key = `moderation/${id}`;
    await store.put(key, b);
    await db.query(
      `INSERT INTO moderation_flags (id, call_id, subject_id, detected_by, score, storage_key) VALUES ($1, $2, $3, $4, $5, $6)`,
      [id, req.params.id, subject, userId, req.body.score, key]);
    return reply.status(201).send({ accepted: true });
  });
};
