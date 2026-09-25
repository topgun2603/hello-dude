/**
 * Chat (design: Chat.dc.html). Free, 1:1, between a caller and a companion who
 * have had a connected call — or whose message request she accepted (owner,
 * 2026-09-24); blocked pairs can't chat. Messages pass the safety filter and
 * strikes (chat-safety.ts). Calls between the pair appear in the thread.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, forbidden, notFound } from "../errors.js";
import { ONLINE_SET } from "../billing/engine.js";
import { assertChatOpen, screenMessage } from "../chat-safety.js";
import { tx } from "../db/pool.js";
import { notify } from "../notifications.js";
import { numberSetting } from "../settings.js";

const Party = z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int(), role: z.enum(["caller", "companion"]), online: z.boolean() });

const Conversation = z.object({
  id: z.uuid(),
  other: Party,
  lastMessage: z.string().nullable(),
  lastMessageAt: z.date().nullable(),
  unread: z.number().int(),
  canMessage: z.boolean(),
}).meta({ id: "Conversation" });

const ThreadItem = z.object({
  kind: z.enum(["message", "call"]),
  id: z.string().describe("message id, or call id for call entries"),
  senderId: z.uuid().nullable(),
  body: z.string().nullable(),
  callType: z.enum(["audio", "video"]).nullable(),
  callMinutes: z.number().int().nullable(),
  at: z.date(),
}).meta({ id: "ChatItem" });

/** Blocks the pair must not have, and the call (or accepted request) they need to have had. */
const ELIGIBLE = `
  u_caller.status = 'active' AND u_comp.status = 'active'
  AND (EXISTS (SELECT 1 FROM calls x WHERE x.caller_id = cv.caller_id AND x.companion_id = cv.companion_id AND x.started_at IS NOT NULL)
       OR EXISTS (SELECT 1 FROM chat_requests q WHERE q.caller_id = cv.caller_id AND q.companion_id = cv.companion_id AND q.status = 'accepted'))
  AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = cv.caller_id AND b.blocked_id = cv.companion_id)
                                          OR (b.blocker_id = cv.companion_id AND b.blocked_id = cv.caller_id))`;

