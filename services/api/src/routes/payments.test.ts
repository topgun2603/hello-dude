import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { balance, createCaller, createCompanion, resetState } from "../../test/fixtures.js";
import {
  call, createAppHarness, errorCode, json, RZP_TEST_SECRET, RZP_WEBHOOK_SECRET, signUp, tokenFor, type AppHarness,
} from "../../test/app-harness.js";
import { checkoutSignature, hmacHex, type RazorpayPayment } from "../payments/razorpay.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  h.razorpay.orders = [];
  h.razorpay.payments.clear();
  h.razorpay.captured = [];
  await h.db.query(`UPDATE coin_packages SET is_active = false`);
  await h.db.query(
    `INSERT INTO coin_packages (play_sku, coins, bonus_coins, price_paise, label, first_recharge_only, is_active)
     VALUES ('t_coins_100', 100, 10, 9900, '110 coins', false, true), ('t_welcome', 50, 50, 1900, 'Welcome', true, true)
     ON CONFLICT (play_sku) DO UPDATE SET coins = EXCLUDED.coins, bonus_coins = EXCLUDED.bonus_coins,
       price_paise = EXCLUDED.price_paise, label = EXCLUDED.label, first_recharge_only = EXCLUDED.first_recharge_only, is_active = true`);
});

type Order = { orderId: string; keyId: string; amountPaise: number; coins: number };
type Result = { status: string; coins: number; balance: number | null };

async function order(token: string, sku = "t_coins_100") {
  return call(h, "POST", "/v1/payments/razorpay/order", { token, body: { sku } });
}
function verify(token: string, orderId: string, paymentId: string, signature = checkoutSignature(RZP_TEST_SECRET, orderId, paymentId)) {
  return call(h, "POST", "/v1/payments/razorpay/verify", { token, body: { orderId, paymentId, signature } });
}
function hook(event: string, payment: RazorpayPayment, secret = RZP_WEBHOOK_SECRET) {
  const payload = JSON.stringify({ event, payload: { payment: { entity: payment } } });
  return h.app.inject({
    method: "POST", url: "/v1/webhooks/razorpay", payload,
    headers: { "content-type": "application/json", "x-razorpay-signature": hmacHex(secret, payload) },
  });
}
const ledgerRows = async (userId: string) => (await h.db.query<{ type: string; amount: number }>(
  `SELECT l.type, l.amount FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
    WHERE w.user_id = $1 AND l.type IN ('purchase', 'purchase_reversal') ORDER BY l.id`, [userId])).rows;

