/**
 * Records a payout's final outcome, whoever learns it first: the provider's
 * immediate answer at approval, its webhook, or the worker's status check.
 * Idempotent: only a payout still in 'processing' (or a 'paid' one the bank
 * reversed) changes. A failure credits the gross amount back to earnings.
 */
import type { Db } from "../db/pool.js";
import { tx } from "../db/pool.js";
import { post } from "../billing/ledger.js";
import { notify, rupeesText, type NotifyDeps } from "../notifications.js";
import type { PayoutProvider, PayoutResult, PayoutTracking } from "./provider.js";

export async function finishPayout(deps: NotifyDeps & { db: Db }, payoutId: string, result: PayoutResult):
  Promise<"paid" | "failed" | "unchanged"> {
  const done = await tx(deps.db, async (c) => {
    const p = (await c.query<{ id: string; companion_id: string; gross_paise: string; net_paise: string; status: string }>(
      `SELECT id, companion_id, gross_paise, net_paise, status FROM payouts WHERE id = $1 FOR UPDATE`, [payoutId])).rows[0];
    if (!p) return null;
    if (result.status === "paid" && p.status === "processing") {
      await c.query(`UPDATE payouts SET status = 'paid', provider_ref = COALESCE($2, provider_ref), processed_at = now() WHERE id = $1`,
        [p.id, result.providerRef]);
      return { p, outcome: "paid" as const };
    }
    if (result.status === "failed" && (p.status === "processing" || p.status === "paid")) {
      await c.query(`UPDATE payouts SET status = 'failed', failure_reason = $2, processed_at = now() WHERE id = $1`, [p.id, result.reason]);
      await post(c, p.companion_id, "earnings", "payout_reversal", Number(p.gross_paise), `payout:${p.id}:reversal`,
        { payoutId: p.id, note: "Withdrawal failed, returned to balance" });
      return { p, outcome: "failed" as const };
    }
    if (result.status === "processing" && p.status === "processing") {
      await c.query(`UPDATE payouts SET provider_ref = COALESCE(provider_ref, $2) WHERE id = $1`, [p.id, result.providerRef]);
    }
    return null;
  });
  if (!done) return "unchanged";
  const { p, outcome } = done;
  if (outcome === "paid") {
    await notify(deps, p.companion_id, { type: "payout_paid", title: `${rupeesText(Number(p.net_paise))} sent to your UPI`,
      body: "Your withdrawal is complete." }).catch(() => {});
  } else {
    await notify(deps, p.companion_id, { type: "payout_failed", title: "Withdrawal failed",
      body: `${rupeesText(Number(p.gross_paise))} is back in your earnings. Check your UPI ID and try again.` }).catch(() => {});
  }
  return outcome;
}

/** Worker fallback: asks the provider about payouts still processing after a few minutes. */
export async function checkProcessingPayouts(deps: NotifyDeps & { db: Db }, provider: PayoutProvider):
  Promise<{ paid: number; failed: number }> {
  const tracking = provider as Partial<PayoutTracking>;
  const out = { paid: 0, failed: 0 };
  if (!tracking.status) return out;
  const rows = (await deps.db.query<{ id: string; provider_ref: string }>(
    `SELECT id, provider_ref FROM payouts WHERE status = 'processing' AND provider_ref IS NOT NULL
        AND approved_at < now() - interval '3 minutes' ORDER BY approved_at LIMIT 50`)).rows;
  for (const r of rows) {
    const result = await tracking.status(r.provider_ref).catch(() => null);
    if (!result) continue;
    const o = await finishPayout(deps, r.id, result);
    if (o !== "unchanged") out[o]++;
  }
  return out;
}
