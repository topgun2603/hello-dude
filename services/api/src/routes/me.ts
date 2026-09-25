import { createHash } from "node:crypto";
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError } from "../errors.js";
import { assertLanguagesActive, LanguageCode, loadProfile, Profile } from "./profile.js";

/** The raw ANDROID_ID never reaches the database. */
export const deviceHash = (deviceId: string) => createHash("sha256").update(`hd-device:${deviceId}`).digest("hex");

export const meRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;

  app.get("/languages", {
    schema: {
      tags: ["profile"],
      summary: "Languages users can pick",
      response: { 200: z.array(z.object({ code: z.string(), name: z.string() })) },
    },
  }, async () => (await db.query<{ code: string; name: string }>(
    `SELECT code, name FROM languages WHERE is_active ORDER BY array_position(
       ARRAY['ta','te','kn','ml','hi','bn','mr','en'], code), code`,
  )).rows);

  app.get("/me", {
    preHandler: requireAuth(),
    schema: { tags: ["profile"], security: bearer, response: { 200: Profile } },
  }, async (req) => loadProfile(db, me(req).userId));

  app.patch("/me", {
    preHandler: requireAuth(),
    schema: {
      tags: ["profile"],
      security: bearer,
      summary: "Update name, avatar or languages (primary language must be in `languages`)",
      body: z.object({
        // nullish: generated clients send null for fields they are not changing.
        displayName: z.string().trim().min(1).max(30).nullish(),
        avatarId: z.number().int().min(1).max(50).nullish(),
        primaryLanguage: LanguageCode.nullish(),
        languages: z.array(LanguageCode).max(8).nullish().describe("Leave empty to keep the current languages"),
      }),
      response: { 200: Profile },
    },
  }, async (req) => {
    const { userId } = me(req);
    const b = req.body;
    await tx(db, async (c) => {
      const current = await loadProfile(c, userId);
      const primary = b.primaryLanguage ?? current.primaryLanguage;
      // Generated clients send [] for "not changing"; only a non-empty list replaces them.
      const languages = [...new Set(b.languages?.length ? b.languages : current.languages)];
      if (!languages.includes(primary)) languages.push(primary);
      await assertLanguagesActive(c, languages);
      // Companions are matched by primary language; changing it re-prices their calls,
      // so it goes through admin review instead.
      if (current.role === "companion" && primary !== current.primaryLanguage) {
        throw new ApiError(403, "COMPANION_LANGUAGE_LOCKED", "Ask support to change your main language");
      }
      await c.query(
        `UPDATE users SET display_name = COALESCE($2, display_name), avatar_id = COALESCE($3, avatar_id),
                primary_language = $4 WHERE id = $1`,
        [userId, b.displayName ?? null, b.avatarId ?? null, primary],
      );
      await c.query(`DELETE FROM user_languages WHERE user_id = $1`, [userId]);
      await c.query(
        `INSERT INTO user_languages (user_id, language_code) SELECT $1, unnest($2::text[])`,
        [userId, languages],
      );
    });
    return loadProfile(db, userId);
  });

  app.put("/devices", {
    preHandler: requireAuth(),
    schema: {
      tags: ["profile"],
      security: bearer,
      summary: "Register this phone's FCM token for call and message pushes (and its id, for the shared-phone fraud check)",
      body: z.object({
        fcmToken: z.string().min(20).max(4096),
        deviceId: z.string().min(4).max(256).optional().describe("Android ANDROID_ID; stored only as a hash"),
      }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    await db.query(
      `INSERT INTO devices (fcm_token, user_id) VALUES ($1, $2)
       ON CONFLICT (fcm_token) DO UPDATE SET user_id = EXCLUDED.user_id, updated_at = now()`,
      [req.body.fcmToken, me(req).userId],
    );
    if (req.body.deviceId) {
      await db.query(
        `INSERT INTO device_accounts (device_hash, user_id) VALUES ($1, $2)
         ON CONFLICT (device_hash, user_id) DO UPDATE SET last_seen = now()`,
        [deviceHash(req.body.deviceId), me(req).userId],
      );
    }
    return reply.status(204).send(null);
  });
};
