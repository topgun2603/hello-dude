import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { AppDeps } from "../app.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError } from "../errors.js";
import { ONLINE_SET } from "../billing/engine.js";
import { busySet, goOffline, goOnline, isOnline } from "../presence.js";
import { notifyFavouritesOnline } from "./favourites.js";
import { LanguageCode } from "./profile.js";

/** Current per-minute prices for one companion (their primary language sets them). */
export const CompanionRates = z.object({
  audioCoinsPerMin: z.number().int().nullable(),
  videoCoinsPerMin: z.number().int().nullable(),
}).meta({ id: "CompanionRates" });

export const OnlineCompanion = z.object({
  id: z.uuid(),
  displayName: z.string(),
  avatarId: z.number().int(),
  primaryLanguage: z.string(),
  languages: z.array(z.string()),
  rating: z.number().nullable().describe("Average stars, null until rated"),
  ratingCount: z.number().int(),
  videoEnabled: z.boolean(),
  busy: z.boolean(),
  isFavourite: z.boolean(),
  rates: CompanionRates,
}).meta({ id: "OnlineCompanion" });
export type OnlineCompanion = z.infer<typeof OnlineCompanion>;

/**
 * Online, KYC-approved companions who speak `language` and have no block with
 * `viewerId`, with each one's current per-minute rates (their primary language
 * sets the price). Free companions first, then by rating.
 */
export async function findOnlineCompanions(
  deps: Pick<AppDeps, "db" | "redis">,
  viewerId: string,
  language: string,
  opts: { video?: boolean } = {},
): Promise<OnlineCompanion[]> {
  const { db, redis } = deps;
  const online = await redis.smembers(ONLINE_SET);
  if (!online.length) return [];

  const rows = (await db.query<{
    id: string; display_name: string; avatar_id: number; primary_language: string; languages: string[];
    rating_sum: number; rating_count: number; video_enabled: boolean; audio: number | null; video: number | null;
    fav: boolean;
  }>(
    `SELECT u.id, u.display_name, u.avatar_id, u.primary_language,
            COALESCE((SELECT array_agg(language_code ORDER BY language_code) FROM user_languages WHERE user_id = u.id),
                     ARRAY[u.primary_language]) AS languages,
            p.rating_sum, p.rating_count, p.video_enabled,
            EXISTS (SELECT 1 FROM favourites f WHERE f.user_id = $2 AND f.companion_id = u.id) AS fav,
            (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'audio'
               AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS audio,
            (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = 'video'
               AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS video
       FROM users u JOIN companion_profiles p ON p.user_id = u.id
      WHERE u.id = ANY($1::uuid[]) AND u.id <> $2
        AND u.role = 'companion' AND u.status = 'active' AND p.kyc_status = 'approved'
        AND ($3 = u.primary_language OR EXISTS (SELECT 1 FROM user_languages l WHERE l.user_id = u.id AND l.language_code = $3))
        AND ($4::boolean IS NOT TRUE OR p.video_enabled)
        AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = $2 AND b.blocked_id = u.id)
                                                  OR (b.blocker_id = u.id AND b.blocked_id = $2))`,
    [online, viewerId, language, opts.video ?? null],
  )).rows;

  const busy = await busySet(redis, rows.map((r) => r.id));
  return rows
    .map((r) => ({
      id: r.id,
      displayName: r.display_name,
      avatarId: r.avatar_id,
      primaryLanguage: r.primary_language,
      languages: r.languages,
      rating: r.rating_count ? Math.round((r.rating_sum / r.rating_count) * 10) / 10 : null,
      ratingCount: r.rating_count,
      videoEnabled: r.video_enabled,
      busy: busy.has(r.id),
      isFavourite: r.fav,
      rates: { audioCoinsPerMin: r.audio, videoCoinsPerMin: r.video_enabled ? r.video : null },
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
      summary: "Home screen: who is online now in a language",
      querystring: z.object({ language: LanguageCode }),
      response: { 200: z.object({ companions: z.array(OnlineCompanion) }) },
    },
  }, async (req) => ({ companions: await findOnlineCompanions(app.deps, me(req).userId, req.query.language) }));

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
      id: string; display_name: string; avatar_id: number; primary_language: string; languages: string[];
      rating_sum: number; rating_count: number; video_enabled: boolean; audio: number | null; video: number | null; fav: boolean;
    }>(
      `SELECT u.id, u.display_name, u.avatar_id, u.primary_language,
              COALESCE((SELECT array_agg(language_code ORDER BY language_code) FROM user_languages WHERE user_id = u.id),
                       ARRAY[u.primary_language]) AS languages,
              p.rating_sum, p.rating_count, p.video_enabled,
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
    return {
      online: await isOnline(redis, r.id),
      companion: {
        id: r.id, displayName: r.display_name, avatarId: r.avatar_id, primaryLanguage: r.primary_language, languages: r.languages,
        rating: r.rating_count ? Math.round((r.rating_sum / r.rating_count) * 10) / 10 : null, ratingCount: r.rating_count,
        videoEnabled: r.video_enabled, busy: busy.has(r.id), isFavourite: r.fav,
        rates: { audioCoinsPerMin: r.audio, videoCoinsPerMin: r.video_enabled ? r.video : null },
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
    await db.query(`UPDATE companion_profiles SET last_online_at = now() WHERE user_id = $1`, [userId]);
    if (!wasOnline) await notifyFavouritesOnline(db, redis, app.deps.events, userId, app.deps.push);
    return { online: true };
  });
};
