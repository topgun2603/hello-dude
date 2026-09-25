/**
 * Group video. A companion hosts up to `max_members` callers, everyone on camera.
 * Instant groups open a lobby now; scheduled groups take free seat bookings and
 * the host opens the lobby near the time. Nobody pays in the lobby — when enough
 * members are waiting the group goes live and every member pays per minute
 * (prepaid, like 1:1 calls), charged by the server only while LiveKit shows them
 * in the room (sweepGroups). The group ends when too few members remain, the host
 * leaves, or it runs past the maximum length. Updates go out as `group_event`.
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
import { notify } from "../notifications.js";
import { goOffline } from "../presence.js";
import type { PushSender } from "../push.js";
import { numberSetting } from "../settings.js";
import { giftPaise } from "./gifts.js";
import { base64File } from "./companion.js";
import { REACTIONS } from "./rooms.js";
import { PHOTO_V_SQL, photoUrl } from "./photos.js";

const HOST_STALE_S = 60;     // host app heartbeats every 15 s
const MEMBER_STALE_S = 60;   // members heartbeat every 20 s
const FEW_GRACE_S = 60;      // too few members for this long ends the group
const FLAG_COOLDOWN_S = 30;
const MAX_FRAME_BYTES = 400 * 1024;
const REMIND_BEFORE_MIN = 10;
const OPEN_EARLY_MIN = 15;   // a scheduled lobby can open this long before the time
const SCHEDULE_DAYS = 7;

type Deps = { db: Db; events: UserEvents; rooms: RoomControl; push: PushSender };
type Status = "scheduled" | "lobby" | "live" | "ended";

export async function groupSettings(db: Db | DbClient) {
  const n = (k: string, d: number) => numberSetting(db, k, d);
  const [coinsPerMin, shareBps, coinValue, minMembers, maxMembers, endBelow, lobbyTimeoutMin, maxMin, noShowMin] = await Promise.all([
    n("group.coins_per_min", 12), n("group.companion_share_bps", 2500), n("coin.value_paise", 80),
    n("group.min_members", 3), n("group.max_members", 10), n("group.end_below", 2),
    n("group.lobby_timeout_minutes", 10), n("group.max_minutes", 120), n("group.no_show_minutes", 15),
  ]);
  return {
    coinsPerMin, minMembers, maxMembers, endBelow, lobbyTimeoutMin, maxMin, noShowMin,
    /** Companion earnings for one member-minute. */
    paisePerMin: Math.round((coinsPerMin * coinValue * shareBps) / 10_000),
  };
}

type GroupRow = {
  id: string; host_id: string; title: string; language_code: string; status: Status; scheduled_at: Date | null;
  lobby_at: Date | null; started_at: Date | null; ended_at: Date | null; end_reason: string | null; livekit_room: string;
  coins_per_min: number; paise_per_min: number; min_members: number; max_members: number; few_since: Date | null;
};

/**
 * Charges `memberId` the next minute at the group's frozen price: coins from the
 * member, the companion's share to the host, one group_ticks row (its primary key
 * blocks a double charge). Returns the balance after, or null if they can't pay.
 */
async function chargeMinute(c: DbClient, g: GroupRow, memberId: string) {
  const m = (await c.query<{ minutes_charged: number }>(
    `SELECT minutes_charged FROM group_members WHERE session_id = $1 AND user_id = $2 FOR UPDATE`, [g.id, memberId])).rows[0];
  if (!m) return null;
  const minute = m.minutes_charged + 1;
  const left = await post(c, memberId, "coins", "group_debit", -g.coins_per_min, `group:${g.id}:${memberId}:${minute}`,
    { groupId: g.id, note: `Group video, minute ${minute}` });
  if (left === null) return null;
  if (g.paise_per_min > 0) {
    await post(c, g.host_id, "earnings", "group_credit", g.paise_per_min, `group:${g.id}:${memberId}:${minute}:credit`,
      { groupId: g.id, note: `Group video, minute ${minute}` });
  }
  await c.query(`INSERT INTO group_ticks (session_id, member_id, minute_no, coins, paise) VALUES ($1, $2, $3, $4, $5)`,
    [g.id, memberId, minute, g.coins_per_min, g.paise_per_min]);
  await c.query(`UPDATE group_members SET minutes_charged = $3, last_charged_at = now() WHERE session_id = $1 AND user_id = $2`,
    [g.id, memberId, minute]);
  return left;
}

/** Members in the lobby or the room right now (not just booked). */
const IN_GROUP = `joined_at IS NOT NULL AND left_at IS NULL`;

async function broadcast(db: Db | DbClient, events: UserEvents, groupId: string, event: Record<string, unknown>) {
  const ids = (await db.query<{ user_id: string }>(
    `SELECT user_id FROM group_members WHERE session_id = $1 AND left_at IS NULL
     UNION SELECT host_id FROM group_sessions WHERE id = $1`, [groupId])).rows;
  await Promise.all(ids.map((m) => events.publish(m.user_id, { t: "group_event", groupId, event }).catch(() => {})));
}
const toUser = (events: UserEvents, userId: string, groupId: string, event: Record<string, unknown>) =>
  events.publish(userId, { t: "group_event", groupId, event }).catch(() => {});

async function removeMember(deps: Deps, g: GroupRow, userId: string, state: string) {
  await deps.db.query(`UPDATE group_members SET left_at = now(), paying = false WHERE session_id = $1 AND user_id = $2`, [g.id, userId]);
  await deps.rooms.removeParticipant(g.livekit_room, userId).catch(() => {});
  await toUser(deps.events, userId, g.id, { kind: "removed", state });
}

