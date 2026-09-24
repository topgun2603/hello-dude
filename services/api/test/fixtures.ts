import { Redis } from "ioredis";
import { createPool, tx, type Db } from "../src/db/pool.js";
import { ensureWallets, post } from "../src/billing/ledger.js";
import { BillingEngine, ONLINE_SET } from "../src/billing/engine.js";
import type { RoomControl, UserEvent, UserEvents } from "../src/billing/ports.js";
import { TEST_DATABASE_URL, TEST_REDIS_URL } from "./env.js";

/** In-memory LiveKit stand-in: tests decide how many people are in each room. */
export class FakeRooms implements RoomControl {
  readonly participants = new Map<string, number>();
  readonly closed: string[] = [];
  async participantCount(room: string) { return this.participants.get(room) ?? this.identities.get(room)?.size ?? 0; }
  /** Who is "in" each room, for tests of the LiveKit presence check. */
  readonly identities = new Map<string, Set<string>>();
  async participantIdentities(room: string) { return [...(this.identities.get(room) ?? [])]; }
  async closeRoom(room: string) { this.closed.push(room); this.participants.delete(room); }
  readonly removed: { room: string; identity: string }[] = [];
  async removeParticipant(room: string, identity: string) {
    this.removed.push({ room, identity });
    this.identities.get(room)?.delete(identity);
  }
  async joinToken(room: string, identity: string, opts?: { canPublish?: boolean }) {
    return `token:${room}:${identity}${opts?.canPublish === false ? ":listen" : ""}`;
  }
}

export class RecordingEvents implements UserEvents {
  readonly sent: { userId: string; event: UserEvent }[] = [];
  async publish(userId: string, event: UserEvent) { this.sent.push({ userId, event }); }
  of(userId: string, t: UserEvent["t"]) { return this.sent.filter((s) => s.userId === userId && s.event.t === t); }
}

export interface Harness {
  db: Db;
  redis: Redis;
  rooms: FakeRooms;
  events: RecordingEvents;
  engine: BillingEngine;
  warnings: unknown[][];
}

export function createHarness(): Harness {
  const db = createPool(TEST_DATABASE_URL);
  const redis = new Redis(TEST_REDIS_URL, { lazyConnect: false, maxRetriesPerRequest: 1 });
  const rooms = new FakeRooms();
  const events = new RecordingEvents();
  const warnings: unknown[][] = [];
  const engine = new BillingEngine({
    db, redis, rooms, events,
    log: { warn: (...a: unknown[]) => { warnings.push(a); }, error: () => {} },
  });
  return { db, redis, rooms, events, engine, warnings };
}

/** Empties every table that tests write to (languages stay seeded). */
export async function resetState(h: Harness): Promise<void> {
  h.rooms.participants.clear();
  h.rooms.closed.length = 0;
  h.events.sent.length = 0;
  h.warnings.length = 0;
  await h.redis.flushdb();
  // TRUNCATE is allowed on ledger_entries: the append-only trigger is row-level.
  await h.db.query(`TRUNCATE account_deletions, report_recordings, refund_requests, call_gifts, favourites, academy_progress, payouts, audit_log, sessions, devices, billing_exceptions, call_ratings, call_ticks, ledger_entries, calls,
    purchases, payouts, reports, blocks, wallets, kyc_documents, companion_profiles,
    user_languages, call_rates, users RESTART IDENTITY CASCADE`);
}

let phoneSeq = 0;
const nextPhone = () => `+9190000${String(++phoneSeq).padStart(5, "0")}`;

export async function createCaller(h: Harness, coins: number): Promise<string> {
  return tx(h.db, async (c) => {
    const id = (await c.query<{ id: string }>(
      `INSERT INTO users (phone, gender, role, display_name, primary_language)
       VALUES ($1, 'male', 'caller', 'Test caller', 'ta') RETURNING id`, [nextPhone()],
    )).rows[0]!.id;
    await ensureWallets(c, id);
    if (coins > 0) await post(c, id, "coins", "bonus", coins, `test:seed:${id}`);
    return id;
  });
}

export async function createCompanion(
  h: Harness,
  opts: { language?: string; video?: boolean; online?: boolean; kyc?: "approved" | "pending" } = {},
): Promise<string> {
  const id = await tx(h.db, async (c) => {
    const userId = (await c.query<{ id: string }>(
      `INSERT INTO users (phone, gender, role, display_name, primary_language)
       VALUES ($1, 'female', 'companion', 'Test companion', $2) RETURNING id`,
      [nextPhone(), opts.language ?? "ta"],
    )).rows[0]!.id;
    await c.query(
      `INSERT INTO companion_profiles (user_id, kyc_status, video_enabled) VALUES ($1, $2, $3)`,
      [userId, opts.kyc ?? "approved", opts.video ?? true],
    );
    await ensureWallets(c, userId);
    return userId;
  });
  if (opts.online ?? true) await h.redis.sadd(ONLINE_SET, id);
  return id;
}

export async function setRate(
  h: Harness, language: string, type: "audio" | "video", coinsPerMin: number, paisePerMin: number,
  effectiveFrom = "now() - interval '1 day'",
): Promise<number> {
  return (await h.db.query<{ id: number }>(
    `INSERT INTO call_rates (language_code, call_type, coins_per_min, companion_paise_per_min, effective_from)
     VALUES ($1, $2, $3, $4, ${effectiveFrom}) RETURNING id`,
    [language, type, coinsPerMin, paisePerMin],
  )).rows[0]!.id;
}

export async function balance(h: Harness, userId: string, kind: "coins" | "earnings"): Promise<number> {
  return (await h.db.query<{ balance: number }>(
    `SELECT balance FROM wallets WHERE user_id = $1 AND kind = $2`, [userId, kind],
  )).rows[0]!.balance;
}

export async function getCall(h: Harness, callId: string) {
  return (await h.db.query<{
    status: string; end_reason: string | null; minutes_charged: number;
    coins_charged: number; paise_credited: number; started_at: Date | null; room_name: string;
  }>(`SELECT * FROM calls WHERE id = $1`, [callId])).rows[0]!;
}

export async function ticks(h: Harness, callId: string): Promise<number[]> {
  return (await h.db.query<{ minute_no: number }>(
    `SELECT minute_no FROM call_ticks WHERE call_id = $1 ORDER BY minute_no`, [callId],
  )).rows.map((r) => r.minute_no);
}

/** Pretends the call connected `seconds` ago (moves started_at back in time). */
export async function backdateStart(h: Harness, callId: string, seconds: number): Promise<void> {
  await h.db.query(`UPDATE calls SET started_at = now() - $2 * interval '1 second' WHERE id = $1`, [callId, seconds]);
}

export async function dueMembers(h: Harness): Promise<string[]> {
  return h.redis.zrange("billing:due", "0", "-1");
}
