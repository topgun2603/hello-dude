import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, getCall, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";
import { ONLINE_SET } from "../billing/engine.js";

let h: AppHarness;
let adminId: string;
let admin: string;

beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

const auditActions = async () =>
  (await h.db.query<{ action: string }>(`SELECT action FROM audit_log ORDER BY id`)).rows.map((r) => r.action);

describe("access", () => {
  it("is admin-only", async () => {
    const caller = await tokenFor(h, await createCaller(h, 0), "caller");
    expect((await call(h, "GET", "/v1/admin/dashboard")).statusCode).toBe(401);
    expect(errorCode(await call(h, "GET", "/v1/admin/dashboard", { token: caller }))).toBe("WRONG_ROLE");
    expect((await call(h, "GET", "/v1/admin/dashboard", { token: admin })).statusCode).toBe(200);
  });
});

describe("pricing", () => {
  it("adds rate versions: the newest effective one is current, future ones are scheduled", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const now = await call(h, "POST", "/v1/admin/rates", {
      token: admin, body: { language: "ta", callType: "audio", coinsPerMin: 12, companionPaisePerMin: 360 },
    });
    expect(now.statusCode).toBe(201);
    const later = await call(h, "POST", "/v1/admin/rates", {
      token: admin,
      body: { language: "ta", callType: "audio", coinsPerMin: 15, companionPaisePerMin: 450,
        effectiveFrom: new Date(Date.now() + 3600_000).toISOString() },
    });
    expect(json(later)).toMatchObject({ status: "scheduled" });

    const rates = json<{ coinsPerMin: number; status: string }[]>(await call(h, "GET", "/v1/admin/rates", { token: admin }));
    expect(rates.map((r) => [r.coinsPerMin, r.status])).toEqual([[15, "scheduled"], [12, "current"], [10, "past"]]);
    expect(await auditActions()).toEqual(["rate.create", "rate.create"]);
  });

  it("new calls use the new rate straight away", async () => {
    await call(h, "POST", "/v1/admin/rates", {
      token: admin, body: { language: "ta", callType: "audio", coinsPerMin: 7, companionPaisePerMin: 200 },
    });
    const caller = await tokenFor(h, await createCaller(h, 100), "caller");
    const companion = await createCompanion(h);
    const start = json<{ coinsPerMin: number }>(await call(h, "POST", "/v1/calls", {
      token: caller, body: { companionId: companion, type: "audio" },
    }));
    expect(start.coinsPerMin).toBe(7);
  });

  it("refuses paying a companion more than ₹1 per coin, or a start time in the past", async () => {
    const tooHigh = await call(h, "POST", "/v1/admin/rates", {
      token: admin, body: { language: "ta", callType: "audio", coinsPerMin: 10, companionPaisePerMin: 1001 },
    });
    expect(errorCode(tooHigh)).toBe("COMPANION_SHARE_TOO_HIGH");
    const past = await call(h, "POST", "/v1/admin/rates", {
      token: admin, body: { language: "ta", callType: "audio", coinsPerMin: 10, companionPaisePerMin: 300,
        effectiveFrom: "2020-01-01T00:00:00Z" },
    });
    expect(errorCode(past)).toBe("EFFECTIVE_IN_PAST");
  });

  it("edits a coin pack and records before/after in the audit log", async () => {
    const packs = json<{ id: number; sku: string }[]>(await call(h, "GET", "/v1/admin/coin-packages", { token: admin }));
    const p300 = packs.find((p) => p.sku === "coins_300")!;
    const r = await call(h, "PUT", `/v1/admin/coin-packages/${p300.id}`, {
      token: admin, body: { coins: 300, bonusCoins: 30, pricePaise: 24900, label: "Popular", isActive: true, sortOrder: 3 },
    });
    expect(json(r)).toMatchObject({ bonusCoins: 30, pricePaise: 24900 });
    const log = (await h.db.query<{ details: { before: { pricePaise: number }; after: { pricePaise: number } } }>(
      `SELECT details FROM audit_log WHERE action = 'package.update'`)).rows[0]!;
    expect([log.details.before.pricePaise, log.details.after.pricePaise]).toEqual([23900, 24900]);

    // Put it back so other test files see the seeded price.
    await call(h, "PUT", `/v1/admin/coin-packages/${p300.id}`, {
      token: admin, body: { coins: 300, bonusCoins: 0, pricePaise: 23900, label: "Popular", isActive: true, sortOrder: 3 },
    });
  });

  it("hidden packs disappear from the app's wallet", async () => {
    const packs = json<{ id: number; sku: string; coins: number; bonusCoins: number; pricePaise: number; label: string | null; sortOrder: number }[]>(
      await call(h, "GET", "/v1/admin/coin-packages", { token: admin }));
    const p50 = packs.find((p) => p.sku === "coins_50")!;
    await call(h, "PUT", `/v1/admin/coin-packages/${p50.id}`, { token: admin, body: { ...p50, id: undefined, sku: undefined, isActive: false } });
    const shop = json<{ sku: string }[]>(await call(h, "GET", "/v1/coin-packages"));
    expect(shop.map((p) => p.sku)).not.toContain("coins_50");
    await call(h, "PUT", `/v1/admin/coin-packages/${p50.id}`, { token: admin, body: { ...p50, id: undefined, sku: undefined, isActive: true } });
  });
});

