import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import {
  backdateStart, balance, createCaller, createCompanion, createHarness, dueMembers, getCall,
  resetState, setRate, ticks, type Harness,
} from "../../test/fixtures.js";
import { busyKey, CallError, DUE_ZSET, ONLINE_SET, RETRY_DELAY_MS } from "./engine.js";

const MIN = 60_000;
let h: Harness;

beforeAll(() => { h = createHarness(); });
afterAll(async () => { await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); });

/** Caller with `coins`, approved Tamil companion, audio 10 coins/min → ₹3.00 (300 paise)/min. */
async function setup(coins = 100) {
  await setRate(h, "ta", "audio", 10, 300);
  await setRate(h, "ta", "video", 25, 700);
  const caller = await createCaller(h, coins);
  const companion = await createCompanion(h);
  return { caller, companion };
}

async function connectedCall(coins = 100, type: "audio" | "video" = "audio") {
  const { caller, companion } = await setup(coins);
  const started = await h.engine.startCall(caller, companion, type);
  h.rooms.participants.set(started.room, 2);
  await h.engine.onCallConnected(started.callId);
  const call = await getCall(h, started.callId);
  return { caller, companion, callId: started.callId, startedMs: call.started_at!.getTime(), room: started.room };
}

async function expectCallError(p: Promise<unknown>, code: CallError["code"]) {
  await expect(p).rejects.toSatisfy((e: unknown) => e instanceof CallError && e.code === code);
}

describe("startCall", () => {
  it("creates a ringing call with the current rate frozen onto it and no money moved", async () => {
    const { caller, companion } = await setup();
    const started = await h.engine.startCall(caller, companion, "audio");

    const call = await getCall(h, started.callId);
    expect(call.status).toBe("ringing");
    expect(started.coinsPerMin).toBe(10);
    expect(started.callerToken).toContain(caller);
    expect(started.companionToken).toContain(companion);
    expect(await balance(h, caller, "coins")).toBe(100);
    expect(await h.redis.get(busyKey(companion))).toBe(caller);
  });

  it("uses the newest effective rate, and a later rate change does not affect the call", async () => {
    const { caller, companion } = await setup();
    await setRate(h, "ta", "audio", 12, 350, "now() - interval '1 hour'");   // newer than setup's
    await setRate(h, "ta", "audio", 99, 999, "now() + interval '1 hour'");   // not effective yet
    const started = await h.engine.startCall(caller, companion, "audio");
    expect(started.coinsPerMin).toBe(12);

    await setRate(h, "ta", "audio", 50, 900, "now()");                        // changes mid-call
    h.rooms.participants.set(started.room, 2);
    await h.engine.onCallConnected(started.callId);
    expect(await balance(h, caller, "coins")).toBe(100 - 12);
    expect(await balance(h, companion, "earnings")).toBe(350);
  });

  it("refuses offline, busy, blocked, unverified and underfunded calls, releasing the busy lock", async () => {
    const { caller, companion } = await setup(5); // less than one minute (10 coins)

    await expectCallError(h.engine.startCall(caller, companion, "audio"), "INSUFFICIENT_BALANCE");
    expect(await h.redis.get(busyKey(companion))).toBeNull();

    const rich = await createCaller(h, 1000);
    await h.redis.srem(ONLINE_SET, companion);
    await expectCallError(h.engine.startCall(rich, companion, "audio"), "OFFLINE");
    await h.redis.sadd(ONLINE_SET, companion);

    await h.db.query(`INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2)`, [companion, rich]);
    await expectCallError(h.engine.startCall(rich, companion, "audio"), "BLOCKED");
    expect(await h.redis.get(busyKey(companion))).toBeNull();

    const pending = await createCompanion(h, { kyc: "pending" });
    await expectCallError(h.engine.startCall(rich, pending, "audio"), "NOT_A_COMPANION");

    const noVideo = await createCompanion(h, { video: false });
    await expectCallError(h.engine.startCall(rich, noVideo, "video"), "VIDEO_NOT_ENABLED");

    const telugu = await createCompanion(h, { language: "te" });
    await expectCallError(h.engine.startCall(rich, telugu, "audio"), "NO_RATE");
  });

  it("lets only one of two simultaneous callers ring the same companion", async () => {
    const { caller, companion } = await setup();
    const other = await createCaller(h, 100);
    const results = await Promise.allSettled([
      h.engine.startCall(caller, companion, "audio"),
      h.engine.startCall(other, companion, "audio"),
    ]);
    expect(results.filter((r) => r.status === "fulfilled")).toHaveLength(1);
    const rejected = results.find((r) => r.status === "rejected") as PromiseRejectedResult;
    expect((rejected.reason as CallError).code).toBe("BUSY");
  });
});

