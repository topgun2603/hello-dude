/**
 * Live mode. A companion with video unlocked goes live; callers swipe through
 * lives like reels. Everyone gets a short free preview (once per live, capped per
 * day); to keep watching they opt in and pay per minute like a 1:1 call — charged
 * at the start of each minute they're in the LiveKit room, checked by the server,
 * never on the app's word (sweepLives). Gifts go to the host. Chat needs a paid
 * minute. Empty lives end on their own; lives have a maximum length and a daily
 * limit per companion. Updates go out as `live_event`.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { Redis } from "ioredis";
import { tx, type Db, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { ApiError, conflict, forbidden, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import type { RoomControl, UserEvents } from "../billing/ports.js";
import { busyKey } from "../billing/engine.js";
import { BLOCK_MESSAGES, checkMessage } from "../chat-filter.js";
import { IST_TODAY_SQL } from "../growth.js";
import { notify } from "../notifications.js";
import { goOffline } from "../presence.js";
import type { PushSender } from "../push.js";
import { numberSetting } from "../settings.js";
import { giftPaise } from "./gifts.js";
import { base64File } from "./companion.js";
import { REACTIONS } from "./rooms.js";
import { PHOTO_V_SQL, checkSigned, photoUrl, signedQuery } from "./photos.js";
import sharp from "sharp";
import { onLiveGift } from "./pk.js";

const HOST_STALE_S = 60;    // host app heartbeats every 15 s
const VIEWER_STALE_S = 60;  // viewers heartbeat every 20 s
const NOTIFY_COOLDOWN_S = 30 * 60;
const FLAG_COOLDOWN_S = 30;
const MAX_FRAME_BYTES = 400 * 1024;
const LIMIT_WARNING_MIN = 5; // warn the host this long before the maximum length
const SNAPSHOT_EVERY_S = 45;  // card stills: at most one per live this often

type Deps = { db: Db; events: UserEvents; rooms: RoomControl; push?: PushSender };

export async function liveSettings(db: Db | DbClient) {
  const n = (k: string, d: number) => numberSetting(db, k, d);
  const [previewSeconds, coinsPerMin, shareBps, maxViewers, coinValue, emptyEndMin, maxMin, maxPerDay, previewsPerDay] =
    await Promise.all([
      n("live.preview_seconds", 10), n("live.coins_per_min", 3), n("live.companion_share_bps", 2500),
      n("live.max_viewers", 200), n("coin.value_paise", 80), n("live.empty_end_minutes", 10),
      n("live.max_minutes", 180), n("live.max_per_day", 4), n("live.previews_per_day", 20),
    ]);
  return {
    previewSeconds, coinsPerMin, maxViewers, emptyEndMin, maxMin, maxPerDay, previewsPerDay,
    /** Companion earnings for one watched minute. */
    paisePerMin: Math.round((coinsPerMin * coinValue * shareBps) / 10_000),
  };
}

type Access = { kind: "host" | "preview" | "paying" | "none"; endsAt: Date | null; minutes: number };

/** What `userId` may do in the live right now. */
export async function liveAccess(db: Db | DbClient, liveId: string, userId: string, previewSeconds: number): Promise<Access> {
  const r = (await db.query<{ host: boolean; preview_end: Date | null; paying: boolean | null; minutes: number | null }>(
    `SELECT (l.host_id = $2) AS host, v.paying, v.minutes_charged AS minutes,
            CASE WHEN v.preview_started_at + make_interval(secs => $3) > now()
                 THEN v.preview_started_at + make_interval(secs => $3) END AS preview_end
       FROM lives l LEFT JOIN live_viewers v ON v.live_id = l.id AND v.user_id = $2
      WHERE l.id = $1`, [liveId, userId, previewSeconds])).rows[0];
  if (!r) return { kind: "none", endsAt: null, minutes: 0 };
  if (r.host) return { kind: "host", endsAt: null, minutes: 0 };
  if (r.paying) return { kind: "paying", endsAt: null, minutes: r.minutes ?? 0 };
  if (r.preview_end) return { kind: "preview", endsAt: r.preview_end, minutes: r.minutes ?? 0 };
  return { kind: "none", endsAt: null, minutes: r.minutes ?? 0 };
}

/**
 * Charges `viewerId` the next minute (prepaid, like calls): coins from the viewer,
 * the companion's share to the host, one live_ticks row (the primary key blocks a
 * double charge). Returns the balance after, or null if they can't pay.
 */
async function chargeMinute(c: DbClient, live: { id: string; host_id: string }, viewerId: string, s: { coinsPerMin: number; paisePerMin: number }) {
  const v = (await c.query<{ minutes_charged: number }>(
    `SELECT minutes_charged FROM live_viewers WHERE live_id = $1 AND user_id = $2 FOR UPDATE`, [live.id, viewerId])).rows[0];
  if (!v) return null;
  const minute = v.minutes_charged + 1;
  const left = await post(c, viewerId, "coins", "live_debit", -s.coinsPerMin, `live:${live.id}:${viewerId}:${minute}`,
    { liveId: live.id, note: `Live, minute ${minute}` });
  if (left === null) return null;
  if (s.paisePerMin > 0) {
    await post(c, live.host_id, "earnings", "live_credit", s.paisePerMin, `live:${live.id}:${viewerId}:${minute}:credit`,
      { liveId: live.id, note: `Live, minute ${minute}` });
  }
  await c.query(`INSERT INTO live_ticks (live_id, viewer_id, minute_no, coins, paise) VALUES ($1, $2, $3, $4, $5)`,
    [live.id, viewerId, minute, s.coinsPerMin, s.paisePerMin]);
  await c.query(`UPDATE live_viewers SET minutes_charged = $3, last_charged_at = now() WHERE live_id = $1 AND user_id = $2`,
    [live.id, viewerId, minute]);
  return left;
}

