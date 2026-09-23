/**
 * Scheduled calls. Money rule: coins are *held* (debited with a booking_hold
 * ledger row) at booking and always come back in full (booking_release) —
 * when the booking is declined, cancelled or expires, or when the caller starts
 * the booked call, which is then billed per minute like any other call.
 * So a caller can never pay twice, and the hold never becomes revenue.
 */
import { tx, type Db, type DbClient } from "./db/pool.js";
import { post } from "./billing/ledger.js";
import { numberSetting } from "./settings.js";
import { notify, type NotifyDeps } from "./notifications.js";

export const DURATIONS = [10, 20, 30] as const;
const SLOT_MIN = 30;
const LEAD_MIN = 30;          // a slot must be at least this far ahead
const START_EARLY_MIN = 5;    // "Call now" opens this long before start…
const START_LATE_MIN = 15;    // …and stays open this long after
const REMIND_MIN = 10;

export interface BookingSettings { windowDays: number; firstSlotMinute: number; lastSlotMinute: number; confirmHours: number }

export async function bookingSettings(db: Db | DbClient): Promise<BookingSettings> {
  const [windowDays, firstSlotMinute, lastSlotMinute, confirmHours] = await Promise.all([
    numberSetting(db, "booking.window_days", 5),
    numberSetting(db, "booking.first_slot_minute", 19 * 60),
    numberSetting(db, "booking.last_slot_minute", 23 * 60),
    numberSetting(db, "booking.confirm_hours", 12),
  ]);
  return { windowDays, firstSlotMinute, lastSlotMinute, confirmHours };
}

/** IST calendar date (YYYY-MM-DD) of an instant. */
export const istDate = (d: Date) => new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Kolkata" }).format(d);
/** Instant for an IST date + minutes after IST midnight. */
export const istInstant = (date: string, minute: number) => new Date(`${date}T00:00:00+05:30`).getTime() + minute * 60_000;

/** The companion's (and this caller's) bookings that still occupy time. */
async function busyRanges(db: Db | DbClient, companionId: string, callerId: string, from: Date, to: Date) {
  return (await db.query<{ s: Date; e: Date }>(
    `SELECT start_at AS s, start_at + make_interval(mins => minutes) AS e FROM bookings
      WHERE (companion_id = $1 OR caller_id = $2) AND status IN ('requested', 'confirmed', 'started')
        AND start_at < $4 AND start_at + make_interval(mins => minutes) > $3`, [companionId, callerId, from, to])).rows;
}

export async function availableSlots(db: Db, companionId: string, callerId: string, now = new Date()) {
  const s = await bookingSettings(db);
  const today = istDate(now);
  const dates = Array.from({ length: s.windowDays }, (_, i) => istDate(new Date(istInstant(today, 0) + i * 86_400_000 + 12 * 3_600_000)));
  const from = new Date(istInstant(dates[0]!, 0));
  const to = new Date(istInstant(dates.at(-1)!, 24 * 60));
  const busy = await busyRanges(db, companionId, callerId, from, to);
  return dates.map((date) => ({
    date,
    slots: Array.from({ length: Math.floor((s.lastSlotMinute - s.firstSlotMinute) / SLOT_MIN) + 1 }, (_, i) => {
      const start = istInstant(date, s.firstSlotMinute + i * SLOT_MIN);
      const end = start + SLOT_MIN * 60_000;
      const clash = busy.some((b) => b.s.getTime() < end && b.e.getTime() > start);
      return { startAt: new Date(start), available: !clash && start >= now.getTime() + LEAD_MIN * 60_000 };
    }),
  }));
}

export class BookingError extends Error {
  constructor(readonly status: number, readonly code: string, message: string) { super(message); }
}

/** Current per-minute rate for the companion's primary language. */
async function currentRate(c: DbClient, companionId: string, type: "audio" | "video") {
  return (await c.query<{ coins: number; video_enabled: boolean }>(
    `SELECT (SELECT coins_per_min FROM call_rates WHERE language_code = u.primary_language AND call_type = $2
               AND effective_from <= now() ORDER BY effective_from DESC LIMIT 1) AS coins, p.video_enabled
       FROM users u JOIN companion_profiles p ON p.user_id = u.id
      WHERE u.id = $1 AND u.role = 'companion' AND u.status = 'active' AND p.kyc_status = 'approved'`, [companionId, type])).rows[0];
}

