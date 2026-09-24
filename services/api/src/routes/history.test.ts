import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, json, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { tx } from "../db/pool.js";
import { post } from "../billing/ledger.js";
import { ONLINE_SET } from "../billing/engine.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await setRate(h, "ta", "audio", 10, 300);
  await setRate(h, "ta", "video", 25, 700);
});

/** A connected call billed for `minutes` minutes, then ended (backdated past the grace period). */
async function billedCall(caller: string, companion: string, type: "audio" | "video", minutes: number) {
  await h.redis.flushdb(); // clear busy locks from the previous call
  await h.redis.sadd(ONLINE_SET, companion);
  const { callId } = await h.engine.startCall(caller, companion, type);
  await h.engine.onCallConnected(callId);
  for (let m = 2; m <= minutes; m++) await h.engine.chargeMinute(callId, m);
  await h.db.query(`UPDATE calls SET started_at = now() - interval '5 minutes' WHERE id = $1`, [callId]);
  await h.engine.endCall(callId, "caller_hangup");
  return callId;
}

describe("call history filters", () => {
  it("filters by type, outcome and date, with totals for the same filters", async () => {
    const callerId = await createCaller(h, 500);
    const companion = await createCompanion(h);
    const token = await tokenFor(h, callerId, "caller");
    await billedCall(callerId, companion, "audio", 3);
    await billedCall(callerId, companion, "video", 2);
    // A missed call from last week.
    await h.redis.flushdb();
    await h.redis.sadd(ONLINE_SET, companion);
    const missed = await h.engine.startCall(callerId, companion, "audio");
    await h.db.query(`UPDATE calls SET status = 'missed', ended_at = now(), created_at = now() - interval '8 days' WHERE id = $1`, [missed.callId]);

    type Page = { calls: { type: string; status: string }[]; summary: { calls: number; connected: number; missed: number; coinsSpent: number } };
    const get = async (q = "") => json<Page>(await call(h, "GET", `/v1/calls${q}`, { token }));

    const all = await get();
    expect(all.calls).toHaveLength(3);
    expect(all.summary).toMatchObject({ calls: 3, connected: 2, missed: 1, coinsSpent: 3 * 10 + 2 * 25 });

    expect((await get("?type=video")).calls.map((c) => c.type)).toEqual(["video"]);
    expect((await get("?outcome=missed")).calls.map((c) => c.status)).toEqual(["missed"]);
    expect((await get("?outcome=connected")).summary).toMatchObject({ calls: 2, missed: 0 });
    const lastWeek = new Date(Date.now() - 3 * 86_400_000).toISOString();
    expect((await get(`?from=${lastWeek}`)).summary.calls).toBe(2);
    expect((await get(`?to=${lastWeek}`)).summary).toMatchObject({ calls: 1, missed: 1 });
  });
});

describe("coin history", () => {
  it("one line per call, gifts and bonuses as their own lines; spent/added filters and totals", async () => {
    const callerId = await createCaller(h, 500);
    const companion = await createCompanion(h);
    const token = await tokenFor(h, callerId, "caller");
    await billedCall(callerId, companion, "audio", 3); // 30 coins over 3 ledger rows
    await tx(h.db, (c) => post(c, callerId, "coins", "daily_bonus", 5, "test:bonus", { note: "Daily bonus, Day 1" }));
    await tx(h.db, (c) => post(c, callerId, "coins", "gift_debit", -20, "test:gift", { note: "Rose gift" }));

    type Hist = { items: { kind: string; title: string; subtitle: string | null; amount: number }[]; nextCursor: string | null;
      summary: { spent: number; added: number; calls: number; gifts: number; bonuses: number } };
    const get = async (q = "") => json<Hist>(await call(h, "GET", `/v1/wallet/history${q}`, { token }));

    const all = await get();
    // Newest first; the last line is the test account's 500 starting coins.
    expect(all.items.map((i) => [i.kind, i.amount])).toEqual([["gift", -20], ["bonus", 5], ["call", -30], ["bonus", 500]]);
    expect(all.items.find((i) => i.kind === "call")).toMatchObject({ title: "Voice call with Test companion", subtitle: "3 min" });
    expect(all.summary).toMatchObject({ spent: 50, added: 505, calls: 30, gifts: 20, bonuses: 505 });

    expect((await get("?filter=spent")).items.every((i) => i.amount < 0)).toBe(true);
    expect((await get("?filter=added")).items.every((i) => i.amount > 0)).toBe(true);
    const future = new Date(Date.now() + 60_000).toISOString();
    expect((await get(`?from=${future}`)).items).toEqual([]);
  });

  it("pages with a cursor without repeating lines", async () => {
    const callerId = await createCaller(h, 0);
    const token = await tokenFor(h, callerId, "caller");
    for (let i = 0; i < 5; i++) {
      await tx(h.db, (c) => post(c, callerId, "coins", "daily_bonus", 1 + i, `test:b${i}`, { note: `Bonus ${i}` }));
    }
    type Hist = { items: { key: string }[]; nextCursor: string | null };
    const p1 = json<Hist>(await call(h, "GET", "/v1/wallet/history?limit=3", { token }));
    expect(p1.items).toHaveLength(3);
    const p2 = json<Hist>(await call(h, "GET", `/v1/wallet/history?limit=3&cursor=${encodeURIComponent(p1.nextCursor!)}`, { token }));
    const keys = [...p1.items, ...p2.items].map((i) => i.key);
    expect(new Set(keys).size).toBe(keys.length);
    expect(keys.length).toBeGreaterThanOrEqual(5);
  });
});