export async function broadcastLive(db: Db | DbClient, events: UserEvents, liveId: string, event: Record<string, unknown>) {
  const ids = (await db.query<{ user_id: string }>(
    `SELECT user_id FROM live_viewers WHERE live_id = $1 AND left_at IS NULL
     UNION SELECT host_id FROM lives WHERE id = $1`, [liveId])).rows;
  await Promise.all(ids.map((m) => events.publish(m.user_id, { t: "live_event", liveId, event }).catch(() => {})));
}

async function endLive(deps: Deps, liveId: string, reason: string) {
  const ended = (await deps.db.query<{ livekit_room: string }>(
    `UPDATE lives SET status = 'ended', ended_at = now(), end_reason = $2 WHERE id = $1 AND status = 'live' RETURNING livekit_room`,
    [liveId, reason])).rows[0];
  if (!ended) return false;
  await broadcastLive(deps.db, deps.events, liveId, { kind: "ended", reason });
  await deps.db.query(`UPDATE live_viewers SET left_at = now(), paying = false WHERE live_id = $1 AND left_at IS NULL`, [liveId]);
  await deps.rooms.closeRoom(ended.livekit_room).catch(() => {});
  return true;
}

/** Ends a companion's live (e.g. when an admin suspends them). */
export async function endLivesOf(deps: Deps, hostId: string, reason: string) {
  const lives = (await deps.db.query<{ id: string }>(`SELECT id FROM lives WHERE host_id = $1 AND status = 'live'`, [hostId])).rows;
  for (const l of lives) await endLive(deps, l.id, reason);
}

/**
 * Worker, every 10 s. For each live: ends it if the host app went quiet, it ran
 * past the maximum length, or nobody watched for too long (warning the host
 * first); charges every paying viewer LiveKit reports in the room whose next
 * minute is due; removes viewers whose preview ended without opting in, or who
 * can't pay (after a low-coins warning).
 */
export async function sweepLives(deps: Deps): Promise<{ ended: number; removed: number; charged: number }> {
  const { db, rooms, events } = deps;
  const s = await liveSettings(db);
  let ended = 0, removed = 0, charged = 0;

  const stale = (await db.query<{ id: string }>(
    `SELECT id FROM lives WHERE status = 'live' AND host_seen_at < now() - make_interval(secs => $1)`, [HOST_STALE_S])).rows;
  for (const l of stale) if (await endLive(deps, l.id, "host_lost")) ended++;

  const tooLong = (await db.query<{ id: string }>(
    `SELECT id FROM lives WHERE status = 'live' AND started_at < now() - make_interval(mins => $1)`, [s.maxMin])).rows;
  for (const l of tooLong) if (await endLive(deps, l.id, "time_limit")) ended++;

  await db.query(
    `UPDATE live_viewers SET left_at = now(), paying = false
      WHERE left_at IS NULL AND last_seen_at < now() - make_interval(secs => $1)`, [VIEWER_STALE_S]);

  const live = (await db.query<{ id: string; host_id: string; livekit_room: string; empty_since: Date | null;
    empty_warned: boolean; limit_warned: boolean; near_limit: boolean }>(
    `SELECT id, host_id, livekit_room, empty_since, empty_warned_at IS NOT NULL AS empty_warned,
            limit_warned_at IS NOT NULL AS limit_warned,
            started_at < now() - make_interval(mins => $1) AS near_limit
       FROM lives WHERE status = 'live'`, [s.maxMin - LIMIT_WARNING_MIN])).rows;
  for (const l of live) {
    const inRoom = (await rooms.participantIdentities(l.livekit_room)).filter((id) => id !== l.host_id);
    const toHost = (event: Record<string, unknown>) =>
      events.publish(l.host_id, { t: "live_event", liveId: l.id, event }).catch(() => {});

    let watching = 0;
    for (const userId of inRoom) {
      const a = await liveAccess(db, l.id, userId, s.previewSeconds);
      if (a.kind === "preview") { watching++; continue; }
      if (a.kind === "paying") {
        const due = (await db.query<{ due: boolean }>(
          `SELECT (last_charged_at IS NULL OR last_charged_at <= now() - interval '60 seconds') AS due
             FROM live_viewers WHERE live_id = $1 AND user_id = $2`, [l.id, userId])).rows[0]?.due;
        if (!due) { watching++; continue; }
        const left = await tx(db, (c) => chargeMinute(c, l, userId, s));
        if (left !== null) {
          charged++;
          watching++;
          await events.publish(userId, { t: "live_event", liveId: l.id, event: { kind: "charged", minute: a.minutes + 1, coinsLeft: left } }).catch(() => {});
          // Warn when the next minute can't be paid.
          if (left < s.coinsPerMin) {
            await events.publish(userId, { t: "live_event", liveId: l.id, event: { kind: "low_balance", coinsLeft: left } }).catch(() => {});
          }
          continue;
        }
        await db.query(`UPDATE live_viewers SET paying = false WHERE live_id = $1 AND user_id = $2`, [l.id, userId]);
        await rooms.removeParticipant(l.livekit_room, userId).catch(() => {});
        await events.publish(userId, { t: "live_event", liveId: l.id, event: { kind: "access", state: "no_coins" } }).catch(() => {});
        removed++;
        continue;
      }
      // Preview over and not paying.
      await rooms.removeParticipant(l.livekit_room, userId).catch(() => {});
      await events.publish(userId, { t: "live_event", liveId: l.id, event: { kind: "access", state: "preview_over" } }).catch(() => {});
      removed++;
    }

    await db.query(`UPDATE lives SET peak_viewers = GREATEST(peak_viewers, $2) WHERE id = $1`, [l.id, watching]);

    // Nobody watching: warn the host halfway, end the live at the limit.
    if (watching > 0) {
      if (l.empty_since) await db.query(`UPDATE lives SET empty_since = NULL, empty_warned_at = NULL WHERE id = $1`, [l.id]);
    } else if (!l.empty_since) {
      await db.query(`UPDATE lives SET empty_since = now() WHERE id = $1`, [l.id]);
    } else {
      const emptyMin = (Date.now() - l.empty_since.getTime()) / 60_000;
      if (emptyMin >= s.emptyEndMin) {
        if (await endLive(deps, l.id, "empty")) ended++;
        continue;
      }
      if (emptyMin >= s.emptyEndMin / 2 && !l.empty_warned) {
        await db.query(`UPDATE lives SET empty_warned_at = now() WHERE id = $1`, [l.id]);
        await toHost({ kind: "empty_warning", endsInMinutes: Math.ceil(s.emptyEndMin - emptyMin) });
      }
    }
    if (l.near_limit && !l.limit_warned) {
      await db.query(`UPDATE lives SET limit_warned_at = now() WHERE id = $1`, [l.id]);
      await toHost({ kind: "limit_warning", endsInMinutes: LIMIT_WARNING_MIN });
    }
  }
  return { ended, removed, charged };
}

