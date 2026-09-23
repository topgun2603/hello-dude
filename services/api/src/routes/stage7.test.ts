import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { tx } from "../db/pool.js";
import { post } from "../billing/ledger.js";
import { backdateStart, balance, createCaller, createCompanion, getCall, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, signUp, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  h.recorder.started.length = 0;
  h.recorder.stopped.length = 0;
  h.otpCodes.codes.clear();
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

async function world(coins = 1000) {
  await setRate(h, "ta", "audio", 10, 300);
  const caller = await createCaller(h, coins);
  const companion = await createCompanion(h);
  return { caller, companion, callerToken: await tokenFor(h, caller, "caller"), companionToken: await tokenFor(h, companion, "companion") };
}

async function liveCall(w: Awaited<ReturnType<typeof world>>) {
  const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
    token: w.callerToken, body: { companionId: w.companion, type: "audio" },
  }));
  await webhook(h, { event: "participant_joined", room: start.room, identity: w.caller });
  await webhook(h, { event: "participant_joined", room: start.room, identity: w.companion });
  return start;
}

async function endedCall(w: Awaited<ReturnType<typeof world>>, seconds = 150) {
  const start = await liveCall(w);
  await h.engine.chargeMinute(start.callId, 2);
  await h.engine.chargeMinute(start.callId, 3);
  await backdateStart(h, start.callId, seconds);
  await call(h, "POST", `/v1/calls/${start.callId}/end`, { token: w.callerToken });
  return start;
}

const giftId = async (code: string) => (await h.db.query<{ id: number }>(`SELECT id FROM gifts WHERE code = $1`, [code])).rows[0]!.id;

// ---------------------------------------------------------------------------
describe("gifts", () => {
  it("costs the caller coins, pays the companion 40% of the coin value, and tells the companion live", async () => {
    const w = await world(1000);
    const start = await liveCall(w); // minute 1: 1000 → 990
    const r = await call(h, "POST", `/v1/calls/${start.callId}/gifts`, {
      token: w.callerToken, body: { giftId: await giftId("star"), clientRef: randomUUID() },
    });
    expect(r.statusCode).toBe(201);
    expect(json(r)).toMatchObject({ gift: { name: "Star", coins: 100 }, coinsLeft: 890 });
    // 100 coins × ₹0.80 × 40% = ₹32
    expect(await balance(h, w.companion, "earnings")).toBe(300 + 3200);
    expect(h.events.of(w.companion, "gift_received")[0]?.event).toMatchObject({ gift: { name: "Star" }, paiseEarned: 3200 });

    const details = json<{ gifts: unknown[] }>(await call(h, "GET", `/v1/calls/${start.callId}`, { token: w.callerToken }));
    expect(details.gifts).toEqual([expect.objectContaining({ name: "Star", coins: 100, paise: 0 })]);
    const companionView = json<{ gifts: unknown[] }>(await call(h, "GET", `/v1/calls/${start.callId}`, { token: w.companionToken }));
    expect(companionView.gifts).toEqual([expect.objectContaining({ coins: 0, paise: 3200 })]);
  });

  it("a retried tap (same clientRef) sends once; no gifts outside a live call or without coins", async () => {
    const w = await world(60);
    const start = await liveCall(w); // 50 left
    const ref = randomUUID();
    const rose = await giftId("rose");
    await call(h, "POST", `/v1/calls/${start.callId}/gifts`, { token: w.callerToken, body: { giftId: rose, clientRef: ref } });
    const again = json<{ coinsLeft: number }>(await call(h, "POST", `/v1/calls/${start.callId}/gifts`, { token: w.callerToken, body: { giftId: rose, clientRef: ref } }));
    expect(again.coinsLeft).toBe(40);
    expect(await balance(h, w.caller, "coins")).toBe(40);

    const broke = await call(h, "POST", `/v1/calls/${start.callId}/gifts`, { token: w.callerToken, body: { giftId: await giftId("crown"), clientRef: randomUUID() } });
    expect([broke.statusCode, errorCode(broke)]).toEqual([402, "INSUFFICIENT_BALANCE"]);

    await call(h, "POST", `/v1/calls/${start.callId}/end`, { token: w.callerToken });
    expect(errorCode(await call(h, "POST", `/v1/calls/${start.callId}/gifts`, { token: w.callerToken, body: { giftId: rose, clientRef: randomUUID() } })))
      .toBe("CALL_NOT_ACTIVE");
  });

  it("admin can reprice or hide a gift", async () => {
    const id = await giftId("rose");
    await call(h, "PUT", `/v1/admin/gifts/${id}`, { token: admin, body: { name: "Rose", emoji: "🌹", coins: 15, isActive: true, sortOrder: 1 } });
    const diamond = await giftId("diamond");
    await call(h, "PUT", `/v1/admin/gifts/${diamond}`, { token: admin, body: { name: "Diamond", emoji: "💎", coins: 1000, isActive: false, sortOrder: 8 } });
    const list = json<{ code: string; coins: number }[]>(await call(h, "GET", "/v1/gifts"));
    expect(list.find((g) => g.code === "rose")?.coins).toBe(15);
    expect(list.map((g) => g.code)).not.toContain("diamond");
  });

  it("admin settings are bounded and audited", async () => {
    expect(errorCode(await call(h, "PUT", "/v1/admin/settings/gift.companion_share_bps", { token: admin, body: { value: 9000 } }))).toBe("OUT_OF_RANGE");
    expect(errorCode(await call(h, "PUT", "/v1/admin/settings/not.a.setting", { token: admin, body: { value: 1 } }))).toBe("SETTING_NOT_FOUND");
    await call(h, "PUT", "/v1/admin/settings/gift.companion_share_bps", { token: admin, body: { value: 5000 } });
    const s = json<{ key: string; value: number }[]>(await call(h, "GET", "/v1/admin/settings", { token: admin }));
    expect(s.find((x) => x.key === "gift.companion_share_bps")?.value).toBe(5000);
    await call(h, "PUT", "/v1/admin/settings/gift.companion_share_bps", { token: admin, body: { value: 4000 } });
  });
});

