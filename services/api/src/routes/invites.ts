/**
 * Callers online, for companions (owner, 2026-09-24): every caller with the app
 * open, with what helps her choose (can pay, VIP, new, calls with her, favourited
 * her). She can't call him — she sends an invite ("Priya wants to talk") and he
 * decides and starts the call, so billing is unchanged. Limits keep it from
 * becoming spam: she must be online to invite; one invite per caller per hour;
 * a cap per companion per hour and per caller per hour.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, conflict, notFound } from "../errors.js";
import { notify } from "../notifications.js";
import { busySet, inAppIds, isOnline } from "../presence.js";
import { numberSetting } from "../settings.js";
import { PHOTO_V_SQL, photoUrl } from "./photos.js";
import { Badge, activeBadges } from "./leaderboards.js";

const INVITE_AGAIN_S = 3600;
const inviteKey = (companionId: string, callerId: string) => `invite:${companionId}:${callerId}`;

const OnlineCaller = z.object({
  id: z.uuid(),
  displayName: z.string(),
  avatarId: z.number().int(),
  language: z.string(),
  canPay: z.boolean().describe("Has coins for a few minutes of a voice call with you"),
  isVip: z.boolean(),
  isNew: z.boolean().describe("Joined in the last 7 days"),
  inCall: z.boolean(),
  callsWithYou: z.number().int(),
  lastCallAt: z.date().nullable(),
  favouritedYou: z.boolean(),
  invitedRecently: z.boolean().describe("You invited him in the last hour"),
  level: z.number().int().describe("Caller level (lifetime coins spent)"),
  levelName: z.string(),
  badge: Badge.nullable().describe("Best active badge, e.g. '#2 fan this week'"),
}).meta({ id: "OnlineCaller" });

export const inviteRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, events } = app.deps;
  const base = { tags: ["companion"], security: bearer };
  const companion = requireAuth("companion");

  app.get("/companion/callers", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Callers with the app open now: your regulars and fans first",
      response: { 200: z.object({ callers: z.array(OnlineCaller), canInvite: z.boolean().describe("You're online and free") }) },
    },
  }, async (req) => {
    const meId = me(req).userId;
    const ids = await inAppIds(redis);
    const rows = ids.length ? (await db.query<{
      id: string; display_name: string; avatar_id: number; primary_language: string; is_new: boolean; vip: boolean;
      balance: number; calls: number; last_call: Date | null; fav: boolean; in_call: boolean; level: number; level_name: string;
    }>(
      `SELECT u.id, u.display_name, u.avatar_id, u.primary_language, u.created_at > now() - interval '7 days' AS is_new,
              lv.level, lv.name AS level_name,
              EXISTS (SELECT 1 FROM vip_subscriptions v WHERE v.user_id = u.id AND v.cancelled_at IS NULL
                        AND v.starts_at <= now() AND v.expires_at > now()) AS vip,
              COALESCE(w.balance, 0) AS balance,
              (SELECT count(*) FROM calls c WHERE c.caller_id = u.id AND c.companion_id = $1 AND c.started_at IS NOT NULL)::int AS calls,
              (SELECT max(c.started_at) FROM calls c WHERE c.caller_id = u.id AND c.companion_id = $1) AS last_call,
              EXISTS (SELECT 1 FROM favourites f WHERE f.user_id = u.id AND f.companion_id = $1) AS fav,
              EXISTS (SELECT 1 FROM calls c WHERE c.caller_id = u.id AND c.status IN ('ringing', 'active')) AS in_call
         FROM users u LEFT JOIN wallets w ON w.user_id = u.id AND w.kind = 'coins'
         CROSS JOIN LATERAL (SELECT level, name FROM caller_levels WHERE min_coins <= u.coins_spent ORDER BY level DESC LIMIT 1) lv
        WHERE u.id = ANY($2::uuid[]) AND u.role = 'caller' AND u.status = 'active'
          AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = $1 AND b.blocked_id = u.id) OR (b.blocker_id = u.id AND b.blocked_id = $1))
        LIMIT 500`, [meId, ids])).rows : [];

    // "Can pay" = a few minutes of a voice call at her rate.
    const rate = (await db.query<{ coins: number }>(
      `SELECT coins_per_min AS coins FROM call_rates
        WHERE language_code = (SELECT primary_language FROM users WHERE id = $1) AND call_type = 'audio' AND effective_from <= now()
        ORDER BY effective_from DESC LIMIT 1`, [meId])).rows[0]?.coins ?? 10;
    const minutes = await numberSetting(db, "invite.can_pay_minutes", 3);
    const badges = await activeBadges(db, rows.map((r) => r.id));
    const invited = rows.length
      ? await redis.pipeline(rows.map((r) => ["exists", inviteKey(meId, r.id)])).exec()
      : [];
    const callers = rows.map((r, i) => ({
      id: r.id, displayName: r.display_name, avatarId: r.avatar_id, language: r.primary_language,
      canPay: r.balance >= rate * minutes, isVip: r.vip, isNew: r.is_new, inCall: r.in_call,
      callsWithYou: r.calls, lastCallAt: r.last_call, favouritedYou: r.fav,
      invitedRecently: invited?.[i]?.[1] === 1,
      level: r.level, levelName: r.level_name, badge: badges.get(r.id) ?? null,
    })).sort((a, b) =>
      Number(b.favouritedYou) - Number(a.favouritedYou) || b.callsWithYou - a.callsWithYou ||
      Number(b.isVip) - Number(a.isVip) || Number(b.canPay) - Number(a.canPay) ||
      Number(a.inCall) - Number(b.inCall) || a.displayName.localeCompare(b.displayName));
    const canInvite = (await isOnline(redis, meId)) && !(await busySet(redis, [meId])).has(meId);
    return { callers, canInvite };
  });

  app.post("/companion/invites", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Invite a caller to call you (he gets 'X wants to talk' and starts the call himself). You must be online; " +
        "one invite per caller per hour; a few per hour in total.",
      body: z.object({ callerId: z.uuid() }),
      response: { 201: z.object({ invitedUntil: z.date() }) },
    },
  }, async (req, reply) => {
    const meId = me(req).userId;
    const { callerId } = req.body;
    if (!(await isOnline(redis, meId))) throw new ApiError(409, "GO_ONLINE", "Go online first — he can only call you while you're online");
    if ((await busySet(redis, [meId])).has(meId)) throw conflict("IN_A_CALL", "Finish your call first");
    const caller = (await db.query<{ ok: boolean }>(
      `SELECT (role = 'caller' AND status = 'active') AS ok FROM users WHERE id = $1`, [callerId])).rows[0];
    if (!caller?.ok) throw notFound("CALLER_NOT_FOUND");
    if ((await db.query(`SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`,
      [meId, callerId])).rowCount) throw new ApiError(403, "BLOCKED", "You can't invite this person");

    const [perCompanion, perCaller] = await Promise.all([
      numberSetting(db, "invite.per_companion_hour", 30), numberSetting(db, "invite.per_caller_hour", 5),
    ]);
    if (!(await redis.set(inviteKey(meId, callerId), "1", "EX", INVITE_AGAIN_S, "NX"))) {
      throw new ApiError(429, "INVITED_RECENTLY", "You already invited him — you can invite again in an hour");
    }
    const hour = Math.floor(Date.now() / 3_600_000);
    const count = async (key: string) => {
      const n = await redis.incr(key);
      if (n === 1) await redis.expire(key, 3600);
      return n;
    };
    if ((await count(`invites:by:${meId}:${hour}`)) > perCompanion) {
      await redis.del(inviteKey(meId, callerId));
      throw new ApiError(429, "INVITE_LIMIT", `You can send ${perCompanion} invites an hour`);
    }
    if ((await count(`invites:to:${callerId}:${hour}`)) > perCaller) {
      await redis.del(inviteKey(meId, callerId));
      throw new ApiError(429, "CALLER_BUSY_WITH_INVITES", "He has had a lot of invites this hour — try later");
    }

    const c = (await db.query<{ display_name: string; avatar_id: number; photo_v: number | null }>(
      `SELECT display_name, avatar_id, ${PHOTO_V_SQL("u")} AS photo_v FROM users u WHERE id = $1`, [meId])).rows[0]!;
    await events.publish(callerId, {
      t: "call_invite",
      companion: { id: meId, displayName: c.display_name, avatarId: c.avatar_id, photoUrl: photoUrl(app.deps.kycKey, meId, c.photo_v) },
    }).catch(() => {});
    await notify(app.deps, callerId, {
      type: "call_invite", title: `${c.display_name} wants to talk`, body: "She's online now — tap to call her",
      data: { companionId: meId },
    });
    reply.status(201);
    return { invitedUntil: new Date(Date.now() + INVITE_AGAIN_S * 1000) };
  });
};