export async function createBooking(c: DbClient, input: { callerId: string; companionId: string; startAt: Date; minutes: number; type: "audio" | "video" }) {
  const { callerId, companionId, startAt, minutes, type } = input;
  const fav = (await c.query(`SELECT 1 FROM favourites WHERE user_id = $1 AND companion_id = $2`, [callerId, companionId])).rowCount;
  if (!fav) throw new BookingError(403, "BOOKING_NEEDS_FAVOURITE", "You can book calls with your favourites");
  const blocked = (await c.query(
    `SELECT 1 FROM blocks WHERE (blocker_id = $1 AND blocked_id = $2) OR (blocker_id = $2 AND blocked_id = $1)`, [callerId, companionId])).rowCount;
  if (blocked) throw new BookingError(403, "BOOKING_BLOCKED", "You can't book this companion");
  const rate = await currentRate(c, companionId, type);
  if (!rate?.coins) throw new BookingError(404, "COMPANION_NOT_FOUND", "This companion isn't available");
  if (type === "video" && !rate.video_enabled) throw new BookingError(400, "VIDEO_NOT_ENABLED", "This companion doesn't take video calls yet");

  // The slot must be one we offer, and still free (serialised per companion).
  await c.query(`SELECT pg_advisory_xact_lock(hashtext('booking:' || $1))`, [companionId]);
  const s = await bookingSettings(c);
  const date = istDate(startAt);
  const minuteOfDay = Math.round((startAt.getTime() - istInstant(date, 0)) / 60_000);
  const inWindow = startAt.getTime() >= Date.now() + LEAD_MIN * 60_000
    && startAt.getTime() <= istInstant(istDate(new Date()), 0) + s.windowDays * 86_400_000;
  if (!inWindow || minuteOfDay < s.firstSlotMinute || minuteOfDay > s.lastSlotMinute || (minuteOfDay - s.firstSlotMinute) % SLOT_MIN) {
    throw new BookingError(400, "SLOT_NOT_OFFERED", "Pick one of the times shown");
  }
  const end = new Date(startAt.getTime() + minutes * 60_000);
  if ((await busyRanges(c, companionId, callerId, startAt, end)).length) {
    throw new BookingError(409, "SLOT_TAKEN", "That time was just taken. Pick another.");
  }

  const held = rate.coins * minutes;
  const id = (await c.query<{ id: string }>(
    `INSERT INTO bookings (caller_id, companion_id, call_type, start_at, minutes, coins_per_min, held_coins)
     VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`, [callerId, companionId, type, startAt, minutes, rate.coins, held])).rows[0]!.id;
  const balance = await post(c, callerId, "coins", "booking_hold", -held, `booking:${id}:hold`, { note: "Held for a booked call" });
  if (balance === null) throw new BookingError(402, "INSUFFICIENT_COINS", `You need ${held} coins to book this call`);
  return { id, held, balance };
}

/** Gives the held coins back once. Returns true if coins moved. */
async function releaseHold(c: DbClient, b: { id: string; caller_id: string; held_coins: number; hold_released: boolean }, note: string) {
  if (b.hold_released) return false;
  await post(c, b.caller_id, "coins", "booking_release", b.held_coins, `booking:${b.id}:release`, { note });
  await c.query(`UPDATE bookings SET hold_released = true WHERE id = $1`, [b.id]);
  return true;
}

export interface BookingRow {
  id: string; caller_id: string; companion_id: string; call_type: "audio" | "video"; start_at: Date; minutes: number;
  coins_per_min: number; held_coins: number; status: string; hold_released: boolean;
}

export async function lockBooking(c: DbClient, id: string): Promise<BookingRow | undefined> {
  return (await c.query<BookingRow>(`SELECT * FROM bookings WHERE id = $1 FOR UPDATE`, [id])).rows[0];
}

export async function decide(c: DbClient, b: BookingRow, action: "confirm" | "decline" | "cancel" | "start", note?: string) {
  const now = Date.now();
  const start = b.start_at.getTime();
  switch (action) {
    case "confirm":
      if (b.status !== "requested") throw new BookingError(409, "BOOKING_NOT_PENDING", "This booking was already answered");
      if (start < now) throw new BookingError(409, "BOOKING_PAST", "This time has passed");
      await c.query(`UPDATE bookings SET status = 'confirmed', decided_at = now() WHERE id = $1`, [b.id]);
      return;
    case "decline":
      if (b.status !== "requested") throw new BookingError(409, "BOOKING_NOT_PENDING", "This booking was already answered");
      await c.query(`UPDATE bookings SET status = 'declined', decided_at = now(), note = $2 WHERE id = $1`, [b.id, note ?? null]);
      await releaseHold(c, b, "Booking declined — coins returned");
      return;
    case "cancel":
      if (b.status !== "requested" && b.status !== "confirmed") throw new BookingError(409, "BOOKING_NOT_ACTIVE", "This booking can't be cancelled now");
      await c.query(`UPDATE bookings SET status = 'cancelled', decided_at = now() WHERE id = $1`, [b.id]);
      await releaseHold(c, b, "Booking cancelled — coins returned");
      return;
    case "start":
      if (b.status !== "confirmed" && b.status !== "started") throw new BookingError(409, "BOOKING_NOT_CONFIRMED", "The companion hasn't confirmed yet");
      if (now < start - START_EARLY_MIN * 60_000 || now > start + START_LATE_MIN * 60_000) {
        throw new BookingError(409, "BOOKING_NOT_NOW", `You can start this call from ${START_EARLY_MIN} minutes before the booked time`);
      }
      await c.query(`UPDATE bookings SET status = 'started' WHERE id = $1`, [b.id]);
      await releaseHold(c, b, "Booked call started — billed per minute");
      return;
  }
}