async function endGroup(deps: Deps, groupId: string, reason: string) {
  const ended = (await deps.db.query<{ livekit_room: string; status_before: Status; title: string; host_id: string }>(
    `UPDATE group_sessions g SET status = 'ended', ended_at = now(), end_reason = $2
       FROM (SELECT id, status AS status_before FROM group_sessions WHERE id = $1 FOR UPDATE) old
      WHERE g.id = old.id AND g.status <> 'ended'
      RETURNING g.livekit_room, old.status_before, g.title, g.host_id`, [groupId, reason])).rows[0];
  if (!ended) return false;
  await broadcast(deps.db, deps.events, groupId, { kind: "ended", reason });
  // Seats booked for a group that never ran: tell them it's off.
  if (ended.status_before === "scheduled" || ended.status_before === "lobby") {
    const booked = (await deps.db.query<{ user_id: string }>(
      `SELECT user_id FROM group_members WHERE session_id = $1 AND left_at IS NULL`, [groupId])).rows;
    for (const b of booked) {
      await notify(deps, b.user_id, {
        type: "group_cancelled", title: "Group video cancelled",
        body: `"${ended.title}" didn't start. You weren't charged.`, data: { groupId },
      });
    }
  }
  await deps.db.query(`UPDATE group_members SET left_at = now(), paying = false WHERE session_id = $1 AND left_at IS NULL`, [groupId]);
  await deps.rooms.closeRoom(ended.livekit_room).catch(() => {});
  return true;
}

/** Ends a companion's open groups (e.g. when an admin suspends them). */
export async function endGroupsOf(deps: Deps, hostId: string, reason: string) {
  const open = (await deps.db.query<{ id: string }>(
    `SELECT id FROM group_sessions WHERE host_id = $1 AND status <> 'ended'`, [hostId])).rows;
  for (const g of open) await endGroup(deps, g.id, reason);
}

/**
 * The lobby has enough members: go live and charge everyone waiting their first
 * minute. Members who can't pay are removed. Returns false if it wasn't ready.
 */
async function startIfReady(deps: Deps, groupId: string) {
  const g = await tx(deps.db, async (c) => {
    const g = (await c.query<GroupRow>(`SELECT * FROM group_sessions WHERE id = $1 FOR UPDATE`, [groupId])).rows[0];
    if (!g || g.status !== "lobby") return null;
    const waiting = (await c.query<{ n: number }>(
      `SELECT count(*)::int AS n FROM group_members WHERE session_id = $1 AND ${IN_GROUP}`, [groupId])).rows[0]!.n;
    if (waiting < g.min_members) return null;
    await c.query(`UPDATE group_sessions SET status = 'live', started_at = now() WHERE id = $1`, [groupId]);
    return { ...g, status: "live" as const };
  });
  if (!g) return false;
  const members = (await deps.db.query<{ user_id: string }>(
    `SELECT user_id FROM group_members WHERE session_id = $1 AND ${IN_GROUP}`, [groupId])).rows;
  for (const m of members) {
    const left = await tx(deps.db, (c) => chargeMinute(c, g, m.user_id));
    if (left === null) await removeMember(deps, g, m.user_id, "no_coins");
    else await toUser(deps.events, m.user_id, g.id, { kind: "charged", minute: 1, coinsLeft: left });
  }
  await broadcast(deps.db, deps.events, groupId, { kind: "started" });
  return true;
}

/**
 * Worker, every 10 s: reminders and host no-shows for scheduled groups; lobbies
 * that waited too long; stale hosts and members; the maximum length; per-minute
 * charges for members LiveKit reports in the room; and ending groups that have
 * had too few members for a while.
 */
