/**
 * Settling Razorpay coin purchases. Both the app's "I paid" call and
 * Razorpay's webhook end up here; whichever comes first credits the coins, the
 * other finds the purchase already credited. Money rules (CLAUDE.md): coins only
 * after the server has seen the payment captured at the right amount, one
 * ledger row per purchase (idempotency key), balance never negative.
 */
import type { Db, DbClient } from "../db/pool.js";
import { tx } from "../db/pool.js";
import { post } from "../billing/ledger.js";
import { rewardReferral } from "../growth.js";
import type { RazorpayGateway, RazorpayPayment } from "./razorpay.js";

export type SettleResult =
  | { status: "credited"; purchaseId: string; userId: string; coins: number; balance: number; fresh: boolean;
      referral: Awaited<ReturnType<typeof rewardReferral>> }
  | { status: "pending"; purchaseId: string; userId: string }
  | { status: "failed"; purchaseId: string; userId: string; reason: string };

interface PurchaseRow {
  id: string; user_id: string; status: "pending" | "credited" | "refunded" | "failed";
  amount_paise: number; coins: number; bonus_coins: number; label: string | null;
  razorpay_order_id: string; razorpay_payment_id: string | null; coins_credited: number;
}

async function lockByOrder(c: DbClient, orderId: string): Promise<PurchaseRow | undefined> {
  return (await c.query<PurchaseRow>(
    `SELECT p.id, p.user_id, p.status, p.amount_paise, k.coins, k.bonus_coins, k.label,
            p.razorpay_order_id, p.razorpay_payment_id, p.coins_credited
       FROM purchases p JOIN coin_packages k ON k.id = p.package_id
      WHERE p.provider = 'razorpay' AND p.razorpay_order_id = $1 FOR UPDATE OF p`, [orderId])).rows[0];
}

/** Why a payment can't pay for this purchase, or null when it matches. */
function mismatch(p: PurchaseRow, pay: RazorpayPayment): string | null {
  if (pay.order_id !== p.razorpay_order_id) return "payment belongs to another order";
  if (pay.currency !== "INR" || pay.amount !== p.amount_paise) return "amount does not match the pack price";
  return null;
}

/**
 * Brings a purchase in line with a payment Razorpay reported (fetched from the
 * API or taken from a signed webhook). Captures an authorized payment first.
 */
export async function settlePayment(db: Db, gw: RazorpayGateway, orderId: string, payment: RazorpayPayment):
  Promise<SettleResult | null> {
  let pay = payment;
  const peek = (await db.query<{ id: string; user_id: string; amount_paise: number }>(
    `SELECT id, user_id, amount_paise FROM purchases WHERE provider = 'razorpay' AND razorpay_order_id = $1`, [orderId])).rows[0];
  if (!peek) return null;
  if (pay.status === "authorized" && pay.order_id === orderId && pay.amount === peek.amount_paise) {
    // Accounts set to manual capture: take the money now so it can't lapse after coins are given.
    pay = await gw.capture(pay.id, pay.amount);
  }
  return tx(db, async (c) => {
    const p = (await lockByOrder(c, orderId))!;
    const coins = p.coins + p.bonus_coins;
    if (p.status === "credited" || p.status === "refunded") {
      if (p.status === "credited") {
        const bal = (await c.query<{ balance: number }>(
          `SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [p.user_id])).rows[0]?.balance ?? 0;
        return { status: "credited", purchaseId: p.id, userId: p.user_id, coins: p.coins_credited, balance: bal, fresh: false, referral: null };
      }
      return { status: "failed", purchaseId: p.id, userId: p.user_id, reason: "refunded" };
    }
    const wrong = mismatch(p, pay);
    if (wrong) {
      await c.query(`UPDATE purchases SET failure_reason = $2 WHERE id = $1`, [p.id, wrong]);
      return { status: "failed", purchaseId: p.id, userId: p.user_id, reason: wrong };
    }
    if (pay.status === "failed") {
      await c.query(`UPDATE purchases SET status = 'failed', failure_reason = $2, razorpay_payment_id = COALESCE(razorpay_payment_id, $3)
                      WHERE id = $1`, [p.id, pay.error_description ?? "payment failed", pay.id]);
      return { status: "failed", purchaseId: p.id, userId: p.user_id, reason: pay.error_description ?? "payment failed" };
    }
    if (pay.status !== "captured") return { status: "pending", purchaseId: p.id, userId: p.user_id };

    const balance = await post(c, p.user_id, "coins", "purchase", coins, `purchase:${p.id}`, {
      purchaseId: p.id, note: `${p.label ?? `${coins} coins`} · Razorpay`,
    });
    await c.query(
      `UPDATE purchases SET status = 'credited', razorpay_payment_id = $2, coins_credited = $3,
              credited_at = now(), failure_reason = NULL WHERE id = $1`,
      [p.id, pay.id, coins]);
    const referral = await rewardReferral(c, p.user_id);
    return { status: "credited", purchaseId: p.id, userId: p.user_id, coins, balance: balance!, fresh: true, referral };
  });
}

/**
 * A credited purchase was refunded in Razorpay: take the coins back as far as
 * the balance allows (it never goes negative); the rest is noted for admins.
 */
export async function refundPurchase(db: Db, orderId: string, payment: RazorpayPayment):
  Promise<{ userId: string; takenBack: number; short: number } | null> {
  return tx(db, async (c) => {
    const p = await lockByOrder(c, orderId);
    if (!p || p.status !== "credited" || payment.id !== p.razorpay_payment_id) return null;
    if (payment.amount_refunded < p.amount_paise) return null; // partial refunds: handled by support
    const bal = (await c.query<{ balance: number }>(
      `SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins' FOR UPDATE`, [p.user_id])).rows[0]?.balance ?? 0;
    const takenBack = Math.min(bal, p.coins_credited);
    if (takenBack > 0) {
      await post(c, p.user_id, "coins", "purchase_reversal", -takenBack, `purchase:${p.id}:refund`, {
        purchaseId: p.id, note: "Purchase refunded",
      });
    }
    const short = p.coins_credited - takenBack;
    await c.query(
      `UPDATE purchases SET status = 'refunded', refunded_at = now(),
              failure_reason = CASE WHEN $2 > 0 THEN $2 || ' coins already spent when refunded' ELSE NULL END
        WHERE id = $1`, [p.id, short]);
    return { userId: p.user_id, takenBack, short };
  });
}
