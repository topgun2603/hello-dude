/**
 * The notification inbox. notify() stores the item (so it shows in the app's
 * Notifications screen), pushes it to the user's phones, and tells an open app
 * over the WebSocket so the bell badge updates at once.
 *
 * Call it after the transaction that caused it has committed; a failed push
 * never fails the caller.
 */
import type { Db, DbClient } from "./db/pool.js";
import type { UserEvents } from "./billing/ports.js";
import type { PushSender } from "./push.js";

export const NOTICE_TYPES = [
  "favourite_online",
  "booking_requested", "booking_confirmed", "booking_cancelled", "booking_reminder",
  "refund_decided",
  "daily_bonus",
  "rate_call",
  "referral_joined", "referral_rewarded",
  "report_actioned",
  "support_coins", "admin_message",
  "payout_paid", "payout_failed",
  "kyc_decided",
  "chat_message",
  "room_live",
  "vip",
  "bonus_earned",
] as const;
export type NoticeType = (typeof NOTICE_TYPES)[number];

export interface Notice {
  type: NoticeType;
  title: string;
  body: string;
  /** Ids the app needs to open the right screen (all strings). */
  data?: Record<string, string>;
}

export interface NotifyDeps { db: Db | DbClient; push: PushSender; events: UserEvents }

/**
 * inbox: false = push only (e.g. chat messages, which have their own screen and
 * would flood the inbox). Returns the inbox row id, or 0 when not stored.
 */
export async function notify(deps: NotifyDeps, userId: string, n: Notice, opts: { push?: boolean; inbox?: boolean } = {}): Promise<number> {
  let id = 0;
  if (opts.inbox !== false) {
    id = (await deps.db.query<{ id: number }>(
      `INSERT INTO notifications (user_id, type, title, body, data) VALUES ($1, $2, $3, $4, $5) RETURNING id`,
      [userId, n.type, n.title, n.body, JSON.stringify(n.data ?? {})])).rows[0]!.id;
    await deps.events.publish(userId, { t: "notification", id, type: n.type, title: n.title }).catch(() => {});
  }
  if (opts.push !== false) {
    const tokens = (await deps.db.query<{ fcm_token: string }>(`SELECT fcm_token FROM devices WHERE user_id = $1`, [userId])).rows;
    await deps.push.notify(tokens.map((t) => t.fcm_token), {
      title: n.title, body: n.body,
      data: { ...(n.data ?? {}), type: n.type, ...(id ? { notificationId: String(id) } : {}) },
    }).catch(() => {});
  }
  return id;
}

/** Plain-English pieces used in several notices. */
export const coinsText = (n: number) => `${n} coin${n === 1 ? "" : "s"}`;
export const rupeesText = (paise: number) => `₹${(paise / 100).toLocaleString("en-IN", { maximumFractionDigits: 2 })}`;