describe("reports and suspensions", () => {
  async function reportedLiveCall() {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    const callerToken = await tokenFor(h, caller, "caller");
    await h.tokens.issue(companion, "companion"); // companion has a session to revoke
    const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
      token: callerToken, body: { companionId: companion, type: "audio" },
    }));
    await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
    await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
    await call(h, "POST", "/v1/reports", {
      token: callerToken, body: { userId: companion, callId: start.callId, reason: "abuse", details: "shouting" },
    });
    return { caller, companion, callId: start.callId };
  }

  it("suspending from a report ends the live call, logs them out and takes them offline", async () => {
    const { companion, callId } = await reportedLiveCall();
    const reports = json<{ id: string; reported: { id: string; reportsAgainst: number } }[]>(
      await call(h, "GET", "/v1/admin/reports", { token: admin }));
    expect(reports).toHaveLength(1);
    expect(reports[0]!.reported).toMatchObject({ id: companion, reportsAgainst: 1 });

    const r = await call(h, "POST", `/v1/admin/reports/${reports[0]!.id}/resolve`, {
      token: admin, body: { decision: "suspend", note: "Confirmed abusive on call" },
    });
    expect(r.statusCode).toBe(204);

    expect((await h.db.query(`SELECT status FROM users WHERE id = $1`, [companion])).rows[0]).toEqual({ status: "suspended" });
    expect((await h.db.query(`SELECT count(*)::int AS n FROM sessions WHERE user_id = $1 AND revoked_at IS NULL`, [companion])).rows[0])
      .toEqual({ n: 0 });
    expect(await h.redis.sismember(ONLINE_SET, companion)).toBe(0);
    expect(await getCall(h, callId)).toMatchObject({ status: "ended", end_reason: "admin" });

    const again = await call(h, "POST", `/v1/admin/reports/${reports[0]!.id}/resolve`, {
      token: admin, body: { decision: "dismiss", note: "double click" },
    });
    expect(errorCode(again)).toBe("REPORT_CLOSED");
    expect(json(await call(h, "GET", "/v1/admin/reports", { token: admin }))).toEqual([]);
    expect(await auditActions()).toEqual(["report.resolve"]);
  });

  it("dismissing leaves the user alone", async () => {
    const { companion } = await reportedLiveCall();
    const [report] = json<{ id: string }[]>(await call(h, "GET", "/v1/admin/reports", { token: admin }));
    await call(h, "POST", `/v1/admin/reports/${report!.id}/resolve`, { token: admin, body: { decision: "dismiss", note: "No evidence" } });
    expect((await h.db.query(`SELECT status FROM users WHERE id = $1`, [companion])).rows[0]).toEqual({ status: "active" });
    const closed = json<{ status: string; resolutionNote: string }[]>(
      await call(h, "GET", "/v1/admin/reports?status=dismissed", { token: admin }));
    expect(closed[0]).toMatchObject({ status: "dismissed", resolutionNote: "No evidence" });
  });
});

describe("gifts", () => {
  it("adds a gift with a code from its name, shows it in the app, and refuses a duplicate", async () => {
    try {
      const r = await call(h, "POST", "/v1/admin/gifts", { token: admin, body: { name: "Teddy Bear", emoji: "🧸", coins: 150 } });
      expect(r.statusCode).toBe(201);
      expect(json(r)).toMatchObject({ code: "teddy_bear", name: "Teddy Bear", coins: 150, isActive: true });
      expect(await auditActions()).toEqual(["gift.create"]);

      const shop = json<{ code: string }[]>(await call(h, "GET", "/v1/gifts", { token: await tokenFor(h, await createCaller(h, 0), "caller") }));
      expect(shop.map((g) => g.code)).toContain("teddy_bear");

      const dup = await call(h, "POST", "/v1/admin/gifts", { token: admin, body: { name: "teddy  bear", emoji: "🐻", coins: 10 } });
      expect(errorCode(dup)).toBe("GIFT_EXISTS");
    } finally {
      // Gifts aren't reset between tests; keep the seeded list as other files expect it.
      await h.db.query(`DELETE FROM gifts WHERE code = 'teddy_bear'`);
    }
  });
});

