/**
 * Per-minute call billing engine.
 *
 * Model: prepaid per minute. Minute N is charged at the START of minute N, so a
 * caller never talks on credit and balances never go negative. Each charge
 * debits the caller and credits the companion in ONE transaction, and writes a
 * call_ticks row whose primary key makes double billing impossible.
 *
 * Sources of truth:
 *   - Postgres: wallets, ledger, calls, call_ticks (all money lives here)
 *   - Redis:    presence, busy locks, the "next charge due" schedule (disposable;
 *               sweep() rebuilds it from Postgres + LiveKit)
 *   - LiveKit webhooks: when a call really connected / really ended
 *
 * Ported from docs/billing-engine.reference.ts. Differences from the draft:
 *   - dependencies are injected so every path can be tested;
 *   - call duration is measured with the database clock, not the API server's;
 *   - user events are published only after the transaction commits;
 *   - a failed grace-period reversal is recorded in billing_exceptions.
 */
import type { Redis } from "ioredis";
import { tx, type Db, type DbClient } from "../db/pool.js";
import { post } from "./ledger.js";
import type { RoomControl, UserEvents } from "./ports.js";

export const DUE_ZSET = "billing:due"; // member = "<callId>:<minuteNo>", score = due epoch ms
export const ONLINE_SET = "online:companions";
export const busyKey = (companionId: string) => `busy:${companionId}`;

export const RING_TIMEOUT_S = 45;
export const GRACE_SECONDS = 10; // calls shorter than this are fully refunded
export const RETRY_DELAY_MS = 5_000;
const MINUTE_MS = 60_000;
const ACTIVE_BUSY_TTL_S = 6 * 3600;

export type CallType = "audio" | "video";
export type EndReason =
  | "caller_hangup" | "companion_hangup" | "companion_reject"
  | "balance" | "network" | "timeout" | "admin";
export type ChargeResult = "ok" | "insufficient" | "not_active" | "already_charged";

export class CallError extends Error {
  constructor(
    readonly code:
      | "OFFLINE" | "BUSY" | "BLOCKED" | "NO_RATE" | "INSUFFICIENT_BALANCE"
      | "NOT_A_COMPANION" | "VIDEO_NOT_ENABLED" | "CALLER_INACTIVE",
  ) {
    super(code);
  }
}

interface CallRow {
  id: string;
  caller_id: string;
  companion_id: string;
  room_name: string;
  status: "ringing" | "active" | "ended" | "missed" | "rejected" | "failed";
  coins_per_min: number;
  companion_paise_per_min: number;
  minutes_charged: number;
  coins_charged: number;
  paise_credited: number;
  started_at: Date | null;
}

export interface StartedCall {
  callId: string;
  room: string;
  coinsPerMin: number;
  callerToken: string;
  companionToken: string;
}

export interface BillingDeps {
  db: Db;
  redis: Redis;
  rooms: RoomControl;
  events: UserEvents;
  log?: Pick<Console, "warn" | "error">;
}

export class BillingEngine {
  private readonly db: Db;
  private readonly redis: Redis;
  private readonly rooms: RoomControl;
  private readonly events: UserEvents;
  private readonly log: Pick<Console, "warn" | "error">;

  constructor(deps: BillingDeps) {
    this.db = deps.db;
    this.redis = deps.redis;
    this.rooms = deps.rooms;
    this.events = deps.events;
    this.log = deps.log ?? console;
  }