// ---------------------------------------------------------------------------

const Host = z.object({
  id: z.uuid(), displayName: z.string(), avatarId: z.number().int(), photoUrl: z.string().nullable().describe("Approved profile photo (signed URL path); null = show the avatar"),
  rating: z.number().nullable(),
  languages: z.array(z.string()), isFavourite: z.boolean(),
});
const LiveCard = z.object({
  id: z.uuid(), title: z.string(), language: z.string(), host: Host, viewers: z.number().int(), startedAt: z.date(),
  snapshotUrl: z.string().nullable().describe("Recent still from the host's camera (signed path); null = use the host's photo/avatar"),
  pkBattleId: z.uuid().nullable().describe("An active PK battle this live is in (GET /pk/{id})"),
}).meta({ id: "LiveCard" });
const AccessZ = z.object({
  kind: z.enum(["host", "preview", "paying", "none"]),
  endsAt: z.date().nullable().describe("When the free preview ends"),
  minutes: z.number().int().describe("Minutes paid for in this live so far"),
}).meta({ id: "LiveAccess" });
const Pricing = z.object({
  previewSeconds: z.number().int(),
  coinsPerMin: z.number().int(),
}).meta({ id: "LivePricing" });
const Join = z.object({
  live: LiveCard, liveKitUrl: z.string(), livekitRoom: z.string(), token: z.string(), access: AccessZ, pricing: Pricing,
  coinsLeft: z.number().int().nullable(),
}).meta({ id: "LiveJoin" });

type LiveRow = { id: string; host_id: string; title: string; language_code: string; livekit_room: string; status: "live" | "ended";
  started_at: Date };

/** Live chat lines kept for late joiners. */
const LIVE_CHAT_KEEP = 50;

async function rateLimited(redis: Redis, key: string, seconds: number) {
  return !(await redis.set(key, "1", "EX", seconds, "NX"));
}