export async function sweepGroups(deps: Deps): Promise<{ ended: number; removed: number; charged: number }> {
  const { db, rooms, events } = deps;
  const s = await groupSettings(db);
  let ended = 0, removed = 0, charged = 0;

  // Scheduled: remind the host and booked members shortly before.
  const soon = (await db.query<{ id: string; host_id: string; title: string }>(
    `UPDATE group_sessions SET reminded_at = now()
      WHERE status = 'scheduled' AND reminded_at IS NULL AND scheduled_at <= now() + make_interval(mins => $1)
      RETURNING id, host_id, title`, [REMIND_BEFORE_MIN])).rows;
  for (const g of soon) {
    const booked = (await db.query<{ user_id: string }>(
      `SELECT user_id FROM group_members WHERE session_id = $1 AND left_at IS NULL`, [g.id])).rows;
    for (const u of [{ user_id: g.host_id }, ...booked]) {
      await notify(deps, u.user_id, {
        type: "group_reminder", title: "Group video starts soon",
        body: u.user_id === g.host_id ? `Open the lobby for "${g.title}"` : `"${g.title}" starts in ${REMIND_BEFORE_MIN} minutes`,
        data: { groupId: g.id },
      });
    }
  }
  const noShow = (await db.query<{ id: string }>(
    `SELECT id FROM group_sessions WHERE status = 'scheduled' AND scheduled_at < now() - make_interval(mins => $1)`, [s.noShowMin])).rows;
  for (const g of noShow) if (await endGroup(deps, g.id, "host_no_show")) ended++;

  const lobbyOver = (await db.query<{ id: string }>(
    `SELECT id FROM group_sessions WHERE status = 'lobby' AND lobby_at < now() - make_interval(mins => $1)`, [s.lobbyTimeoutMin])).rows;
  for (const g of lobbyOver) if (await endGroup(deps, g.id, "not_enough_members")) ended++;

  const stale = (await db.query<{ id: string }>(
    `SELECT id FROM group_sessions WHERE status IN ('lobby', 'live') AND host_seen_at < now() - make_interval(secs => $1)`,
    [HOST_STALE_S])).rows;
  for (const g of stale) if (await endGroup(deps, g.id, "host_lost")) ended++;

  const tooLong = (await db.query<{ id: string }>(
    `SELECT id FROM group_sessions WHERE status = 'live' AND started_at < now() - make_interval(mins => $1)`, [s.maxMin])).rows;
  for (const g of tooLong) if (await endGroup(deps, g.id, "time_limit")) ended++;

  await db.query(
    `UPDATE group_members m SET left_at = now(), paying = false
       FROM group_sessions g
      WHERE g.id = m.session_id AND g.status IN ('lobby', 'live') AND m.joined_at IS NOT NULL AND m.left_at IS NULL
        AND m.last_seen_at < now() - make_interval(secs => $1)`, [MEMBER_STALE_S]);

  const live = (await db.query<GroupRow>(`SELECT * FROM group_sessions WHERE status = 'live'`)).rows;
  for (const g of live) {
    const inRoom = (await rooms.participantIdentities(g.livekit_room)).filter((id) => id !== g.host_id);
    let present = 0;
    for (const userId of inRoom) {
      const m = (await db.query<{ paying: boolean; in_group: boolean; due: boolean; minutes: number }>(
        `SELECT paying, (${IN_GROUP}) AS in_group, minutes_charged AS minutes,
                (last_charged_at IS NULL OR last_charged_at <= now() - interval '60 seconds') AS due
           FROM group_members WHERE session_id = $1 AND user_id = $2`, [g.id, userId])).rows[0];
      if (!m?.paying || !m.in_group) {
        await rooms.removeParticipant(g.livekit_room, userId).catch(() => {});
        removed++;
        continue;
      }
      if (!m.due) { present++; continue; }
      const left = await tx(db, (c) => chargeMinute(c, g, userId));
      if (left === null) {
        await removeMember(deps, g, userId, "no_coins");
        removed++;
        continue;
      }
      charged++;
      present++;
      await toUser(events, userId, g.id, { kind: "charged", minute: m.minutes + 1, coinsLeft: left });
      // Warn when the next minute can't be paid.
      if (left < g.coins_per_min) await toUser(events, userId, g.id, { kind: "low_balance", coinsLeft: left });
    }

    // Too few members: after a short grace (people reconnecting), end the group.
    if (present >= s.endBelow) {
      if (g.few_since) await db.query(`UPDATE group_sessions SET few_since = NULL WHERE id = $1`, [g.id]);
    } else if (!g.few_since) {
      await db.query(`UPDATE group_sessions SET few_since = now() WHERE id = $1`, [g.id]);
      await toUser(events, g.host_id, g.id, { kind: "few_warning", endsInSeconds: FEW_GRACE_S });
    } else if (Date.now() - g.few_since.getTime() >= FEW_GRACE_S * 1000) {
      if (await endGroup(deps, g.id, "too_few")) ended++;
    }
  }
  return { ended, removed, charged };
}

// ---------------------------------------------------------------------------

const Host = z.object({
  id: z.uuid(), displayName: z.string(), avatarId: z.number().int(), photoUrl: z.string().nullable().describe("Approved profile photo (signed URL path); null = show the avatar"),
  rating: z.number().nullable(), isFavourite: z.boolean(),
});
const GroupCard = z.object({
  id: z.uuid(), title: z.string(), language: z.string(),
  status: z.enum(["scheduled", "lobby", "live", "ended"]),
  host: Host,
  scheduledAt: z.date().nullable(), startedAt: z.date().nullable(),
  members: z.number().int().describe("Seats taken (booked or in the group)"),
  minMembers: z.number().int(), maxMembers: z.number().int(), coinsPerMin: z.number().int(),
  mySeat: z.enum(["none", "booked", "joined"]),
}).meta({ id: "GroupCard" });
const Room = z.object({ liveKitUrl: z.string(), livekitRoom: z.string(), token: z.string() }).meta({ id: "GroupRoom" });
const Join = z.object({
  group: GroupCard,
  room: Room.nullable().describe("Set once the group is live — connect with camera and mic on"),
  minutes: z.number().int().describe("Minutes you've paid for in this group"),
  coinsLeft: z.number().int(),
}).meta({ id: "GroupJoin" });
const HostState = z.object({
  group: GroupCard, room: Room.nullable(), waiting: z.number().int(), earnedPaise: z.number().int(), paidMinutes: z.number().int(),
}).meta({ id: "GroupHostState" });

async function rateLimited(redis: Redis, key: string, seconds: number) {
  return !(await redis.set(key, "1", "EX", seconds, "NX"));
}