// ---------------------------------------------------------------------------
describe("favourites", () => {
  it("adds, lists (with online state), flags the home list, and removes", async () => {
    const w = await world();
    expect((await call(h, "PUT", `/v1/favourites/${w.companion}`, { token: w.callerToken, body: {} })).statusCode).toBe(204);
    const favs = json<{ id: string; online: boolean; notify: boolean }[]>(await call(h, "GET", "/v1/favourites", { token: w.callerToken }));
    expect(favs).toEqual([expect.objectContaining({ id: w.companion, online: true, notify: true })]);
    const home = json<{ companions: { isFavourite: boolean }[] }>(await call(h, "GET", "/v1/companions/online?language=ta", { token: w.callerToken }));
    expect(home.companions[0]!.isFavourite).toBe(true);

    await call(h, "DELETE", `/v1/favourites/${w.companion}`, { token: w.callerToken });
    expect(json(await call(h, "GET", "/v1/favourites", { token: w.callerToken }))).toEqual([]);
    expect(errorCode(await call(h, "PUT", `/v1/favourites/${w.caller}`, { token: w.callerToken, body: {} }))).toBe("CANNOT_TARGET_SELF");
  });

  it("alerts fans when a favourite comes online — once per 30 minutes, only with the bell on", async () => {
    const w = await world();
    const quiet = await createCaller(h, 0);
    await call(h, "PUT", `/v1/favourites/${w.companion}`, { token: w.callerToken, body: {} });
    await call(h, "PUT", `/v1/favourites/${w.companion}`, { token: await tokenFor(h, quiet, "caller"), body: { notify: false } });
    await h.redis.srem("online:companions", w.companion);

    await call(h, "POST", "/v1/companion/presence", { token: w.companionToken, body: { online: true } });
    await call(h, "POST", "/v1/companion/presence", { token: w.companionToken, body: { online: true } }); // heartbeat: no new alert
    await call(h, "POST", "/v1/companion/presence", { token: w.companionToken, body: { online: false } });
    await call(h, "POST", "/v1/companion/presence", { token: w.companionToken, body: { online: true } }); // within cooldown
    expect(h.events.of(w.caller, "favourite_online")).toHaveLength(1);
    expect(h.events.of(quiet, "favourite_online")).toHaveLength(0);
  });
});

