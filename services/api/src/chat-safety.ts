/**
 * Screens a chat message or message request (owner, 2026-09-24): the filter
 * (chat-filter.ts), then strikes for each blocked attempt. 3 strikes in 24 h pause
 * the sender's chat for 24 h; 5 in 30 days file an automatic report for the admin;
 * companions with strikes also get a payout flag (routes/companion.ts riskFlags).
 */
import type { Db } from "./db/pool.js";
import { ApiError } from "./errors.js";
import { BLOCK_MESSAGES, checkMessage, checkSplit } from "./chat-filter.js";
import { numberSetting } from "./settings.js";

const SPLIT_WINDOW = "10 minutes";
const SPLIT_MESSAGES = 5;

const istTime = (d: Date) =>
  d.toLocaleString("en-IN", { timeZone: "Asia/Kolkata", hour: "numeric", minute: "2-digit", day: "numeric", month: "short" });

/** Throws CHAT_PAUSED while the sender's chat is paused. */
export async function assertChatOpen(db: Db, userId: string) {
  const until = (await db.query<{ until: Date | null }>(
    `SELECT CASE WHEN chat_paused_until > now() THEN chat_paused_until END AS until FROM users WHERE id = $1`, [userId])).rows[0]?.until;
  if (until) {
    throw new ApiError(429, "CHAT_PAUSED",
      `Your chat is paused until ${istTime(until)} after repeated attempts to share contact details or payments.`);
  }
}

/**
 * Checks `text` from `senderId`. On a block it records a strike, applies any pause
 * or review, and throws MESSAGE_BLOCKED (422) with what happens next.
 */
export async function screenMessage(db: Db, senderId: string, text: string,
  where: { conversationId?: string; requestId?: string } = {}) {
  await assertChatOpen(db, senderId);
  let reason = checkMessage(text);
  if (!reason && where.conversationId) {
    // A number sent in pieces over the last few messages.
    const recent = (await db.query<{ body: string }>(
      `SELECT body FROM (SELECT body, id FROM messages WHERE conversation_id = $1 AND sender_id = $2
                           AND created_at > now() - $3::interval ORDER BY id DESC LIMIT $4) m ORDER BY id`,
      [where.conversationId, senderId, SPLIT_WINDOW, SPLIT_MESSAGES])).rows.map((r) => r.body);
    reason = checkSplit(recent, text);
  }
  if (!reason) return;

  const [toPause, pauseHours, toReview] = await Promise.all([
    numberSetting(db, "chat.strikes_to_pause", 3), numberSetting(db, "chat.pause_hours", 24), numberSetting(db, "chat.strikes_to_review", 5),
  ]);
  await db.query(`INSERT INTO chat_violations (conversation_id, request_id, sender_id, reason) VALUES ($1, $2, $3, $4)`,
    [where.conversationId ?? null, where.requestId ?? null, senderId, reason]);
  const n = (await db.query<{ day: number; month: number }>(
    `SELECT count(*) FILTER (WHERE created_at > now() - interval '24 hours')::int AS day,
            count(*) FILTER (WHERE created_at > now() - interval '30 days')::int AS month
       FROM chat_violations WHERE sender_id = $1`, [senderId])).rows[0]!;

  let next = "";
  if (n.day >= toPause) {
    await db.query(`UPDATE users SET chat_paused_until = now() + make_interval(hours => $2) WHERE id = $1`, [senderId, pauseHours]);
    next = ` Your chat is now paused for ${pauseHours} hours.`;
  } else if (n.day === toPause - 1) {
    next = " One more and your chat will be paused.";
  }
  if (n.month >= toReview) {
    // One automatic report a month for the admin to review.
    await db.query(
      `INSERT INTO reports (reporter_id, reported_id, reason, details, source)
       SELECT NULL, $1, 'off_platform', $2, 'system'
        WHERE NOT EXISTS (SELECT 1 FROM reports WHERE reported_id = $1 AND source = 'system' AND created_at > now() - interval '30 days')`,
      [senderId, `${n.month} blocked attempts to share contact details or payments in chat in the last 30 days`]);
  }
  throw new ApiError(422, "MESSAGE_BLOCKED", BLOCK_MESSAGES[reason] + next);
}