export const groupRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, rooms, events } = app.deps;
  const base = { tags: ["groups"], security: bearer };
  const member = requireAuth("caller");
  const host = requireAuth("companion");
  const deps: Deps = { db, events, rooms, push: app.deps.push };

  const load = async (id: string) => {
    const r = (await db.query<GroupRow>(`SELECT * FROM group_sessions WHERE id = $1`, [id])).rows[0];
    if (!r) throw notFound("GROUP_NOT_FOUND");
    return r;
  };
  const cards = async (userId: string, where: string, args: unknown[]) => (await db.query<{
    id: string; title: string; language_code: string; status: Status; scheduled_at: Date | null; started_at: Date | null;
    min_members: number; max_members: number; coins_per_min: number; host_id: string; host_name: string; host_avatar: number; host_photo_v: number | null;
    rating_sum: number | null; rating_count: number | null; fav: boolean; members: number; booked: boolean | null; joined: boolean | null;
  }>(
    `SELECT g.id, g.title, g.language_code, g.status, g.scheduled_at, g.started_at, g.min_members, g.max_members, g.coins_per_min,
            h.id AS host_id, h.display_name AS host_name, h.avatar_id AS host_avatar, ${PHOTO_V_SQL("h")} AS host_photo_v, p.rating_sum, p.rating_count,
            EXISTS (SELECT 1 FROM favourites f WHERE f.user_id = $1 AND f.companion_id = h.id) AS fav,
            (SELECT count(*) FROM group_members m WHERE m.session_id = g.id AND m.left_at IS NULL)::int AS members,
            (mine.left_at IS NULL AND mine.booked_at IS NOT NULL) AS booked,
            (mine.left_at IS NULL AND mine.joined_at IS NOT NULL) AS joined
       FROM group_sessions g JOIN users h ON h.id = g.host_id LEFT JOIN companion_profiles p ON p.user_id = h.id
       LEFT JOIN group_members mine ON mine.session_id = g.id AND mine.user_id = $1
      WHERE ${where}
        AND NOT EXISTS (SELECT 1 FROM blocks b WHERE (b.blocker_id = $1 AND b.blocked_id = h.id) OR (b.blocker_id = h.id AND b.blocked_id = $1))
      ORDER BY g.status = 'live' DESC, g.status = 'lobby' DESC, fav DESC, COALESCE(g.scheduled_at, g.created_at) LIMIT 100`,
    [userId, ...args])).rows.map((r) => ({
    id: r.id, title: r.title, language: r.language_code, status: r.status, scheduledAt: r.scheduled_at, startedAt: r.started_at,
    members: r.members, minMembers: r.min_members, maxMembers: r.max_members, coinsPerMin: r.coins_per_min,
    mySeat: (r.joined ? "joined" : r.booked ? "booked" : "none") as "none" | "booked" | "joined",
    host: {
      id: r.host_id, displayName: r.host_name, avatarId: r.host_avatar, photoUrl: photoUrl(app.deps.kycKey, r.host_id, r.host_photo_v), isFavourite: r.fav,
      rating: r.rating_count ? Math.round(((r.rating_sum ?? 0) / r.rating_count) * 10) / 10 : null,
    },
  }));
  const card = async (userId: string, id: string) => (await cards(userId, `g.id = $2`, [id]))[0]!;
  const room = async (g: GroupRow, userId: string) => ({
    liveKitUrl: app.deps.liveKitUrl, livekitRoom: g.livekit_room,
    // The name shows on everyone's video tile.
    token: await rooms.joinToken(g.livekit_room, userId, { canPublish: true, name: await name(userId) }),
  });
  const coins = async (userId: string) =>
    (await db.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [userId])).rows[0]?.balance ?? 0;
  const inGroup = async (groupId: string, userId: string) =>
    !!(await db.query(`SELECT 1 FROM group_members WHERE session_id = $1 AND user_id = $2 AND ${IN_GROUP}`, [groupId, userId])).rowCount;
  const name = async (userId: string) =>
    (await db.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [userId])).rows[0]!.display_name;
  const hostState = async (g: GroupRow, userId: string) => {
    const s = (await db.query<{ waiting: number; paise: number; minutes: number }>(
      `SELECT (SELECT count(*) FROM group_members WHERE session_id = $1 AND ${IN_GROUP})::int AS waiting,
              (COALESCE((SELECT sum(paise) FROM group_ticks WHERE session_id = $1), 0)
               + COALESCE((SELECT sum(paise_credited) FROM group_gifts WHERE session_id = $1), 0))::int AS paise,
              (SELECT count(*) FROM group_ticks WHERE session_id = $1)::int AS minutes`, [g.id])).rows[0]!;
    return {
      group: await card(userId, g.id), room: g.status === "lobby" || g.status === "live" ? await room(g, userId) : null,
      waiting: s.waiting, earnedPaise: s.paise, paidMinutes: s.minutes,
    };
  };
  const notBlocked = async (userId: string, hostId: string) => {
    if ((await db.query(
      `SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`, [userId, hostId])).rowCount) {
      throw forbidden("GROUP_BLOCKED");
    }
  };
  /** Seats are booked or joined members; the lobby/room never exceeds the maximum. */
  const seatsTaken = async (c: DbClient | Db, g: GroupRow, except: string) =>
    (await c.query<{ n: number }>(
      `SELECT count(*)::int AS n FROM group_members WHERE session_id = $1 AND left_at IS NULL AND user_id <> $2`, [g.id, except])).rows[0]!.n;
  const hostBusyElsewhere = async (userId: string) => {
    if (await redis.exists(busyKey(userId))) throw conflict("IN_A_CALL", "Finish your call first");
    if ((await db.query(`SELECT 1 FROM lives WHERE host_id = $1 AND status = 'live'`, [userId])).rowCount) {
      throw conflict("ALREADY_LIVE", "End your live first");
    }
  };

  app.get("/groups", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      ...base,
      summary: "Callers: groups live now, lobbies filling up and upcoming ones. Companions: their own open groups.",
      querystring: z.object({ language: z.string().optional() }),
      response: { 200: z.object({ groups: z.array(GroupCard) }) },
    },
  }, async (req) => {
    const { userId, role } = me(req);
    const where = role === "companion"
      ? `g.host_id = $1 AND g.status <> 'ended'`
      : `g.status <> 'ended' AND ($2::text IS NULL OR g.language_code = $2)
         AND (g.status <> 'scheduled' OR g.scheduled_at < now() + make_interval(days => ${SCHEDULE_DAYS}))`;
    return { groups: await cards(userId, where, role === "companion" ? [] : [req.query.language ?? null]) };
  });

  // --- host ------------------------------------------------------------------------
  app.post("/groups", {
    preHandler: host,
    schema: {
      ...base,
      summary: "Host a group video (companions with video unlocked). Leave scheduledAt out to open a lobby now; " +
        "set it (within 7 days) to take seat bookings.",
      body: z.object({
        title: z.string().trim().min(3).max(60),
        language: z.string().nullish(),
        scheduledAt: z.coerce.date().nullish(),
      }),
      response: { 201: HostState },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const { title, scheduledAt } = req.body;
    if (checkMessage(title)) throw new ApiError(400, "TITLE_BLOCKED", "Keep contact details and payments out of the title");
    if (scheduledAt) {
      const ahead = scheduledAt.getTime() - Date.now();
      if (ahead < 5 * 60_000 || ahead > SCHEDULE_DAYS * 86_400_000) {
        throw new ApiError(400, "BAD_TIME", "Pick a time between 5 minutes and 7 days from now");
      }
    } else {
      await hostBusyElsewhere(userId);
    }
    const s = await groupSettings(db);
    const g = await tx(db, async (c) => {
      const p = (await c.query<{ ok: boolean; video: boolean; lang: string }>(
        `SELECT (p.kyc_status = 'approved' AND u.status = 'active') AS ok, p.video_enabled AS video, u.primary_language AS lang
           FROM companion_profiles p JOIN users u ON u.id = p.user_id WHERE p.user_id = $1`, [userId])).rows[0];
      if (!p?.ok) throw new ApiError(403, "KYC_NOT_APPROVED", "Finish verification before hosting a group");
      if (!p.video) throw new ApiError(403, "VIDEO_LOCKED", "Group video unlocks with video calls (after the academy)");
      const lang = req.body.language ?? p.lang;
      if (!(await c.query(`SELECT 1 FROM languages WHERE code = $1 AND is_active`, [lang])).rowCount) {
        throw new ApiError(400, "LANGUAGE_UNSUPPORTED", "That language is not available yet");
      }
      if (!scheduledAt && (await c.query(`SELECT 1 FROM group_sessions WHERE host_id = $1 AND status IN ('lobby', 'live')`, [userId])).rowCount) {
        throw conflict("GROUP_OPEN", "You already have a group open");
      }
      return (await c.query<GroupRow>(
        `INSERT INTO group_sessions (host_id, title, language_code, status, scheduled_at, lobby_at, livekit_room,
                                     coins_per_min, paise_per_min, min_members, max_members)
         VALUES ($1, $2, $3, $4, $5, CASE WHEN $4 = 'lobby' THEN now() END, 'group_' || gen_random_uuid(), $6, $7, $8, $9) RETURNING *`,
        [userId, title, lang, scheduledAt ? "scheduled" : "lobby", scheduledAt ?? null,
          s.coinsPerMin, s.paisePerMin, s.minMembers, s.maxMembers])).rows[0]!;
    });
    if (g.status === "lobby") await goOffline(redis, userId); // no 1:1 calls while hosting
    reply.status(201);
    return hostState(g, userId);
  });

  app.post("/groups/:id/open", {
    preHandler: host,
    schema: { ...base, summary: "Host: open the lobby of a scheduled group (up to 15 min early). Booked members are told.",
      params: z.object({ id: z.uuid() }), response: { 200: HostState } },
  }, async (req) => {
    const userId = me(req).userId;
    const g = await load(req.params.id);
    if (g.host_id !== userId) throw forbidden("NOT_THE_HOST");
    if (g.status !== "scheduled") throw conflict("NOT_SCHEDULED", "This group isn't waiting to open");
    if (g.scheduled_at && g.scheduled_at.getTime() - Date.now() > OPEN_EARLY_MIN * 60_000) {
      throw new ApiError(409, "TOO_EARLY", `You can open the lobby ${OPEN_EARLY_MIN} minutes before the time`);
    }
    await hostBusyElsewhere(userId);
    const opened = await tx(db, async (c) => {
      if ((await c.query(`SELECT 1 FROM group_sessions WHERE host_id = $1 AND status IN ('lobby', 'live')`, [userId])).rowCount) {
        throw conflict("GROUP_OPEN", "You already have a group open");
      }
      return (await c.query<GroupRow>(
        `UPDATE group_sessions SET status = 'lobby', lobby_at = now(), host_seen_at = now() WHERE id = $1 AND status = 'scheduled' RETURNING *`,
        [g.id])).rows[0];
    });
    if (!opened) throw conflict("NOT_SCHEDULED", "This group isn't waiting to open");
    await goOffline(redis, userId);
    const booked = (await db.query<{ user_id: string }>(
      `SELECT user_id FROM group_members WHERE session_id = $1 AND left_at IS NULL`, [g.id])).rows;
    const hostName = await name(userId);
    for (const b of booked) {
      await notify(app.deps, b.user_id, {
        type: "group_open", title: `${hostName}'s group is open`, body: `Join "${g.title}" now — it starts when enough people are in.`,
        data: { groupId: g.id },
      });
    }
    return hostState(opened, userId);
  });

  app.post("/groups/:id/host-heartbeat", {
    preHandler: host,
    schema: { ...base, summary: "Host: still here (every 15 s). Returns the group, who's waiting and what it has earned.",
      params: z.object({ id: z.uuid() }), response: { 200: HostState } },
  }, async (req) => {
    const g = await load(req.params.id);
    if (g.host_id !== me(req).userId) throw forbidden("NOT_THE_HOST");
    if (g.status === "lobby" || g.status === "live") await db.query(`UPDATE group_sessions SET host_seen_at = now() WHERE id = $1`, [g.id]);
    return hostState(g, g.host_id);
  });

  app.post("/groups/:id/end", {
    preHandler: host,
    schema: { ...base, summary: "Host: end (or cancel) the group", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const g = await load(req.params.id);
    if (g.host_id !== me(req).userId) throw forbidden("NOT_THE_HOST");
    await endGroup(deps, g.id, g.status === "live" ? "host_ended" : "host_cancelled");
    return reply.status(204).send(null);
  });

  // --- members ---------------------------------------------------------------------
  app.post("/groups/:id/book", {
    preHandler: member,
    schema: { ...base, summary: "Book a free seat in a scheduled group (reminder 10 min before)", params: z.object({ id: z.uuid() }),
      response: { 200: GroupCard } },
  }, async (req) => {
    const userId = me(req).userId;
    const g = await load(req.params.id);
    if (g.status !== "scheduled") throw conflict("NOT_SCHEDULED", "Seats can only be booked before the group opens");
    await notBlocked(userId, g.host_id);
    await tx(db, async (c) => {
      await c.query(`SELECT 1 FROM group_sessions WHERE id = $1 FOR UPDATE`, [g.id]);
      if (await seatsTaken(c, g, userId) >= g.max_members) throw conflict("GROUP_FULL", "All seats are taken");
      await c.query(
        `INSERT INTO group_members (session_id, user_id, booked_at) VALUES ($1, $2, now())
         ON CONFLICT (session_id, user_id) DO UPDATE SET booked_at = now(), left_at = NULL`, [g.id, userId]);
    });
    return card(userId, g.id);
  });

  app.post("/groups/:id/cancel-booking", {
    preHandler: member,
    schema: { ...base, summary: "Give up a booked seat", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    await db.query(`UPDATE group_members SET left_at = now() WHERE session_id = $1 AND user_id = $2 AND joined_at IS NULL`,
      [req.params.id, me(req).userId]);
    return reply.status(204).send(null);
  });

  app.post("/groups/:id/join", {
    preHandler: member,
    schema: {
      ...base,
      summary: "Join the lobby or the live group. Send agree=true: everyone in the group sees your camera, and once it's live " +
        "you pay per minute (the first minute when it starts, or now if it's already live). 402 AGREE_REQUIRED / INSUFFICIENT_BALANCE.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ agree: z.boolean().nullish().describe("Agree to the per-minute price and to being on camera") }).nullish(),
      response: { 200: Join },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const g = await load(req.params.id);
    if (g.status === "ended") throw new ApiError(410, "GROUP_ENDED", "This group has ended");
    if (g.status === "scheduled") throw conflict("NOT_OPEN_YET", "The host hasn't opened this group yet — book a seat");
    await notBlocked(userId, g.host_id);
    const already = await inGroup(g.id, userId);
    if (!already && !req.body?.agree) {
      throw new ApiError(402, "AGREE_REQUIRED", `${g.coins_per_min} coins a minute once the group starts. Everyone can see your camera.`);
    }
    if (!already && await coins(userId) < g.coins_per_min) {
      throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${g.coins_per_min} coins for a minute. Add coins to join.`);
    }
    await tx(db, async (c) => {
      await c.query(`SELECT 1 FROM group_sessions WHERE id = $1 FOR UPDATE`, [g.id]);
      if (!already && await seatsTaken(c, g, userId) >= g.max_members) throw conflict("GROUP_FULL", "This group is full");
      await c.query(
        `INSERT INTO group_members (session_id, user_id, joined_at, last_seen_at, paying) VALUES ($1, $2, now(), now(), true)
         ON CONFLICT (session_id, user_id) DO UPDATE
           SET joined_at = COALESCE(CASE WHEN group_members.left_at IS NULL THEN group_members.joined_at END, now()),
               left_at = NULL, last_seen_at = now(), paying = true`, [g.id, userId]);
    });

    let coinsLeft: number | null = null;
    if (g.status === "lobby") {
      await broadcast(db, events, g.id, { kind: "waiting", count: (await hostState(g, g.host_id)).waiting });
      await startIfReady(deps, g.id);
    } else {
      // Already live: pay the first minute now, unless this minute is already paid (rejoin).
      coinsLeft = await tx(db, async (c) => {
        const due = (await c.query<{ due: boolean }>(
          `SELECT (last_charged_at IS NULL OR last_charged_at <= now() - interval '60 seconds') AS due
             FROM group_members WHERE session_id = $1 AND user_id = $2`, [g.id, userId])).rows[0]!.due;
        if (!due) return null;
        const left = await chargeMinute(c, g, userId);
        if (left === null) throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${g.coins_per_min} coins for a minute. Add coins to join.`);
        return left;
      }).catch(async (err) => {
        await db.query(`UPDATE group_members SET left_at = now(), paying = false WHERE session_id = $1 AND user_id = $2`, [g.id, userId]);
        throw err;
      });
      await broadcast(db, events, g.id, { kind: "joined", userId, displayName: await name(userId) });
    }
    const now = await load(g.id);
    if (now.status === "live" && !(await inGroup(g.id, userId))) {
      throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${g.coins_per_min} coins for a minute. Add coins to join.`);
    }
    const minutes = (await db.query<{ m: number }>(
      `SELECT minutes_charged AS m FROM group_members WHERE session_id = $1 AND user_id = $2`, [g.id, userId])).rows[0]!.m;
    return {
      group: await card(userId, g.id), room: now.status === "live" ? await room(now, userId) : null,
      minutes, coinsLeft: coinsLeft ?? await coins(userId),
    };
  });

  app.post("/groups/:id/heartbeat", {
    preHandler: member,
    schema: { ...base, summary: "Member: still here (every 20 s). Returns the group; when it turns live, join again for the room.",
      params: z.object({ id: z.uuid() }), response: { 200: z.object({ group: GroupCard, minutes: z.number().int() }) } },
  }, async (req) => {
    const userId = me(req).userId;
    const r = await db.query<{ m: number }>(
      `UPDATE group_members SET last_seen_at = now() WHERE session_id = $1 AND user_id = $2 AND ${IN_GROUP} RETURNING minutes_charged AS m`,
      [req.params.id, userId]);
    await load(req.params.id);
    return { group: await card(userId, req.params.id), minutes: r.rows[0]?.m ?? 0 };
  });

  app.post("/groups/:id/leave", {
    preHandler: member,
    schema: { ...base, summary: "Member: leave (stops the per-minute charge)", params: z.object({ id: z.uuid() }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const r = await db.query(`UPDATE group_members SET left_at = now(), paying = false WHERE session_id = $1 AND user_id = $2 AND left_at IS NULL`,
      [req.params.id, userId]);
    if (r.rowCount) await broadcast(db, events, req.params.id, { kind: "left", userId });
    return reply.status(204).send(null);
  });

  // --- in the group ------------------------------------------------------------------
  const requireInGroup = async (g: GroupRow, userId: string) => {
    if (g.status !== "live" && g.status !== "lobby") throw new ApiError(410, "GROUP_ENDED", "This group has ended");
    if (g.host_id !== userId && !(await inGroup(g.id, userId))) throw forbidden("NOT_IN_GROUP");
  };

  app.post("/groups/:id/messages", {
    preHandler: requireAuth("caller", "companion"),
    schema: { ...base, summary: "Chat (members and the host; safety-filtered; one message every 2 s)", params: z.object({ id: z.uuid() }),
      body: z.object({ body: z.string().trim().min(1).max(200) }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const g = await load(req.params.id);
    await requireInGroup(g, userId);
    const reason = checkMessage(req.body.body);
    if (reason) throw new ApiError(422, "MESSAGE_BLOCKED", BLOCK_MESSAGES[reason]);
    if (await rateLimited(redis, `group:msg:${g.id}:${userId}`, 2)) throw new ApiError(429, "TOO_FAST", "Slow down a little");
    await broadcast(db, events, g.id, { kind: "chat", userId, displayName: await name(userId), body: req.body.body, isHost: g.host_id === userId });
    return reply.status(204).send(null);
  });

  app.post("/groups/:id/react", {
    preHandler: requireAuth("caller", "companion"),
    schema: { ...base, summary: "Send a reaction", params: z.object({ id: z.uuid() }),
      body: z.object({ emoji: z.string().refine((e) => REACTIONS.includes(e), "Not a reaction").describe(REACTIONS.join(" ")) }),
      response: { 204: z.null() } },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const g = await load(req.params.id);
    await requireInGroup(g, userId);
    if (!(await rateLimited(redis, `group:react:${g.id}:${userId}`, 1))) {
      await broadcast(db, events, g.id, { kind: "reaction", userId, displayName: await name(userId), emoji: req.body.emoji });
    }
    return reply.status(204).send(null);
  });

  app.post("/groups/:id/gifts", {
    preHandler: member,
    schema: {
      ...base,
      summary: "Send the host a gift (same prices and companion share as call gifts). Safe to retry with the same clientRef.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ giftId: z.number().int(), clientRef: z.uuid() }),
      response: { 201: z.object({ coinsLeft: z.number().int() }) },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const g = await load(req.params.id);
    if (g.status !== "live") throw new ApiError(410, "GROUP_ENDED", "Gifts open once the group is live");
    if (!(await inGroup(g.id, userId))) throw forbidden("NOT_IN_GROUP");
    const gift = (await db.query<{ id: number; name: string; emoji: string; coins: number }>(
      `SELECT id, name, emoji, coins FROM gifts WHERE id = $1 AND is_active`, [req.body.giftId])).rows[0];
    if (!gift) throw notFound("GIFT_NOT_FOUND");
    const paise = await giftPaise(db, gift.coins);
    const result = await tx(db, async (c) => {
      const ins = await c.query<{ id: string }>(
        `INSERT INTO group_gifts (session_id, sender_id, receiver_id, gift_id, coins, paise_credited, client_ref)
         VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (client_ref) DO NOTHING RETURNING id`,
        [g.id, userId, g.host_id, gift.id, gift.coins, paise, req.body.clientRef]);
      if (!ins.rowCount) return { duplicate: true, coinsLeft: await coins(userId) };
      const id = ins.rows[0]!.id;
      const left = await post(c, userId, "coins", "gift_debit", -gift.coins, `groupgift:${id}:debit`, { groupId: g.id, note: `${gift.name} gift in a group` });
      if (left === null) throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${gift.coins} coins for a ${gift.name}`);
      if (paise > 0) await post(c, g.host_id, "earnings", "gift_credit", paise, `groupgift:${id}:credit`, { groupId: g.id, note: `${gift.name} gift in a group` });
      return { duplicate: false, coinsLeft: left };
    });
    if (!result.duplicate) {
      await broadcast(db, events, g.id, { kind: "gift", userId, displayName: await name(userId), gift: { name: gift.name, emoji: gift.emoji } });
    }
    reply.status(201);
    return { coinsLeft: result.coinsLeft };
  });

  app.post("/groups/:id/moderation", {
    preHandler: requireAuth("caller", "companion"),
    bodyLimit: 1024 * 1024,
    schema: {
      ...base,
      summary: "A frame an on-device check flagged. Every phone checks its own camera (and blurs it at once); subjectId is whose video it is.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ frameBase64: base64File(MAX_FRAME_BYTES), score: z.number().min(0).max(1), subjectId: z.uuid().nullish() }),
      response: { 201: z.object({ accepted: z.literal(true) }), 202: z.object({ accepted: z.literal(false) }) },
    },
  }, async (req, reply) => {
    const userId = me(req).userId;
    const g = await load(req.params.id);
    const isPart = async (id: string) => id === g.host_id ||
      !!(await db.query(`SELECT 1 FROM group_members WHERE session_id = $1 AND user_id = $2 AND joined_at IS NOT NULL`, [g.id, id])).rowCount;
    const subject = req.body.subjectId ?? userId;
    if (!(await isPart(userId)) || !(await isPart(subject))) throw forbidden("NOT_IN_GROUP");
    const b = req.body.frameBase64;
    if (!(b[0] === 0xff && b[1] === 0xd8)) throw new ApiError(400, "NOT_A_JPEG", "The frame must be a JPEG");
    if (!(await redis.set(`mod:group:${g.id}:${subject}`, "1", "EX", FLAG_COOLDOWN_S, "NX"))) return reply.status(202).send({ accepted: false });
    const id = (await db.query<{ id: string }>(`SELECT gen_random_uuid() AS id`)).rows[0]!.id;
    const key = `moderation/${id}`;
    await app.deps.store.put(key, b);
    await db.query(
      `INSERT INTO moderation_flags (id, group_id, subject_id, detected_by, score, storage_key) VALUES ($1, $2, $3, $4, $5, $6)`,
      [id, g.id, subject, userId, req.body.score, key]);
    return reply.status(201).send({ accepted: true });
  });

  app.post("/groups/:id/report", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      ...base,
      summary: "Report someone in the group. The host can also remove them.",
      params: z.object({ id: z.uuid() }),
      body: z.object({
        userId: z.uuid(),
        reason: z.enum(["abuse", "sexual_content", "spam", "underage", "fraud", "off_platform"]),
        details: z.string().trim().max(500).nullish(),
        remove: z.boolean().nullish().describe("Host only: remove them from the group"),
      }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const reporter = me(req).userId;
    const g = await load(req.params.id);
    const { userId: reported, reason, details, remove } = req.body;
    if (reported === reporter) throw new ApiError(400, "SELF_REPORT", "You can't report yourself");
    const part = async (id: string) => id === g.host_id ||
      !!(await db.query(`SELECT 1 FROM group_members WHERE session_id = $1 AND user_id = $2 AND joined_at IS NOT NULL`, [g.id, id])).rowCount;
    if (!(await part(reporter)) || !(await part(reported))) throw forbidden("NOT_IN_GROUP");
    await db.query(`INSERT INTO reports (reporter_id, reported_id, group_id, reason, details) VALUES ($1, $2, $3, $4, $5)`,
      [reporter, reported, g.id, reason, details ?? null]);
    if (remove && reporter === g.host_id && reported !== g.host_id && (g.status === "live" || g.status === "lobby")) {
      await removeMember(deps, g, reported, "removed_by_host");
      await broadcast(db, events, g.id, { kind: "left", userId: reported });
    }
    return reply.status(204).send(null);
  });

  // --- admin -----------------------------------------------------------------------
  const AdminGroup = z.object({
    id: z.uuid(), title: z.string(), language: z.string(), status: z.enum(["scheduled", "lobby", "live", "ended"]),
    host: z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int() }),
    members: z.number().int(), paidMinutes: z.number().int(), minuteCoins: z.number().int(), giftCoins: z.number().int(),
    openFlags: z.number().int(), scheduledAt: z.date().nullable(), startedAt: z.date().nullable(), endedAt: z.date().nullable(),
    endReason: z.string().nullable(),
  }).meta({ id: "AdminGroup" });

  app.get("/admin/groups", {
    preHandler: can("rooms.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "Open groups, then the last 50 that ended", response: { 200: z.array(AdminGroup) } },
  }, async () => (await db.query<{
    id: string; title: string; language_code: string; status: Status; host_id: string; host_name: string; host_avatar: number;
    members: number; minutes: number; minute_coins: number; gift_coins: number; flags: number;
    scheduled_at: Date | null; started_at: Date | null; ended_at: Date | null; end_reason: string | null;
  }>(
    `SELECT g.id, g.title, g.language_code, g.status, h.id AS host_id, h.display_name AS host_name, h.avatar_id AS host_avatar,
            (SELECT count(*) FROM group_members m WHERE m.session_id = g.id AND m.left_at IS NULL)::int AS members,
            (SELECT count(*) FROM group_ticks t WHERE t.session_id = g.id)::int AS minutes,
            COALESCE((SELECT sum(coins) FROM group_ticks t WHERE t.session_id = g.id), 0)::int AS minute_coins,
            COALESCE((SELECT sum(coins) FROM group_gifts x WHERE x.session_id = g.id), 0)::int AS gift_coins,
            (SELECT count(*) FROM moderation_flags f WHERE f.group_id = g.id AND f.status = 'open')::int AS flags,
            g.scheduled_at, g.started_at, g.ended_at, g.end_reason
       FROM group_sessions g JOIN users h ON h.id = g.host_id
      WHERE g.status <> 'ended' OR g.id IN (SELECT id FROM group_sessions WHERE status = 'ended' ORDER BY ended_at DESC LIMIT 50)
      ORDER BY g.status = 'live' DESC, g.status = 'lobby' DESC, g.status = 'scheduled' DESC, COALESCE(g.started_at, g.scheduled_at, g.created_at) DESC`,
  )).rows.map((r) => ({
    id: r.id, title: r.title, language: r.language_code, status: r.status,
    host: { id: r.host_id, displayName: r.host_name, avatarId: r.host_avatar },
    members: r.members, paidMinutes: r.minutes, minuteCoins: r.minute_coins, giftCoins: r.gift_coins, openFlags: r.flags,
    scheduledAt: r.scheduled_at, startedAt: r.started_at, endedAt: r.ended_at, endReason: r.end_reason,
  })));

  app.post("/admin/groups/:id/end", {
    preHandler: can("rooms.manage"),
    schema: { tags: ["admin"], security: bearer, summary: "End or cancel a group now (moderation)", params: z.object({ id: z.uuid() }),
      body: z.object({ reason: z.string().trim().min(3).max(500) }), response: { 204: z.null() } },
  }, async (req, reply) => {
    const g = await load(req.params.id);
    if (g.status === "ended") throw conflict("GROUP_ENDED", "Already ended");
    await db.query(`INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, 'group.end', 'group', $2, $3)`,
      [me(req).userId, g.id, JSON.stringify({ reason: req.body.reason, hostId: g.host_id })]);
    await endGroup(deps, g.id, "admin");
    return reply.status(204).send(null);
  });
};
