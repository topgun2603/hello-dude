import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { tx } from "../db/pool.js";
import { post } from "../billing/ledger.js";
import { ONLINE_SET } from "../billing/engine.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`DELETE FROM admin_roles WHERE NOT is_system`);
  await setRate(h, "ta", "audio", 10, 300);
  await setRate(h, "ta", "video", 25, 700);
  const id = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, id, "admin");
});

async function billedCall(caller: string, companion: string, type: "audio" | "video", minutes: number) {
  await h.redis.flushdb();
  await h.redis.sadd(ONLINE_SET, companion);
  const { callId } = await h.engine.startCall(caller, companion, type);
  await h.engine.onCallConnected(callId);
  for (let m = 2; m <= minutes; m++) await h.engine.chargeMinute(callId, m);
  await h.db.query(`UPDATE calls SET started_at = now() - interval '5 minutes' WHERE id = $1`, [callId]);
  await h.engine.endCall(callId, "caller_hangup");
  return callId;
}

type A = {
  range: { days: number }; totals: Record<string, number | null>; previousTotals: Record<string, number | null>;
  margin: { netRevenuePaise: number; marginPct: number | null };
  daily: { calls: number; minutes: number; coinsSpent: number }[];
  byType: { type: string; calls: number }[]; byHour: unknown[]; byLanguage: { code: string; calls: number }[];
  topRated: { displayName: string; rating: number }[]; topSpenders: { id: string; coinsSpent: number }[];
  topEarners: { id: string; earnedPaise: number }[]; mostActive: { id: string; calls: number }[];
};
const get = async (q = "", token = admin) => call(h, "GET", `/v1/admin/analytics${q}`, { token });

describe("admin analytics", () => {
  it("totals, daily series, breakdowns and leaderboards agree with what happened", async () => {
    const big = await createCaller(h, 1000), small = await createCaller(h, 1000);
    const priya = await createCompanion(h);
    const c1 = await billedCall(big, priya, "video", 3); // 75 coins
    await billedCall(small, priya, "audio", 2); // 20 coins
    await tx(h.db, (c) => post(c, big, "coins", "gift_debit", -30, "t:gift", { note: "Rose gift", callId: c1 }));
    await h.db.query(`INSERT INTO call_ratings (call_id, rater_id, stars) VALUES ($1, $2, 5)`, [c1, big]);
    const pack = (await h.db.query<{ id: number; price_paise: number }>(`SELECT id, price_paise FROM coin_packages WHERE NOT first_recharge_only ORDER BY id LIMIT 1`)).rows[0]!;
    await h.db.query(`INSERT INTO purchases (user_id, package_id, purchase_token, coins_credited, status) VALUES ($1, $2, 'tok-a', 100, 'credited')`, [big, pack.id]);

    const r = await get("?minRatings=1");
    expect(r.statusCode).toBe(200);
    const a = json<A>(r);
    expect(a.range.days).toBe(30);
    expect(a.totals).toMatchObject({
      connectedCalls: 2, minutes: 5, coinsOnCalls: 95, coinsOnGifts: 30, coinsSpent: 125,
      salesPaise: pack.price_paise, purchases: 1, activeCallers: 2, payingCallers: 1, ratings: 1, avgRating: 5,
    });
    expect(a.totals.companionEarningsPaise).toBeGreaterThan(0);
    expect(a.previousTotals.connectedCalls).toBe(0);

    // The daily series adds up to the totals.
    const sum = (k: "calls" | "minutes" | "coinsSpent") => a.daily.reduce((n, d) => n + d[k], 0);
    expect(a.daily).toHaveLength(30);
    expect([sum("calls"), sum("minutes"), sum("coinsSpent")]).toEqual([2, 5, 125]);

    expect(Object.fromEntries(a.byType.map((t) => [t.type, t.calls]))).toEqual({ audio: 1, video: 1 });
    expect(a.byHour).toHaveLength(24);
    expect(a.byLanguage.find((l) => l.code === "ta")?.calls).toBe(2);

    expect(a.topSpenders.map((s) => [s.id, s.coinsSpent])).toEqual([[big, 105], [small, 20]]);
    expect(a.topEarners[0]!.id).toBe(priya);
    expect(a.mostActive[0]).toMatchObject({ id: priya, calls: 2 });
    expect(a.topRated[0]).toMatchObject({ rating: 5 });
    // Net = sales ÷ 1.18 × 0.85 (defaults), shown as an estimate.
    expect(a.margin.netRevenuePaise).toBe(Math.round((pack.price_paise / 1.18) * 0.85));
  });

  it("ranges: a custom range and the period before it; bad ranges are refused", async () => {
    const a = json<A & { range: { from: string; to: string }; previous: { from: string; to: string } }>(
      await get("?from=2026-09-01&to=2026-09-07"));
    expect(a.range).toMatchObject({ from: "2026-09-01", to: "2026-09-07", days: 7 });
    expect(a.previous).toEqual({ from: "2026-08-25", to: "2026-08-31" });
    expect(errorCode(await get("?from=2026-09-07&to=2026-09-01"))).toBe("BAD_RANGE");
    expect(errorCode(await get("?from=2024-01-01&to=2026-09-01"))).toBe("BAD_RANGE");
  });

  it("only roles with 'See analytics' can open it", async () => {
    const mod = (await call(h, "POST", "/v1/admin/staff", { token: admin, body: { phone: "9811100011", name: "Mod", roleCode: "moderator" } }));
    const modToken = await tokenFor(h, json<{ id: string }>(mod).id, "admin");
    expect(errorCode(await get("", modToken))).toBe("NO_PERMISSION");

    await call(h, "POST", "/v1/admin/roles", { token: admin, body: { name: "Analyst", permissions: ["analytics.view"] } });
    const analyst = await call(h, "POST", "/v1/admin/staff", { token: admin, body: { phone: "9811100012", name: "Ana", roleCode: "analyst" } });
    expect((await get("", await tokenFor(h, json<{ id: string }>(analyst).id, "admin"))).statusCode).toBe(200);
  });
});