// ---------------------------------------------------------------------------
describe("first-recharge offer", () => {
  it("only new signed-in users without a purchase see it, with an end time", async () => {
    const fresh = await signUp(h, "9876543210");
    const packs = json<{ sku: string; firstRecharge: boolean; offerEndsAt: string | null }[]>(
      await call(h, "GET", "/v1/coin-packages", { token: fresh.accessToken }));
    expect(packs[0]).toMatchObject({ sku: "first_recharge_100", firstRecharge: true });
    expect(new Date(packs[0]!.offerEndsAt!).getTime()).toBeGreaterThan(Date.now() + 23 * 3600_000);

    const anon = json<{ sku: string }[]>(await call(h, "GET", "/v1/coin-packages"));
    expect(anon.map((p) => p.sku)).not.toContain("first_recharge_100");

    await h.db.query(`UPDATE users SET created_at = now() - interval '25 hours' WHERE id = $1`, [fresh.userId]);
    const later = json<{ sku: string }[]>(await call(h, "GET", "/v1/coin-packages", { token: fresh.accessToken }));
    expect(later.map((p) => p.sku)).not.toContain("first_recharge_100");
  });
});

// ---------------------------------------------------------------------------
describe("refund requests", () => {
  it("caller asks once; admin approves part and takes the companion's share back", async () => {
    const w = await world(1000);
    const start = await endedCall(w); // 3 minutes: 30 coins, ₹9 earned
    const r = await call(h, "POST", `/v1/calls/${start.callId}/refund-request`, {
      token: w.callerToken, body: { reason: "couldnt_hear", details: "Very noisy line" },
    });
    expect(r.statusCode).toBe(201);
    expect(json(r)).toMatchObject({ status: "requested", coinsEligible: 30 });
    expect(errorCode(await call(h, "POST", `/v1/calls/${start.callId}/refund-request`, { token: w.callerToken, body: { reason: "other" } })))
      .toBe("REFUND_ALREADY_REQUESTED");

    const queue = json<{ id: string; caller: { displayName: string }; call: { minutesCharged: number } }[]>(
      await call(h, "GET", "/v1/admin/refunds", { token: admin }));
    expect(queue[0]).toMatchObject({ call: { minutesCharged: 3 } });
    expect(errorCode(await call(h, "POST", `/v1/admin/refunds/${queue[0]!.id}/decide`, {
      token: admin, body: { decision: "approve", coins: 31, note: "too many" } }))).toBe("TOO_MANY_COINS");

    await call(h, "POST", `/v1/admin/refunds/${queue[0]!.id}/decide`, {
      token: admin, body: { decision: "approve", coins: 20, reverseCompanion: true, note: "Two bad minutes" },
    });
    expect(await balance(h, w.caller, "coins")).toBe(1000 - 30 + 20);
    expect(await balance(h, w.companion, "earnings")).toBe(900 - 600); // 20/30 of ₹9 taken back
    const details = json<{ refundRequest: object; coinsRefunded: number }>(await call(h, "GET", `/v1/calls/${start.callId}`, { token: w.callerToken }));
    expect(details.refundRequest).toMatchObject({ status: "approved", coinsRefunded: 20 });
    expect(details.coinsRefunded).toBe(20);
  });

  it("rejection keeps the coins where they are; unfinished or unconnected calls can't be refunded", async () => {
    const w = await world(1000);
    const start = await endedCall(w);
    await call(h, "POST", `/v1/calls/${start.callId}/refund-request`, { token: w.callerToken, body: { reason: "other" } });
    const [req] = json<{ id: string }[]>(await call(h, "GET", "/v1/admin/refunds", { token: admin }));
    await call(h, "POST", `/v1/admin/refunds/${req!.id}/decide`, { token: admin, body: { decision: "reject", note: "Call was fine" } });
    expect(await balance(h, w.caller, "coins")).toBe(970);

    const ringing = json<{ callId: string }>(await call(h, "POST", "/v1/calls", { token: w.callerToken, body: { companionId: w.companion, type: "audio" } }));
    expect(errorCode(await call(h, "POST", `/v1/calls/${ringing.callId}/refund-request`, { token: w.callerToken, body: { reason: "other" } })))
      .toBe("CALL_NOT_REFUNDABLE");
  });
});

