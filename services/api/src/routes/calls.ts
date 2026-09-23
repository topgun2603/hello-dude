import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { FastifyBaseLogger } from "fastify";
import { tx } from "../db/pool.js";
import type { AppDeps } from "../app.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, conflict, forbidden, notFound } from "../errors.js";
import { CallError, type CallType, type StartedCall } from "../billing/engine.js";
import { findOnlineCompanions } from "./companions.js";
import { LanguageCode } from "./profile.js";
import { RefundRequest } from "./refunds.js";

const CallTypeZ = z.enum(["audio", "video"]);
const CallIdParams = z.object({ id: z.uuid() });

const JoinInfo = z.object({
  callId: z.uuid(),
  liveKitUrl: z.string(),
  room: z.string(),
  token: z.string().describe("LiveKit join token for this user only"),
  coinsPerMin: z.number().int(),
}).meta({ id: "JoinInfo" });

const Party = z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int() }).meta({ id: "Party" });

const CallSummary = z.object({
  id: z.uuid(),
  type: CallTypeZ,
  status: z.enum(["ringing", "active", "ended", "missed", "rejected", "failed"]),
  direction: z.enum(["outgoing", "incoming"]).describe("outgoing = I was the caller"),
  other: Party,
  language: z.string(),
  coinsPerMin: z.number().int(),
  createdAt: z.date(),
  startedAt: z.date().nullable(),
  endedAt: z.date().nullable(),
  endReason: z.string().nullable(),
  durationSeconds: z.number().int().nullable(),
  minutesCharged: z.number().int(),
  coinsCharged: z.number().int(),
  coinsRefunded: z.number().int(),
  paiseEarned: z.number().int().describe("Companion side: earnings after any reversal"),
  myRating: z.number().int().nullable(),
}).meta({ id: "CallSummary" });

const CallDetails = CallSummary.extend({
  gifts: z.array(z.object({ name: z.string(), emoji: z.string(), coins: z.number().int(), paise: z.number().int(), at: z.date() })),
  refundRequest: RefundRequest.nullable(),
  minutes: z.array(z.object({
    minuteNo: z.number().int(),
    coins: z.number().int(),
    paise: z.number().int(),
    chargedAt: z.date(),
  })),
}).meta({ id: "CallDetails" });

interface CallRow {
  id: string; type: CallType; status: z.infer<typeof CallSummary>["status"]; caller_id: string; companion_id: string;
  language_code: string; coins_per_min: number; created_at: Date; started_at: Date | null; ended_at: Date | null;
  end_reason: string | null; minutes_charged: number; coins_charged: number; paise_credited: number;
  other_id: string; other_name: string; other_avatar: number; refunded: number; reversed: number; my_rating: number | null;
}

const CALL_SELECT = `
  SELECT c.id, c.type, c.status, c.caller_id, c.companion_id, c.language_code, c.coins_per_min,
         c.created_at, c.started_at, c.ended_at, c.end_reason, c.minutes_charged, c.coins_charged, c.paise_credited,
         o.id AS other_id, o.display_name AS other_name, o.avatar_id AS other_avatar,
         COALESCE((SELECT sum(amount) FROM ledger_entries WHERE call_id = c.id AND type = 'refund'), 0)::bigint AS refunded,
         COALESCE((SELECT -sum(amount) FROM ledger_entries WHERE call_id = c.id AND type = 'refund_reversal'), 0)::bigint AS reversed,
         (SELECT stars FROM call_ratings WHERE call_id = c.id AND rater_id = $1) AS my_rating
    FROM calls c JOIN users o ON o.id = CASE WHEN c.caller_id = $1 THEN c.companion_id ELSE c.caller_id END
   WHERE (c.caller_id = $1 OR c.companion_id = $1)`;

function toSummary(r: CallRow, userId: string): z.infer<typeof CallSummary> {
  return {
    id: r.id,
    type: r.type,
    status: r.status,
    direction: r.caller_id === userId ? "outgoing" : "incoming",
    other: { id: r.other_id, displayName: r.other_name, avatarId: r.other_avatar },
    language: r.language_code,
    coinsPerMin: r.coins_per_min,
    createdAt: r.created_at,
    startedAt: r.started_at,
    endedAt: r.ended_at,
    endReason: r.end_reason,
    durationSeconds: r.started_at && r.ended_at
      ? Math.round((r.ended_at.getTime() - r.started_at.getTime()) / 1000) : null,
    minutesCharged: r.minutes_charged,
    coinsCharged: r.coins_charged,
    coinsRefunded: r.refunded,
    paiseEarned: r.paise_credited - r.reversed,
    myRating: r.my_rating,
  };
}