  // -------------------------------------------------------------------------
  // 1. Caller taps "Call"
  // -------------------------------------------------------------------------
  async startCall(callerId: string, companionId: string, type: CallType): Promise<StartedCall> {
    if (!(await this.redis.sismember(ONLINE_SET, companionId))) throw new CallError("OFFLINE");
    // SET NX: only one caller can ring a companion at a time.
    const locked = await this.redis.set(busyKey(companionId), callerId, "EX", RING_TIMEOUT_S + 5, "NX");
    if (!locked) throw new CallError("BUSY");

    try {
      const call = await tx(this.db, async (c) => {
        const caller = (await c.query<{ status: string }>(
          `SELECT status FROM users WHERE id = $1`, [callerId],
        )).rows[0];
        if (caller?.status !== "active") throw new CallError("CALLER_INACTIVE");

        const companion = (await c.query<{ status: string; role: string; kyc_status: string; video_enabled: boolean }>(
          `SELECT u.status, u.role, p.kyc_status, p.video_enabled
             FROM users u JOIN companion_profiles p ON p.user_id = u.id
            WHERE u.id = $1`,
          [companionId],
        )).rows[0];
        if (!companion || companion.role !== "companion" || companion.status !== "active"
            || companion.kyc_status !== "approved") {
          throw new CallError("NOT_A_COMPANION");
        }
        if (type === "video" && !companion.video_enabled) throw new CallError("VIDEO_NOT_ENABLED");

        const blocked = await c.query(
          `SELECT 1 FROM blocks
            WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`,
          [callerId, companionId],
        );
        if (blocked.rowCount) throw new CallError("BLOCKED");

        // Current rate for the companion's language + call type, frozen onto the call.
        const rate = (await c.query<{ id: number; language_code: string; coins_per_min: number; companion_paise_per_min: number }>(
          `SELECT r.id, r.language_code, r.coins_per_min, r.companion_paise_per_min
             FROM call_rates r JOIN users u ON u.primary_language = r.language_code
            WHERE u.id = $1 AND r.call_type = $2 AND r.effective_from <= now()
            ORDER BY r.effective_from DESC LIMIT 1`,
          [companionId, type],
        )).rows[0];
        if (!rate) throw new CallError("NO_RATE");

        const balance = (await c.query<{ balance: number }>(
          `SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [callerId],
        )).rows[0]?.balance ?? 0;
        if (balance < rate.coins_per_min) throw new CallError("INSUFFICIENT_BALANCE");

        return (await c.query<CallRow>(
          `INSERT INTO calls (caller_id, companion_id, type, language_code, rate_id,
                              coins_per_min, companion_paise_per_min, room_name)
           VALUES ($1, $2, $3, $4, $5, $6, $7, 'call_' || gen_random_uuid())
           RETURNING *`,
          [callerId, companionId, type, rate.language_code, rate.id,
           rate.coins_per_min, rate.companion_paise_per_min],
        )).rows[0]!;
      });

      // The incoming-call FCM push to the companion is sent by the caller of startCall.
      return {
        callId: call.id,
        room: call.room_name,
        coinsPerMin: call.coins_per_min,
        callerToken: await this.rooms.joinToken(call.room_name, callerId),
        companionToken: await this.rooms.joinToken(call.room_name, companionId),
      };
    } catch (e) {
      await this.redis.del(busyKey(companionId));
      throw e;
    }
  }

  // -------------------------------------------------------------------------
  // 2. LiveKit webhook: second participant joined -> the call is really connected
  // -------------------------------------------------------------------------
  async onCallConnected(callId: string): Promise<void> {
    const call = (await this.db.query<CallRow>(
      `UPDATE calls SET status = 'active', started_at = now()
        WHERE id = $1 AND status = 'ringing' RETURNING *`,
      [callId],
    )).rows[0];
    if (!call) return; // duplicate or late webhook

    await this.redis.expire(busyKey(call.companion_id), ACTIVE_BUSY_TTL_S);
    const result = await this.chargeMinute(callId, 1);
    if (result !== "ok" && result !== "already_charged") {
      await this.endCall(callId, "balance");
      return;
    }
    await this.schedule(callId, 2, call.started_at!.getTime() + MINUTE_MS);

    const balance = (await this.db.query<{ balance: number }>(
      `SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [call.caller_id],
    )).rows[0]?.balance ?? null;
    const connected = { t: "call_connected" as const, callId, coinsPerMin: call.coins_per_min };
    await this.events.publish(call.caller_id, { ...connected, balanceAfterFirstMinute: balance });
    await this.events.publish(call.companion_id, { ...connected, balanceAfterFirstMinute: null });
  }

  // -------------------------------------------------------------------------
  // 3. Charge one minute. Idempotent: the call_ticks PK stops double billing.
  // -------------------------------------------------------------------------
  async chargeMinute(callId: string, minuteNo: number): Promise<ChargeResult> {
    let lowBalanceFor: string | null = null;
    let result: ChargeResult;
    try {
      result = await tx(this.db, async (c) => {
        const call = (await c.query<CallRow>(`SELECT * FROM calls WHERE id = $1 FOR UPDATE`, [callId])).rows[0];
        if (!call || call.status !== "active") return "not_active";

        const tick = await c.query(
          `INSERT INTO call_ticks (call_id, minute_no, coins_charged, paise_credited)
           VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING`,
          [callId, minuteNo, call.coins_per_min, call.companion_paise_per_min],
        );
        if (!tick.rowCount) return "already_charged";

        const refs = { callId, note: `minute ${minuteNo}` };
        const after = await post(c, call.caller_id, "coins", "call_debit",
          -call.coins_per_min, `call:${callId}:m${minuteNo}:debit`, refs);
        if (after === null) throw new InsufficientFunds(); // rolls back the tick row too

        if (call.companion_paise_per_min > 0) {
          await post(c, call.companion_id, "earnings", "call_credit",
            call.companion_paise_per_min, `call:${callId}:m${minuteNo}:credit`, refs);
        }
        await c.query(
          `UPDATE calls SET minutes_charged = minutes_charged + 1,
                  coins_charged = coins_charged + $2, paise_credited = paise_credited + $3
            WHERE id = $1`,
          [callId, call.coins_per_min, call.companion_paise_per_min],
        );
        // The NEXT minute can't be paid: the client shows "call ends in 60s".
        if (after < call.coins_per_min) lowBalanceFor = call.caller_id;
        return "ok";
      });
    } catch (e) {
      if (e instanceof InsufficientFunds) return "insufficient";
      throw e;
    }
    if (lowBalanceFor) await this.events.publish(lowBalanceFor, { t: "low_balance", callId });
    return result;
  }

  // -------------------------------------------------------------------------
  // 4. Worker: charge every minute that is due. Several workers can run; ZREM
  //    claims a job so two workers never charge the same minute (and the PK
  //    would stop it anyway). Returns how many jobs this pass handled.
  // -------------------------------------------------------------------------
  async processDue(nowMs: number = Date.now(), limit = 100): Promise<number> {
    const due = await this.redis.zrangebyscore(DUE_ZSET, 0, nowMs, "LIMIT", 0, limit);
    let handled = 0;
    for (const member of due) {
      if ((await this.redis.zrem(DUE_ZSET, member)) !== 1) continue; // another worker took it
      handled++;
      const [callId, m] = member.split(":");
      const minuteNo = Number(m);
      try {
        const r = await this.chargeMinute(callId!, minuteNo);
        if (r === "ok" || r === "already_charged") {
          const startedMs = await this.startedAtMs(callId!);
          if (startedMs !== null) await this.schedule(callId!, minuteNo + 1, startedMs + minuteNo * MINUTE_MS);
        } else if (r === "insufficient") {
          await this.endCall(callId!, "balance");
        }
        // "not_active": the call already ended; drop the job.
      } catch (err) {
        this.log.error("billing: charge failed, retrying", { callId, minuteNo, err });
        await this.redis.zadd(DUE_ZSET, nowMs + RETRY_DELAY_MS, member);
      }
    }
    return handled;
  }

  async runWorker(signal: AbortSignal, intervalMs = 2_000): Promise<void> {
    while (!signal.aborted) {
      try {
        await this.processDue();
      } catch (err) {
        this.log.error("billing: worker pass failed", err);
      }
      await new Promise((r) => setTimeout(r, intervalMs));
    }
  }

  // -------------------------------------------------------------------------
  // 5. End call: hangup, LiveKit room_finished webhook, balance, sweeper or
  //    admin. Safe to call any number of times.
  // -------------------------------------------------------------------------
  async endCall(callId: string, reason: EndReason): Promise<void> {
    const call = await tx(this.db, async (c) => {
      const row = (await c.query<CallRow & { duration_s: number | null }>(
        `UPDATE calls
            SET status = CASE WHEN status = 'ringing'
                              THEN (CASE WHEN $2 = 'companion_reject' THEN 'rejected' ELSE 'missed' END)::call_status
                              ELSE 'ended' END,
                ended_at = now(), end_reason = $2
          WHERE id = $1 AND status IN ('ringing', 'active')
          RETURNING *, EXTRACT(EPOCH FROM (now() - started_at))::float8 AS duration_s`,
        [callId, reason],
      )).rows[0];
      if (!row) return null; // already ended

      if (row.started_at && row.duration_s !== null) {
        if (row.duration_s < GRACE_SECONDS && row.minutes_charged > 0) {
          await this.graceRefund(c, row);
        }
        await c.query(
          `UPDATE companion_profiles SET total_call_seconds = total_call_seconds + $2 WHERE user_id = $1`,
          [row.companion_id, Math.round(row.duration_s)],
        );
      }
      return row;
    });
    if (!call) return;

    // Disposable state. A leftover schedule entry would return "not_active" anyway.
    await this.redis.zrem(DUE_ZSET, `${callId}:${call.minutes_charged + 1}`);
    await this.redis.del(busyKey(call.companion_id));
    await this.rooms.closeRoom(call.room_name);
    await this.events.publish(call.caller_id, { t: "call_ended", callId, reason });
    await this.events.publish(call.companion_id, { t: "call_ended", callId, reason });
  }

  private async graceRefund(c: DbClient, row: CallRow): Promise<void> {
    await post(c, row.caller_id, "coins", "refund", row.coins_charged,
      `call:${row.id}:grace:refund`, { callId: row.id, note: "call under grace period" });
    if (row.paise_credited === 0) return;
    // If the companion already withdrew the money the guard refuses to go
    // negative; finance settles it by hand.
    const reversed = await post(c, row.companion_id, "earnings", "refund_reversal",
      -row.paise_credited, `call:${row.id}:grace:reverse`, { callId: row.id, note: "call under grace period" });
    if (reversed === null) {
      await c.query(
        `INSERT INTO billing_exceptions (call_id, user_id, kind, amount)
         VALUES ($1, $2, 'grace_reversal_failed', $3)`,
        [row.id, row.companion_id, row.paise_credited],
      );
      this.log.warn("billing: grace reversal needs manual review", { callId: row.id });
    }
  }

  // -------------------------------------------------------------------------
  // 6. Sweeper (run every ~30 s): repairs what a crash or lost webhook left.
  // -------------------------------------------------------------------------
  async sweep(): Promise<void> {
    const stale = await this.db.query<{ id: string }>(
      `SELECT id FROM calls
        WHERE status = 'ringing' AND created_at < now() - $1 * interval '1 second'`,
      [RING_TIMEOUT_S],
    );
    for (const r of stale.rows) await this.endCall(r.id, "timeout");

    // Every active call must have its next minute scheduled. If Redis lost it,
    // ask LiveKit whether both people are still there.
    const active = await this.db.query<{ id: string; room_name: string; started_at: Date; minutes_charged: number }>(
      `SELECT id, room_name, started_at, minutes_charged FROM calls WHERE status = 'active'`,
    );
    for (const r of active.rows) {
      const next = r.minutes_charged + 1;
      if ((await this.redis.zscore(DUE_ZSET, `${r.id}:${next}`)) !== null) continue;
      if ((await this.rooms.participantCount(r.room_name)) < 2) {
        await this.endCall(r.id, "network");
      } else {
        await this.schedule(r.id, next, r.started_at.getTime() + r.minutes_charged * MINUTE_MS);
      }
    }
  }

  // -------------------------------------------------------------------------
  private async schedule(callId: string, minuteNo: number, dueMs: number): Promise<void> {
    await this.redis.zadd(DUE_ZSET, dueMs, `${callId}:${minuteNo}`);
  }

  private async startedAtMs(callId: string): Promise<number | null> {
    const r = await this.db.query<{ started_at: Date | null }>(`SELECT started_at FROM calls WHERE id = $1`, [callId]);
    return r.rows[0]?.started_at?.getTime() ?? null;
  }
}

class InsufficientFunds extends Error {}
