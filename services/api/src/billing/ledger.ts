import type { DbClient } from "../db/pool.js";

export type WalletKind = "coins" | "earnings";
export type LedgerType =
  | "purchase" | "call_debit" | "call_credit" | "refund" | "refund_reversal"
  | "bonus" | "payout" | "payout_reversal" | "adjustment" | "gift_debit" | "gift_credit"
  | "daily_bonus" | "referral_bonus" | "booking_hold" | "booking_release" | "live_pass_debit" | "live_pass_credit" | "live_debit" | "live_credit" | "group_debit" | "group_credit"
  | "purchase_reversal";

export interface LedgerRefs {
  callId?: string;
  purchaseId?: string;
  payoutId?: string;
  note?: string;
  liveId?: string;
  groupId?: string;
}

/** Creates the coins + earnings wallets for a user. Safe to call repeatedly. */
export async function ensureWallets(c: DbClient, userId: string): Promise<void> {
  await c.query(
    `INSERT INTO wallets (user_id, kind) VALUES ($1, 'coins'), ($1, 'earnings')
     ON CONFLICT (user_id, kind) DO NOTHING`,
    [userId],
  );
}

/**
 * Posts one signed amount to a wallet and appends the matching ledger row.
 * Must run inside a transaction.
 *
 * Returns the new balance, or null when a debit would take the balance below
 * zero (nothing is written in that case). A repeated idempotency key throws a
 * unique violation, which rolls back the caller's transaction.
 */
export async function post(
  c: DbClient,
  userId: string,
  kind: WalletKind,
  type: LedgerType,
  amount: number,
  idempotencyKey: string,
  refs: LedgerRefs = {},
): Promise<number | null> {
  if (!Number.isSafeInteger(amount) || amount === 0) {
    throw new Error(`ledger amount must be a non-zero integer, got ${amount}`);
  }
  const w = await c.query<{ id: string; balance: number }>(
    `UPDATE wallets SET balance = balance + $1, updated_at = now()
      WHERE user_id = $2 AND kind = $3 AND balance + $1 >= 0
      RETURNING id, balance`,
    [amount, userId, kind],
  );
  const wallet = w.rows[0];
  if (!wallet) return null;
  await c.query(
    `INSERT INTO ledger_entries
       (wallet_id, type, amount, balance_after, call_id, purchase_id, payout_id, idempotency_key, note, live_id, group_id)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
    [wallet.id, type, amount, wallet.balance, refs.callId ?? null, refs.purchaseId ?? null,
     refs.payoutId ?? null, idempotencyKey, refs.note ?? null, refs.liveId ?? null, refs.groupId ?? null],
  );
  return wallet.balance;
}
