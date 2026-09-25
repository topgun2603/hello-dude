import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { AppDeps } from "../app.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError } from "../errors.js";
import { ONLINE_SET } from "../billing/engine.js";
import { busySet, goOffline, goOnline, isOnline } from "../presence.js";
import { notifyFavouritesOnline } from "./favourites.js";
import { countOnlineMinute } from "../rewards.js";
import { LanguageCode } from "./profile.js";
import { PHOTO_V_SQL, photoUrl } from "./photos.js";
import { Badge, activeBadges } from "./leaderboards.js";

/** Current per-minute prices for one companion (their primary language sets them). */
export const CompanionRates = z.object({
  audioCoinsPerMin: z.number().int().nullable(),
  videoCoinsPerMin: z.number().int().nullable(),
}).meta({ id: "CompanionRates" });

export const OnlineCompanion = z.object({
  id: z.uuid(),
  displayName: z.string(),
  avatarId: z.number().int(),
  photoUrl: z.string().nullable().describe("Approved profile photo (signed URL path); null = show the avatar"),
  primaryLanguage: z.string(),
  languages: z.array(z.string()),
  rating: z.number().nullable().describe("Average stars, null until rated"),
  ratingCount: z.number().int(),
  audioEnabled: z.boolean().describe("Takes voice calls right now"),
  videoEnabled: z.boolean().describe("Takes video calls right now (unlocked and switched on)"),
  busy: z.boolean(),
  isFavourite: z.boolean(),
  rates: CompanionRates,
  badge: Badge.nullable().describe("Best active badge, e.g. '#1 companion this week'"),
}).meta({ id: "OnlineCompanion" });
export type OnlineCompanion = z.infer<typeof OnlineCompanion>;

/**
 * Online, KYC-approved companions who speak `language` and have no block with
 * `viewerId`, with each one's current per-minute rates (their primary language
 * sets the price). Free companions first, then by rating.
 */
export async function findOnlineCompanions(
  deps: Pick<AppDeps, "db" | "redis" | "kycKey">,
  viewerId: string,
  /** null = any language (Random). */
  language: string | null,
  opts: { video?: boolean } = {},
): Promise<OnlineCompanion[]> {
  const { db, redis } = deps;
  const online = await redis.smembers(ONLINE_SET);
  if (!online.length) return [];

  const rows = (await db.query<{
    id: string; display_name: string; avatar_id: number; photo_v: number | null; primary_language: string; languages: string[];
    rating_sum: number; rating_count: number; video_enabled: boolean; takes_audio: boolean; audio: number | null; video: number | null;
    fav: boolean;
  }>(
    `SELECT u.id, u.display_name, u.avatar_id, ${PHOTO_V_SQL("u")} AS photo_v, u.primary_language,
            COALESCE((SELECT array_agg(language_code ORDER BY language_code) FROM user_languages WHERE user_id = u.id),
                     ARRAY[u.primary_language]) AS languages,
            p.rating_sum, p.rating_count, p.video_enabled AND p.takes_video AS video_enabled, p.takes_audio,
            EXISTS (SELECT 1 FROM favourites f WHERE f.user_id = $2 AND f.companion_id = u.id) AS fav,
            (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'audio'
               AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS audio,
            (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'video'
               AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS video
       FROM users u JOIN companion_profiles p ON p.user_id = u.id
      WHERE u.id = ANY($1::uuid[]) AND u.id <> $2
        AND u.role = 'companion' AND u.status = 'active' AND p.kyc_status = 'approved'
        AND ($3::text IS NULL OR $3 = u.primary_language
             OR EXISTS (SELECT 1 FROM user_languages l WHERE l.user_id = u.id AND l.language_code = $3))
        -- $4: null = any; true = takes video now; false = takes voice now
        AND ($4::boolean IS NULL OR CASE WHEN $4 THEN p.video_enabled AND p.takes_video ELSE p.takes_audio END)
        AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = $2 AND b.blocked_id = u.id)
                                                  OR (b.blocker_id = u.id AND b.blocked_id = $2))`,
    [online, viewerId, language, opts.video ?? null],
  )).rows;

  const busy = await busySet(redis, rows.map((r) => r.id));
  const badges = await activeBadges(db, rows.map((r) => r.id));
  return rows
    .map((r) => ({
      badge: badges.get(r.id) ?? null,
      id: r.id,
      displayName: r.display_name,
      avatarId: r.avatar_id,
      photoUrl: photoUrl(deps.kycKey, r.id, r.photo_v),
      primaryLanguage: r.primary_language,
      languages: r.languages,
      rating: r.rating_count ? Math.round((r.rating_sum / r.rating_count) * 10) / 10 : null,
      ratingCount: r.rating_count,
      audioEnabled: r.takes_audio,
      videoEnabled: r.video_enabled,
      busy: busy.has(r.id),
      isFavourite: r.fav,
      rates: { audioCoinsPerMin: r.takes_audio ? r.audio : null, videoCoinsPerMin: r.video_enabled ? r.video : null },
    }))
    .sort((a, b) => Number(a.busy) - Number(b.busy) || (b.rating ?? 0) - (a.rating ?? 0));
}

