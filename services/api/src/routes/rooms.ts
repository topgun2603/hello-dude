/**
 * Voice rooms (designs: Rooms.dc.html, RoomLive.dc.html). Approved companions
 * host; listening is free; listeners raise a hand and the host brings them on
 * stage (up to max_speakers). Chat passes the same safety filter as 1:1 chat.
 * Gifts go to a companion on stage and pay the same share as call gifts.
 * Live updates are sent to every member as `room_event` over the WebSocket.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { Redis } from "ioredis";
import { tx, type Db } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { ApiError, conflict, forbidden, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import type { RoomControl, UserEvents } from "../billing/ports.js";
import { BLOCK_MESSAGES, checkMessage } from "../chat-filter.js";
import { notify } from "../notifications.js";
import { giftPaise } from "./gifts.js";

export const REACTIONS = ["❤️", "😂", "👏", "🔥", "😮", "🙏"];
const STALE_S = 90;           // members send a heartbeat every 30 s
const ROOM_NOTIFY_COOLDOWN_S = 30 * 60;

const Person = z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int() });
const RoomCard = z.object({
  id: z.uuid(), title: z.string(), category: z.string(), categoryName: z.string(), language: z.string(),
  host: Person, listeners: z.number().int(), faces: z.array(Person).describe("A few people in the room, for the stacked avatars"),
  createdAt: z.date(),
}).meta({ id: "RoomCard" });

const Member = Person.extend({ role: z.enum(["host", "speaker", "listener"]), handRaised: z.boolean(), isCompanion: z.boolean() }).meta({ id: "RoomMember" });
const RoomState = z.object({
  id: z.uuid(), title: z.string(), category: z.string(), language: z.string(), status: z.enum(["live", "ended"]),
  maxSpeakers: z.number().int(), members: z.array(Member), me: z.enum(["host", "speaker", "listener"]).nullable(),
}).meta({ id: "RoomState" });
const Join = z.object({ room: RoomState, liveKitUrl: z.string(), token: z.string(), livekitRoom: z.string() }).meta({ id: "RoomJoin" });

type RoomRow = { id: string; host_id: string; title: string; category: string; language_code: string; livekit_room: string;
  status: "live" | "ended"; max_speakers: number };
type MemberRow = { user_id: string; display_name: string; avatar_id: number; role: "host" | "speaker" | "listener";
  hand_raised_at: Date | null; user_role: string };

/** Ends stale memberships and rooms whose host is gone or that emptied out. Worker: every 30 s. */
export async function sweepRooms(deps: { db: Db; events: UserEvents; rooms: RoomControl }): Promise<{ left: number; ended: number }> {
  const left = (await deps.db.query(
    `UPDATE voice_room_members SET left_at = now(), hand_raised_at = NULL
      WHERE left_at IS NULL AND last_seen_at < now() - make_interval(secs => $1)`, [STALE_S])).rowCount ?? 0;
  const dead = (await deps.db.query<{ id: string; livekit_room: string }>(
    `UPDATE voice_rooms r SET status = 'ended', ended_at = now(), end_reason = 'host_left'
      WHERE r.status = 'live' AND NOT EXISTS (
        SELECT 1 FROM voice_room_members m WHERE m.room_id = r.id AND m.user_id = r.host_id AND m.left_at IS NULL)
        AND r.created_at < now() - interval '30 seconds'
      RETURNING r.id, r.livekit_room`)).rows;
  for (const r of dead) {
    await deps.rooms.closeRoom(r.livekit_room).catch(() => {});
    await broadcastTo(deps.db, deps.events, r.id, { kind: "ended" }, true);
  }
  return { left, ended: dead.length };
}

async function broadcastTo(db: Db, events: UserEvents, roomId: string, event: Record<string, unknown>, includeLeft = false) {
  const ids = (await db.query<{ user_id: string }>(
    `SELECT user_id FROM voice_room_members
      WHERE room_id = $1 AND (left_at IS NULL ${includeLeft ? "OR left_at > now() - interval '5 minutes'" : ""})`,
    [roomId])).rows;
  await Promise.all(ids.map((m) => events.publish(m.user_id, { t: "room_event", roomId, event }).catch(() => {})));
}

