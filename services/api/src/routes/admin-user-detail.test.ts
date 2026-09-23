import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
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

type Detail = {
  phone: string; role: string; coins: number; earningsPaise: number;
  stats: { calls: number; minutes: number; coinsSpent: number; paiseEarned: number; reportsAgainst: number; reportsMade: number };
  companion: { kycStatus: string; academyTotal: number } | null;
  calls: { direction: string; other: { id: string }; minutes: number; coins: number; paise: number }[];
  ledger: { wallet: string; amount: number }[];
  reports: { direction: string; reason: string }[];
  audit: { action: string }[];
};

describe("admin user detail", () => {
  it("shows both sides of a billed, reported call — masked, and admin-only", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    const callerToken = await tokenFor(h, caller, "caller");
    const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
      token: callerToken, body: { companionId: companion, type: "audio" },
    }));
    await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
    await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
    await call(h, "POST", "/v1/reports", { token: callerToken, body: { userId: companion, callId: start.callId, reason: "abuse" } });

    const c = json<Detail>(await call(h, "GET", `/v1/admin/users/${caller}`, { token: admin }));
    expect(c.role).toBe("caller");
    expect(c.phone).toContain("•");
    expect(c.coins).toBe(90);
    expect(c.companion).toBeNull();
    expect(c.stats).toMatchObject({ calls: 1, minutes: 1, coinsSpent: 10, reportsMade: 1, reportsAgainst: 0 });
    expect(c.calls[0]).toMatchObject({ direction: "outgoing", other: { id: companion }, minutes: 1, coins: 10 });
    expect(c.ledger.some((l) => l.wallet === "coins" && l.amount === -10)).toBe(true);
    expect(c.reports[0]).toMatchObject({ direction: "by", reason: "abuse" });

    const k = json<Detail>(await call(h, "GET", `/v1/admin/users/${companion}`, { token: admin }));
    expect(k.companion).toMatchObject({ kycStatus: "approved" });
    expect(k.companion!.academyTotal).toBeGreaterThan(0);
    expect(k.earningsPaise).toBe(300);
    expect(k.stats).toMatchObject({ paiseEarned: 300, reportsAgainst: 1 });
    expect(k.calls[0]).toMatchObject({ direction: "incoming", other: { id: caller }, paise: 300 });

    // Suspending ends the call inside the 10 s grace period: the history shows the refund and the admin action.
    await call(h, "POST", `/v1/admin/users/${caller}/status`, { token: admin, body: { status: "suspended", reason: "testing" } });
    const after = json<Detail & { status: string }>(await call(h, "GET", `/v1/admin/users/${caller}`, { token: admin }));
    expect(after).toMatchObject({ status: "suspended", coins: 100 });
    expect(after.ledger.filter((l) => l.wallet === "coins").map((l) => l.amount)).toEqual(expect.arrayContaining([-10, 10]));
    expect(after.audit.map((a) => a.action)).toContain("user.status");

    expect(errorCode(await call(h, "GET", `/v1/admin/users/${crypto.randomUUID()}`, { token: admin }))).toBe("USER_NOT_FOUND");
    expect(errorCode(await call(h, "GET", `/v1/admin/users/${caller}`, { token: await tokenFor(h, companion, "companion") })))
      .toBe("WRONG_ROLE");
  });

  it("notes, free coins and messages: saved, audited, pushed — and a retried coin grant can't double-credit", async () => {
    const caller = await createCaller(h, 5);
    const companion = await createCompanion(h);
    await h.db.query(`INSERT INTO devices (fcm_token, user_id) VALUES ('tok-caller', $1)`, [caller]);

    const note = await call(h, "POST", `/v1/admin/users/${caller}/notes`, { token: admin, body: { body: "Asked about refunds twice" } });
    expect(note.statusCode).toBe(201);
    expect(json(note)).toMatchObject({ author: "Ops", body: "Asked about refunds twice" });

    const requestId = crypto.randomUUID();
    const grant = await call(h, "POST", `/v1/admin/users/${caller}/coins`, { token: admin, body: { coins: 50, reason: "Call dropped twice", requestId } });
    expect(json(grant)).toEqual({ coins: 55 });
    expect(errorCode(await call(h, "POST", `/v1/admin/users/${caller}/coins`, { token: admin, body: { coins: 50, reason: "Call dropped twice", requestId } })))
      .toBe("DUPLICATE_REQUEST");
    expect(errorCode(await call(h, "POST", `/v1/admin/users/${companion}/coins`, {
      token: admin, body: { coins: 5, reason: "nope", requestId: crypto.randomUUID() } }))).toBe("NOT_A_CALLER");

    const msg = await call(h, "POST", `/v1/admin/users/${caller}/message`, { token: admin, body: { title: "Hi", body: "We fixed your wallet" } });
    expect(json(msg)).toEqual({ devices: 1 });
    expect(json(await call(h, "POST", `/v1/admin/users/${companion}/message`, { token: admin, body: { title: "Hi", body: "Welcome" } })))
      .toEqual({ devices: 0 });
    expect(h.push.notices.map((n) => [n.tokens, n.notice.title])).toEqual([
      [["tok-caller"], "You got 50 free coins 🎉"], [["tok-caller"], "Hi"], [[], "Hi"],
    ]);

    const d = json<Detail & { coins: number; notes: { body: string }[] }>(await call(h, "GET", `/v1/admin/users/${caller}`, { token: admin }));
    expect(d.coins).toBe(55);
    expect(d.notes.map((n) => n.body)).toEqual(["Asked about refunds twice"]);
    expect(d.ledger[0]).toMatchObject({ wallet: "coins", amount: 50 });
    expect(d.audit.map((a) => a.action)).toEqual(["user.message", "user.coins", "user.note"]);
    expect(errorCode(await call(h, "POST", `/v1/admin/users/${caller}/notes`, { token: await tokenFor(h, caller, "caller"), body: { body: "x" } })))
      .toBe("WRONG_ROLE");
  });
});