export const companionRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis } = app.deps;

  app.get("/companions/online", {
    preHandler: requireAuth(),
    schema: {
      tags: ["companions"],
      security: bearer,
      summary: "Who is online now: in one language (Home), or everyone when language is left out (Online tab)",
      querystring: z.object({ language: LanguageCode.optional() }),
      response: { 200: z.object({ companions: z.array(OnlineCompanion) }) },
    },
  }, async (req) => ({ companions: await findOnlineCompanions(app.deps, me(req).userId, req.query.language ?? null) }));

  app.get("/companions/:id", {
    preHandler: requireAuth(),
    schema: {
      tags: ["companions"],
      security: bearer,
      summary: "One companion with current rates (for Call buttons outside the home list, e.g. chat)",
      params: z.object({ id: z.uuid() }),
      response: { 200: z.object({ companion: OnlineCompanion, online: z.boolean() }) },
    },
  }, async (req) => {
    const viewer = me(req).userId;
    const r = (await db.query<{
      id: string; display_name: string; avatar_id: number; photo_v: number | null; primary_language: string; languages: string[];
      rating_sum: number; rating_count: number; video_enabled: boolean; takes_audio: boolean; audio: number | null; video: number | null; fav: boolean;
    }>(
      `SELECT u.id, u.display_name, u.avatar_id, ${PHOTO_V_SQL("u")} AS photo_v, u.primary_language,
              COALESCE((SELECT array_agg(language_code ORDER BY language_code) FROM user_languages WHERE user_id = u.id),
                       ARRAY[u.primary_language]) AS languages,
              p.rating_sum, p.rating_count, p.video_enabled AND p.takes_video AS video_enabled, p.takes_audio,
              EXISTS (SELECT 1 FROM favourites f WHERE f.user_id = $2 AND f.companion_id = u.id) AS fav,
              (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'audio'
                 AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS audio,
              (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'video'
                 AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS video
         FROM users u JOIN companion_profiles p ON p.user_id = u.id
        WHERE u.id = $1 AND u.role = 'companion' AND u.status = 'active' AND p.kyc_status = 'approved'
          AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = $2 AND b.blocked_id = u.id)
                                                    OR (b.blocker_id = u.id AND b.blocked_id = $2))`,
      [req.params.id, viewer])).rows[0];
    if (!r) throw new ApiError(404, "COMPANION_NOT_FOUND", "This companion isn't available");
    const busy = await busySet(redis, [r.id]);
    const badge = (await activeBadges(db, [r.id])).get(r.id) ?? null;
    return {
      online: await isOnline(redis, r.id),
      companion: {
        badge,
        id: r.id, displayName: r.display_name, avatarId: r.avatar_id, photoUrl: photoUrl(app.deps.kycKey, r.id, r.photo_v),
        primaryLanguage: r.primary_language, languages: r.languages,
        rating: r.rating_count ? Math.round((r.rating_sum / r.rating_count) * 10) / 10 : null, ratingCount: r.rating_count,
        audioEnabled: r.takes_audio, videoEnabled: r.video_enabled, busy: busy.has(r.id), isFavourite: r.fav,
        rates: { audioCoinsPerMin: r.takes_audio ? r.audio : null, videoCoinsPerMin: r.video_enabled ? r.video : null },
      },
    };
  });

  app.post("/companion/presence", {
    preHandler: requireAuth("companion"),
    schema: {
      tags: ["companion"],
      security: bearer,
      summary: "Go online / offline. While online, call again every 60 s as a heartbeat.",
      body: z.object({ online: z.boolean() }),
      response: { 200: z.object({ online: z.boolean() }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    if (!req.body.online) {
      await goOffline(redis, userId);
      await db.query(`UPDATE companion_profiles SET last_online_at = now() WHERE user_id = $1`, [userId]);
      return { online: false };
    }
    const ok = (await db.query(
      `SELECT 1 FROM users u JOIN companion_profiles p ON p.user_id = u.id
        WHERE u.id = $1 AND u.status = 'active' AND p.kyc_status = 'approved'`, [userId],
    )).rowCount;
    if (!ok) throw new ApiError(403, "KYC_NOT_APPROVED", "Finish verification before going online");
    const wasOnline = await isOnline(redis, userId);
    await goOnline(redis, userId);
    await countOnlineMinute(db, redis, userId);
    await db.query(`UPDATE companion_profiles SET last_online_at = now() WHERE user_id = $1`, [userId]);
    if (!wasOnline) await notifyFavouritesOnline(db, redis, app.deps.events, userId, app.deps.push);
    return { online: true };
  });
};