describe("connect and per-minute charging", () => {
  it("charges minute 1 only when both participants have joined, and schedules minute 2", async () => {
    const { caller, companion, callId, startedMs } = await connectedCall();

    expect(await balance(h, caller, "coins")).toBe(90);
    expect(await balance(h, companion, "earnings")).toBe(300);
    expect(await ticks(h, callId)).toEqual([1]);
    expect(await h.redis.zscore(DUE_ZSET, `${callId}:2`)).toBe(String(startedMs + MIN));
    expect((await getCall(h, callId)).status).toBe("active");
  });

  it("ignores a duplicate connected webhook", async () => {
    const { caller, callId } = await connectedCall();
    await h.engine.onCallConnected(callId);
    await h.engine.onCallConnected(callId);
    expect(await ticks(h, callId)).toEqual([1]);
    expect(await balance(h, caller, "coins")).toBe(90);
  });

  it("charges each minute at its start, not before", async () => {
    const { caller, companion, callId, startedMs } = await connectedCall();

    expect(await h.engine.processDue(startedMs + MIN - 1)).toBe(0);   // minute 2 not due yet
    await h.engine.processDue(startedMs + MIN);                        // minute 2
    await h.engine.processDue(startedMs + 2 * MIN);                    // minute 3

    expect(await ticks(h, callId)).toEqual([1, 2, 3]);
    expect(await balance(h, caller, "coins")).toBe(70);
    expect(await balance(h, companion, "earnings")).toBe(900);
    const call = await getCall(h, callId);
    expect([call.minutes_charged, call.coins_charged, call.paise_credited]).toEqual([3, 30, 900]);
    expect(await h.redis.zscore(DUE_ZSET, `${callId}:4`)).toBe(String(startedMs + 3 * MIN));
  });

  it("writes a ledger row for every coin that moves, and wallet balances match the ledger", async () => {
    const { caller, companion, callId, startedMs } = await connectedCall();
    await h.engine.processDue(startedMs + MIN);

    const rows = (await h.db.query<{ type: string; amount: number; note: string }>(
      `SELECT type, amount, note FROM ledger_entries WHERE call_id = $1 ORDER BY id`, [callId],
    )).rows;
    expect(rows).toEqual([
      { type: "call_debit", amount: -10, note: "minute 1" },
      { type: "call_credit", amount: 300, note: "minute 1" },
      { type: "call_debit", amount: -10, note: "minute 2" },
      { type: "call_credit", amount: 300, note: "minute 2" },
    ]);
    const sums = (await h.db.query<{ user_id: string; kind: string; balance: number; ledger: number }>(
      `SELECT w.user_id, w.kind, w.balance, COALESCE(SUM(l.amount), 0)::bigint AS ledger
         FROM wallets w LEFT JOIN ledger_entries l ON l.wallet_id = w.id
        WHERE w.user_id IN ($1, $2) GROUP BY w.id`, [caller, companion],
    )).rows;
    for (const s of sums) expect(s.balance).toBe(s.ledger);
  });
});

describe("insufficient balance", () => {
  it("warns when the next minute can't be paid, then ends the call without going negative", async () => {
    const { caller, companion, callId, startedMs } = await connectedCall(25); // 2 minutes + 5 spare coins
    await backdateStart(h, callId, 125); // keep the DB clock in step with the simulated worker clock

    expect(h.events.of(caller, "low_balance")).toHaveLength(0);
    await h.engine.processDue(startedMs + MIN);                        // minute 2 → 5 coins left
    expect(h.events.of(caller, "low_balance")).toHaveLength(1);

    await h.engine.processDue(startedMs + 2 * MIN);                    // minute 3 can't be paid
    const call = await getCall(h, callId);
    expect(call.status).toBe("ended");
    expect(call.end_reason).toBe("balance");
    expect(await ticks(h, callId)).toEqual([1, 2]);                    // failed tick rolled back
    expect(await balance(h, caller, "coins")).toBe(5);
    expect(await balance(h, companion, "earnings")).toBe(600);
    expect(h.events.of(caller, "call_ended")).toHaveLength(1);
    expect(h.events.of(companion, "call_ended")).toHaveLength(1);
    expect(await dueMembers(h)).toEqual([]);
    expect(await h.redis.get(busyKey(companion))).toBeNull();
  });

  it("ends the call at connect if the caller spent their coins while it was ringing", async () => {
    const { caller, companion } = await setup(10);
    const started = await h.engine.startCall(caller, companion, "audio");
    await h.db.query(`UPDATE wallets SET balance = 0 WHERE user_id = $1 AND kind = 'coins'`, [caller]);

    await h.engine.onCallConnected(started.callId);
    const call = await getCall(h, started.callId);
    expect([call.status, call.end_reason, call.minutes_charged]).toEqual(["ended", "balance", 0]);
    expect(await dueMembers(h)).toEqual([]);
  });

  it("the database itself refuses a negative balance", async () => {
    const caller = await createCaller(h, 5);
    await expect(h.db.query(
      `UPDATE wallets SET balance = balance - 10 WHERE user_id = $1 AND kind = 'coins'`, [caller],
    )).rejects.toThrow(/check constraint/);
  });
});