// ---------------------------------------------------------------------------
describe("report recordings", () => {
  it("starts recording a live call on report, and deletes it when the report is closed", async () => {
    const w = await world();
    const start = await liveCall(w);
    const r = json<{ reportId: string; recording: string }>(await call(h, "POST", "/v1/reports", {
      token: w.callerToken, body: { userId: w.companion, callId: start.callId, reason: "abuse", alsoBlock: false },
    }));
    expect(r.recording).toBe("started");
    expect(h.recorder.started).toEqual([(await getCall(h, start.callId)).room_name]);
    expect((await h.db.query(`SELECT count(*)::int AS n FROM blocks`)).rows[0]).toEqual({ n: 0 }); // alsoBlock: false

    const [report] = json<{ id: string; recording: string }[]>(await call(h, "GET", "/v1/admin/reports", { token: admin }));
    expect(report!.recording).toBe("recording");
    await call(h, "POST", `/v1/admin/reports/${report!.id}/resolve`, { token: admin, body: { decision: "dismiss", note: "Reviewed audio" } });
    expect(h.recorder.stopped).toEqual([`eg_${r.reportId}`]);
    const [closed] = json<{ recording: string }[]>(await call(h, "GET", "/v1/admin/reports?status=dismissed", { token: admin }));
    expect(closed!.recording).toBe("deleted");
  });

  it("says not_live for a report after the call, and blocks by default", async () => {
    const w = await world();
    const start = await endedCall(w);
    const r = json<{ recording: string }>(await call(h, "POST", "/v1/reports", {
      token: w.callerToken, body: { userId: w.companion, callId: start.callId, reason: "spam" },
    }));
    expect(r.recording).toBe("not_live");
    expect((await h.db.query(`SELECT count(*)::int AS n FROM blocks`)).rows[0]).toEqual({ n: 1 });
  });
});

// ---------------------------------------------------------------------------
describe("academy", () => {
  it("unlocks lessons in order, needs every answer right, and gates video unlock", async () => {
    const w = await world();
    const a = json<{ passed: number; total: number; lessons: { id: number; status: string; quiz: object[] }[] }>(
      await call(h, "GET", "/v1/companion/academy", { token: w.companionToken }));
    expect(a.total).toBe(5);
    expect(a.lessons.map((l) => l.status)).toEqual(["available", "locked", "locked", "locked", "locked"]);
    expect(JSON.stringify(a.lessons[0]!.quiz)).not.toContain("answer");

    expect(errorCode(await call(h, "POST", `/v1/companion/academy/${a.lessons[1]!.id}/answers`, { token: w.companionToken, body: { answers: [0, 0, 0] } })))
      .toBe("LESSON_LOCKED");
    const wrong = json<{ passed: boolean; correct: boolean[] }>(await call(h, "POST", `/v1/companion/academy/${a.lessons[0]!.id}/answers`, {
      token: w.companionToken, body: { answers: [1, 1, 1] } }));
    expect(wrong).toEqual({ passed: false, correct: [true, true, false] });

    // Admin can't unlock video before the academy is done.
    expect(errorCode(await call(h, "POST", `/v1/admin/companions/${w.companion}/video`, { token: admin, body: { enabled: true, reason: "try" } })))
      .toBe("ACADEMY_INCOMPLETE");

    const answers = (await h.db.query<{ id: number; quiz: { answer: number }[] }>(`SELECT id, quiz FROM academy_lessons ORDER BY position`)).rows;
    for (const l of answers) {
      const r = json<{ passed: boolean }>(await call(h, "POST", `/v1/companion/academy/${l.id}/answers`, {
        token: w.companionToken, body: { answers: l.quiz.map((q) => q.answer) } }));
      expect(r.passed).toBe(true);
    }
    expect(json(await call(h, "GET", "/v1/companion/academy", { token: w.companionToken }))).toMatchObject({ passed: 5 });
    expect((await call(h, "POST", `/v1/admin/companions/${w.companion}/video`, { token: admin, body: { enabled: true, reason: "Academy done" } })).statusCode).toBe(204);
  });
});

