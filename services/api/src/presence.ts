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
