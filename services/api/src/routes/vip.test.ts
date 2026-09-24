import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { balance, createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

type Vip = { active: boolean; discountPct: number; weeklyGift: { name: string; used: boolean } | null; plans: { months: number; pricePaise: number }[]; purchasable: boolean };

async function liveCall(callerToken: string, caller: string, companion: string) {
  const start = json<{ callId: string; room: string; coinsPerMin: number }>(
    await call(h, "POST", "/v1/calls", { token: callerToken, body: { companionId: companion, type: "audio" } }));
  await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
  await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
  return start;
}

describe("VIP", () => {
  it("not VIP: plans on show, can't buy until Play Billing", async () => {
    const token = await tokenFor(h, await createCaller(h, 0), "caller");
    const v = json<Vip>(await call(h, "GET", "/v1/vip", { token }));
    expect(v).toMatchObject({ active: false, discountPct: 10, weeklyGift: null, purchasable: false });
    expect(v.plans.map((p) => [p.months, p.pricePaise])).toEqual([[1, 29900], [3, 69900]]);
  });

  it("admin grant: 10% off per minute paid by the platform, a free Rose once a week, then revoke", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    const token = await tokenFor(h, caller, "caller");

    expect((await call(h, "POST", `/v1/admin/users/${caller}/vip`, { token: admin, body: { days: 30, reason: "Loyal caller" } })).statusCode).toBe(200);
    expect(errorCode(await call(h, "POST", `/v1/admin/users/${companion}/vip`, { token: admin, body: { days: 30, reason: "nope" } }))).toBe("NOT_A_CALLER");
    const v = json<Vip>(await call(h, "GET", "/v1/vip", { token }));
    expect(v).toMatchObject({ active: true, weeklyGift: { name: "Rose", used: false } });
    expect((await h.db.query(`SELECT title FROM notifications WHERE user_id = $1`, [caller])).rows).toEqual([{ title: "You're VIP 👑" }]);

    // First minute: caller pays 9, companion still earns ₹3.
    const started = await liveCall(token, caller, companion);
    expect(started.coinsPerMin).toBe(9);
    expect(await balance(h, caller, "coins")).toBe(91);
    expect(await balance(h, companion, "earnings")).toBe(300);

    // This week's Rose is free; the next one costs coins. The companion is paid for both.
    const rose = (await h.db.query<{ id: number; coins: number }>(`SELECT id, coins FROM gifts WHERE code = 'rose'`)).rows[0]!;
    const send = () => call(h, "POST", `/v1/calls/${started.callId}/gifts`, { token, body: { giftId: rose.id, clientRef: randomUUID() } });
    expect(json<{ coinsLeft: number }>(await send()).coinsLeft).toBe(91);
    expect(json<{ coinsLeft: number }>(await send()).coinsLeft).toBe(91 - rose.coins);
    const earned = await balance(h, companion, "earnings");
    expect(earned).toBeGreaterThan(300);
    expect(json<Vip>(await call(h, "GET", "/v1/vip", { token })).weeklyGift).toMatchObject({ used: true });

    const detail = json<{ vip: { source: string } | null }>(await call(h, "GET", `/v1/admin/users/${caller}`, { token: admin }));
    expect(detail.vip).toMatchObject({ source: "admin" });

    await call(h, "POST", `/v1/calls/${started.callId}/end`, { token });
    expect((await call(h, "POST", `/v1/admin/users/${caller}/vip/revoke`, { token: admin, body: { reason: "Test over" } })).statusCode).toBe(204);
    expect(json<Vip>(await call(h, "GET", "/v1/vip", { token })).active).toBe(false);
    const again = json<{ coinsPerMin: number }>(await call(h, "POST", "/v1/calls", { token, body: { companionId: companion, type: "audio" } }));
    expect(again.coinsPerMin).toBe(10);
    const actions = (await h.db.query<{ action: string }>(`SELECT action FROM audit_log ORDER BY id`)).rows.map((r) => r.action);
    expect(actions).toEqual(["user.vip_grant", "user.vip_revoke"]);
  });

  it("admin edits a plan price", async () => {
    const [plan] = json<{ id: number }[]>(await call(h, "GET", "/v1/admin/vip-plans", { token: admin }));
    const r = json<{ pricePaise: number; label: string | null }>(await call(h, "PUT", `/v1/admin/vip-plans/${plan!.id}`, {
      token: admin, body: { pricePaise: 24900, label: "Try it", isActive: true } }));
    expect(r).toMatchObject({ pricePaise: 24900, label: "Try it" });
    await call(h, "PUT", `/v1/admin/vip-plans/${plan!.id}`, { token: admin, body: { pricePaise: 29900, label: null, isActive: true } });
  });

  it("perks can't make a minute cost more than it earns: companion share capped at ₹1 per coin charged", async () => {
    await setRate(h, "ta", "audio", 10, 1000); // the most admin rates allow: ₹10 per 10 coins
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    await call(h, "POST", `/v1/admin/users/${caller}/vip`, { token: admin, body: { days: 30, reason: "Cap test" } });
    // Top level (+8%) on top of the VIP discount.
    await h.db.query(`UPDATE companion_levels SET min_hours = 0, min_rating = 0 WHERE level = 5`);
    try {
      const start = json<{ callId: string; coinsPerMin: number }>(await call(h, "POST", "/v1/calls", {
        token: await tokenFor(h, caller, "caller"), body: { companionId: companion, type: "audio" } }));
      expect(start.coinsPerMin).toBe(9);
      expect((await h.db.query(`SELECT companion_paise_per_min FROM calls WHERE id = $1`, [start.callId])).rows[0])
        .toEqual({ companion_paise_per_min: 900 }); // not 1080
    } finally {
      await h.db.query(`UPDATE companion_levels SET min_hours = 100, min_rating = 4.7 WHERE level = 5`);
    }
  });
});
