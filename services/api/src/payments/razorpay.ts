/**
 * Razorpay (payments inside the app, via User Choice Billing). The app opens
 * Razorpay's checkout for an order the server created; coins are credited only
 * after the server checks the checkout signature and fetches the payment, or
 * from a signed webhook. Keys come from env (RAZORPAY_KEY_ID / _SECRET).
 */
import { createHmac, timingSafeEqual } from "node:crypto";

export interface RazorpayOrder { id: string; amount: number; currency: string; status: string }

export interface RazorpayPayment {
  id: string;
  order_id: string | null;
  amount: number;
  currency: string;
  status: "created" | "authorized" | "captured" | "refunded" | "failed";
  amount_refunded: number;
  method?: string | null;
  error_description?: string | null;
}

export interface RazorpayGateway {
  /** Public key id the app's checkout needs. */
  readonly keyId: string;
  createOrder(amountPaise: number, receipt: string, notes: Record<string, string>): Promise<RazorpayOrder>;
  fetchPayment(paymentId: string): Promise<RazorpayPayment>;
  capture(paymentId: string, amountPaise: number): Promise<RazorpayPayment>;
  /** Checkout callback: HMAC-SHA256("order_id|payment_id", key secret). */
  checkoutSignatureOk(orderId: string, paymentId: string, signature: string): boolean;
  /** Webhook: HMAC-SHA256(raw body, webhook secret). False when no webhook secret is set. */
  webhookSignatureOk(rawBody: string, signature: string | undefined): boolean;
}

export function hmacHex(secret: string, data: string): string {
  return createHmac("sha256", secret).update(data).digest("hex");
}

function sameHex(expected: string, given: string | undefined): boolean {
  if (!given) return false;
  const a = Buffer.from(expected, "utf8");
  const b = Buffer.from(given, "utf8");
  return a.length === b.length && timingSafeEqual(a, b);
}

export function checkoutSignature(keySecret: string, orderId: string, paymentId: string): string {
  return hmacHex(keySecret, `${orderId}|${paymentId}`);
}

export class RazorpayError extends Error {
  constructor(readonly status: number, message: string) { super(message); }
}

export function razorpayGateway(keyId: string, keySecret: string, webhookSecret?: string): RazorpayGateway {
  const auth = `Basic ${Buffer.from(`${keyId}:${keySecret}`).toString("base64")}`;
  async function api<T>(method: "GET" | "POST", path: string, body?: unknown): Promise<T> {
    const res = await fetch(`https://api.razorpay.com/v1${path}`, {
      method,
      headers: { authorization: auth, ...(body ? { "content-type": "application/json" } : {}) },
      body: body ? JSON.stringify(body) : undefined,
      signal: AbortSignal.timeout(15_000),
    });
    const json = await res.json().catch(() => ({})) as { error?: { description?: string } };
    if (!res.ok) throw new RazorpayError(res.status, json.error?.description ?? `Razorpay ${res.status}`);
    return json as T;
  }
  return {
    keyId,
    createOrder: (amount, receipt, notes) => api("POST", "/orders", { amount, currency: "INR", receipt, notes }),
    fetchPayment: (id) => api("GET", `/payments/${encodeURIComponent(id)}`),
    capture: (id, amount) => api("POST", `/payments/${encodeURIComponent(id)}/capture`, { amount, currency: "INR" }),
    checkoutSignatureOk: (orderId, paymentId, signature) =>
      sameHex(checkoutSignature(keySecret, orderId, paymentId), signature),
    webhookSignatureOk: (raw, signature) => !!webhookSecret && sameHex(hmacHex(webhookSecret, raw), signature),
  };
}