describe("ending calls", () => {
  it("refunds everything when a call ends inside the 10 s grace period", async () => {
    const { caller, companion, callId, room } = await connectedCall();
    await backdateStart(h, callId, 4);
    await h.engine.endCall(callId, "caller_hangup");

    expect(await balance(h, caller, "coins")).toBe(100);
    expect(await balance(h, companion, "earnings")).toBe(0);
    expect(await ticks(h, callId)).toEqual([1]); // minute stays visible in call details
    const types = (await h.db.query<{ type: string }>(
      `SELECT type FROM ledger_entries WHERE call_id = $1 ORDER BY id`, [callId],
    )).rows.map((r) => r.type);
    expect(types).toEqual(["call_debit", "call_credit", "refund", "refund_reversal"]);
    expect(h.rooms.closed).toEqual([room]);
  });

  it("does not refund a call that lasted past the grace period", async () => {
    const { caller, companion, callId } = await connectedCall();
    await backdateStart(h, callId, 45);
    await h.engine.endCall(callId, "companion_hangup");

    expect(await balance(h, caller, "coins")).toBe(90);
    expect(await balance(h, companion, "earnings")).toBe(300);
    const profile = (await h.db.query<{ total_call_seconds: number }>(
      `SELECT total_call_seconds FROM companion_profiles WHERE user_id = $1`, [companion],
    )).rows[0]!;
    expect(profile.total_call_seconds).toBeGreaterThanOrEqual(45);
  });

  it("records a manual-review exception if the companion's earnings are already gone", async () => {
    const { caller, companion, callId } = await connectedCall();
    await h.db.query(`UPDATE wallets SET balance = 0 WHERE user_id = $1 AND kind = 'earnings'`, [companion]);
    await backdateStart(h, callId, 3);
    await h.engine.endCall(callId, "caller_hangup");

    expect(await balance(h, caller, "coins")).toBe(100); // caller is refunded regardless
    const ex = (await h.db.query<{ kind: string; amount: number }>(
      `SELECT kind, amount FROM billing_exceptions WHERE call_id = $1`, [callId],
    )).rows;
    expect(ex).toEqual([{ kind: "grace_reversal_failed", amount: 300 }]);
    expect(h.warnings).toHaveLength(1);
  });

  it("is safe to call repeatedly — refunds and events happen once", async () => {
    const { caller, callId } = await connectedCall();
    await backdateStart(h, callId, 2);
    await Promise.all([
      h.engine.endCall(callId, "caller_hangup"),
      h.engine.endCall(callId, "network"),
      h.engine.endCall(callId, "companion_hangup"),
    ]);
    await h.engine.endCall(callId, "admin");

    expect(await balance(h, caller, "coins")).toBe(100);
    expect(h.events.of(caller, "call_ended")).toHaveLength(1);
  });

  it("marks an unanswered call missed and a declined call rejected, charging nothing", async () => {
    const { caller, companion } = await setup();
    const a = await h.engine.startCall(caller, companion, "audio");
    await h.engine.endCall(a.callId, "companion_reject");
    const b = await h.engine.startCall(caller, companion, "audio");
    await h.engine.endCall(b.callId, "caller_hangup");

    expect((await getCall(h, a.callId)).status).toBe("rejected");
    expect((await getCall(h, b.callId)).status).toBe("missed");
    expect(await balance(h, caller, "coins")).toBe(100);
  });

  it("stops charging once the call has ended", async () => {
    const { caller, callId, startedMs } = await connectedCall();
    await backdateStart(h, callId, 30);
    await h.engine.endCall(callId, "caller_hangup");
    await h.redis.zadd(DUE_ZSET, startedMs + MIN, `${callId}:2`); // stale job left behind

    await h.engine.processDue(startedMs + MIN);
    expect(await ticks(h, callId)).toEqual([1]);
    expect(await balance(h, caller, "coins")).toBe(90);
    expect(await dueMembers(h)).toEqual([]);
  });
});

