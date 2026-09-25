/**
 * PK battles (owner, 2026-09-25). A live host invites another live host; if she
 * accepts, both lives show side by side for pk.seconds (5 min). Score = gift coins
 * sent to each host (from either live) during the battle; more wins a "PK winner"
 * badge. Viewers get a listen-only token for the other live's room and still pay
 * only for their own live. Updates go to both lives as `live_event` kinds
 * pk_invite / pk_started / pk_score / pk_ended.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type Db, type DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, conflict, forbidden, notFound } from "../errors.js";
import type { RoomControl, UserEvents } from "../billing/ports.js";
import { numberSetting } from "../settings.js";
import { broadcastLive } from "./lives.js";

const INVITE_EXPIRES_S = 30;
type Deps = { db: Db; events: UserEvents; rooms: RoomControl };

type BattleRow = {
  id: string; live_a: string; live_b: string; host_a: string; host_b: string; status: string; seconds: number;
  started_at: Date | null; ends_at: Date | null; score_a: number; score_b: number; winner_host: string | null;
};

/** Gift coins to each host during the battle (from any live). */
async function liveScores(db: Db | DbClient, b: BattleRow) {
  const r = (await db.query<{ a: number; b: number }>(
    `SELECT COALESCE(sum(coins) FILTER (WHERE receiver_id = $1), 0)::int AS a, COALESCE(sum(coins) FILTER (WHERE receiver_id = $2), 0)::int AS b
       FROM live_gifts WHERE live_id IN ($3, $4) AND created_at >= $5 AND created_at < COALESCE($6, now())`,
    [b.host_a, b.host_b, b.live_a, b.live_b, b.started_at, b.ends_at])).rows[0]!;
  return { a: r.a, b: r.b };
}

async function toBoth(deps: Deps, b: BattleRow, event: Record<string, unknown>) {
  await broadcastLive(deps.db, deps.events, b.live_a, event);
  await broadcastLive(deps.db, deps.events, b.live_b, event);
}

/** Called after a gift in a live: push the new score if that live is in a battle. */
export async function onLiveGift(deps: Deps, liveId: string) {
  const b = (await deps.db.query<BattleRow>(
    `SELECT * FROM pk_battles WHERE status = 'active' AND (live_a = $1 OR live_b = $1)`, [liveId])).rows[0];
  if (!b) return;
  const s = await liveScores(deps.db, b);
  await toBoth(deps, b, { kind: "pk_score", battleId: b.id, scoreA: s.a, scoreB: s.b });
}

/** Ends a battle: final score, winner badge, tell both lives. */
async function finish(deps: Deps, battleId: string, reason: string) {
  const b = await tx(deps.db, async (c) => {
    const row = (await c.query<BattleRow>(`SELECT * FROM pk_battles WHERE id = $1 AND status = 'active' FOR UPDATE`, [battleId])).rows[0];
    if (!row) return null;
    const end = new Date(Math.min(Date.now(), row.ends_at!.getTime()));
    const s = await liveScores(c, { ...row, ends_at: end });
    const winner = s.a === s.b ? null : s.a > s.b ? row.host_a : row.host_b;
    await c.query(`UPDATE pk_battles SET status = 'ended', ends_at = $2, score_a = $3, score_b = $4, winner_host = $5 WHERE id = $1`,
      [battleId, end, s.a, s.b, winner]);
    if (winner) {
      await c.query(
        `INSERT INTO user_badges (user_id, kind, rank, label, period_start, expires_at) VALUES ($1, 'pk_win', NULL, 'PK winner', $2, now() + interval '24 hours')
         ON CONFLICT DO NOTHING`, [winner, row.started_at]);
    }
    return { ...row, score_a: s.a, score_b: s.b, winner_host: winner };
  });
  if (!b) return false;
  await toBoth(deps, b, { kind: "pk_ended", battleId: b.id, scoreA: b.score_a, scoreB: b.score_b, winnerHostId: b.winner_host, reason });
  return true;
}

