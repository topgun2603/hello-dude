/**
 * Chat (design: Chat.dc.html). Free, 1:1, only between a caller and a companion
 * who have had a connected call; blocked pairs can't chat. Messages pass the
 * safety filter (chat-filter.ts). Calls between the pair appear in the thread.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, forbidden, notFound } from "../errors.js";
import { ONLINE_SET } from "../billing/engine.js";
import { BLOCK_MESSAGES, checkMessage } from "../chat-filter.js";
import { notify } from "../notifications.js";

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

/** Blocks the pair must not have, and the call they need to have had. */
const ELIGIBLE = `
  u_caller.status = 'active' AND u_comp.status = 'active'
  AND EXISTS (SELECT 1 FROM calls x WHERE x.caller_id = cv.caller_id AND x.companion_id = cv.companion_id AND x.started_at IS NOT NULL)
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
      summary: "Open the chat with someone (created on first use). Needs a connected call between you and no blocks.",
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
    const talked = (await db.query(`SELECT 1 FROM calls WHERE caller_id = $1 AND companion_id = $2 AND started_at IS NOT NULL LIMIT 1`,
      [callerId, companionId])).rowCount;
    if (!talked) throw new ApiError(403, "CHAT_NEEDS_CALL", "You can message someone after your first call together");
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
    const reason = checkMessage(req.body.body);
    if (reason) {
      await db.query(`INSERT INTO chat_violations (conversation_id, sender_id, reason) VALUES ($1, $2, $3)`, [cv.id, userId, reason]);
      throw new ApiError(422, "MESSAGE_BLOCKED", BLOCK_MESSAGES[reason]);
    }
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
};