describe("Razorpay coin purchases", () => {
  it("order at the pack price → checkout → verify credits coins + bonus exactly once", async () => {
    const caller = await createCaller(h, 5);
    const token = await tokenFor(h, caller, "caller");
    const o = json<Order>(await order(token));
    expect(o).toMatchObject({ keyId: "rzp_test_key", amountPaise: 9900, coins: 110 });
    const pay = h.razorpay.pay(o.orderId);

    expect(json<Result>(await verify(token, o.orderId, pay.id))).toMatchObject({ status: "credited", coins: 110, balance: 115 });
    // The app retries (or the webhook arrives too): no second credit.
    expect(json<Result>(await verify(token, o.orderId, pay.id))).toMatchObject({ status: "credited", coins: 110, balance: 115 });
    expect((await hook("payment.captured", pay)).statusCode).toBe(200);
    expect(await balance(h, caller, "coins")).toBe(115);
    expect(await ledgerRows(caller)).toEqual([{ type: "purchase", amount: 110 }]);
    const p = (await h.db.query(`SELECT status, razorpay_payment_id, coins_credited FROM purchases`)).rows;
    expect(p).toEqual([{ status: "credited", razorpay_payment_id: pay.id, coins_credited: 110 }]);
  });

  it("a wrong signature, someone else's order or a mismatched amount never credits", async () => {
    const caller = await createCaller(h, 0);
    const token = await tokenFor(h, caller, "caller");
    const o = json<Order>(await order(token));
    const pay = h.razorpay.pay(o.orderId);
    expect(errorCode(await verify(token, o.orderId, pay.id, "forged"))).toBe("BAD_SIGNATURE");

    const other = await tokenFor(h, await createCaller(h, 0), "caller");
    expect(errorCode(await verify(other, o.orderId, pay.id))).toBe("ORDER_NOT_FOUND");

    const o2 = json<Order>(await order(token));
    const cheap = h.razorpay.pay(o2.orderId, { amount: 100 });
    expect(json<Result>(await verify(token, o2.orderId, cheap.id))).toMatchObject({ status: "failed", coins: 0 });
    expect(await balance(h, caller, "coins")).toBe(0);
  });

  it("an authorized payment is captured before coins are given; a failed one is marked failed", async () => {
    const token = await tokenFor(h, await createCaller(h, 0), "caller");
    const o = json<Order>(await order(token));
    const pay = h.razorpay.pay(o.orderId, { status: "authorized" });
    expect(json<Result>(await verify(token, o.orderId, pay.id))).toMatchObject({ status: "credited", coins: 110 });
    expect(h.razorpay.captured).toEqual([pay.id]);

    const o2 = json<Order>(await order(token));
    const bad = h.razorpay.pay(o2.orderId, { status: "failed", error_description: "Card declined" });
    expect(json<Result>(await verify(token, o2.orderId, bad.id))).toMatchObject({ status: "failed" });
    expect((await h.db.query(`SELECT status, failure_reason FROM purchases WHERE razorpay_order_id = $1`, [o2.orderId])).rows)
      .toEqual([{ status: "failed", failure_reason: "Card declined" }]);
  });

  it("webhook credits when the app never came back; bad signatures are refused", async () => {
    const caller = await createCaller(h, 0);
    const token = await tokenFor(h, caller, "caller");
    const o = json<Order>(await order(token));
    const pay = h.razorpay.pay(o.orderId);
    expect((await hook("payment.captured", pay, "wrong-secret")).statusCode).toBe(401);
    expect(await balance(h, caller, "coins")).toBe(0);
    expect((await hook("payment.captured", pay)).statusCode).toBe(200);
    expect(await balance(h, caller, "coins")).toBe(110);
    expect(h.events.sent.some((e) => e.userId === caller && e.event.t === "wallet")).toBe(true);
  });

  it("refund takes the coins back, never below zero", async () => {
    const caller = await createCaller(h, 0);
    const token = await tokenFor(h, caller, "caller");
    const o = json<Order>(await order(token));
    const pay = h.razorpay.pay(o.orderId);
    await verify(token, o.orderId, pay.id);
    // Spent 70 of the 110 before the refund.
    await h.db.query(`UPDATE wallets SET balance = 40 WHERE user_id = $1 AND kind = 'coins'`, [caller]);
    expect((await hook("refund.processed", { ...pay, status: "refunded", amount_refunded: 9900 })).statusCode).toBe(200);
    expect(await balance(h, caller, "coins")).toBe(0);
    expect((await h.db.query(`SELECT status, failure_reason FROM purchases`)).rows)
      .toEqual([{ status: "refunded", failure_reason: "70 coins already spent when refunded" }]);
    // Repeated notice changes nothing.
    await hook("refund.processed", { ...pay, status: "refunded", amount_refunded: 9900 });
    expect((await ledgerRows(caller)).filter((r) => r.type === "purchase_reversal")).toEqual([{ type: "purchase_reversal", amount: -40 }]);
  });

  it("welcome pack only before the first credited recharge; companions can't buy coins", async () => {
    const buyer = await signUp(h, "9876500001");
    const o = json<Order>(await order(buyer.accessToken, "t_welcome"));
    expect(o.coins).toBe(100);
    await verify(buyer.accessToken, o.orderId, h.razorpay.pay(o.orderId).id);
    expect(errorCode(await order(buyer.accessToken, "t_welcome"))).toBe("OFFER_ENDED");
    expect(errorCode(await order(buyer.accessToken, "nope"))).toBe("PACK_NOT_FOUND");

    const companion = await tokenFor(h, await createCompanion(h), "companion");
    expect((await order(companion)).statusCode).toBe(403);
  });

  it("first credited recharge pays the referral reward", async () => {
    const inviter = await signUp(h, "9876500002", { displayName: "Karthik" });
    const { code } = json<{ code: string }>(await call(h, "GET", "/v1/referral", { token: inviter.accessToken }));
    const friend = await signUp(h, "9876500003", { displayName: "Arun", referralCode: code });
    const o = json<Order>(await order(friend.accessToken));
    await verify(friend.accessToken, o.orderId, h.razorpay.pay(o.orderId).id);
    expect(await balance(h, friend.userId, "coins")).toBe(160); // 110 + 50 welcome bonus
    expect(await balance(h, inviter.userId, "coins")).toBe(50);
    const note = (await h.db.query(`SELECT title FROM notifications WHERE user_id = $1 AND type = 'referral_rewarded'`, [inviter.userId])).rows;
    expect(note).toEqual([{ title: "You earned 50 coins" }]);
  });
});