/** Worker, every 10 s: finish battles whose time is up (or whose live ended); expire unanswered invites. */
export async function sweepBattles(deps: Deps): Promise<number> {
  await deps.db.query(`UPDATE pk_battles SET status = 'expired' WHERE status = 'invited' AND created_at < now() - make_interval(secs => $1)`,
    [INVITE_EXPIRES_S]);
  const due = (await deps.db.query<{ id: string; reason: string }>(
    `SELECT b.id, CASE WHEN b.ends_at <= now() THEN 'time' ELSE 'live_ended' END AS reason
       FROM pk_battles b JOIN lives la ON la.id = b.live_a JOIN lives lb ON lb.id = b.live_b
      WHERE b.status = 'active' AND (b.ends_at <= now() OR la.status <> 'live' OR lb.status <> 'live')`)).rows;
  let n = 0;
  for (const d of due) if (await finish(deps, d.id, d.reason)) n++;
  return n;
}

const Side = z.object({
  liveId: z.uuid(), hostId: z.uuid(), hostName: z.string(), avatarId: z.number().int(), score: z.number().int(),
}).meta({ id: "PkSide" });
const Battle = z.object({
  id: z.uuid(), status: z.enum(["invited", "active", "ended", "declined", "expired", "cancelled"]),
  a: Side, b: Side, endsAt: z.date().nullable(), winnerHostId: z.uuid().nullable(),
}).meta({ id: "PkBattle" });