async function notifyCompanion(deps: AppDeps, log: FastifyBaseLogger, callerId: string, companionId: string,
                               callId: string, type: CallType): Promise<void> {
  try {
    const [caller, devices] = await Promise.all([
      deps.db.query<{ display_name: string; avatar_id: number }>(
        `SELECT display_name, avatar_id FROM users WHERE id = $1`, [callerId]),
      deps.db.query<{ fcm_token: string }>(`SELECT fcm_token FROM devices WHERE user_id = $1`, [companionId]),
    ]);
    const callerName = caller.rows[0]?.display_name ?? "";
    const callerAvatarId = caller.rows[0]?.avatar_id ?? 1;
    // Foreground apps ring from the WebSocket event; the push wakes a sleeping phone.
    await deps.events.publish(companionId, {
      t: "incoming_call", callId, callType: type,
      caller: { id: callerId, displayName: callerName, avatarId: callerAvatarId },
    });
    await deps.push.incomingCall(devices.rows.map((d) => d.fcm_token), {
      callId, callType: type, callerName, callerAvatarId,
    });
  } catch (err) {
    // The call still rings over the WebSocket; the sweeper times it out if nobody answers.
    log.error({ err, callId }, "incoming-call push failed");
  }
}

export const callRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, engine, rooms, liveKitUrl } = app.deps;

  const joinInfo = (s: StartedCall) => ({
    callId: s.callId, liveKitUrl, room: s.room, token: s.callerToken, coinsPerMin: s.coinsPerMin,
  });

  async function loadCall(callId: string, userId: string): Promise<CallRow> {
    const row = (await db.query<CallRow>(`${CALL_SELECT} AND c.id = $2`, [userId, callId])).rows[0];
    if (!row) throw notFound("CALL_NOT_FOUND");
    return row;
  }

  app.post("/calls", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Call a specific companion. Nothing is charged until both sides join.",
      body: z.object({ companionId: z.uuid(), type: CallTypeZ }),
      response: { 201: JoinInfo },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    const started = await engine.startCall(userId, req.body.companionId, req.body.type);
    await notifyCompanion(app.deps, req.log, userId, req.body.companionId, started.callId, req.body.type);
    reply.status(201);
    return joinInfo(started);
  });

  app.post("/calls/match", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Instant match: ring a free online companion who speaks the language",
      body: z.object({ language: LanguageCode, type: CallTypeZ }),
      response: { 201: JoinInfo.extend({ companion: Party }) },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    const { language, type } = req.body;
    const free = (await findOnlineCompanions(app.deps, userId, language, { video: type === "video" }))
      .filter((c) => !c.busy);
    // Spread calls across the best-rated half instead of always ringing the top companion.
    const pool = free.slice(0, Math.max(3, Math.ceil(free.length / 2)));
    for (const c of pool.sort(() => Math.random() - 0.5)) {
      try {
        const started = await engine.startCall(userId, c.id, type);
        await notifyCompanion(app.deps, req.log, userId, c.id, started.callId, type);
        reply.status(201);
        return { ...joinInfo(started), companion: { id: c.id, displayName: c.displayName, avatarId: c.avatarId } };
      } catch (e) {
        // Someone else got this companion first, or they just went offline: try the next.
        if (e instanceof CallError && (e.code === "BUSY" || e.code === "OFFLINE")) continue;
        throw e;
      }
    }
    throw new ApiError(404, "NO_COMPANION_AVAILABLE", "Nobody is free right now, try again in a minute");
  });

  app.post("/calls/:id/accept", {
    preHandler: requireAuth("companion"),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Companion answers a ringing call and gets their join token",
      params: CallIdParams,
      response: { 200: JoinInfo },
    },
  }, async (req) => {
    const { userId } = me(req);
    const call = await loadCall(req.params.id, userId);
    if (call.companion_id !== userId) throw forbidden("NOT_YOUR_CALL");
    if (call.status !== "ringing") throw conflict("CALL_NOT_RINGING", "This call has already ended");
    const room = (await db.query<{ room_name: string }>(`SELECT room_name FROM calls WHERE id = $1`, [call.id])).rows[0]!;
    await app.deps.events.publish(call.caller_id, { t: "call_accepted", callId: call.id });
    return {
      callId: call.id, liveKitUrl, room: room.room_name,
      token: await rooms.joinToken(room.room_name, userId), coinsPerMin: call.coins_per_min,
    };
  });

  app.post("/calls/:id/reject", {
    preHandler: requireAuth("companion"),
    schema: { tags: ["calls"], security: bearer, params: CallIdParams, response: { 204: z.null() } },
  }, async (req, reply) => {
    const { userId } = me(req);
    const call = await loadCall(req.params.id, userId);
    if (call.companion_id !== userId) throw forbidden("NOT_YOUR_CALL");
    if (call.status === "ringing") await engine.endCall(call.id, "companion_reject");
    return reply.status(204).send(null);
  });

  app.post("/calls/:id/end", {
    preHandler: requireAuth(),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Hang up (either side). Safe to repeat.",
      params: CallIdParams,
      response: { 200: CallSummary },
    },
  }, async (req) => {
    const { userId } = me(req);
    const call = await loadCall(req.params.id, userId);
    await engine.endCall(call.id, call.caller_id === userId ? "caller_hangup" : "companion_hangup");
    return toSummary(await loadCall(call.id, userId), userId);
  });

  app.get("/calls", {
    preHandler: requireAuth(),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Call history, newest first. Page with `before` = createdAt of the last call seen.",
      querystring: z.object({
        before: z.coerce.date().optional(),
        limit: z.coerce.number().int().min(1).max(50).default(20),
      }),
      response: { 200: z.object({ calls: z.array(CallSummary), nextBefore: z.date().nullable() }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    const { before, limit } = req.query;
    const rows = (await db.query<CallRow>(
      `${CALL_SELECT} AND ($2::timestamptz IS NULL OR c.created_at < $2) ORDER BY c.created_at DESC LIMIT $3`,
      [userId, before ?? null, limit],
    )).rows;
    return {
      calls: rows.map((r) => toSummary(r, userId)),
      nextBefore: rows.length === limit ? rows[rows.length - 1]!.created_at : null,
    };
  });

  app.get("/calls/:id", {
    preHandler: requireAuth(),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Call details: every billed minute, refunds included",
      params: CallIdParams,
      response: { 200: CallDetails },
    },
  }, async (req) => {
    const { userId } = me(req);
    const call = await loadCall(req.params.id, userId);
    const minutes = (await db.query<{ minute_no: number; coins_charged: number; paise_credited: number; charged_at: Date }>(
      `SELECT minute_no, coins_charged, paise_credited, charged_at FROM call_ticks WHERE call_id = $1 ORDER BY minute_no`,
      [call.id],
    )).rows;
    const isCaller = call.caller_id === userId;
    const [gifts, refund] = await Promise.all([
      db.query<{ name: string; emoji: string; coins: number; paise_credited: number; created_at: Date }>(
        `SELECT g.name, g.emoji, cg.coins, cg.paise_credited, cg.created_at FROM call_gifts cg JOIN gifts g ON g.id = cg.gift_id
          WHERE cg.call_id = $1 ORDER BY cg.created_at`, [call.id]),
      isCaller ? db.query(`SELECT * FROM refund_requests WHERE call_id = $1`, [call.id]) : Promise.resolve({ rows: [] }),
    ]);
    const rr = refund.rows[0];
    return {
      ...toSummary(call, userId),
      gifts: gifts.rows.map((g) => ({ name: g.name, emoji: g.emoji, coins: isCaller ? g.coins : 0,
        paise: isCaller ? 0 : g.paise_credited, at: g.created_at })),
      refundRequest: rr ? { id: rr.id, status: rr.status, reason: rr.reason, coinsEligible: rr.coins_eligible,
        coinsRefunded: rr.coins_refunded, note: rr.note, createdAt: rr.created_at } : null,
      // Each side only sees their own money: coins for the caller, paise for the companion.
      minutes: minutes.map((m) => ({
        minuteNo: m.minute_no,
        coins: isCaller ? m.coins_charged : 0,
        paise: isCaller ? 0 : m.paise_credited,
        chargedAt: m.charged_at,
      })),
    };
  });

  app.post("/calls/:id/rating", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Rate a finished call (once)",
      params: CallIdParams,
      body: z.object({ stars: z.number().int().min(1).max(5) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    const call = await loadCall(req.params.id, userId);
    if (call.caller_id !== userId) throw forbidden("NOT_YOUR_CALL");
    if (call.status !== "ended" || !call.started_at) throw conflict("CALL_NOT_RATEABLE", "Only connected calls can be rated");
    await tx(db, async (c) => {
      const ins = await c.query(
        `INSERT INTO call_ratings (call_id, rater_id, stars) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING`,
        [call.id, userId, req.body.stars],
      );
      if (!ins.rowCount) throw conflict("ALREADY_RATED", "You already rated this call");
      await c.query(
        `UPDATE companion_profiles SET rating_sum = rating_sum + $2, rating_count = rating_count + 1 WHERE user_id = $1`,
        [call.companion_id, req.body.stars],
      );
    });
    return reply.status(204).send(null);
  });
};
