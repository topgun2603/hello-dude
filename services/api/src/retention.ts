/**
 * Deletes data once the Privacy Policy (docs/legal/privacy.md §4) says it must
 * go. Run hourly by the worker; every step is safe to repeat.
 *
 * - Sign-in sessions: 30 days after they expired or were revoked.
 * - Report recordings: as soon as the report is closed (a safety net — closing
 *   a report already deletes them, but a crash in between must not keep audio).
 * - Rejected companion applications: KYC files and Aadhaar/PAN fields 90 days
 *   after the decision, unless they have been paid (PAN is then kept for TDS).
 * - Flagged video frames: 30 days after an admin reviewed them.
 * - Notifications: 90 days after they were read.
 * - Chat messages: 1 year after the conversation's last message.
 */
import type { Db } from "./db/pool.js";
import type { Recorder } from "./recording.js";
import type { ObjectStore } from "./storage.js";

export const RETENTION = {
  sessionsDays: 30,
  rejectedKycDays: 90,
  moderationFrameDays: 30,
  readNotificationDays: 90,
  chatDays: 365,
} as const;

export interface RetentionResult {
  sessions: number;
  recordings: number;
  rejectedKyc: number;
  frames: number;
  notifications: number;
  chatMessages: number;
}

export async function runRetention(deps: { db: Db; store: ObjectStore; recorder: Recorder }): Promise<RetentionResult> {
  const { db, store, recorder } = deps;

  const sessions = (await db.query(
    `DELETE FROM sessions
      WHERE expires_at < now() - make_interval(days => $1)
         OR revoked_at < now() - make_interval(days => $1)`, [RETENTION.sessionsDays])).rowCount ?? 0;

  const recs = (await db.query<{ id: string; egress_id: string | null; storage_key: string | null; status: string }>(
    `SELECT rr.id, rr.egress_id, rr.storage_key, rr.status
       FROM report_recordings rr JOIN reports r ON r.id = rr.report_id
      WHERE r.status <> 'open' AND rr.status IN ('recording', 'ready')`)).rows;
  for (const r of recs) {
    if (r.status === "recording" && r.egress_id) await recorder.stop(r.egress_id).catch(() => {});
    if (r.storage_key) await store.delete(r.storage_key);
    await db.query(`UPDATE report_recordings SET status = 'deleted', deleted_at = now() WHERE id = $1`, [r.id]);
  }

  const rejected = (await db.query<{ user_id: string; paid: boolean }>(
    `SELECT user_id, paid FROM (
       SELECT p.*, EXISTS (SELECT 1 FROM payouts x WHERE x.companion_id = p.user_id AND x.status = 'paid') AS paid
         FROM companion_profiles p
        WHERE p.kyc_status = 'rejected' AND p.kyc_reviewed_at < now() - make_interval(days => $1)) p
      WHERE EXISTS (SELECT 1 FROM kyc_documents d WHERE d.user_id = p.user_id)
         OR p.aadhaar_name IS NOT NULL OR p.aadhaar_last4 IS NOT NULL
         OR (NOT p.paid AND (p.pan_last4 IS NOT NULL OR p.pan_encrypted IS NOT NULL))`,
    [RETENTION.rejectedKycDays])).rows;
  for (const r of rejected) {
    const files = (await db.query<{ storage_key: string }>(`SELECT storage_key FROM kyc_documents WHERE user_id = $1`, [r.user_id])).rows;
    for (const f of files) await store.delete(f.storage_key);
    await db.query(`DELETE FROM kyc_documents WHERE user_id = $1`, [r.user_id]);
    await db.query(
      `UPDATE companion_profiles
          SET aadhaar_last4 = NULL, aadhaar_name = NULL, aadhaar_dob = NULL, aadhaar_gender = NULL,
              aadhaar_generated_at = NULL, selfie_blinks = NULL
              ${r.paid ? "" : ", pan_last4 = NULL, pan_encrypted = NULL"}
        WHERE user_id = $1`, [r.user_id]);
  }

  const frames = (await db.query<{ id: string; storage_key: string }>(
    `SELECT id, storage_key FROM moderation_flags
      WHERE status <> 'open' AND storage_key IS NOT NULL AND reviewed_at < now() - make_interval(days => $1)`,
    [RETENTION.moderationFrameDays])).rows;
  for (const f of frames) {
    await store.delete(f.storage_key);
    await db.query(`UPDATE moderation_flags SET storage_key = NULL, frame_deleted_at = now() WHERE id = $1`, [f.id]);
  }

  const notifications = (await db.query(
    `DELETE FROM notifications WHERE read_at < now() - make_interval(days => $1)`, [RETENTION.readNotificationDays])).rowCount ?? 0;

  const chatMessages = (await db.query(
    `DELETE FROM messages m USING conversations cv
      WHERE m.conversation_id = cv.id AND cv.last_message_at < now() - make_interval(days => $1)`, [RETENTION.chatDays])).rowCount ?? 0;

  return { sessions, recordings: recs.length, rejectedKyc: rejected.length, frames: frames.length, notifications, chatMessages };
}