export const pkRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, rooms } = app.deps;
  const deps: Deps = { db, events: app.deps.events, rooms };
  const base = { tags: ["lives"], security: bearer };
  const host = requireAuth("companion");

  const load = async (id: string) => {
    const b = (await db.query<BattleRow>(`SELECT * FROM pk_battles WHERE id = $1`, [id])).rows[0];
    if (!b) throw notFound("BATTLE_NOT_FOUND");
    return b;
  };
  const view = async (b: BattleRow) => {
    const hosts = new Map((await db.query<{ id: string; display_name: string; avatar_id: number }>(
      `SELECT id, display_name, avatar_id FROM users WHERE id IN ($1, $2)`, [b.host_a, b.host_b])).rows.map((u) => [u.id, u]));
    const s = b.status === "active" ? await liveScores(db, b) : { a: b.score_a, b: b.score_b };
    const side = (liveId: string, hostId: string, score: number) => ({
      liveId, hostId, hostName: hosts.get(hostId)!.display_name, avatarId: hosts.get(hostId)!.avatar_id, score,
    });
    return {
      id: b.id, status: b.status as z.infer<typeof Battle>["status"], a: side(b.live_a, b.host_a, s.a), b: side(b.live_b, b.host_b, s.b),
      endsAt: b.ends_at, winnerHostId: b.winner_host,
    };
  };

  app.post("/lives/:id/pk", {
    preHandler: host,
    schema: {
      ...base,
      summary: "Host: challenge another live host to a 5-minute PK battle (she has 30 s to accept)",
      params: z.object({ id: z.uuid() }),
      body: z.object({ opponentLiveId: z.uuid() }),
      response: { 201: Battle },
    },
  }, async (req, reply) => {
    const meId = me(req).userId;
    const lives = (await db.query<{ id: string; host_id: string; status: string }>(
      `SELECT id, host_id, status FROM lives WHERE id IN ($1, $2)`, [req.params.id, req.body.opponentLiveId])).rows;
    const mine = lives.find((l) => l.id === req.params.id), theirs = lives.find((l) => l.id === req.body.opponentLiveId);
    if (!mine || !theirs) throw notFound("LIVE_NOT_FOUND");
    if (mine.host_id !== meId) throw forbidden("NOT_THE_HOST");
    if (mine.status !== "live" || theirs.status !== "live" || theirs.host_id === meId) throw conflict("NOT_LIVE", "Both of you need to be live");
    if ((await db.query(`SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`,
      [meId, theirs.host_id])).rowCount) throw forbidden("BLOCKED");
    const seconds = await numberSetting(db, "pk.seconds", 300);
    let b: BattleRow;
    try {
      b = (await db.query<BattleRow>(
        `INSERT INTO pk_battles (live_a, live_b, host_a, host_b, seconds) VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [mine.id, theirs.id, meId, theirs.host_id, seconds])).rows[0]!;
    } catch (e) {
      if ((e as { code?: string }).code === "23505") throw conflict("IN_BATTLE", "One of you is already in a battle");
      throw e;
    }
    const v = await view(b);
    await app.deps.events.publish(theirs.host_id, { t: "live_event", liveId: theirs.id, event: { kind: "pk_invite", battle: v } }).catch(() => {});
    reply.status(201);
    return v;
  });

  const answer = (accept: boolean) => async (req: { params: { id: string } } & Parameters<typeof me>[0]) => {
    const b = await load(req.params.id);
    if (b.host_b !== me(req).userId) throw forbidden("NOT_INVITED");
    if (b.status !== "invited" || Date.now() - (await db.query<{ t: Date }>(`SELECT created_at AS t FROM pk_battles WHERE id = $1`, [b.id])).rows[0]!.t.getTime()
      > INVITE_EXPIRES_S * 1000) throw conflict("INVITE_OVER", "This challenge is no longer open");
    const updated = (await db.query<BattleRow>(
      accept
        ? `UPDATE pk_battles SET status = 'active', started_at = now(), ends_at = now() + make_interval(secs => seconds) WHERE id = $1 AND status = 'invited' RETURNING *`
        : `UPDATE pk_battles SET status = 'declined' WHERE id = $1 AND status = 'invited' RETURNING *`, [b.id])).rows[0];
    if (!updated) throw conflict("INVITE_OVER", "This challenge is no longer open");
    const v = await view(updated);
    if (accept) await toBoth(deps, updated, { kind: "pk_started", battle: v });
    else await app.deps.events.publish(b.host_a, { t: "live_event", liveId: b.live_a, event: { kind: "pk_declined", battleId: b.id } }).catch(() => {});
    return v;
  };

  app.post("/pk/:id/accept", {
    preHandler: host,
    schema: { ...base, summary: "Accept a PK challenge: the battle starts now", params: z.object({ id: z.uuid() }), response: { 200: Battle } },
  }, answer(true));

  app.post("/pk/:id/decline", {
    preHandler: host,
    schema: { ...base, summary: "Decline a PK challenge", params: z.object({ id: z.uuid() }), response: { 200: Battle } },
  }, answer(false));

  app.get("/pk/:id", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      ...base,
      summary: "A battle with live scores, plus a listen-only token for the other side's room (hosts and viewers of either live)",
      params: z.object({ id: z.uuid() }),
      querystring: z.object({ fromLiveId: z.uuid().describe("The live you're in") }),
      response: { 200: z.object({ battle: Battle, other: z.object({ liveKitUrl: z.string(), livekitRoom: z.string(), token: z.string() }).nullable() }) },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const b = await load(req.params.id);
    const { fromLiveId } = req.query;
    if (fromLiveId !== b.live_a && fromLiveId !== b.live_b) throw forbidden("NOT_IN_BATTLE");
    const inLive = userId === b.host_a || userId === b.host_b ||
      !!(await db.query(`SELECT 1 FROM live_viewers WHERE live_id = $1 AND user_id = $2 AND left_at IS NULL`, [fromLiveId, userId])).rowCount;
    if (!inLive) throw forbidden("NOT_IN_BATTLE");
    const otherLive = fromLiveId === b.live_a ? b.live_b : b.live_a;
    const room = (await db.query<{ livekit_room: string }>(`SELECT livekit_room FROM lives WHERE id = $1`, [otherLive])).rows[0]!.livekit_room;
    return {
      battle: await view(b),
      other: b.status === "active"
        ? { liveKitUrl: app.deps.liveKitUrl, livekitRoom: room, token: await rooms.joinToken(room, `${userId}:pk`, { canPublish: false }) }
        : null,
    };
  });

  app.post("/pk/:id/end", {
    preHandler: host,
    schema: { ...base, summary: "Either host: end the battle early (current score decides)", params: z.object({ id: z.uuid() }),
      response: { 204: z.null() } },
  }, async (req, reply) => {
    const b = await load(req.params.id);
    if (b.host_a !== me(req).userId && b.host_b !== me(req).userId) throw forbidden("NOT_IN_BATTLE");
    if (b.status === "invited") await db.query(`UPDATE pk_battles SET status = 'cancelled' WHERE id = $1 AND status = 'invited'`, [b.id]);
    else if (b.status === "active") await finish(deps, b.id, "host_ended");
    else throw new ApiError(409, "BATTLE_OVER", "This battle is already over");
    return reply.status(204).send(null);
  });
};
