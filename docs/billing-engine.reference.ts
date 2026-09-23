/**
 * Per-minute call billing engine.
 *
 * Model: prepaid per minute. Minute N is charged at the START of minute N,
 * so a caller can never talk on credit and balances never go negative.
 * Each charge debits the caller and credits the companion in ONE transaction.
 *
 * Sources of truth:
 *   - Postgres: wallets, ledger, calls, call_ticks (money lives only here)
 *   - Redis:    presence, busy locks, the "next charge due" schedule (disposable)
 *   - LiveKit webhooks: when a call really connected / really ended
 *
 * deps: pg, ioredis, livekit-server-sdk
 */
import { Pool, PoolClient } from "pg";
import Redis from "ioredis";
import { AccessToken, RoomServiceClient } from "livekit-server-sdk";

const db = new Pool({ connectionString: process.env.DATABASE_URL });
const redis = new Redis(process.env.REDIS_URL!);
const rooms = new RoomServiceClient(
  process.env.LIVEKIT_URL!, process.env.LIVEKIT_KEY!, process.env.LIVEKIT_SECRET!,
);

const DUE_ZSET = "billing:due";         // member = callId, score = next charge epoch ms
const RING_TIMEOUT_S = 45;
const GRACE_SECONDS = 10;               // calls shorter than this are fully refunded
const TICK_INTERVAL_MS = 2000;

// ---------------------------------------------------------------------------
// Ledger primitive: atomic, idempotent, can't go negative
// ---------------------------------------------------------------------------
type Refs = { callId?: string; purchaseId?: string; payoutId?: string; note?: string };

