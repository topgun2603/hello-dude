/**
 * Companion presence. The engine reads the ONLINE_SET; the app keeps a
 * heartbeat key alive while the companion is online. If the app dies the
 * heartbeat expires and dropStalePresence() takes them offline.
 */
import type { Redis } from "ioredis";
import { busyKey, ONLINE_SET } from "./billing/engine.js";

export const HEARTBEAT_TTL_S = 120; // app sends a heartbeat every 60 s
const hbKey = (id: string) => `presence:hb:${id}`;

export async function goOnline(redis: Redis, companionId: string): Promise<void> {
  await redis.multi().set(hbKey(companionId), "1", "EX", HEARTBEAT_TTL_S).sadd(ONLINE_SET, companionId).exec();
}

export async function goOffline(redis: Redis, companionId: string): Promise<void> {
  await redis.multi().del(hbKey(companionId)).srem(ONLINE_SET, companionId).exec();
}

export async function isOnline(redis: Redis, companionId: string): Promise<boolean> {
  return (await redis.sismember(ONLINE_SET, companionId)) === 1;
}

/** Removes companions whose heartbeat expired. Run every ~30 s from the worker. */
export async function dropStalePresence(redis: Redis): Promise<number> {
  const ids = await redis.smembers(ONLINE_SET);
  if (!ids.length) return 0;
  const alive = await redis.mget(ids.map(hbKey));
  const stale = ids.filter((_, i) => alive[i] === null);
  if (stale.length) await redis.srem(ONLINE_SET, ...stale);
  return stale.length;
}

/** Which of `ids` are ringing or in a call right now. */
export async function busySet(redis: Redis, ids: string[]): Promise<Set<string>> {
  if (!ids.length) return new Set();
  const v = await redis.mget(ids.map(busyKey));
  return new Set(ids.filter((_, i) => v[i] !== null));
}

// ---------------------------------------------------------------------------
// "In the app": anyone (caller or companion) with a live WebSocket. One sorted set,
// member = user id, score = last ping (ms). Fresh = pinged within IN_APP_TTL_S, so a
// dead API instance's users drop out on their own; stale members are trimmed on read.

export const IN_APP_TTL_S = 70;
const IN_APP = "presence:app";
const freshSince = () => Date.now() - IN_APP_TTL_S * 1000;

export async function markInApp(redis: Redis, userId: string): Promise<void> {
  await redis.zadd(IN_APP, Date.now(), userId);
}

export async function leftApp(redis: Redis, userId: string): Promise<void> {
  await redis.zrem(IN_APP, userId);
}

/** Which of `ids` have the app open right now. */
export async function inAppSet(redis: Redis, ids: string[]): Promise<Set<string>> {
  if (!ids.length) return new Set();
  const scores = await redis.zmscore(IN_APP, ...ids);
  const since = freshSince();
  return new Set(ids.filter((_, i) => scores[i] !== null && Number(scores[i]) >= since));
}

/** Everyone with the app open right now. */
export async function inAppIds(redis: Redis): Promise<string[]> {
  const since = freshSince();
  await redis.zremrangebyscore(IN_APP, "-inf", `(${since}`);
  return redis.zrangebyscore(IN_APP, since, "+inf");
}