describe("users", () => {
  it("searches by name or last digits, with the number masked", async () => {
    const a = await createCaller(h, 50);
    await h.db.query(`UPDATE users SET display_name = 'Karthik' WHERE id = $1`, [a]);
    await createCaller(h, 0);
    const byName = json<{ users: { id: string; phone: string; coins: number }[]; total: number }>(
      await call(h, "GET", "/v1/admin/users?role=caller&q=kart", { token: admin }));
    expect(byName.total).toBe(1);
    expect(byName.users[0]).toMatchObject({ id: a, coins: 50 });
    expect(byName.users[0]!.phone).toMatch(/^\+91 ••••••\d{4}$/);

    const last4 = byName.users[0]!.phone.slice(-4);
    const byDigits = json<{ users: { id: string }[] }>(await call(h, "GET", `/v1/admin/users?role=caller&q=${last4}`, { token: admin }));
    expect(byDigits.users.map((u) => u.id)).toContain(a);
  });

  it("shows when a user was last seen (never, then after a sign-in)", async () => {
    const u = await createCaller(h, 0);
    const lastSeen = async () => json<{ users: { id: string; lastSeenAt: string | null }[] }>(
      await call(h, "GET", "/v1/admin/users?role=caller", { token: admin })).users.find((x) => x.id === u)!.lastSeenAt;
    expect(await lastSeen()).toBeNull();
    await h.tokens.issue(u, "caller"); // a sign-in creates a session
    expect(Date.now() - new Date((await lastSeen())!).getTime()).toBeLessThan(60_000);
  });

  it("suspends and reactivates, but never your own account", async () => {
    const u = await createCaller(h, 0);
    expect((await call(h, "POST", `/v1/admin/users/${u}/status`, { token: admin, body: { status: "suspended", reason: "spam" } })).statusCode).toBe(204);
    const suspended = json<{ users: { id: string }[] }>(await call(h, "GET", "/v1/admin/users?status=suspended", { token: admin }));
    expect(suspended.users.map((x) => x.id)).toEqual([u]);
    await call(h, "POST", `/v1/admin/users/${u}/status`, { token: admin, body: { status: "active", reason: "appeal accepted" } });
    expect((await h.db.query(`SELECT status FROM users WHERE id = $1`, [u])).rows[0]).toEqual({ status: "active" });

    expect(errorCode(await call(h, "POST", `/v1/admin/users/${adminId}/status`, { token: admin, body: { status: "banned", reason: "oops" } })))
      .toBe("CANNOT_TARGET_SELF");
    const log = json<{ action: string; details: { from: string; to: string } }[]>(await call(h, "GET", "/v1/admin/audit", { token: admin }));
    expect(log.map((l) => [l.details.from, l.details.to])).toEqual([["suspended", "active"], ["active", "suspended"]]);
  });

  it("keeps the audit log append-only", async () => {
    const u = await createCaller(h, 0);
    await call(h, "POST", `/v1/admin/users/${u}/status`, { token: admin, body: { status: "suspended", reason: "test" } });
    await expect(h.db.query(`UPDATE audit_log SET action = 'x'`)).rejects.toThrow(/append-only/);
    await expect(h.db.query(`DELETE FROM audit_log`)).rejects.toThrow(/append-only/);
  });
});

describe("dashboard", () => {
  it("counts live calls, online companions and today's spend", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    await createCompanion(h, { language: "te" });
    const start = json<{ room: string }>(await call(h, "POST", "/v1/calls", {
      token: await tokenFor(h, caller, "caller"), body: { companionId: companion, type: "audio" },
    }));
    await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
    await webhook(h, { event: "participant_joined", room: start.room, identity: companion });

    await call(h, "POST", "/v1/reports", {
      token: await tokenFor(h, caller, "caller"), body: { userId: companion, reason: "spam" },
    });

    const d = json<{ live: object; today: object; yesterday: object; languages: { code: string; online: number; inCall: number }[];
      byHour: { calls: number }[]; openReportsByReason: Record<string, number>; activity: { kind: string; user: { id: string } }[] }>(
      await call(h, "GET", "/v1/admin/dashboard", { token: admin }));
    expect(d.live).toEqual({ voiceCalls: 1, videoCalls: 0, ringing: 0, companionsOnline: 2 });
    expect(d.today).toMatchObject({ connectedCalls: 1, minutesBilled: 1, coinsSpent: 10, companionEarningsPaise: 300 });
    expect(d.yesterday).toEqual({ connectedCalls: 0, coinsSpent: 0, newUsers: 0 });
    expect(d.languages.find((l) => l.code === "ta")).toMatchObject({ online: 1, inCall: 1 });
    expect(d.languages.find((l) => l.code === "te")).toMatchObject({ online: 1, inCall: 0 });
    expect(d.byHour).toHaveLength(24);
    expect(d.byHour.reduce((n, x) => n + x.calls, 0)).toBe(1);
    expect(d.openReportsByReason).toEqual({ spam: 1 });
    expect(d.activity[0]).toMatchObject({ kind: "report", user: { id: caller } });
    expect(d.activity.some((e) => e.kind === "signup" && e.user.id === companion)).toBe(true);
  });
});
