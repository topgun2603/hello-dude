/**
 * Time-based notifications, run by the worker every few minutes. Each one is
 * sent at most once (checked against the notifications table).
 */
import type { Db } from "./db/pool.js";
import { notify, type NotifyDeps } from "./notifications.js";
import { checkinState, IST_TODAY_SQL } from "./growth.js";

/** "How was your call?" 10 minutes after a paid call the caller hasn't rated (within 2 hours). */
export async function sendRateReminders(deps: NotifyDeps & { db: Db }): Promise<number> {
  const due = (await deps.db.query<{ id: string; caller_id: string; other_name: string }>(
    `SELECT c.id, c.caller_id, u.display_name AS other_name
       FROM calls c JOIN users u ON u.id = c.companion_id
      WHERE c.status = 'ended' AND c.minutes_charged >= 1
        AND c.ended_at BETWEEN now() - interval '2 hours' AND now() - interval '10 minutes'
        AND NOT EXISTS (SELECT 1 FROM call_ratings r WHERE r.call_id = c.id)
        AND NOT EXISTS (SELECT 1 FROM notifications n
                         WHERE n.user_id = c.caller_id AND n.type = 'rate_call' AND n.data->>'callId' = c.id::text)
      LIMIT 500`)).rows;
  for (const c of due) {
    await notify(deps, c.caller_id, {
      type: "rate_call", title: `How was your call with ${c.other_name}?`, body: "Rate it to help us match you better",
      data: { callId: c.id },
    }, { push: false }); // an inbox nudge, not worth a buzz
  }
  return due.length;
}

/**
 * "Your daily bonus is ready": once per IST day from 10 AM, to callers who used
 * the app in the last 14 days and haven't claimed yet.
 */
export async function sendDailyBonusReminders(deps: NotifyDeps & { db: Db }, now = new Date()): Promise<number> {
  const istHour = Number(new Intl.DateTimeFormat("en-GB", { hour: "numeric", hour12: false, timeZone: "Asia/Kolkata" }).format(now));
  if (istHour < 10) return 0;
  const due = (await deps.db.query<{ id: string }>(
    `SELECT u.id FROM users u
      WHERE u.role = 'caller' AND u.status = 'active'
        AND EXISTS (SELECT 1 FROM sessions s WHERE s.user_id = u.id AND s.created_at > now() - interval '14 days')
        AND NOT EXISTS (SELECT 1 FROM checkins c WHERE c.user_id = u.id AND c.day = ${IST_TODAY_SQL})
        AND NOT EXISTS (SELECT 1 FROM notifications n WHERE n.user_id = u.id AND n.type = 'daily_bonus'
                           AND (n.created_at AT TIME ZONE 'Asia/Kolkata')::date = ${IST_TODAY_SQL})
      LIMIT 2000`)).rows;
  for (const u of due) {
    const s = await checkinState(deps.db, u.id);
    await notify(deps, u.id, {
      type: "daily_bonus", title: "Your daily bonus is ready",
      body: `Claim ${s.rewards[s.day - 1] ?? 0} coins, Day ${s.day}`,
    });
  }
  return due.length;
}