// ---------------------------------------------------------------------------
describe("delete my account", () => {
  it("removes a caller's personal data, frees the number, keeps the money trail", async () => {
    const s = await signUp(h, "9876543210", { displayName: "Arun" });
    await tx(h.db, (c) => post(c, s.userId, "coins", "bonus", 40, `test:del:${s.userId}`));
    await h.db.query(`INSERT INTO devices (fcm_token, user_id) VALUES ('fcm-token-for-deletion-test-00', $1)`, [s.userId]);

    expect(errorCode(await call(h, "POST", "/v1/me/delete", { token: s.accessToken, body: { confirm: "yes" } }))).toBe("VALIDATION");
    const r = await call(h, "POST", "/v1/me/delete", { token: s.accessToken, body: { confirm: "DELETE" } });
    expect(json(r)).toMatchObject({ deleted: true });

    const u = (await h.db.query(`SELECT status, display_name, phone FROM users WHERE id = $1`, [s.userId])).rows[0];
    expect(u).toMatchObject({ status: "deleted", display_name: "Deleted user" });
    expect(u.phone).not.toContain("9876543210");
    expect((await h.db.query(`SELECT count(*)::int AS n FROM devices WHERE user_id = $1`, [s.userId])).rows[0]).toEqual({ n: 0 });
    expect((await h.db.query(`SELECT forfeited_coins FROM account_deletions WHERE user_id = $1`, [s.userId])).rows[0]).toEqual({ forfeited_coins: 40 });
    expect((await h.db.query(`SELECT count(*)::int AS n FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id WHERE w.user_id = $1`, [s.userId])).rows[0])
      .toEqual({ n: 1 });
    expect((await call(h, "POST", "/v1/auth/refresh", { body: { refreshToken: s.refreshToken } })).statusCode).toBe(401);

    // The same number can sign up again as a brand-new account.
    await h.redis.flushdb();
    const again = await signUp(h, "9876543210");
    expect(again.userId).not.toBe(s.userId);
  });

  it("companions must withdraw earnings first; KYC files are deleted", async () => {
    const w = await world();
    await h.store.put(`kyc/${w.companion}/selfie`, Buffer.from("face"));
    await h.db.query(`INSERT INTO kyc_documents (user_id, doc_type, storage_key) VALUES ($1, 'selfie', $2)`, [w.companion, `kyc/${w.companion}/selfie`]);
    await tx(h.db, (c) => post(c, w.companion, "earnings", "call_credit", 20_000, `test:earn:${w.companion}`));
    expect(errorCode(await call(h, "POST", "/v1/me/delete", { token: w.companionToken, body: { confirm: "DELETE" } }))).toBe("EARNINGS_LEFT");

    await h.db.query(`UPDATE wallets SET balance = 0 WHERE user_id = $1 AND kind = 'earnings'`, [w.companion]);
    expect((await call(h, "POST", "/v1/me/delete", { token: w.companionToken, body: { confirm: "DELETE" } })).statusCode).toBe(200);
    expect(h.store.keys()).not.toContain(`kyc/${w.companion}/selfie`);
  });
});