describe("worker crashes and retries", () => {
  it("retries a minute 5 s later when charging throws", async () => {
    const { callId, startedMs } = await connectedCall();
    const spy = vi.spyOn(h.engine, "chargeMinute").mockRejectedValueOnce(new Error("db blip"));

    const now = startedMs + MIN;
    await h.engine.processDue(now);
    expect(await h.redis.zscore(DUE_ZSET, `${callId}:2`)).toBe(String(now + RETRY_DELAY_MS));
    expect(await ticks(h, callId)).toEqual([1]);

    spy.mockRestore();
    await h.engine.processDue(now + RETRY_DELAY_MS);
    expect(await ticks(h, callId)).toEqual([1, 2]);
  });

  it("never double-charges a minute when two workers race for it", async () => {
    const { caller, callId, startedMs } = await connectedCall();
    await Promise.all([
      h.engine.processDue(startedMs + MIN),
      h.engine.processDue(startedMs + MIN),
      h.engine.chargeMinute(callId, 2),
    ]);
    expect(await ticks(h, callId)).toEqual([1, 2]);
    expect(await balance(h, caller, "coins")).toBe(80);
  });

  it("a worker that claimed a minute and died loses nothing: the sweeper reschedules it", async () => {
    const { callId, startedMs } = await connectedCall();
    await h.redis.zrem(DUE_ZSET, `${callId}:2`); // claimed, then the process died

    await h.engine.sweep();
    expect(await h.redis.zscore(DUE_ZSET, `${callId}:2`)).toBe(String(startedMs + MIN));
    await h.engine.processDue(startedMs + MIN);
    expect(await ticks(h, callId)).toEqual([1, 2]);
  });

  it("a worker that charged but died before scheduling: the sweeper schedules the next minute", async () => {
    const { callId, startedMs } = await connectedCall();
    await h.redis.zrem(DUE_ZSET, `${callId}:2`);
    await h.engine.chargeMinute(callId, 2);      // charged, then the process died

    await h.engine.sweep();
    expect(await dueMembers(h)).toEqual([`${callId}:3`]);
    expect(await h.redis.zscore(DUE_ZSET, `${callId}:3`)).toBe(String(startedMs + 2 * MIN));
  });

  it("a crash between 'connected' and the first charge is repaired by the sweeper", async () => {
    const { caller, companion } = await setup();
    const started = await h.engine.startCall(caller, companion, "audio");
    h.rooms.participants.set(started.room, 2);
    await h.db.query(`UPDATE calls SET status = 'active', started_at = now() WHERE id = $1`, [started.callId]);

    await h.engine.sweep();
    await h.engine.processDue(Date.now() + 1000);
    expect(await ticks(h, started.callId)).toEqual([1]);
    expect(await balance(h, caller, "coins")).toBe(90);
  });
});

describe("sweeper", () => {
  it("times out calls that rang for more than 45 s", async () => {
    const { caller, companion } = await setup();
    const started = await h.engine.startCall(caller, companion, "audio");
    await h.db.query(`UPDATE calls SET created_at = now() - interval '46 seconds' WHERE id = $1`, [started.callId]);

    await h.engine.sweep();
    const call = await getCall(h, started.callId);
    expect([call.status, call.end_reason]).toEqual(["missed", "timeout"]);
    expect(await h.redis.get(busyKey(companion))).toBeNull();
  });

  it("leaves a ringing call under 45 s alone", async () => {
    const { caller, companion } = await setup();
    const started = await h.engine.startCall(caller, companion, "audio");
    await h.engine.sweep();
    expect((await getCall(h, started.callId)).status).toBe("ringing");
  });

  it("ends an active call whose schedule was lost and whose room is empty (lost webhook)", async () => {
    const { callId, room } = await connectedCall();
    await h.redis.del(DUE_ZSET);                   // Redis restarted and lost the schedule
    h.rooms.participants.set(room, 1);             // the caller's phone died

    await h.engine.sweep();
    const call = await getCall(h, callId);
    expect([call.status, call.end_reason]).toEqual(["ended", "network"]);
  });

  it("does not touch a healthy active call", async () => {
    const { callId } = await connectedCall();
    const before = await dueMembers(h);
    await h.engine.sweep();
    expect(await dueMembers(h)).toEqual(before);
    expect((await getCall(h, callId)).status).toBe("active");
  });
});

describe("ledger", () => {
  it("is append-only: updates and deletes are refused", async () => {
    await connectedCall();
    await expect(h.db.query(`UPDATE ledger_entries SET amount = 1`)).rejects.toThrow(/append-only/);
    await expect(h.db.query(`DELETE FROM ledger_entries`)).rejects.toThrow(/append-only/);
  });
});
