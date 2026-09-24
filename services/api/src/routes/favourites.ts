import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { Redis } from "ioredis";
import type { Db } from "../db/pool.js";
import type { UserEvents } from "../billing/ports.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, notFound } from "../errors.js";
import { busySet } from "../presence.js";
import { ONLINE_SET } from "../billing/engine.js";
import { CompanionRates } from "./companions.js";
import { notify } from "../notifications.js";
import type { PushSender } from "../push.js";
import { PHOTO_V_SQL, photoUrl } from "./photos.js";

const NOTIFY_COOLDOWN_S = 30 * 60;

const Favourite = z.object({
  id: z.uuid(), displayName: z.string(), avatarId: z.number().int(), photoUrl: z.string().nullable().describe("Approved profile photo (signed URL path); null = show the avatar"),
  languages: z.array(z.string()),
  online: z.boolean(), busy: z.boolean(), lastOnlineAt: z.date().nullable(), notify: z.boolean(),
  audioEnabled: z.boolean(),
  videoEnabled: z.boolean(),
  rates: CompanionRates,
}).meta({ id: "Favourite" });

/**
 * A companion just came online: tell the callers who favourited them (with the
 * bell on), at most once per 30 minutes each. Reaching closed apps needs FCM.
 */
export async function notifyFavouritesOnline(db: Db, redis: Redis, events: UserEvents, companionId: string, push?: PushSender): Promise<number> {
  const companion = (await db.query<{ display_name: string; avatar_id: number }>(
    `SELECT display_name, avatar_id FROM users WHERE id = $1`, [companionId])).rows[0];
  if (!companion) return 0;
  const fans = (await db.query<{ user_id: string }>(
    `SELECT f.user_id FROM favourites f JOIN users u ON u.id = f.user_id
      WHERE f.companion_id = $1 AND f.notify AND u.status = 'active'
        AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = f.user_id AND b.blocked_id = $1)
                                                  OR (b.blocker_id = $1 AND b.blocked_id = f.user_id))`,
    [companionId])).rows;
  let sent = 0;
  for (const { user_id } of fans) {
    const fresh = await redis.set(`fav:notified:${user_id}:${companionId}`, "1", "EX", NOTIFY_COOLDOWN_S, "NX");
    if (!fresh) continue;
    await events.publish(user_id, {
      t: "favourite_online",
      companion: { id: companionId, displayName: companion.display_name, avatarId: companion.avatar_id },
    });
    if (push) {
      await notify({ db, push, events }, user_id, {
        type: "favourite_online", title: `${companion.display_name} is online now`, body: "From your favourites · tap to call",
        data: { companionId },
      });
    }
    sent++;
  }
  return sent;
}

export const favouriteRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis } = app.deps;
  const base = { tags: ["favourites"], security: bearer };

  app.get("/favourites", {
    preHandler: requireAuth(),
    schema: { ...base, summary: "My favourite companions, free ones first", response: { 200: z.array(Favourite) } },
  }, async (req) => {
    const rows = (await db.query<{
      id: string; display_name: string; avatar_id: number; photo_v: number | null; languages: string[]; last_online_at: Date | null; notify: boolean;
      video_enabled: boolean; takes_audio: boolean; audio: number | null; video: number | null;
    }>(
      `SELECT u.id, u.display_name, u.avatar_id, ${PHOTO_V_SQL("u")} AS photo_v, f.notify, p.last_online_at, p.video_enabled AND p.takes_video AS video_enabled, p.takes_audio,
              COALESCE((SELECT array_agg(language_code ORDER BY language_code) FROM user_languages WHERE user_id = u.id), ARRAY[u.primary_language]) AS languages,
              (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'audio' AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS audio,
              (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'video' AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS video
         FROM favourites f JOIN users u ON u.id = f.companion_id JOIN companion_profiles p ON p.user_id = u.id
        WHERE f.user_id = $1 AND u.status = 'active' AND p.kyc_status = 'approved'
        ORDER BY f.created_at DESC`, [me(req).userId])).rows;
    const online = new Set(await redis.smembers(ONLINE_SET));
    const busy = await busySet(redis, rows.map((r) => r.id));
    return rows
      .map((r) => ({
        id: r.id, displayName: r.display_name, avatarId: r.avatar_id, photoUrl: photoUrl(app.deps.kycKey, r.id, r.photo_v), languages: r.languages,
        online: online.has(r.id), busy: busy.has(r.id), lastOnlineAt: r.last_online_at, notify: r.notify,
        audioEnabled: r.takes_audio, videoEnabled: r.video_enabled,
        rates: { audioCoinsPerMin: r.takes_audio ? r.audio : null, videoCoinsPerMin: r.video_enabled ? r.video : null },
      }))
      .sort((a, b) => Number(b.online && !b.busy) - Number(a.online && !a.busy) || Number(b.online) - Number(a.online));
  });

  app.put("/favourites/:companionId", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Add (or update) a favourite. notify = alert me when they come online.",
      params: z.object({ companionId: z.uuid() }),
      body: z.object({ notify: z.boolean().nullish() }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    if (req.params.companionId === userId) throw new ApiError(400, "CANNOT_TARGET_SELF");
    const ok = await db.query(`SELECT 1 FROM users WHERE id = $1 AND role = 'companion'`, [req.params.companionId]);
    if (!ok.rowCount) throw notFound("COMPANION_NOT_FOUND");
    await db.query(
      `INSERT INTO favourites (user_id, companion_id, notify) VALUES ($1, $2, COALESCE($3, true))
       ON CONFLICT (user_id, companion_id) DO UPDATE SET notify = COALESCE($3, favourites.notify)`,
      [userId, req.params.companionId, req.body.notify ?? null]);
    return reply.status(204).send(null);
  });

  app.delete("/favourites/:companionId", {
    preHandler: requireAuth(),
    schema: { ...base, params: z.object({ companionId: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    await db.query(`DELETE FROM favourites WHERE user_id = $1 AND companion_id = $2`, [me(req).userId, req.params.companionId]);
    return reply.status(204).send(null);
  });
};