export const chatRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis } = app.deps;
  const base = { tags: ["chat"], security: bearer };
  const auth = requireAuth("caller", "companion");

  /** The conversation if this user is in it, with which side they are. */
  async function load(conversationId: string, userId: string) {
    const cv = (await db.query<{ id: string; caller_id: string; companion_id: string; eligible: boolean }>(
      `SELECT cv.id, cv.caller_id, cv.companion_id, (${ELIGIBLE}) AS eligible
         FROM conversations cv JOIN users u_caller ON u_caller.id = cv.caller_id JOIN users u_comp ON u_comp.id = cv.companion_id
        WHERE cv.id = $1`, [conversationId])).rows[0];
    if (!cv) throw notFound("CONVERSATION_NOT_FOUND");
    if (cv.caller_id !== userId && cv.companion_id !== userId) throw forbidden("NOT_YOUR_CONVERSATION");
    return { ...cv, asCaller: cv.caller_id === userId, otherId: cv.caller_id === userId ? cv.companion_id : cv.caller_id };
  }

  app.get("/chats", {
    preHandler: auth,
    schema: { ...base, summary: "My conversations, most recent first, with unread counts", response: { 200: z.object({ items: z.array(Conversation), unread: z.number().int() }) } },
  }, async (req) => {
    const userId = me(req).userId;
    const rows = (await db.query<{ id: string; other_id: string; other_name: string; other_avatar: number; other_role: "caller" | "companion";
      last_body: string | null; last_message_at: Date | null; unread: number; eligible: boolean }>(
      `SELECT cv.id, o.id AS other_id, o.display_name AS other_name, o.avatar_id AS other_avatar, o.role AS other_role,
              (SELECT body FROM messages m WHERE m.conversation_id = cv.id ORDER BY m.id DESC LIMIT 1) AS last_body,
              cv.last_message_at,
              (SELECT count(*) FROM messages m WHERE m.conversation_id = cv.id AND m.sender_id <> $1
                 AND m.created_at > COALESCE(CASE WHEN cv.caller_id = $1 THEN cv.caller_last_read_at ELSE cv.companion_last_read_at END, 'epoch'))::int AS unread,
              (${ELIGIBLE}) AS eligible
         FROM conversations cv
         JOIN users u_caller ON u_caller.id = cv.caller_id JOIN users u_comp ON u_comp.id = cv.companion_id
         JOIN users o ON o.id = CASE WHEN cv.caller_id = $1 THEN cv.companion_id ELSE cv.caller_id END
        WHERE (cv.caller_id = $1 OR cv.companion_id = $1) AND cv.last_message_at IS NOT NULL
        ORDER BY cv.last_message_at DESC LIMIT 200`, [userId])).rows;
    const online = new Set(await redis.smembers(ONLINE_SET));
    const items = rows.map((r) => ({
      id: r.id, other: { id: r.other_id, displayName: r.other_name, avatarId: r.other_avatar, role: r.other_role, online: online.has(r.other_id) },
      lastMessage: r.last_body, lastMessageAt: r.last_message_at, unread: r.unread, canMessage: r.eligible,
    }));
    return { items, unread: items.reduce((n, i) => n + i.unread, 0) };
  });

  app.post("/chats/with/:userId", {
    preHandler: auth,
    schema: {
      ...base,
      summary: "Open the chat with someone (created on first use). Needs a connected call or an accepted message request, and no blocks. " +
        "A caller without either gets CHAT_NEEDS_REQUEST: send one with POST /chats/requests.",
      params: z.object({ userId: z.uuid() }),
      response: { 200: Conversation },
    },
  }, async (req) => {
    const meId = me(req).userId;
    const other = (await db.query<{ id: string; role: string }>(`SELECT id, role FROM users WHERE id = $1 AND status <> 'deleted'`,
      [req.params.userId])).rows[0];
    if (!other) throw notFound("USER_NOT_FOUND");
    const myRole = me(req).role;
    if (!((myRole === "caller" && other.role === "companion") || (myRole === "companion" && other.role === "caller"))) {
      throw new ApiError(400, "CHAT_NOT_ALLOWED", "Chat is between a caller and a companion");
    }
    const [callerId, companionId] = myRole === "caller" ? [meId, other.id] : [other.id, meId];
    const talked = (await db.query(
      `SELECT 1 FROM calls WHERE caller_id = $1 AND companion_id = $2 AND started_at IS NOT NULL
       UNION ALL SELECT 1 FROM chat_requests WHERE caller_id = $1 AND companion_id = $2 AND status = 'accepted' LIMIT 1`,
      [callerId, companionId])).rowCount;
    if (!talked) {
      throw myRole === "caller"
        ? new ApiError(403, "CHAT_NEEDS_REQUEST", "Send a message request first — she can accept it, or you can call her")
        : new ApiError(403, "CHAT_NEEDS_CALL", "You can message a caller after your first call together");
    }
    const blocked = (await db.query(
      `SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`, [callerId, companionId])).rowCount;
    if (blocked) throw new ApiError(403, "CHAT_BLOCKED", "You can't message this person");
    const id = (await db.query<{ id: string }>(
      `INSERT INTO conversations (caller_id, companion_id) VALUES ($1, $2)
       ON CONFLICT (caller_id, companion_id) DO UPDATE SET caller_id = EXCLUDED.caller_id RETURNING id`, [callerId, companionId])).rows[0]!.id;
    const o = (await db.query<{ display_name: string; avatar_id: number; role: "caller" | "companion" }>(
      `SELECT display_name, avatar_id, role FROM users WHERE id = $1`, [other.id])).rows[0]!;
    return {
      id, other: { id: other.id, displayName: o.display_name, avatarId: o.avatar_id, role: o.role, online: (await redis.sismember(ONLINE_SET, other.id)) === 1 },
      lastMessage: null, lastMessageAt: null, unread: 0, canMessage: true,
    };
  });

  app.get("/chats/:id/messages", {
    preHandler: auth,
    schema: {
      ...base,
      summary: "The thread: messages and calls between you, newest first (page with ?before=<ISO time>)",
      params: z.object({ id: z.uuid() }),
      querystring: z.object({ before: z.coerce.date().optional(), limit: z.coerce.number().int().min(1).max(100).default(50) }),
      response: { 200: z.object({ items: z.array(ThreadItem), canMessage: z.boolean() }) },
    },
  }, async (req) => {
    const cv = await load(req.params.id, me(req).userId);
    const before = req.query.before ?? new Date(Date.now() + 60_000);
    const rows = (await db.query<{ kind: "message" | "call"; id: string; sender_id: string | null; body: string | null;
      call_type: "audio" | "video" | null; minutes: number | null; at: Date }>(
      `(SELECT 'message' AS kind, m.id::text AS id, m.sender_id, m.body, NULL::call_type AS call_type, NULL::int AS minutes, m.created_at AS at
          FROM messages m WHERE m.conversation_id = $1 AND m.created_at < $3)
       UNION ALL
       (SELECT 'call', c.id::text, c.caller_id, NULL, c.type, GREATEST(1, EXTRACT(EPOCH FROM (c.ended_at - c.started_at))::int / 60), c.started_at
          FROM calls c WHERE c.caller_id = $2 AND c.companion_id = $4 AND c.started_at IS NOT NULL AND c.ended_at IS NOT NULL AND c.started_at < $3)
       ORDER BY at DESC LIMIT $5`, [cv.id, cv.caller_id, before, cv.companion_id, req.query.limit])).rows;
    return {
      canMessage: cv.eligible,
      items: rows.map((r) => ({ kind: r.kind, id: r.id, senderId: r.sender_id, body: r.body, callType: r.call_type, callMinutes: r.minutes, at: r.at })),
    };
  });

  app.post("/chats/:id/messages", {
    preHandler: auth,
    schema: {
      ...base,
      summary: "Send a message. Phone numbers, UPI IDs and payment or contact-app requests are refused (MESSAGE_BLOCKED).",
      params: z.object({ id: z.uuid() }),
      body: z.object({ body: z.string().trim().min(1).max(1000), clientRef: z.uuid() }),
      response: { 201: ThreadItem },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const cv = await load(req.params.id, userId);
    if (!cv.eligible) throw new ApiError(403, "CHAT_CLOSED", "You can't message this person any more");
    // Filter + strikes (pause after repeated attempts); throws MESSAGE_BLOCKED / CHAT_PAUSED.
    await screenMessage(db, userId, req.body.body, { conversationId: cv.id });
    // A retried send (same clientRef) returns the original message.
    const inserted = (await db.query<{ id: string; created_at: Date; fresh: boolean }>(
      `WITH ins AS (
         INSERT INTO messages (conversation_id, sender_id, body, client_ref) VALUES ($1, $2, $3, $4)
         ON CONFLICT (client_ref) DO NOTHING RETURNING id, created_at)
       SELECT id::text, created_at, true AS fresh FROM ins
       UNION ALL SELECT id::text, created_at, false FROM messages WHERE client_ref = $4 AND NOT EXISTS (SELECT 1 FROM ins)`,
      [cv.id, userId, req.body.body, req.body.clientRef])).rows[0]!;
    if (inserted.fresh) {
      await db.query(
        `UPDATE conversations SET last_message_at = $2,
                caller_last_read_at = CASE WHEN caller_id = $3 THEN $2 ELSE caller_last_read_at END,
                companion_last_read_at = CASE WHEN companion_id = $3 THEN $2 ELSE companion_last_read_at END
          WHERE id = $1`, [cv.id, inserted.created_at, userId]);
      await app.deps.events.publish(cv.otherId, {
        t: "chat_message", conversationId: cv.id,
        message: { id: Number(inserted.id), senderId: userId, body: req.body.body, createdAt: inserted.created_at.toISOString() },
      });
      // One buzz per conversation every 2 minutes; the chat screen shows the rest live.
      if (await redis.set(`chatpush:${cv.id}:${cv.otherId}`, "1", "EX", 120, "NX")) {
        const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
        await notify(app.deps, cv.otherId, {
          type: "chat_message", title: name, body: req.body.body.length > 80 ? `${req.body.body.slice(0, 80)}…` : req.body.body,
          data: { conversationId: cv.id },
        }, { inbox: false });
      }
    }
    reply.status(201);
    return { kind: "message" as const, id: inserted.id, senderId: userId, body: req.body.body, callType: null, callMinutes: null, at: inserted.created_at };
  });

  app.post("/chats/:id/read", {
    preHandler: auth,
    schema: { ...base, summary: "Mark the conversation read up to now", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const cv = await load(req.params.id, me(req).userId);
    await db.query(`UPDATE conversations SET ${cv.asCaller ? "caller_last_read_at" : "companion_last_read_at"} = now() WHERE id = $1`, [cv.id]);
    return reply.status(204).send(null);
  });

  // --- message requests (a caller who hasn't called her yet) -------------------------
  const Request = z.object({
    id: z.uuid(),
    other: Party,
    body: z.string(),
    status: z.enum(["pending", "accepted", "declined"]),
    createdAt: z.date(),
    conversationId: z.uuid().nullable().describe("Set once accepted"),
  }).meta({ id: "ChatRequest" });

  type ReqRow = { id: string; caller_id: string; companion_id: string; body: string; status: "pending" | "accepted" | "declined";
    created_at: Date; other_id: string; other_name: string; other_avatar: number; other_role: "caller" | "companion"; conversation_id: string | null };
  const requestRows = async (where: string, args: unknown[], viewer: string) => (await db.query<ReqRow>(
    `SELECT q.*, o.id AS other_id, o.display_name AS other_name, o.avatar_id AS other_avatar, o.role AS other_role,
            (SELECT id FROM conversations cv WHERE cv.caller_id = q.caller_id AND cv.companion_id = q.companion_id) AS conversation_id
       FROM chat_requests q JOIN users o ON o.id = CASE WHEN q.caller_id = $1 THEN q.companion_id ELSE q.caller_id END
      WHERE ${where} ORDER BY q.created_at DESC LIMIT 100`, [viewer, ...args])).rows;
  const toRequest = async (r: ReqRow) => ({
    id: r.id, body: r.body, status: r.status, createdAt: r.created_at,
    conversationId: r.status === "accepted" ? r.conversation_id : null,
    other: { id: r.other_id, displayName: r.other_name, avatarId: r.other_avatar, role: r.other_role,
      online: (await redis.sismember(ONLINE_SET, r.other_id)) === 1 },
  });

  app.post("/chats/requests", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Send a companion you haven't called yet one message request (she accepts or declines). Same safety filter and strikes as chat; " +
        "a few a day; after a decline you can ask again in 7 days.",
      body: z.object({ companionId: z.uuid(), body: z.string().trim().min(1).max(300) }),
      response: { 201: Request },
    },
  }, async (req, reply) => {
    const callerId = me(req).userId;
    const { companionId, body } = req.body;
    const c = (await db.query<{ ok: boolean }>(
      `SELECT (u.role = 'companion' AND u.status = 'active' AND p.kyc_status = 'approved') AS ok
         FROM users u JOIN companion_profiles p ON p.user_id = u.id WHERE u.id = $1`, [companionId])).rows[0];
    if (!c?.ok) throw notFound("COMPANION_NOT_FOUND");
    if ((await db.query(`SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`,
      [callerId, companionId])).rowCount) throw new ApiError(403, "CHAT_BLOCKED", "You can't message this person");
    if ((await db.query(
      `SELECT 1 FROM calls WHERE caller_id = $1 AND companion_id = $2 AND started_at IS NOT NULL
       UNION ALL SELECT 1 FROM chat_requests WHERE caller_id = $1 AND companion_id = $2 AND status = 'accepted' LIMIT 1`,
      [callerId, companionId])).rowCount) throw new ApiError(409, "CHAT_OPEN", "You can already chat — open the chat");
    if ((await db.query(`SELECT 1 FROM chat_requests WHERE caller_id = $1 AND companion_id = $2 AND status = 'pending'`,
      [callerId, companionId])).rowCount) throw new ApiError(409, "REQUEST_PENDING", "Your request is waiting for her answer");
    const retryDays = await numberSetting(db, "chat.request_retry_days", 7);
    if ((await db.query(
      `SELECT 1 FROM chat_requests WHERE caller_id = $1 AND companion_id = $2 AND status = 'declined'
          AND decided_at > now() - make_interval(days => $3)`, [callerId, companionId, retryDays])).rowCount) {
      throw new ApiError(409, "REQUEST_DECLINED", `She didn't accept your last request. You can ask again after ${retryDays} days, or call her.`);
    }
    const perDay = await numberSetting(db, "chat.requests_per_day", 5);
    const today = (await db.query<{ n: number }>(
      `SELECT count(*)::int AS n FROM chat_requests WHERE caller_id = $1 AND created_at > now() - interval '24 hours'`, [callerId])).rows[0]!.n;
    if (today >= perDay) throw new ApiError(429, "REQUEST_LIMIT", `You can send ${perDay} message requests a day`);
    await screenMessage(db, callerId, body);
    const id = (await db.query<{ id: string }>(
      `INSERT INTO chat_requests (caller_id, companion_id, body) VALUES ($1, $2, $3) RETURNING id`, [callerId, companionId, body])).rows[0]!.id;
    const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [callerId])).rows[0]!.display_name;
    await notify(app.deps, companionId, {
      type: "chat_request", title: `${name} wants to chat`, body: body.length > 80 ? `${body.slice(0, 80)}…` : body, data: { requestId: id },
    });
    reply.status(201);
    return toRequest((await requestRows(`q.id = $2`, [id], callerId))[0]!);
  });

  app.get("/chats/requests", {
    preHandler: auth,
    schema: {
      ...base,
      summary: "Companions: requests waiting for an answer. Callers: the requests they sent (last 30 days).",
      response: { 200: z.object({ items: z.array(Request) }) },
    },
  }, async (req) => {
    const { userId, role } = me(req);
    const rows = role === "companion"
      ? await requestRows(`q.companion_id = $1 AND q.status = 'pending'
          AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = q.caller_id AND b.blocked_id = q.companion_id)
                                                OR (b.blocker_id = q.companion_id AND b.blocked_id = q.caller_id))`, [], userId)
      : await requestRows(`q.caller_id = $1 AND q.created_at > now() - interval '30 days'`, [], userId);
    return { items: await Promise.all(rows.map(toRequest)) };
  });

  const decide = async (requestId: string, companionId: string, accept: boolean) => {
    const r = (await db.query<{ caller_id: string; companion_id: string; body: string; status: string; created_at: Date }>(
      `SELECT caller_id, companion_id, body, status, created_at FROM chat_requests WHERE id = $1`, [requestId])).rows[0];
    if (!r || r.companion_id !== companionId) throw notFound("REQUEST_NOT_FOUND");
    if (r.status !== "pending") throw new ApiError(409, "REQUEST_DECIDED", "You already answered this request");
    return r;
  };

  app.post("/chats/requests/:id/accept", {
    preHandler: requireAuth("companion"),
    schema: {
      ...base,
      summary: "Accept: the chat opens with their request as the first message",
      params: z.object({ id: z.uuid() }),
      response: { 200: Conversation },
    },
  }, async (req) => {
    const companionId = me(req).userId;
    const r = await decide(req.params.id, companionId, true);
    await assertChatOpen(db, companionId);
    const conversationId = await tx(db, async (c) => {
      const upd = await c.query(`UPDATE chat_requests SET status = 'accepted', decided_at = now() WHERE id = $1 AND status = 'pending'`, [req.params.id]);
      if (!upd.rowCount) throw new ApiError(409, "REQUEST_DECIDED", "You already answered this request");
      const id = (await c.query<{ id: string }>(
        `INSERT INTO conversations (caller_id, companion_id) VALUES ($1, $2)
         ON CONFLICT (caller_id, companion_id) DO UPDATE SET caller_id = EXCLUDED.caller_id RETURNING id`, [r.caller_id, companionId])).rows[0]!.id;
      await c.query(`INSERT INTO messages (conversation_id, sender_id, body, client_ref, created_at) VALUES ($1, $2, $3, $4, $5)`,
        [id, r.caller_id, r.body, req.params.id, r.created_at]);
      await c.query(`UPDATE conversations SET last_message_at = now(), companion_last_read_at = now() WHERE id = $1`, [id]);
      return id;
    });
    const name = (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [companionId])).rows[0]!.display_name;
    await notify(app.deps, r.caller_id, {
      type: "chat_request_accepted", title: `${name} accepted your message`, body: "You can chat now.", data: { conversationId },
    });
    const o = (await db.query<{ display_name: string; avatar_id: number }>(
      `SELECT display_name, avatar_id FROM users WHERE id = $1`, [r.caller_id])).rows[0]!;
    return {
      id: conversationId, other: { id: r.caller_id, displayName: o.display_name, avatarId: o.avatar_id, role: "caller" as const,
        online: (await redis.sismember(ONLINE_SET, r.caller_id)) === 1 },
      lastMessage: r.body, lastMessageAt: new Date(), unread: 0, canMessage: true,
    };
  });

  app.post("/chats/requests/:id/decline", {
    preHandler: requireAuth("companion"),
    schema: { ...base, summary: "Decline (they aren't told directly; they can ask again after 7 days)", params: z.object({ id: z.uuid() }),
      response: { 204: z.null() } },
  }, async (req, reply) => {
    await decide(req.params.id, me(req).userId, false);
    await db.query(`UPDATE chat_requests SET status = 'declined', decided_at = now() WHERE id = $1 AND status = 'pending'`, [req.params.id]);
    return reply.status(204).send(null);
  });
};
