import { z } from "zod";
import type { FastifyPluginAsync } from "fastify";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, notFound } from "../errors.js";
import { notify } from "../notifications.js";
import { numberSetting } from "../settings.js";
import type { RazorpayPayment } from "../payments/razorpay.js";
import { refundPurchase, settlePayment, type SettleResult } from "../payments/purchases.js";
import type { AppDeps } from "../app.js";
import { finishPayout } from "../payouts/finish.js";
import { razorpayXResult, type PayoutTracking } from "../payouts/provider.js";

/**
 * Coin purchases through Razorpay, inside the app (User Choice Billing):
 *
 *   1. POST /payments/razorpay/order   server creates the order at the pack's price
 *   2. the app opens Razorpay checkout for that order
 *   3. POST /payments/razorpay/verify  app hands over Razorpay's reply; the server checks the
 *                                      signature, fetches the payment and credits the coins
 *   4. POST /webhooks/razorpay         Razorpay's own signed notice; credits the coins if the
 *                                      app never came back (killed, network), handles refunds
 *
 * Never link users to a website to pay, and never mention cheaper prices elsewhere (Play policy).
 */
const paymentsOff = () => new ApiError(503, "PAYMENTS_OFF", "Buying coins isn't open yet. Please try again later.");

const SettleResponse = z.object({
  status: z.enum(["credited", "pending", "failed"]),
  coins: z.number().int().describe("Coins added by this purchase (0 unless credited)"),
  balance: z.number().int().nullable().describe("Coin balance after crediting"),
  message: z.string(),
}).meta({ id: "PurchaseResult" });

async function afterCredit(deps: AppDeps, r: SettleResult): Promise<void> {
  if (r.status !== "credited" || !r.fresh) return;
  await deps.events.publish(r.userId, { t: "wallet", coins: r.balance }).catch(() => {});
  const ref = r.referral;
  if (ref && (ref.referrerCoins > 0 || ref.referrerPaise > 0)) {
    const reward = ref.referrerCoins > 0 ? `${ref.referrerCoins} coins` : `₹${(ref.referrerPaise / 100).toFixed(0)}`;
    await notify(deps, ref.referrerId, {
      type: "referral_rewarded",
      title: `You earned ${reward}`,
      body: `${ref.refereeName} made their first recharge.`,
    }).catch(() => {});
  }
}

function toResponse(r: SettleResult) {
  switch (r.status) {
    case "credited": return { status: r.status, coins: r.coins, balance: r.balance, message: `${r.coins} coins added` };
    case "pending": return { status: r.status, coins: 0, balance: null,
      message: "Payment is still being confirmed. Your coins will appear in a minute." };
    case "failed": return { status: r.status, coins: 0, balance: null,
      message: "Payment didn't go through. No coins were charged — try again." };
  }
}

export const paymentRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;

  app.post("/payments/razorpay/order", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["wallet"],
      security: bearer,
      summary: "Start buying a coin pack with Razorpay: creates the order the app opens checkout for",
      body: z.object({ sku: z.string().min(1) }),
      response: {
        200: z.object({
          orderId: z.string(), keyId: z.string(), amountPaise: z.number().int(), currency: z.string(),
          coins: z.number().int().describe("Coins incl. bonus"), name: z.string(), description: z.string(),
          phone: z.string().nullable().describe("Prefill for checkout"),
        }).meta({ id: "RazorpayOrder" }),
      },
    },
  }, async (req) => {
    const gw = app.deps.razorpay;
    if (!gw) throw paymentsOff();
    const { userId } = me(req);
    const hours = await numberSetting(db, "offer.first_recharge_hours", 24);
    const pack = (await db.query<{ id: number; coins: number; bonus_coins: number; price_paise: number; label: string | null;
      first_recharge_only: boolean; eligible: boolean; phone: string | null }>(
      `SELECT k.id, k.coins, k.bonus_coins, k.price_paise, k.label, k.first_recharge_only, u.phone,
              (u.created_at + $3 * interval '1 hour' > now()
                AND NOT EXISTS (SELECT 1 FROM purchases p WHERE p.user_id = u.id AND p.status = 'credited')) AS eligible
         FROM coin_packages k, users u
        WHERE k.play_sku = $1 AND k.is_active AND u.id = $2`, [req.body.sku, userId, hours])).rows[0];
    if (!pack) throw notFound("PACK_NOT_FOUND");
    if (pack.first_recharge_only && !pack.eligible) {
      throw new ApiError(409, "OFFER_ENDED", "This welcome offer isn't available any more.");
    }
    const coins = pack.coins + pack.bonus_coins;
    const purchaseId = (await db.query<{ id: string }>(`SELECT gen_random_uuid() AS id`)).rows[0]!.id;
    const order = await gw.createOrder(pack.price_paise, purchaseId, { purchaseId, userId, sku: req.body.sku });
    await db.query(
      `INSERT INTO purchases (id, user_id, package_id, provider, amount_paise, razorpay_order_id)
       VALUES ($1, $2, $3, 'razorpay', $4, $5)`, [purchaseId, userId, pack.id, pack.price_paise, order.id]);
    return {
      orderId: order.id, keyId: gw.keyId, amountPaise: pack.price_paise, currency: "INR", coins,
      name: "Hello Dude!", description: pack.label ?? `${coins} coins`, phone: pack.phone,
    };
  });

  app.post("/payments/razorpay/verify", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["wallet"],
      security: bearer,
      summary: "After checkout: the server checks Razorpay's signature and the payment, then credits the coins (once)",
      body: z.object({ orderId: z.string().min(1), paymentId: z.string().min(1), signature: z.string().min(1) }),
      response: { 200: SettleResponse },
    },
  }, async (req) => {
    const gw = app.deps.razorpay;
    if (!gw) throw paymentsOff();
    const { orderId, paymentId, signature } = req.body;
    const owner = (await db.query<{ user_id: string }>(
      `SELECT user_id FROM purchases WHERE provider = 'razorpay' AND razorpay_order_id = $1`, [orderId])).rows[0];
    if (!owner || owner.user_id !== me(req).userId) throw notFound("ORDER_NOT_FOUND");
    if (!gw.checkoutSignatureOk(orderId, paymentId, signature)) {
      throw new ApiError(400, "BAD_SIGNATURE", "We couldn't confirm this payment. If money was taken, it will be refunded.");
    }
    const payment = await gw.fetchPayment(paymentId);
    const result = (await settlePayment(db, gw, orderId, payment))!;
    await afterCredit(app.deps, result);
    return toResponse(result);
  });
};