async function post(
  c: PoolClient, userId: string, kind: "coins" | "earnings",
  type: string, amount: number, idemKey: string, refs: Refs = {},
): Promise<number | null> {
  // Guarded update: returns no row if the debit would make balance negative.
  const w = await c.query(
    `UPDATE wallets SET balance = balance + $1, updated_at = now()
      WHERE user_id = $2 AND kind = $3 AND balance + $1 >= 0
      RETURNING id, balance`,
    [amount, userId, kind],
  );
  if (w.rowCount === 0) return null;
  await c.query(
    `INSERT INTO ledger_entries
       (wallet_id, type, amount, balance_after, call_id, purchase_id, payout_id, idempotency_key, note)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
    [w.rows[0].id, type, amount, w.rows[0].balance, refs.callId ?? null,
     refs.purchaseId ?? null, refs.payoutId ?? null, idemKey, refs.note ?? null],
  );
  return Number(w.rows[0].balance);
}

async function tx<T>(fn: (c: PoolClient) => Promise<T>): Promise<T> {
  const c = await db.connect();
  try {
    await c.query("BEGIN");
    const r = await fn(c);
    await c.query("COMMIT");
    return r;
  } catch (e) {
    await c.query("ROLLBACK");
    throw e;
  } finally {
    c.release();
  }
}

// ---------------------------------------------------------------------------
// 1. Caller taps "Call"
// ---------------------------------------------------------------------------
export async function startCall(callerId: string, companionId: string, type: "audio" | "video") {
  // Companion must be online and not busy. SET NX = only one caller wins.
  if (!(await redis.sismember("online:companions", companionId))) throw new Error("OFFLINE");
  const locked = await redis.set(`busy:${companionId}`, callerId, "EX", RING_TIMEOUT_S + 5, "NX");
  if (!locked) throw new Error("BUSY");

  try {
    const call = await tx(async (c) => {
      const blocked = await c.query(
        `SELECT 1 FROM blocks WHERE (blocker_id=$1 AND blocked_id=$2) OR (blocker_id=$2 AND blocked_id=$1)`,
        [callerId, companionId],
      );
      if (blocked.rowCount) throw new Error("BLOCKED");

      // Current rate for the companion's language + call type, frozen onto the call.
      const rate = (await c.query(
        `SELECT r.* FROM call_rates r JOIN users u ON u.primary_language = r.language_code
          WHERE u.id = $1 AND r.call_type = $2 AND r.effective_from <= now()
          ORDER BY r.effective_from DESC LIMIT 1`,
        [companionId, type],
      )).rows[0];
      if (!rate) throw new Error("NO_RATE");

      const bal = (await c.query(
        `SELECT balance FROM wallets WHERE user_id=$1 AND kind='coins'`, [callerId],
      )).rows[0]?.balance ?? 0;
      if (Number(bal) < rate.coins_per_min) throw new Error("INSUFFICIENT_BALANCE");

      return (await c.query(
        `INSERT INTO calls (caller_id, companion_id, type, language_code, rate_id,
                            coins_per_min, companion_paise_per_min, room_name)
         VALUES ($1,$2,$3,$4,$5,$6,$7, 'call_' || gen_random_uuid())
         RETURNING *`,
        [callerId, companionId, type, rate.language_code, rate.id,
         rate.coins_per_min, rate.companion_paise_per_min],
      )).rows[0];
    });

    // Tokens let each side join the room; tokens expire so they can't be reused.
    const token = (identity: string) => {
      const t = new AccessToken(process.env.LIVEKIT_KEY!, process.env.LIVEKIT_SECRET!, {
        identity, ttl: "2h",
      });
      t.addGrant({ room: call.room_name, roomJoin: true, canPublish: true, canSubscribe: true });
      return t.toJwt();
    };

    // Push incoming-call notification to companion via FCM here (omitted).
    return { callId: call.id, room: call.room_name,
             callerToken: await token(callerId), companionToken: await token(companionId) };
  } catch (e) {
    await redis.del(`busy:${companionId}`);
    throw e;
  }
}

// ---------------------------------------------------------------------------
// 2. LiveKit webhook: second participant joined -> call is really connected
// ---------------------------------------------------------------------------
export async function onCallConnected(callId: string) {
  const res = await db.query(
    `UPDATE calls SET status='active', started_at=now()
      WHERE id=$1 AND status='ringing' RETURNING started_at`,
    [callId],
  );
  if (!res.rowCount) return;                         // duplicate webhook, ignore

  await redis.expire(`busy:${(await companionOf(callId))}`, 6 * 3600);
  const result = await chargeMinute(callId, 1);
  if (result !== "ok") return endCall(callId, "balance");

  const startedMs = new Date(res.rows[0].started_at).getTime();
  await redis.zadd(DUE_ZSET, startedMs + 60_000, `${callId}:2`);
}

// ---------------------------------------------------------------------------
// 3. Charge one minute (idempotent: call_ticks PK stops double billing)
// ---------------------------------------------------------------------------
type ChargeResult = "ok" | "insufficient" | "not_active" | "already_charged";

export async function chargeMinute(callId: string, minuteNo: number): Promise<ChargeResult> {
  return tx(async (c) => {
    const call = (await c.query(`SELECT * FROM calls WHERE id=$1 FOR UPDATE`, [callId])).rows[0];
    if (!call || call.status !== "active") return "not_active";

    const tick = await c.query(
      `INSERT INTO call_ticks (call_id, minute_no, coins_charged, paise_credited)
       VALUES ($1,$2,$3,$4) ON CONFLICT DO NOTHING`,
      [callId, minuteNo, call.coins_per_min, call.companion_paise_per_min],
    );
    if (!tick.rowCount) return "already_charged";

    const refs = { callId, note: `minute ${minuteNo}` };
    const after = await post(c, call.caller_id, "coins", "call_debit",
      -call.coins_per_min, `call:${callId}:m${minuteNo}:debit`, refs);
    if (after === null) {
      // Not enough coins: undo the tick row by rolling back this transaction.
      throw new InsufficientFunds();
    }
    await post(c, call.companion_id, "earnings", "call_credit",
      call.companion_paise_per_min, `call:${callId}:m${minuteNo}:credit`, refs);

    await c.query(
      `UPDATE calls SET minutes_charged = minutes_charged + 1,
              coins_charged = coins_charged + $2, paise_credited = paise_credited + $3
        WHERE id=$1`,
      [callId, call.coins_per_min, call.companion_paise_per_min],
    );

    // Warn the caller if the NEXT minute can't be paid (client shows "ends in 60s").
    if (after < call.coins_per_min) {
      await redis.publish(`user:${call.caller_id}`, JSON.stringify({ t: "low_balance", callId }));
    }
    return "ok";
  }).catch((e) => {
    if (e instanceof InsufficientFunds) return "insufficient" as const;
    throw e;
  });
}
class InsufficientFunds extends Error {}

// ---------------------------------------------------------------------------
// 4. Worker loop: charges every due minute. Run 1+ instances; ZREM claims a job
//    so two workers never charge the same minute (and the PK would stop it anyway).
// ---------------------------------------------------------------------------
export async function runBillingWorker() {
  for (;;) {
    const due = await redis.zrangebyscore(DUE_ZSET, 0, Date.now(), "LIMIT", 0, 100);
    for (const member of due) {
      if ((await redis.zrem(DUE_ZSET, member)) !== 1) continue;   // another worker took it
      const [callId, m] = member.split(":");
      const minuteNo = Number(m);
      try {
        const r = await chargeMinute(callId, minuteNo);
        if (r === "ok" || r === "already_charged") {
          const started = await startedAtMs(callId);
          await redis.zadd(DUE_ZSET, started + minuteNo * 60_000, `${callId}:${minuteNo + 1}`);
        } else if (r === "insufficient") {
          await endCall(callId, "balance");
        }
      } catch (err) {
        console.error("charge failed, retrying in 5s", callId, err);
        await redis.zadd(DUE_ZSET, Date.now() + 5000, member);
      }
    }
    await new Promise((r) => setTimeout(r, TICK_INTERVAL_MS));
  }
}

// ---------------------------------------------------------------------------
// 5. End call — from hangup button, LiveKit room_finished webhook, balance,
//    timeout sweeper or admin. Safe to call many times.
// ---------------------------------------------------------------------------
export async function endCall(callId: string, reason: string) {
  const call = await tx(async (c) => {
    const row = (await c.query(
      `UPDATE calls
          SET status = CASE WHEN status='ringing'
                            THEN (CASE WHEN $2 = 'companion_reject' THEN 'rejected' ELSE 'missed' END)::call_status
                            ELSE 'ended' END,
              ended_at = now(), end_reason = $2
        WHERE id=$1 AND status IN ('ringing','active')
        RETURNING *`,
      [callId, reason],
    )).rows[0];
    if (!row) return null;                                 // already ended

    // Grace refund: connection too short to be a real conversation.
    if (row.started_at) {
      const secs = (Date.now() - new Date(row.started_at).getTime()) / 1000;
      if (secs < GRACE_SECONDS && row.minutes_charged > 0) {
        await post(c, row.caller_id, "coins", "refund", Number(row.coins_charged),
          `call:${callId}:grace:refund`, { callId, note: "call under grace period" });
        // Reverse companion credit; if they already withdrew it, balance guard fails
        // and it goes to manual review instead of going negative.
        const rev = await post(c, row.companion_id, "earnings", "refund_reversal",
          -Number(row.paise_credited), `call:${callId}:grace:reverse`, { callId });
        if (rev === null) console.warn("reversal needs manual review", callId);
      }
      await c.query(
        `UPDATE companion_profiles SET total_call_seconds = total_call_seconds + $2 WHERE user_id=$1`,
        [row.companion_id, Math.round(secs)],
      );
    }
    return row;
  });
  if (!call) return;

  // Clean up disposable state. Scheduled ticks will return "not_active" anyway.
  await redis.del(`busy:${call.companion_id}`);
  await rooms.deleteRoom(call.room_name).catch(() => {});  // kicks both clients
  await redis.publish(`user:${call.caller_id}`, JSON.stringify({ t: "call_ended", callId, reason }));
  await redis.publish(`user:${call.companion_id}`, JSON.stringify({ t: "call_ended", callId, reason }));
}

// ---------------------------------------------------------------------------
// 6. Sweeper (run every 30s): fixes anything a crash or lost webhook left behind
// ---------------------------------------------------------------------------
export async function sweep() {
  const stale = await db.query(
    `SELECT id FROM calls WHERE status='ringing' AND created_at < now() - $1 * interval '1 second'`,
    [RING_TIMEOUT_S],
  );
  for (const r of stale.rows) await endCall(r.id, "timeout");

  // Active calls must have a schedule entry; if Redis lost it, check LiveKit.
  const active = await db.query(`SELECT id, room_name, started_at, minutes_charged FROM calls WHERE status='active'`);
  for (const r of active.rows) {
    const next = `${r.id}:${r.minutes_charged + 1}`;
    if (await redis.zscore(DUE_ZSET, next)) continue;
    const participants = await rooms.listParticipants(r.room_name).catch(() => []);
    if (participants.length < 2) await endCall(r.id, "network");
    else await redis.zadd(DUE_ZSET, new Date(r.started_at).getTime() + r.minutes_charged * 60_000, next);
  }
}

// ---------------------------------------------------------------------------
async function companionOf(callId: string) {
  return (await db.query(`SELECT companion_id FROM calls WHERE id=$1`, [callId])).rows[0].companion_id;
}
async function startedAtMs(callId: string) {
  const r = await db.query(`SELECT started_at FROM calls WHERE id=$1`, [callId]);
  return new Date(r.rows[0].started_at).getTime();
}