async function rateLimited(redis: Redis, key: string, seconds: number) {
  return !(await redis.set(key, "1", "EX", seconds, "NX"));
}

export const roomRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, rooms, events } = app.deps;
  const base = { tags: ["rooms"], security: bearer };
  const auth = requireAuth("caller", "companion");
  const broadcast = (roomId: string, event: Record<string, unknown>) => broadcastTo(db, events, roomId, event);

  const loadRoom = async (id: string) => {
    const r = (await db.query<RoomRow>(`SELECT * FROM voice_rooms WHERE id = $1`, [id])).rows[0];
    if (!r) throw notFound("ROOM_NOT_FOUND");
    return r;
  };
  const members = async (roomId: string) => (await db.query<MemberRow>(
    `SELECT m.user_id, u.display_name, u.avatar_id, m.role, m.hand_raised_at, u.role AS user_role
       FROM voice_room_members m JOIN users u ON u.id = m.user_id
      WHERE m.room_id = $1 AND m.left_at IS NULL
      ORDER BY CASE m.role WHEN 'host' THEN 0 WHEN 'speaker' THEN 1 ELSE 2 END, m.joined_at`, [roomId])).rows;
  const state = async (r: RoomRow, userId: string) => {
    const ms = await members(r.id);
    return {
      id: r.id, title: r.title, category: r.category, language: r.language_code, status: r.status, maxSpeakers: r.max_speakers,
      members: ms.map((m) => ({ id: m.user_id, displayName: m.display_name, avatarId: m.avatar_id, role: m.role,
        handRaised: !!m.hand_raised_at, isCompanion: m.user_role === "companion" })),
      me: ms.find((m) => m.user_id === userId)?.role ?? null,
    };
  };
  const memberOf = async (roomId: string, userId: string) => (await db.query<{ role: "host" | "speaker" | "listener" }>(
    `SELECT role FROM voice_room_members WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL`, [roomId, userId])).rows[0];
  const joinResult = async (r: RoomRow, userId: string, role: string) => ({
    room: await state(r, userId), liveKitUrl: app.deps.liveKitUrl, livekitRoom: r.livekit_room,
    token: await rooms.joinToken(r.livekit_room, userId, { canPublish: role !== "listener" }),
  });

  app.get("/room-categories", {
    preHandler: auth,
    schema: { ...base, summary: "Room categories (All + these)", response: { 200: z.array(z.object({ code: z.string(), name: z.string() })) } },
  }, async () => (await db.query<{ code: string; name: string }>(
    `SELECT code, name FROM room_categories WHERE is_active ORDER BY sort_order`)).rows);

  app.get("/rooms", {
    preHandler: auth,
    schema: {
      ...base,
      summary: "Live rooms, biggest first (optionally one category / language)",
      querystring: z.object({ category: z.string().optional(), language: z.string().optional() }),
      response: { 200: z.array(RoomCard) },
    },
  }, async (req) => {
    const rows = (await db.query<{ id: string; title: string; category: string; category_name: string; language_code: string;
      host_id: string; host_name: string; host_avatar: number; listeners: number; faces: { id: string; displayName: string; avatarId: number }[];
      created_at: Date }>(
      `SELECT r.id, r.title, r.category, c.name AS category_name, r.language_code, r.created_at,
              h.id AS host_id, h.display_name AS host_name, h.avatar_id AS host_avatar,
              (SELECT count(*) FROM voice_room_members m WHERE m.room_id = r.id AND m.left_at IS NULL)::int AS listeners,
              COALESCE((SELECT json_agg(json_build_object('id', u.id, 'displayName', u.display_name, 'avatarId', u.avatar_id))
                          FROM (SELECT u.* FROM voice_room_members m JOIN users u ON u.id = m.user_id
                                 WHERE m.room_id = r.id AND m.left_at IS NULL
                                 ORDER BY CASE m.role WHEN 'host' THEN 0 WHEN 'speaker' THEN 1 ELSE 2 END LIMIT 3) u), '[]') AS faces
         FROM voice_rooms r JOIN room_categories c ON c.code = r.category JOIN users h ON h.id = r.host_id
        WHERE r.status = 'live' AND ($1::text IS NULL OR r.category = $1) AND ($2::text IS NULL OR r.language_code = $2)
          AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = $3 AND b.blocked_id = r.host_id) OR (b.blocker_id = r.host_id AND b.blocked_id = $3))
        ORDER BY listeners DESC, r.created_at DESC LIMIT 100`,
      [req.query.category ?? null, req.query.language ?? null, me(req).userId])).rows;
    return rows.map((r) => ({
      id: r.id, title: r.title, category: r.category, categoryName: r.category_name, language: r.language_code,
      host: { id: r.host_id, displayName: r.host_name, avatarId: r.host_avatar }, listeners: r.listeners, faces: r.faces, createdAt: r.created_at,
    }));
  });

  app.post("/rooms", {
    preHandler: requireAuth("companion"),
    schema: {
      ...base,
      summary: "Start a room (approved companions; one live room at a time)",
      body: z.object({ title: z.string().trim().min(3).max(60), category: z.string(), language: z.string() }),
      response: { 201: Join },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    if (checkMessage(req.body.title)) throw new ApiError(400, "TITLE_BLOCKED", "Keep contact details and payments out of the title");
    const r = await tx(db, async (c) => {
      const ok = (await c.query(`SELECT 1 FROM companion_profiles p JOIN users u ON u.id = p.user_id
                                  WHERE p.user_id = $1 AND p.kyc_status = 'approved' AND u.status = 'active'`, [userId])).rowCount;
      if (!ok) throw new ApiError(403, "KYC_NOT_APPROVED", "Finish verification before hosting a room");
      const cat = (await c.query(`SELECT 1 FROM room_categories WHERE code = $1 AND is_active`, [req.body.category])).rowCount;
      if (!cat) throw new ApiError(400, "CATEGORY_UNKNOWN", "Pick one of the categories");
      const lang = (await c.query(`SELECT 1 FROM languages WHERE code = $1 AND is_active`, [req.body.language])).rowCount;
      if (!lang) throw new ApiError(400, "LANGUAGE_UNSUPPORTED", "That language is not available yet");
      const existing = (await c.query(`SELECT 1 FROM voice_rooms WHERE host_id = $1 AND status = 'live'`, [userId])).rowCount;
      if (existing) throw conflict("ALREADY_HOSTING", "You already have a live room");
      const room = (await c.query<RoomRow>(
        `INSERT INTO voice_rooms (host_id, title, category, language_code, livekit_room)
         VALUES ($1, $2, $3, $4, 'vroom_' || gen_random_uuid()) RETURNING *`,
        [userId, req.body.title, req.body.category, req.body.language])).rows[0]!;
      await c.query(`INSERT INTO voice_room_members (room_id, user_id, role) VALUES ($1, $2, 'host')`, [room.id, userId]);
      return room;
    });
    // Tell people who favourited this companion (at most every 30 min).
    if (await redis.set(`room:notified:${userId}`, "1", "EX", ROOM_NOTIFY_COOLDOWN_S, "NX")) {
      const host = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!;
      const fans = (await db.query<{ user_id: string }>(`SELECT user_id FROM favourites WHERE companion_id = $1 AND notify`, [userId])).rows;
      for (const f of fans) {
        await notify(app.deps, f.user_id, { type: "room_live", title: `${host.display_name} started a room`, body: r.title, data: { roomId: r.id } });
      }
    }
    reply.status(201);
    return joinResult(r, userId, "host");
  });

  app.post("/rooms/:id/join", {
    preHandler: auth,
    schema: { ...base, summary: "Join as a listener (free). Rejoining keeps your role.", params: z.object({ id: z.uuid() }), response: { 200: Join } },
  }, async (req) => {
    const userId = me(req).userId;
    const r = await loadRoom(req.params.id);
    if (r.status !== "live") throw new ApiError(410, "ROOM_ENDED", "This room has ended");
    const blocked = (await db.query(
      `SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`, [userId, r.host_id])).rowCount;
    if (blocked) throw forbidden("ROOM_BLOCKED");
    const row = (await db.query<{ role: string; fresh: boolean }>(
      `INSERT INTO voice_room_members (room_id, user_id, role) VALUES ($1, $2, 'listener')
       ON CONFLICT (room_id, user_id) DO UPDATE SET left_at = NULL, last_seen_at = now(),
         role = CASE WHEN voice_room_members.left_at IS NULL THEN voice_room_members.role ELSE 'listener' END
       RETURNING role, (xmax = 0) AS fresh`, [r.id, userId])).rows[0]!;
    const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
    await broadcast(r.id, { kind: "join", userId, displayName: name });
    return joinResult(r, userId, row.role);
  });

  app.get("/rooms/:id", {
    preHandler: auth,
    schema: { ...base, summary: "Current stage and members", params: z.object({ id: z.uuid() }), response: { 200: RoomState } },
  }, async (req) => state(await loadRoom(req.params.id), me(req).userId));

  app.post("/rooms/:id/heartbeat", {
    preHandler: auth,
    schema: { ...base, summary: "Still here (every 30 s)", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    await db.query(`UPDATE voice_room_members SET last_seen_at = now() WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL`,
      [req.params.id, me(req).userId]);
    return reply.status(204).send(null);
  });

  app.post("/rooms/:id/leave", {
    preHandler: auth,
    schema: { ...base, summary: "Leave. When the host leaves, the room ends.", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const r = await loadRoom(req.params.id);
    await db.query(`UPDATE voice_room_members SET left_at = now(), hand_raised_at = NULL WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL`,
      [r.id, userId]);
    if (r.host_id === userId && r.status === "live") {
      await db.query(`UPDATE voice_rooms SET status = 'ended', ended_at = now(), end_reason = 'host_ended' WHERE id = $1`, [r.id]);
      await rooms.closeRoom(r.livekit_room).catch(() => {});
      await broadcastTo(db, events, r.id, { kind: "ended" }, true);
    } else {
      await broadcast(r.id, { kind: "leave", userId });
    }
    return reply.status(204).send(null);
  });

  app.post("/rooms/:id/hand", {
    preHandler: auth,
    schema: { ...base, summary: "Raise or lower your hand to speak", params: z.object({ id: z.uuid() }), body: z.object({ raised: z.boolean() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const m = await memberOf(req.params.id, userId);
    if (!m) throw forbidden("NOT_IN_ROOM");
    if (m.role !== "listener") throw new ApiError(400, "ALREADY_ON_STAGE", "You're already on stage");
    await db.query(`UPDATE voice_room_members SET hand_raised_at = $3 WHERE room_id = $1 AND user_id = $2`,
      [req.params.id, userId, req.body.raised ? new Date() : null]);
    await broadcast(req.params.id, { kind: "hand", userId, raised: req.body.raised });
    return reply.status(204).send(null);
  });

  app.post("/rooms/:id/stage/:userId", {
    preHandler: requireAuth("companion"),
    schema: {
      ...base,
      summary: "Host: bring someone on stage, or move a speaker back to listening. They then fetch a new token.",
      params: z.object({ id: z.uuid(), userId: z.uuid() }),
      body: z.object({ action: z.enum(["invite", "remove"]) }),
      response: { 200: RoomState },
    },
  }, async (req) => {
    const hostId = me(req).userId;
    const r = await loadRoom(req.params.id);
    if (r.host_id !== hostId) throw forbidden("NOT_THE_HOST");
    const target = await memberOf(r.id, req.params.userId);
    if (!target || target.role === "host") throw notFound("MEMBER_NOT_FOUND");
    if (req.body.action === "invite") {
      const speakers = (await db.query<{ n: number }>(
        `SELECT count(*)::int AS n FROM voice_room_members WHERE room_id = $1 AND left_at IS NULL AND role IN ('host', 'speaker')`, [r.id])).rows[0]!.n;
      if (target.role !== "speaker" && speakers >= r.max_speakers) throw conflict("STAGE_FULL", `The stage is full (${r.max_speakers})`);
    }
    const role = req.body.action === "invite" ? "speaker" : "listener";
    await db.query(`UPDATE voice_room_members SET role = $3, hand_raised_at = NULL WHERE room_id = $1 AND user_id = $2`, [r.id, req.params.userId, role]);
    await broadcast(r.id, { kind: "role", userId: req.params.userId, role });
    return state(r, hostId);
  });

  app.post("/rooms/:id/token", {
    preHandler: auth,
    schema: { ...base, summary: "A fresh LiveKit token for your current role (after moving on/off stage)", params: z.object({ id: z.uuid() }),
      response: { 200: z.object({ token: z.string(), role: z.enum(["host", "speaker", "listener"]) }) } },
  }, async (req) => {
    const userId = me(req).userId;
    const r = await loadRoom(req.params.id);
    const m = await memberOf(r.id, userId);
    if (!m || r.status !== "live") throw forbidden("NOT_IN_ROOM");
    return { role: m.role, token: await rooms.joinToken(r.livekit_room, userId, { canPublish: m.role !== "listener" }) };
  });

  app.post("/rooms/:id/messages", {
    preHandler: auth,
    schema: { ...base, summary: "Say something in the room feed (safety-filtered; one message every 2 s)", params: z.object({ id: z.uuid() }),
      body: z.object({ body: z.string().trim().min(1).max(200) }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    if (!(await memberOf(req.params.id, userId))) throw forbidden("NOT_IN_ROOM");
    const reason = checkMessage(req.body.body);
    if (reason) throw new ApiError(422, "MESSAGE_BLOCKED", BLOCK_MESSAGES[reason]);
    if (await rateLimited(redis, `room:msg:${req.params.id}:${userId}`, 2)) throw new ApiError(429, "TOO_FAST", "Slow down a little");
    const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
    await broadcast(req.params.id, { kind: "chat", userId, displayName: name, body: req.body.body });
    return reply.status(204).send(null);
  });

  app.post("/rooms/:id/react", {
    preHandler: auth,
    schema: { ...base, summary: "Send a reaction", params: z.object({ id: z.uuid() }),
      // A plain string (not an enum): the Dart generator can't name emoji enum values.
      body: z.object({ emoji: z.string().refine((e) => REACTIONS.includes(e), "Not a reaction").describe(REACTIONS.join(" ")) }),
      response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    if (!(await memberOf(req.params.id, userId))) throw forbidden("NOT_IN_ROOM");
    if (!(await rateLimited(redis, `room:react:${req.params.id}:${userId}`, 1))) {
      await broadcast(req.params.id, { kind: "reaction", userId, emoji: req.body.emoji });
    }
    return reply.status(204).send(null);
  });

  app.post("/rooms/:id/gifts", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Send a gift to a companion on stage (same prices and companion share as call gifts)",
      params: z.object({ id: z.uuid() }),
      body: z.object({ giftId: z.number().int(), toUserId: z.uuid(), clientRef: z.uuid() }),
      response: { 201: z.object({ coinsLeft: z.number().int() }) },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const { giftId, toUserId, clientRef } = req.body;
    const r = await loadRoom(req.params.id);
    if (r.status !== "live") throw new ApiError(410, "ROOM_ENDED", "This room has ended");
    if (!(await memberOf(r.id, userId))) throw forbidden("NOT_IN_ROOM");
    const to = (await db.query<{ role: string; display_name: string; member_role: string }>(
      `SELECT u.role, u.display_name, m.role AS member_role FROM voice_room_members m JOIN users u ON u.id = m.user_id
        WHERE m.room_id = $1 AND m.user_id = $2 AND m.left_at IS NULL`, [r.id, toUserId])).rows[0];
    if (!to || to.member_role === "listener" || to.role !== "companion") {
      throw new ApiError(400, "GIFT_RECEIVER_INVALID", "Gifts go to a companion on stage");
    }
    const gift = (await db.query<{ id: number; name: string; emoji: string; coins: number }>(
      `SELECT id, name, emoji, coins FROM gifts WHERE id = $1 AND is_active`, [giftId])).rows[0];
    if (!gift) throw notFound("GIFT_NOT_FOUND");
    const paise = await giftPaise(db, gift.coins);
    const result = await tx(db, async (c) => {
      const ins = await c.query<{ id: string }>(
        `INSERT INTO voice_room_gifts (room_id, sender_id, receiver_id, gift_id, coins, paise_credited, client_ref)
         VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (client_ref) DO NOTHING RETURNING id`,
        [r.id, userId, toUserId, gift.id, gift.coins, paise, clientRef]);
      const bal = async () => (await c.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [userId])).rows[0]?.balance ?? 0;
      if (!ins.rowCount) return { duplicate: true, coinsLeft: await bal() };
      const id = ins.rows[0]!.id;
      const left = await post(c, userId, "coins", "gift_debit", -gift.coins, `roomgift:${id}:debit`, { note: `${gift.name} gift in a voice room` });
      if (left === null) throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${gift.coins} coins for a ${gift.name}`);
      if (paise > 0) await post(c, toUserId, "earnings", "gift_credit", paise, `roomgift:${id}:credit`, { note: `${gift.name} gift in a voice room` });
      return { duplicate: false, coinsLeft: left };
    });
    if (!result.duplicate) {
      const from = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
      await broadcast(r.id, { kind: "gift", userId, displayName: from, toUserId, toName: to.display_name, gift: { name: gift.name, emoji: gift.emoji } });
    }
    reply.status(201);
    return { coinsLeft: result.coinsLeft };
  });

  // --- admin ---------------------------------------------------------------------
  app.get("/admin/rooms", {
    preHandler: can("rooms.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "Live voice rooms", response: { 200: z.array(RoomCard) } },
  }, async () => (await db.query<{ id: string; title: string; category: string; category_name: string; language_code: string; host_id: string;
    host_name: string; host_avatar: number; listeners: number; created_at: Date }>(
    `SELECT r.id, r.title, r.category, c.name AS category_name, r.language_code, r.created_at, h.id AS host_id, h.display_name AS host_name,
            h.avatar_id AS host_avatar, (SELECT count(*) FROM voice_room_members m WHERE m.room_id = r.id AND m.left_at IS NULL)::int AS listeners
       FROM voice_rooms r JOIN room_categories c ON c.code = r.category JOIN users h ON h.id = r.host_id
      WHERE r.status = 'live' ORDER BY r.created_at DESC`)).rows.map((r) => ({
    id: r.id, title: r.title, category: r.category, categoryName: r.category_name, language: r.language_code,
    host: { id: r.host_id, displayName: r.host_name, avatarId: r.host_avatar }, listeners: r.listeners, faces: [], createdAt: r.created_at,
  })));

  app.post("/admin/rooms/:id/end", {
    preHandler: can("rooms.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "End a room now (moderation)", params: z.object({ id: z.uuid() }),
      body: z.object({ reason: z.string().trim().min(3).max(500) }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const r = await loadRoom(req.params.id);
    if (r.status !== "live") throw conflict("ROOM_ENDED", "Already ended");
    await tx(db, async (c) => {
      await c.query(`UPDATE voice_rooms SET status = 'ended', ended_at = now(), end_reason = 'admin' WHERE id = $1`, [r.id]);
      await c.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, 'room.end', 'room', $2, $3)`,
        [me(req).userId, r.id, JSON.stringify({ reason: req.body.reason, hostId: r.host_id })]);
    });
    await rooms.closeRoom(r.livekit_room).catch(() => {});
    await broadcastTo(db, events, r.id, { kind: "ended" }, true);
    return reply.status(204).send(null);
  });
};