/** Razorpay webhooks. The signature covers the raw body, so this plugin keeps the text. */
export const razorpayWebhookRoutes: FastifyPluginAsync = async (app) => {
  const { db } = app.deps;
  app.removeContentTypeParser("application/json");
  app.addContentTypeParser("application/json", { parseAs: "string" }, (_req, body, done) => done(null, body));

  app.post("/webhooks/razorpay", { schema: { hide: true } }, async (req, reply) => {
    const gw = app.deps.razorpay;
    const raw = typeof req.body === "string" ? req.body : "";
    const sig = req.headers["x-razorpay-signature"];
    if (!gw || !gw.webhookSignatureOk(raw, typeof sig === "string" ? sig : undefined)) {
      return reply.status(401).send({ error: { code: "BAD_SIGNATURE", message: "Invalid webhook signature" } });
    }
    const body = JSON.parse(raw) as { event?: string; payload?: { payment?: { entity?: RazorpayPayment } } };
    const payment = body.payload?.payment?.entity;
    const orderId = payment?.order_id;
    if (!payment || !orderId) return { ok: true };
    switch (body.event) {
      case "payment.authorized":
      case "payment.captured":
      case "payment.failed":
      case "order.paid": {
        const r = await settlePayment(db, gw, orderId, payment);
        if (r) await afterCredit(app.deps, r);
        break;
      }
      case "refund.processed": {
        const r = await refundPurchase(db, orderId, payment);
        if (r) {
          await app.deps.events.publish(r.userId, { t: "wallet", coins: null }).catch(() => {});
          if (r.short > 0) req.log.warn({ orderId, short: r.short }, "refunded purchase: coins already spent");
        }
        break;
      }
    }
    return { ok: true };
  });

  /** RazorpayX payout updates (dashboard → RazorpayX → Webhooks, its own secret). */
  app.post("/webhooks/razorpayx", { schema: { hide: true } }, async (req, reply) => {
    const provider = app.deps.payouts as Partial<PayoutTracking>;
    const raw = typeof req.body === "string" ? req.body : "";
    const sig = req.headers["x-razorpay-signature"];
    if (!provider.webhookSignatureOk?.(raw, typeof sig === "string" ? sig : undefined)) {
      return reply.status(401).send({ error: { code: "BAD_SIGNATURE", message: "Invalid webhook signature" } });
    }
    const body = JSON.parse(raw) as { event?: string; payload?: { payout?: { entity?: { id: string; status: string; reference_id?: string | null;
      failure_reason?: string | null; status_details?: { description?: string } | null } } } };
    const entity = body.payload?.payout?.entity;
    if (!entity || !body.event?.startsWith("payout.")) return { ok: true };
    const payout = (await db.query<{ id: string }>(
      `SELECT id FROM payouts WHERE provider_ref = $1 OR id::text = $2 LIMIT 1`, [entity.id, entity.reference_id ?? ""])).rows[0];
    if (payout) await finishPayout(app.deps, payout.id, razorpayXResult(entity));
    return { ok: true };
  });
};