const when = (d: Date) => new Intl.DateTimeFormat("en-IN", {
  weekday: "short", day: "numeric", month: "short", hour: "numeric", minute: "2-digit", timeZone: "Asia/Kolkata",
}).format(d);
export { when as bookingWhen };

/**
 * Worker job (every minute): expire unanswered requests (refund), remind both
 * 10 minutes before, and close bookings after the window (completed if they
 * talked, otherwise missed + refund).
 */
export async function sweepBookings(deps: NotifyDeps & { db: Db }): Promise<{ expired: number; reminded: number; closed: number }> {
  const { db } = deps;
  const s = await bookingSettings(db);
  const names = async (ids: string[]) => new Map((await db.query<{ id: string; display_name: string }>(
    `SELECT id, display_name FROM users WHERE id = ANY($1::uuid[])`, [ids])).rows.map((r) => [r.id, r.display_name]));

  // 1. Unanswered: too old, or the time has come.
  const stale = (await db.query<BookingRow>(
    `SELECT * FROM bookings WHERE status = 'requested'
        AND (created_at < now() - make_interval(hours => $1) OR start_at <= now())`, [s.confirmHours])).rows;
  for (const b of stale) {
    const moved = await tx(db, async (c) => {
      const locked = await lockBooking(c, b.id);
      if (!locked || locked.status !== "requested") return false;
      await c.query(`UPDATE bookings SET status = 'expired', decided_at = now() WHERE id = $1`, [b.id]);
      await releaseHold(c, locked, "Booking not confirmed in time — coins returned");
      return true;
    });
    if (moved) {
      const n = await names([b.companion_id]);
      await notify(deps, b.caller_id, { type: "booking_cancelled", title: `${n.get(b.companion_id)} couldn't confirm your call`,
        body: `${b.held_coins} coins are back in your wallet`, data: { bookingId: b.id } });
    }
  }

  // 2. Reminders.
  const soon = (await db.query<BookingRow>(
    `UPDATE bookings SET reminder_sent_at = now()
      WHERE status = 'confirmed' AND reminder_sent_at IS NULL AND start_at <= now() + make_interval(mins => $1) AND start_at > now()
      RETURNING *`, [REMIND_MIN])).rows;
  for (const b of soon) {
    const n = await names([b.caller_id, b.companion_id]);
    await notify(deps, b.caller_id, { type: "booking_reminder", title: `Your call with ${n.get(b.companion_id)} starts soon`,
      body: `${when(b.start_at)} · tap to call`, data: { bookingId: b.id } });
    await notify(deps, b.companion_id, { type: "booking_reminder", title: `${n.get(b.caller_id)} will call you soon`,
      body: `${when(b.start_at)} · stay online`, data: { bookingId: b.id } });
  }

  // 3. Close after the window: did they talk?
  const over = (await db.query<BookingRow & { talked: boolean }>(
    `SELECT b.*, EXISTS (SELECT 1 FROM calls c WHERE c.caller_id = b.caller_id AND c.companion_id = b.companion_id
                           AND c.started_at IS NOT NULL
                           AND c.created_at BETWEEN b.start_at - interval '10 minutes' AND b.start_at + make_interval(mins => $1)) AS talked
       FROM bookings b WHERE b.status IN ('confirmed', 'started') AND b.start_at < now() - make_interval(mins => $1)`,
    [START_LATE_MIN])).rows;
  for (const b of over) {
    const refunded = await tx(db, async (c) => {
      const locked = await lockBooking(c, b.id);
      if (!locked || (locked.status !== "confirmed" && locked.status !== "started")) return false;
      await c.query(`UPDATE bookings SET status = $2 WHERE id = $1`, [b.id, b.talked ? "completed" : "missed"]);
      return releaseHold(c, locked, "Booked call didn't happen — coins returned");
    });
    if (!b.talked && refunded) {
      const n = await names([b.companion_id]);
      await notify(deps, b.caller_id, { type: "booking_cancelled", title: `Your call with ${n.get(b.companion_id)} didn't happen`,
        body: `${b.held_coins} coins are back in your wallet`, data: { bookingId: b.id } });
    }
  }
  return { expired: stale.length, reminded: soon.length, closed: over.length };
}
