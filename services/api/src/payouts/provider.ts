import { createHmac, timingSafeEqual } from "node:crypto";

/**
 * UPI payouts (RazorpayX or Cashfree Payouts in production). Until an account
 * exists, the simulator pays instantly — except UPI IDs containing "fail",
 * which fail, so the reversal path can be tried end to end.
 */
export interface PayoutRequest { payoutId: string; upiId: string; amountPaise: number; name: string }
export type PayoutResult =
  | { status: "paid"; providerRef: string }
  | { status: "processing"; providerRef: string }   // provider will confirm by webhook
  | { status: "failed"; reason: string };

export interface PayoutProvider {
  readonly name: string;
  send(req: PayoutRequest): Promise<PayoutResult>;
}

export function simulatedPayouts(): PayoutProvider {
  return {
    name: "simulator",
    async send(req) {
      if (/fail/i.test(req.upiId)) return { status: "failed", reason: "UPI ID rejected by bank (simulated)" };
      return { status: "paid", providerRef: `sim_${req.payoutId.slice(0, 8)}` };
    },
  };
}

/** Optional provider extras: status lookup (worker fallback) and webhook signatures. */
export interface PayoutTracking {
  /** Current state of a payout sent earlier (providerRef from send). */
  status(providerRef: string): Promise<PayoutResult>;
  /** HMAC check of a raw webhook body; false when no webhook secret is set. */
  webhookSignatureOk(rawBody: string, signature: string | undefined): boolean;
}

interface RazorpayXPayout { id: string; status: string; failure_reason?: string | null; status_details?: { description?: string } | null }

/** Maps a RazorpayX payout state to ours (queued/pending/processing wait for the webhook). */
export function razorpayXResult(p: RazorpayXPayout): PayoutResult {
  switch (p.status) {
    case "processed": return { status: "paid", providerRef: p.id };
    case "failed": case "rejected": case "reversed": case "cancelled":
      return { status: "failed", reason: p.status_details?.description ?? p.failure_reason ?? `Payout ${p.status}` };
    default: return { status: "processing", providerRef: p.id };
  }
}

/**
 * RazorpayX payouts to UPI (same API keys as Razorpay + the RazorpayX account
 * number). Contact → UPI fund account → payout; the payout id doubles as
 * Razorpay's idempotency key, so a retried request never pays twice.
 */
export function razorpayXPayouts(opts: {
  keyId: string; keySecret: string; accountNumber: string; webhookSecret?: string;
}): PayoutProvider & PayoutTracking {
  const auth = `Basic ${Buffer.from(`${opts.keyId}:${opts.keySecret}`).toString("base64")}`;
  async function api<T>(method: "GET" | "POST", path: string, body?: unknown, headers: Record<string, string> = {}): Promise<T> {
    const res = await fetch(`https://api.razorpay.com/v1${path}`, {
      method,
      headers: { authorization: auth, ...(body ? { "content-type": "application/json" } : {}), ...headers },
      body: body ? JSON.stringify(body) : undefined,
      signal: AbortSignal.timeout(20_000),
    });
    const json = await res.json().catch(() => ({})) as { error?: { description?: string } };
    if (!res.ok) throw new Error(json.error?.description ?? `RazorpayX ${res.status}`);
    return json as T;
  }
  return {
    name: "razorpayx",
    async send(req) {
      const contact = await api<{ id: string }>("POST", "/contacts", {
        name: req.name.slice(0, 50) || "Companion", type: "vendor", reference_id: req.payoutId.slice(0, 40),
      });
      const account = await api<{ id: string }>("POST", "/fund_accounts", {
        contact_id: contact.id, account_type: "vpa", vpa: { address: req.upiId },
      });
      const payout = await api<RazorpayXPayout>("POST", "/payouts", {
        account_number: opts.accountNumber, fund_account_id: account.id, amount: req.amountPaise, currency: "INR",
        mode: "UPI", purpose: "payout", queue_if_low_balance: true, reference_id: req.payoutId.slice(0, 40),
        narration: "Hello Dude earnings",
      }, { "X-Payout-Idempotency": req.payoutId });
      return razorpayXResult(payout);
    },
    async status(ref) {
      return razorpayXResult(await api<RazorpayXPayout>("GET", `/payouts/${encodeURIComponent(ref)}`));
    },
    webhookSignatureOk(raw, signature) {
      if (!opts.webhookSecret || !signature) return false;
      const expected = Buffer.from(createHmac("sha256", opts.webhookSecret).update(raw).digest("hex"));
      const given = Buffer.from(signature);
      return expected.length === given.length && timingSafeEqual(expected, given);
    },
  };
}

/** RazorpayX when its account number is set, else the simulator (dev). */
export function payoutsFromConfig(cfg: {
  RAZORPAY_KEY_ID?: string; RAZORPAY_KEY_SECRET?: string; RAZORPAYX_ACCOUNT_NUMBER?: string; RAZORPAYX_WEBHOOK_SECRET?: string;
}): PayoutProvider {
  if (cfg.RAZORPAYX_ACCOUNT_NUMBER && cfg.RAZORPAY_KEY_ID && cfg.RAZORPAY_KEY_SECRET) {
    return razorpayXPayouts({ keyId: cfg.RAZORPAY_KEY_ID, keySecret: cfg.RAZORPAY_KEY_SECRET,
      accountNumber: cfg.RAZORPAYX_ACCOUNT_NUMBER, webhookSecret: cfg.RAZORPAYX_WEBHOOK_SECRET });
  }
  return simulatedPayouts();
}