export const liveRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, rooms, events } = app.deps;
  const base = { tags: ["lives"], security: bearer };
  const viewer = requireAuth("caller");
  const host = requireAuth("companion");
  const deps: Deps = { db, events, rooms, push: app.deps.push };

  const loadLive = async (id: string) => {
    const r = (await db.query<LiveRow>(`SELECT * FROM lives WHERE id = $1`, [id])).rows[0];
    if (!r) throw notFound("LIVE_NOT_FOUND");
    return r;
  };
  type Order = "for_you" | "popular" | "new";
  const ORDER_SQL: Record<Order, string> = {
    // Favourites, then the viewer's own language, then the busiest.
    for_you: `fav DESC, (l.language_code = (SELECT primary_language FROM users WHERE id = $1)) DESC, viewers DESC, l.started_at DESC`,
    popular: `viewers DESC, l.started_at DESC`,
    new: `l.started_at DESC`,
  };
  const FROM = `FROM lives l JOIN users h ON h.id = l.host_id LEFT JOIN companion_profiles p ON p.user_id = h.id`;
  const NOT_BLOCKED = `NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = $1 AND b.blocked_id = h.id) OR (b.blocker_id = h.id AND b.blocked_id = $1))`;
  /** Signed path to a live's latest snapshot; the time in the path busts the cache when a new one arrives. */
  const snapshotUrl = (liveId: string, at: Date | null) => {
    if (!at) return null;
    const t = Math.floor(at.getTime() / 1000);
    return `/v1/lives/${liveId}/snapshot/${t}.jpg?${signedQuery(app.deps.kycKey, `live-snapshot.${liveId}.${t}`)}`;
  };
  const cards = async (viewerId: string, where: string, args: unknown[], opts: { order?: Order; limit?: number; offset?: number } = {}) => (await db.query<{
    id: string; title: string; language_code: string; started_at: Date; host_id: string; host_name: string; host_avatar: number; host_photo_v: number | null;
    rating_sum: number | null; rating_count: number | null; languages: string[]; fav: boolean; viewers: number; snapshot_at: Date | null; pk_id: string | null;
  }>(
    `SELECT l.id, l.title, l.language_code, l.started_at, h.id AS host_id, h.display_name AS host_name, h.avatar_id AS host_avatar, ${PHOTO_V_SQL("h")} AS host_photo_v,
            p.rating_sum, p.rating_count,
            COALESCE((SELECT array_agg(language_code ORDER BY language_code) FROM user_languages WHERE user_id = h.id), ARRAY[h.primary_language]) AS languages,
            EXISTS (SELECT 1 FROM favourites f WHERE f.user_id = $1 AND f.companion_id = h.id) AS fav,
            (SELECT count(*) FROM live_viewers v WHERE v.live_id = l.id AND v.left_at IS NULL)::int AS viewers,
            CASE WHEN l.snapshot_key IS NOT NULL THEN l.snapshot_at END AS snapshot_at,
            (SELECT pk.id FROM pk_battles pk WHERE pk.status = 'active' AND l.id IN (pk.live_a, pk.live_b) LIMIT 1) AS pk_id
       ${FROM}
      WHERE ${where} AND ${NOT_BLOCKED}
      ORDER BY ${ORDER_SQL[opts.order ?? "for_you"]}
      LIMIT ${Math.min(opts.limit ?? 100, 100)} OFFSET ${Math.max(opts.offset ?? 0, 0)}`, [viewerId, ...args])).rows.map((r) => ({
    id: r.id, title: r.title, language: r.language_code, startedAt: r.started_at, viewers: r.viewers,
    snapshotUrl: snapshotUrl(r.id, r.snapshot_at), pkBattleId: r.pk_id,
    host: {
      id: r.host_id, displayName: r.host_name, avatarId: r.host_avatar, photoUrl: photoUrl(app.deps.kycKey, r.host_id, r.host_photo_v),
      languages: r.languages, isFavourite: r.fav,
      rating: r.rating_count ? Math.round(((r.rating_sum ?? 0) / r.rating_count) * 10) / 10 : null,
    },
  }));
  const pricing = async () => {
    const s = await liveSettings(db);
    return { previewSeconds: s.previewSeconds, coinsPerMin: s.coinsPerMin };
  };
  const coins = async (userId: string) =>
    (await db.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [userId])).rows[0]?.balance ?? 0;

  app.get("/lives", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      ...base,
      summary: "Live now, a page at a time, with the total and the price per minute. " +
        "sort: for_you (favourites, your language, busiest), popular or new; favourites=true shows only favourites; q searches names and titles.",
      querystring: z.object({
        language: z.string().optional(),
        sort: z.enum(["for_you", "popular", "new"]).optional(),
        favourites: z.enum(["true", "false"]).optional(),
        q: z.string().trim().max(40).optional(),
        limit: z.coerce.number().int().min(1).max(100).optional(),
        offset: z.coerce.number().int().min(0).max(10_000).optional(),
      }),
      response: { 200: z.object({ lives: z.array(LiveCard), total: z.number().int(), pricing: Pricing }) },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const { language, sort, favourites, q, limit, offset } = req.query;
    const like = q ? `%${q.replace(/[\\%_]/g, (c) => `\\${c}`)}%` : null;
    const where = `l.status = 'live' AND ($2::text IS NULL OR l.language_code = $2)
      AND (NOT $3::boolean OR EXISTS (SELECT 1 FROM favourites f WHERE f.user_id = $1 AND f.companion_id = h.id))
      AND ($4::text IS NULL OR h.display_name ILIKE $4 OR l.title ILIKE $4)`;
    const args = [language ?? null, favourites === "true", like];
    const total = (await db.query<{ n: number }>(
      `SELECT count(*)::int AS n ${FROM} WHERE ${where} AND ${NOT_BLOCKED}`, [userId, ...args])).rows[0]!.n;
    return {
      lives: await cards(userId, where, args, { order: sort ?? "for_you", limit: limit ?? 30, offset: offset ?? 0 }),
      total,
      pricing: await pricing(),
    };
  });

  // --- host ------------------------------------------------------------------------
  app.post("/lives", {
    preHandler: host,
    schema: {
      ...base,
      summary: "Go live (companions with video unlocked). You stop getting 1:1 calls until the live ends.",
      // nullish: the generated app client sends null for fields it leaves out.
      body: z.object({ title: z.string().trim().min(3).max(60), language: z.string().nullish() }),
      response: { 201: Join },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    if (checkMessage(req.body.title)) throw new ApiError(400, "TITLE_BLOCKED", "Keep contact details and payments out of the title");
    if (await redis.exists(busyKey(userId))) throw conflict("IN_A_CALL", "Finish your call before going live");
    if ((await db.query(`SELECT 1 FROM group_sessions WHERE host_id = $1 AND status IN ('lobby', 'live')`, [userId])).rowCount) {
      throw conflict("GROUP_OPEN", "End your group video before going live");
    }
    const s = await liveSettings(db);
    const live = await tx(db, async (c) => {
      const p = (await c.query<{ ok: boolean; video: boolean; lang: string }>(
        `SELECT (p.kyc_status = 'approved' AND u.status = 'active') AS ok, p.video_enabled AS video, u.primary_language AS lang
           FROM companion_profiles p JOIN users u ON u.id = p.user_id WHERE p.user_id = $1`, [userId])).rows[0];
      if (!p?.ok) throw new ApiError(403, "KYC_NOT_APPROVED", "Finish verification before going live");
      if (!p.video) throw new ApiError(403, "VIDEO_LOCKED", "Going live unlocks with video calls (after the academy)");
      const lang = req.body.language ?? p.lang;
      if (!(await c.query(`SELECT 1 FROM languages WHERE code = $1 AND is_active`, [lang])).rowCount) {
        throw new ApiError(400, "LANGUAGE_UNSUPPORTED", "That language is not available yet");
      }
      if ((await c.query(`SELECT 1 FROM lives WHERE host_id = $1 AND status = 'live'`, [userId])).rowCount) {
        throw conflict("ALREADY_LIVE", "You're already live");
      }
      const today = (await c.query<{ n: number }>(
        `SELECT count(*)::int AS n FROM lives WHERE host_id = $1 AND (started_at AT TIME ZONE 'Asia/Kolkata')::date = ${IST_TODAY_SQL}`,
        [userId])).rows[0]!.n;
      if (today >= s.maxPerDay) throw new ApiError(429, "LIVE_DAILY_LIMIT", `You can go live ${s.maxPerDay} times a day. Try again tomorrow.`);
      return (await c.query<LiveRow>(
        `INSERT INTO lives (host_id, title, language_code, livekit_room) VALUES ($1, $2, $3, 'live_' || gen_random_uuid()) RETURNING *`,
        [userId, req.body.title, lang])).rows[0]!;
    });
    await goOffline(redis, userId); // no 1:1 calls while live
    if (await redis.set(`live:notified:${userId}`, "1", "EX", NOTIFY_COOLDOWN_S, "NX")) {
      const h = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!;
      const fans = (await db.query<{ user_id: string }>(`SELECT user_id FROM favourites WHERE companion_id = $1 AND notify`, [userId])).rows;
      for (const f of fans) {
        await notify(app.deps, f.user_id, { type: "live_started", title: `${h.display_name} is live now`, body: live.title, data: { liveId: live.id } });
      }
    }
    reply.status(201);
    const [card] = await cards(userId, `l.id = $2`, [live.id]);
    return {
      live: card!, liveKitUrl: app.deps.liveKitUrl, livekitRoom: live.livekit_room, access: { kind: "host" as const, endsAt: null, minutes: 0 },
      token: await rooms.joinToken(live.livekit_room, userId, { canPublish: true }), pricing: await pricing(), coinsLeft: null,
    };
  });

  app.post("/lives/:id/host-heartbeat", {
    preHandler: host,
    schema: {
      ...base,
      summary: "Host: still live (every 15 s). Returns viewers and what this live has earned.",
      params: z.object({ id: z.uuid() }),
      response: { 200: z.object({ status: z.enum(["live", "ended"]), viewers: z.number().int(), earnedPaise: z.number().int(),
        paidMinutes: z.number().int() }) },
    },
  }, async (req) => {
    const l = await loadLive(req.params.id);
    if (l.host_id !== me(req).userId) throw forbidden("NOT_THE_HOST");
    if (l.status === "live") await db.query(`UPDATE lives SET host_seen_at = now() WHERE id = $1`, [l.id]);
    const s = (await db.query<{ viewers: number; paise: number; minutes: number }>(
      `SELECT (SELECT count(*) FROM live_viewers WHERE live_id = $1 AND left_at IS NULL)::int AS viewers,
              (COALESCE((SELECT sum(paise) FROM live_ticks WHERE live_id = $1), 0)
               + COALESCE((SELECT sum(paise_credited) FROM live_gifts WHERE live_id = $1), 0))::int AS paise,
              (SELECT count(*) FROM live_ticks WHERE live_id = $1)::int AS minutes`, [l.id])).rows[0]!;
    return { status: l.status, viewers: s.viewers, earnedPaise: s.paise, paidMinutes: s.minutes };
  });

  app.post("/lives/:id/end", {
    preHandler: host,
    schema: { ...base, summary: "Host: end the live", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const l = await loadLive(req.params.id);
    if (l.host_id !== me(req).userId) throw forbidden("NOT_THE_HOST");
    await endLive(deps, l.id, "host_ended");
    return reply.status(204).send(null);
  });

  app.post("/lives/:id/snapshot", {
    preHandler: host,
    bodyLimit: 1024 * 1024,
    schema: {
      ...base,
      summary: "Host: a still for the live's card (about once a minute, already safety-checked on the phone)",
      params: z.object({ id: z.uuid() }),
      body: z.object({ frameBase64: base64File(MAX_FRAME_BYTES) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const l = await loadLive(req.params.id);
    if (l.host_id !== me(req).userId) throw forbidden("NOT_THE_HOST");
    if (l.status !== "live") throw new ApiError(410, "LIVE_ENDED", "This live has ended");
    if (await rateLimited(redis, `live:snap:${l.id}`, SNAPSHOT_EVERY_S)) return reply.status(204).send(null);
    let jpeg: Buffer;
    try {
      // Portrait card, metadata dropped.
      jpeg = await sharp(req.body.frameBase64).rotate().resize(360, 480, { fit: "cover", position: "attention" })
        .jpeg({ quality: 72, mozjpeg: true }).toBuffer();
    } catch {
      throw new ApiError(400, "NOT_AN_IMAGE", "The frame must be a JPEG or PNG");
    }
    const key = `live-snapshots/${l.id}`;
    await app.deps.store.put(key, jpeg);
    await db.query(`UPDATE lives SET snapshot_key = $2, snapshot_at = now() WHERE id = $1`, [l.id, key]);
    return reply.status(204).send(null);
  });

  // Signed link from GET /lives; served only while the live is on.
  app.get("/lives/:id/snapshot/:file", {
    schema: {
      tags: ["lives"],
      summary: "A live's card snapshot, through a signed URL from GET /lives",
      params: z.object({ id: z.uuid(), file: z.string().regex(/^\d+\.jpg$/) }),
      querystring: z.object({ exp: z.coerce.number().int(), sig: z.string().max(64) }),
    },
  }, async (req, reply) => {
    const t = req.params.file.replace(/\.jpg$/, "");
    if (!checkSigned(app.deps.kycKey, `live-snapshot.${req.params.id}.${t}`, req.query.exp, req.query.sig)) throw notFound("SNAPSHOT_NOT_FOUND");
    const l = (await db.query<{ status: string; snapshot_key: string | null }>(
      `SELECT status, snapshot_key FROM lives WHERE id = $1`, [req.params.id])).rows[0];
    if (!l || l.status !== "live" || !l.snapshot_key) throw notFound("SNAPSHOT_NOT_FOUND");
    const bytes = await app.deps.store.get(l.snapshot_key);
    return reply.header("cache-control", "private, max-age=300").type("image/jpeg").send(bytes);
  });

  // --- viewers ---------------------------------------------------------------------
  app.post("/lives/:id/join", {
    preHandler: viewer,
    schema: {
      ...base,
      summary: "Watch. The first visit has a free preview. After it, send pay=true to keep watching at the per-minute price " +
        "(the first minute is charged now, then one each minute you stay). 402 PAY_TO_WATCH / INSUFFICIENT_BALANCE otherwise.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ pay: z.boolean().nullish().describe("Agree to pay per minute after the preview") }).nullish(),
      response: { 200: Join },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const l = await loadLive(req.params.id);
    if (l.status !== "live") throw new ApiError(410, "LIVE_ENDED", "This live has ended");
    const blocked = (await db.query(
      `SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`, [userId, l.host_id])).rowCount;
    if (blocked) throw forbidden("LIVE_BLOCKED");
    const s = await liveSettings(db);
    const watching = (await db.query<{ n: number }>(
      `SELECT count(*)::int AS n FROM live_viewers WHERE live_id = $1 AND left_at IS NULL AND user_id <> $2`, [l.id, userId])).rows[0]!.n;
    if (watching >= s.maxViewers) throw conflict("LIVE_FULL", "This live is full right now");

    // First visit to this live starts the preview — unless today's free previews are used up.
    const first = !(await db.query(`SELECT 1 FROM live_viewers WHERE live_id = $1 AND user_id = $2`, [l.id, userId])).rowCount;
    if (first) {
      const previewsToday = (await db.query<{ n: number }>(
        `SELECT count(*)::int AS n FROM live_viewers WHERE user_id = $1 AND (joined_at AT TIME ZONE 'Asia/Kolkata')::date = ${IST_TODAY_SQL}`,
        [userId])).rows[0]!.n;
      const noPreview = previewsToday >= s.previewsPerDay;
      await db.query(
        `INSERT INTO live_viewers (live_id, user_id, preview_started_at) VALUES ($1, $2, CASE WHEN $3 THEN now() - interval '1 day' ELSE now() END)
         ON CONFLICT (live_id, user_id) DO NOTHING`, [l.id, userId, noPreview]);
    } else {
      await db.query(`UPDATE live_viewers SET left_at = NULL, last_seen_at = now() WHERE live_id = $1 AND user_id = $2`, [l.id, userId]);
    }

    let access = await liveAccess(db, l.id, userId, s.previewSeconds);
    let coinsLeft: number | null = null;
    if (access.kind === "none") {
      if (!req.body?.pay) throw new ApiError(402, "PAY_TO_WATCH", `Keep watching for ${s.coinsPerMin} coins a minute`);
      // Opt in and pay the first minute now (prepaid, like calls).
      coinsLeft = await tx(db, async (c) => {
        const left = await chargeMinute(c, l, userId, s);
        if (left === null) {
          throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${s.coinsPerMin} coins for a minute. Add coins to keep watching.`);
        }
        await c.query(`UPDATE live_viewers SET paying = true WHERE live_id = $1 AND user_id = $2`, [l.id, userId]);
        return left;
      });
      access = await liveAccess(db, l.id, userId, s.previewSeconds);
    }
    await broadcastLive(db, events, l.id, { kind: "viewers", count: watching + 1 });
    const [card] = await cards(userId, `l.id = $2`, [l.id]);
    return {
      live: card!, liveKitUrl: app.deps.liveKitUrl, livekitRoom: l.livekit_room, access,
      pricing: { previewSeconds: s.previewSeconds, coinsPerMin: s.coinsPerMin },
      coinsLeft: coinsLeft ?? await coins(userId),
      token: await rooms.joinToken(l.livekit_room, userId, { canPublish: false }),
    };
  });

  app.post("/lives/:id/heartbeat", {
    preHandler: viewer,
    schema: { ...base, summary: "Viewer: still watching (every 20 s). Returns your access.", params: z.object({ id: z.uuid() }), response: { 200: AccessZ } },
  }, async (req) => {
    const userId = me(req).userId;
    await db.query(`UPDATE live_viewers SET last_seen_at = now(), left_at = NULL WHERE live_id = $1 AND user_id = $2`, [req.params.id, userId]);
    return liveAccess(db, req.params.id, userId, (await liveSettings(db)).previewSeconds);
  });

  app.post("/lives/:id/leave", {
    preHandler: viewer,
    schema: { ...base, summary: "Viewer: stop watching (stops the per-minute charge)", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    await db.query(`UPDATE live_viewers SET left_at = now(), paying = false WHERE live_id = $1 AND user_id = $2 AND left_at IS NULL`,
      [req.params.id, me(req).userId]);
    return reply.status(204).send(null);
  });

  app.post("/lives/:id/messages", {
    preHandler: requireAuth("caller", "companion"),
    schema: { ...base, summary: "Chat (paying viewers and the host; safety-filtered; one message every 2 s)", params: z.object({ id: z.uuid() }),
      body: z.object({ body: z.string().trim().min(1).max(200) }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const l = await loadLive(req.params.id);
    if (l.status !== "live") throw new ApiError(410, "LIVE_ENDED", "This live has ended");
    const a = await liveAccess(db, l.id, userId, (await liveSettings(db)).previewSeconds);
    if (a.kind !== "host" && a.kind !== "paying") throw new ApiError(402, "PAY_TO_WATCH", "Keep watching to chat");
    const reason = checkMessage(req.body.body);
    if (reason) throw new ApiError(422, "MESSAGE_BLOCKED", BLOCK_MESSAGES[reason]);
    if (await rateLimited(redis, `live:msg:${l.id}:${userId}`, 2)) throw new ApiError(429, "TOO_FAST", "Slow down a little");
    const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
    await broadcastLive(db, events, l.id, { kind: "chat", userId, displayName: name, body: req.body.body, isHost: a.kind === "host" });
    // Recent lines for people who join later (Redis only; gone 6 h after the last message).
    const key = `live:chat:${l.id}`;
    await redis.multi()
      .rpush(key, JSON.stringify({ userId, displayName: name, body: req.body.body, isHost: a.kind === "host", at: new Date().toISOString() }))
      .ltrim(key, -LIVE_CHAT_KEEP, -1)
      .expire(key, 6 * 3600)
      .exec();
    return reply.status(204).send(null);
  });

  app.get("/lives/:id/messages", {
    preHandler: requireAuth("caller", "companion"),
    schema: { ...base, summary: "Recent chat of a live (last 50, oldest first) so late joiners see the conversation",
      params: z.object({ id: z.uuid() }),
      response: { 200: z.object({ messages: z.array(z.object({
        userId: z.string(), displayName: z.string(), body: z.string(), isHost: z.boolean(), at: z.string(),
      })) }).meta({ id: "LiveChatHistory" }) } },
  }, async (req) => {
    const raw = await redis.lrange(`live:chat:${req.params.id}`, 0, -1);
    return { messages: raw.map((r) => JSON.parse(r) as { userId: string; displayName: string; body: string; isHost: boolean; at: string }) };
  });

  app.post("/lives/:id/react", {
    preHandler: viewer,
    schema: { ...base, summary: "Send a reaction (anyone watching, preview included)", params: z.object({ id: z.uuid() }),
      body: z.object({ emoji: z.string().refine((e) => REACTIONS.includes(e), "Not a reaction").describe(REACTIONS.join(" ")) }),
      response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const a = await liveAccess(db, req.params.id, userId, (await liveSettings(db)).previewSeconds);
    if (a.kind === "none") throw new ApiError(402, "PAY_TO_WATCH", "Keep watching to send hearts");
    if (!(await rateLimited(redis, `live:react:${req.params.id}:${userId}`, 1))) {
      const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
      await broadcastLive(db, events, req.params.id, { kind: "reaction", userId, displayName: name, emoji: req.body.emoji });
    }
    return reply.status(204).send(null);
  });

  app.post("/lives/:id/gifts", {
    preHandler: viewer,
    schema: {
      ...base,
      summary: "Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef. During a PK battle, toHostId may name the other host.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ giftId: z.number().int(), clientRef: z.uuid(), toHostId: z.uuid().nullish().describe("PK battle: gift the other side's host") }),
      response: { 201: z.object({ coinsLeft: z.number().int() }) },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const l = await loadLive(req.params.id);
    if (l.status !== "live") throw new ApiError(410, "LIVE_ENDED", "This live has ended");
    const gift = (await db.query<{ id: number; name: string; emoji: string; coins: number }>(
      `SELECT id, name, emoji, coins FROM gifts WHERE id = $1 AND is_active`, [req.body.giftId])).rows[0];
    if (!gift) throw notFound("GIFT_NOT_FOUND");
    let receiver = l.host_id;
    if (req.body.toHostId && req.body.toHostId !== l.host_id) {
      const pk = (await db.query(
        `SELECT 1 FROM pk_battles WHERE status = 'active' AND ((live_a = $1 AND host_b = $2) OR (live_b = $1 AND host_a = $2))`,
        [l.id, req.body.toHostId])).rowCount;
      if (!pk) throw new ApiError(409, "NOT_IN_BATTLE", "That host isn't battling this live");
      receiver = req.body.toHostId;
    }
    const paise = await giftPaise(db, gift.coins);
    const result = await tx(db, async (c) => {
      const ins = await c.query<{ id: string }>(
        `INSERT INTO live_gifts (live_id, sender_id, receiver_id, gift_id, coins, paise_credited, client_ref)
         VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (client_ref) DO NOTHING RETURNING id`,
        [l.id, userId, receiver, gift.id, gift.coins, paise, req.body.clientRef]);
      const bal = async () => (await c.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [userId])).rows[0]?.balance ?? 0;
      if (!ins.rowCount) return { duplicate: true, coinsLeft: await bal() };
      const id = ins.rows[0]!.id;
      const left = await post(c, userId, "coins", "gift_debit", -gift.coins, `livegift:${id}:debit`, { liveId: l.id, note: `${gift.name} gift in a live` });
      if (left === null) throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${gift.coins} coins for a ${gift.name}`);
      if (paise > 0) await post(c, receiver, "earnings", "gift_credit", paise, `livegift:${id}:credit`, { liveId: l.id, note: `${gift.name} gift in a live` });
      return { duplicate: false, coinsLeft: left };
    });
    if (!result.duplicate) {
      const from = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
      await broadcastLive(db, events, l.id, { kind: "gift", userId, displayName: from, gift: { name: gift.name, emoji: gift.emoji }, toHostId: receiver });
      await onLiveGift({ db, events, rooms }, l.id);
    }
    reply.status(201);
    return { coinsLeft: result.coinsLeft };
  });

  app.post("/lives/:id/moderation", {
    preHandler: requireAuth("caller", "companion"),
    bodyLimit: 1024 * 1024,
    schema: {
      ...base,
      summary: "A frame of the host's video that an on-device check flagged (host's own phone or a viewer's)",
      params: z.object({ id: z.uuid() }),
      body: z.object({ frameBase64: base64File(MAX_FRAME_BYTES), score: z.number().min(0).max(1) }),
      response: { 201: z.object({ accepted: z.literal(true) }), 202: z.object({ accepted: z.literal(false) }) },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const l = await loadLive(req.params.id);
    if (l.host_id !== userId && !(await db.query(`SELECT 1 FROM live_viewers WHERE live_id = $1 AND user_id = $2`, [l.id, userId])).rowCount) {
      throw forbidden("NOT_IN_LIVE");
    }
    const b = req.body.frameBase64;
    if (!(b[0] === 0xff && b[1] === 0xd8)) throw new ApiError(400, "NOT_A_JPEG", "The frame must be a JPEG");
    if (!(await redis.set(`mod:live:${l.id}:${userId}`, "1", "EX", FLAG_COOLDOWN_S, "NX"))) return reply.status(202).send({ accepted: false });
    const id = (await db.query<{ id: string }>(`SELECT gen_random_uuid() AS id`)).rows[0]!.id;
    const key = `moderation/${id}`;
    await app.deps.store.put(key, b);
    await db.query(
      `INSERT INTO moderation_flags (id, live_id, subject_id, detected_by, score, storage_key) VALUES ($1, $2, $3, $4, $5, $6)`,
      [id, l.id, l.host_id, userId, req.body.score, key]);
    return reply.status(201).send({ accepted: true });
  });

  // --- admin -----------------------------------------------------------------------
  const AdminLive = z.object({
    id: z.uuid(), title: z.string(), language: z.string(), status: z.enum(["live", "ended"]),
    host: z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int() }),
    viewers: z.number().int(), peakViewers: z.number().int(), paidMinutes: z.number().int(), minuteCoins: z.number().int(),
    giftCoins: z.number().int(), openFlags: z.number().int(), startedAt: z.date(), endedAt: z.date().nullable(), endReason: z.string().nullable(),
  }).meta({ id: "AdminLive" });

  app.get("/admin/lives", {
    preHandler: can("rooms.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "Lives now, then the last 50 that ended", response: { 200: z.array(AdminLive) } },
  }, async () => (await db.query<{
    id: string; title: string; language_code: string; status: "live" | "ended"; host_id: string; host_name: string; host_avatar: number;
    viewers: number; peak_viewers: number; minutes: number; minute_coins: number; gift_coins: number; flags: number;
    started_at: Date; ended_at: Date | null; end_reason: string | null;
  }>(
    `SELECT l.id, l.title, l.language_code, l.status, h.id AS host_id, h.display_name AS host_name, h.avatar_id AS host_avatar,
            (SELECT count(*) FROM live_viewers v WHERE v.live_id = l.id AND v.left_at IS NULL)::int AS viewers, l.peak_viewers,
            (SELECT count(*) FROM live_ticks t WHERE t.live_id = l.id)::int AS minutes,
            COALESCE((SELECT sum(coins) FROM live_ticks t WHERE t.live_id = l.id), 0)::int AS minute_coins,
            COALESCE((SELECT sum(coins) FROM live_gifts g WHERE g.live_id = l.id), 0)::int AS gift_coins,
            (SELECT count(*) FROM moderation_flags f WHERE f.live_id = l.id AND f.status = 'open')::int AS flags,
            l.started_at, l.ended_at, l.end_reason
       FROM lives l JOIN users h ON h.id = l.host_id
      WHERE l.status = 'live' OR l.id IN (SELECT id FROM lives WHERE status = 'ended' ORDER BY ended_at DESC LIMIT 50)
      ORDER BY l.status = 'live' DESC, l.started_at DESC`)).rows.map((r) => ({
    id: r.id, title: r.title, language: r.language_code, status: r.status,
    host: { id: r.host_id, displayName: r.host_name, avatarId: r.host_avatar },
    viewers: r.viewers, peakViewers: r.peak_viewers, paidMinutes: r.minutes, minuteCoins: r.minute_coins, giftCoins: r.gift_coins,
    openFlags: r.flags, startedAt: r.started_at, endedAt: r.ended_at, endReason: r.end_reason,
  })));

  app.post("/admin/lives/:id/end", {
    preHandler: can("rooms.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "End a live now (moderation)", params: z.object({ id: z.uuid() }),
      body: z.object({ reason: z.string().trim().min(3).max(500) }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const l = await loadLive(req.params.id);
    if (l.status !== "live") throw conflict("LIVE_ENDED", "Already ended");
    await db.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, 'live.end', 'live', $2, $3)`,
      [me(req).userId, l.id, JSON.stringify({ reason: req.body.reason, hostId: l.host_id })]);
    await endLive(deps, l.id, "admin");
    return reply.status(204).send(null);
  });
};
