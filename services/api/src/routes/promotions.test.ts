import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`TRUNCATE promotions RESTART IDENTITY CASCADE`);
  const id = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, id, "admin");
});

type Promo = { id: number; title: string; emoji: string | null; status: string; shown: number; clicked: number; reach: number; shownToday: number };

const offer = (over: Record<string, unknown> = {}) => ({
  title: "Double coins weekend", body: "Every pack gives 2× coins until Sunday.", highlight: "2× coins", badge: "Weekend only",
  emoji: "🎉", ctaLabel: "Grab it", ctaAction: "wallet", theme: "brand", audience: "callers", frequency: "every_open",
  confetti: true, priority: 10, isActive: true, startsAt: new Date(Date.now() - 60_000).toISOString(), endsAt: null, ...over,
});

const create = async (over: Record<string, unknown> = {}) => {
  const r = await call(h, "POST", "/v1/admin/promotions", { token: admin, body: offer(over) });
  expect(r.statusCode).toBe(201);
  return json<Promo>(r);
};
const current = async (token: string) =>
  json<{ promotion: { id: number; title: string; confetti: boolean } | null }>(await call(h, "GET", "/v1/promotions/current", { token })).promotion;
const event = (token: string, id: number, action: "shown" | "clicked") =>
  call(h, "POST", `/v1/promotions/${id}/events`, { token, body: { action } });
const caller = async () => tokenFor(h, await createCaller(h, 0), "caller");

describe("app-open offers popup", () => {
  it("admins only; the end must be after the start; every change is audited", async () => {
    const c = await caller();
    expect(errorCode(await call(h, "GET", "/v1/admin/promotions", { token: c }))).toBe("WRONG_ROLE");
    const bad = await call(h, "POST", "/v1/admin/promotions",
      { token: admin, body: offer({ endsAt: new Date(Date.now() - 3_600_000).toISOString() }) });
    expect(bad.statusCode).toBe(400);

    const p = await create();
    expect(p.emoji).toBe("🎉"); // emoji survive the round trip
    await call(h, "PUT", `/v1/admin/promotions/${p.id}`, { token: admin, body: offer({ title: "Big weekend" }) });
    await call(h, "POST", `/v1/admin/promotions/${p.id}/active`, { token: admin, body: { isActive: false } });
    await call(h, "DELETE", `/v1/admin/promotions/${p.id}`, { token: admin });
    const actions = (await h.db.query<{ action: string }>(`SELECT action FROM audit_log ORDER BY id`)).rows.map((r) => r.action);
    expect(actions).toEqual(["promotion.create", "promotion.update", "promotion.off", "promotion.delete"]);
  });

  it("every_open shows on each open; the highest priority wins; off / scheduled / ended never show", async () => {
    const c = await caller();
    expect(await current(c)).toBeNull();
    await create({ title: "Low", priority: 1 });
    const high = await create({ title: "High", priority: 50 });
    await create({ title: "Off", priority: 99, isActive: false });
    await create({ title: "Later", priority: 99, startsAt: new Date(Date.now() + 3_600_000).toISOString() });
    await h.db.query(`INSERT INTO promotions (title, cta_label, cta_action, priority, starts_at, ends_at)
                      VALUES ('Over', 'Go', 'wallet', 99, now() - interval '2 days', now() - interval '1 day')`);

    expect((await current(c))!.title).toBe("High");
    expect((await event(c, high.id, "shown")).statusCode).toBe(204);
    expect((await current(c))!.title).toBe("High"); // every open

    const list = json<Promo[]>(await call(h, "GET", "/v1/admin/promotions", { token: admin }));
    expect(Object.fromEntries(list.map((p) => [p.title, p.status])))
      .toEqual({ High: "live", Low: "live", Off: "off", Later: "scheduled", Over: "ended" });
  });

  it("once and daily frequencies: after it's shown, the next one in line takes over", async () => {
    const c = await caller();
    const once = await create({ title: "Once", frequency: "once", priority: 30 });
    const daily = await create({ title: "Daily", frequency: "daily", priority: 20 });
    await create({ title: "Always", priority: 1 });

    expect((await current(c))!.title).toBe("Once");
    await event(c, once.id, "shown");
    expect((await current(c))!.title).toBe("Daily");
    await event(c, daily.id, "shown");
    expect((await current(c))!.title).toBe("Always");

    // Yesterday's view doesn't count for a daily offer.
    await h.db.query(`UPDATE promotion_views SET at = now() - interval '1 day' WHERE promotion_id = $1`, [daily.id]);
    expect((await current(c))!.title).toBe("Daily");
    // Another person still gets the once-only offer.
    expect((await current(await caller()))!.title).toBe("Once");
  });

  it("audience: companions, first-time buyers and paying callers", async () => {
    await create({ title: "For companions", audience: "companions", ctaAction: "rewards" });
    await create({ title: "First recharge", audience: "never_paid", priority: 5 });
    await create({ title: "Thanks for buying", audience: "paid", priority: 5 });

    const companion = await tokenFor(h, await createCompanion(h), "companion");
    expect((await current(companion))!.title).toBe("For companions");

    const newId = await createCaller(h, 0);
    expect((await current(await tokenFor(h, newId, "caller")))!.title).toBe("First recharge");

    const payerId = await createCaller(h, 0);
    const pack = (await h.db.query<{ id: number }>(`SELECT id FROM coin_packages LIMIT 1`)).rows[0]!.id;
    await h.db.query(`INSERT INTO purchases (user_id, package_id, purchase_token, coins_credited, status) VALUES ($1, $2, 'tok-p', 100, 'credited')`,
      [payerId, pack]);
    expect((await current(await tokenFor(h, payerId, "caller")))!.title).toBe("Thanks for buying");
  });

  it("admin list counts shows, taps and reach; unknown promotions are 404", async () => {
    const p = await create();
    const a = await caller(), b = await caller();
    await event(a, p.id, "shown");
    await event(a, p.id, "shown");
    await event(a, p.id, "clicked");
    await event(b, p.id, "shown");
    const [row] = json<Promo[]>(await call(h, "GET", "/v1/admin/promotions", { token: admin }));
    expect(row).toMatchObject({ shown: 3, clicked: 1, reach: 2, shownToday: 3 });
    expect(errorCode(await event(a, 9999, "shown"))).toBe("PROMOTION_NOT_FOUND");
  });
});
