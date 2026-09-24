import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { balance, createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { sweepBookings } from "../bookings.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); });

type Slots = { durations: number[]; days: { date: string; slots: { startAt: string; available: boolean }[] }[] };
type Booking = { id: string; status: string; heldCoins: number; canStart: boolean; startAt: string };

async function setup(coins = 500) {
  await setRate(h, "ta", "audio", 10, 300);
  const caller = await createCaller(h, coins);
  const companion = await createCompanion(h);
  await h.db.query(`INSERT INTO favourites (user_id, companion_id) VALUES ($1, $2)`, [caller, companion]);
  return { caller, companion, callerToken: await tokenFor(h, caller, "caller"), companionToken: await tokenFor(h, companion, "companion") };
}

const firstFree = (s: Slots, skip = 0) => s.days.flatMap((d) => d.slots).filter((x) => x.available)[skip]!.startAt;
const noteTitles = async (userId: string) =>
  (await h.db.query<{ title: string }>(`SELECT title FROM notifications WHERE user_id = $1 ORDER BY id`, [userId])).rows.map((r) => r.title);
const deps = () => ({ db: h.db, push: h.push, events: h.events });

describe("scheduled calls", () => {
  it("offers 5 days of 30-min slots 7–11 PM IST, favourites only", async () => {
    const { companion, callerToken } = await setup();
    const s = json<Slots>(await call(h, "GET", `/v1/companions/${companion}/slots`, { token: callerToken }));
    expect(s.durations).toEqual([10, 20, 30]);
    expect(s.days).toHaveLength(5);
    expect(s.days[1]!.slots).toHaveLength(9);
    const t = new Date(s.days[1]!.slots[0]!.startAt);
    expect(new Intl.DateTimeFormat("en-GB", { hour: "2-digit", minute: "2-digit", timeZone: "Asia/Kolkata" }).format(t)).toBe("19:00");
    expect(s.days[1]!.slots.every((x) => x.available)).toBe(true);

    const stranger = await createCompanion(h);
    expect(errorCode(await call(h, "POST", "/v1/bookings", { token: callerToken, body: { companionId: stranger, startAt: firstFree(s), minutes: 20 } })))
      .toBe("BOOKING_NEEDS_FAVOURITE");
  });

  it("holds coins at booking; confirm, then cancel gives every coin back", async () => {
    const { caller, companion, callerToken, companionToken } = await setup();
    const s = json<Slots>(await call(h, "GET", `/v1/companions/${companion}/slots`, { token: callerToken }));
    const r = json<{ booking: Booking; coins: number }>(await call(h, "POST", "/v1/bookings", {
      token: callerToken, body: { companionId: companion, startAt: firstFree(s), minutes: 20 } }));
    expect(r.booking).toMatchObject({ status: "requested", heldCoins: 200 });
    expect(r.coins).toBe(300);
    expect(await noteTitles(companion)).toEqual(["Test caller wants to call you"]);

    // The slot is now taken for others too.
    const s2 = json<Slots>(await call(h, "GET", `/v1/companions/${companion}/slots`, { token: callerToken }));
    expect(s2.days.flatMap((d) => d.slots).find((x) => x.startAt === r.booking.startAt)!.available).toBe(false);
    const rival = await createCaller(h, 500);
    await h.db.query(`INSERT INTO favourites (user_id, companion_id) VALUES ($1, $2)`, [rival, companion]);
    expect(errorCode(await call(h, "POST", "/v1/bookings", { token: await tokenFor(h, rival, "caller"),
      body: { companionId: companion, startAt: r.booking.startAt, minutes: 10 } }))).toBe("SLOT_TAKEN");

    expect(json<Booking>(await call(h, "POST", `/v1/bookings/${r.booking.id}/confirm`, { token: companionToken })).status).toBe("confirmed");
    expect(await noteTitles(caller)).toEqual(["Test companion confirmed your call"]);
    expect(errorCode(await call(h, "POST", `/v1/bookings/${r.booking.id}/confirm`, { token: callerToken }))).toBe("WRONG_ROLE");

    expect(json<Booking>(await call(h, "POST", `/v1/bookings/${r.booking.id}/cancel`, { token: callerToken })).status).toBe("cancelled");
    expect(await balance(h, caller, "coins")).toBe(500);
    expect(errorCode(await call(h, "POST", `/v1/bookings/${r.booking.id}/cancel`, { token: callerToken }))).toBe("BOOKING_NOT_ACTIVE");
    expect(await balance(h, caller, "coins")).toBe(500); // no double refund
  });

  it("decline and expiry refund; not enough coins books nothing", async () => {
    const { caller, companion, callerToken, companionToken } = await setup(250);
    const s = json<Slots>(await call(h, "GET", `/v1/companions/${companion}/slots`, { token: callerToken }));
    const a = json<{ booking: Booking }>(await call(h, "POST", "/v1/bookings", { token: callerToken, body: { companionId: companion, startAt: firstFree(s), minutes: 20 } }));
    const poor = await call(h, "POST", "/v1/bookings", { token: callerToken, body: { companionId: companion, startAt: firstFree(s, 3), minutes: 10 } });
    expect(errorCode(poor)).toBe("INSUFFICIENT_COINS");
    expect((await h.db.query(`SELECT count(*)::int AS n FROM bookings`)).rows[0]).toEqual({ n: 1 });

    await call(h, "POST", `/v1/bookings/${a.booking.id}/decline`, { token: companionToken, body: { note: "Busy that night" } });
    expect(await balance(h, caller, "coins")).toBe(250);

    const b = json<{ booking: Booking }>(await call(h, "POST", "/v1/bookings", { token: callerToken, body: { companionId: companion, startAt: firstFree(s, 1), minutes: 10 } }));
    await h.db.query(`UPDATE bookings SET created_at = now() - interval '13 hours' WHERE id = $1`, [b.booking.id]);
    expect(await sweepBookings(deps())).toMatchObject({ expired: 1 });
    expect(await balance(h, caller, "coins")).toBe(250);
    expect((await noteTitles(caller)).at(-1)).toBe("Test companion couldn't confirm your call");
  });

  it("\"Call now\" opens near the time, returns the hold, and the booking closes as missed or completed", async () => {
    const { caller, companion, callerToken, companionToken } = await setup();
    const s = json<Slots>(await call(h, "GET", `/v1/companions/${companion}/slots`, { token: callerToken }));
    const r = json<{ booking: Booking }>(await call(h, "POST", "/v1/bookings", { token: callerToken, body: { companionId: companion, startAt: firstFree(s), minutes: 10 } }));
    await call(h, "POST", `/v1/bookings/${r.booking.id}/confirm`, { token: companionToken });
    expect(errorCode(await call(h, "POST", `/v1/bookings/${r.booking.id}/start`, { token: callerToken }))).toBe("BOOKING_NOT_NOW");

    // It's time: reminder, then start.
    await h.db.query(`UPDATE bookings SET start_at = now() + interval '4 minutes' WHERE id = $1`, [r.booking.id]);
    expect(await sweepBookings(deps())).toMatchObject({ reminded: 1 });
    expect(await sweepBookings(deps())).toMatchObject({ reminded: 0 });
    const started = json<Booking>(await call(h, "POST", `/v1/bookings/${r.booking.id}/start`, { token: callerToken }));
    expect(started.status).toBe("started");
    expect(await balance(h, caller, "coins")).toBe(500); // hold back; the call itself bills per minute

    // Nobody called within the window → missed, and no second refund.
    await h.db.query(`UPDATE bookings SET start_at = now() - interval '20 minutes' WHERE id = $1`, [r.booking.id]);
    expect(await sweepBookings(deps())).toMatchObject({ closed: 1 });
    expect((await h.db.query(`SELECT status FROM bookings WHERE id = $1`, [r.booking.id])).rows[0]).toEqual({ status: "missed" });
    expect(await balance(h, caller, "coins")).toBe(500);

    // Every hold has exactly one release: coins in == coins out.
    const net = (await h.db.query<{ n: number }>(
      `SELECT COALESCE(sum(amount), 0)::int AS n FROM ledger_entries WHERE type IN ('booking_hold', 'booking_release')`)).rows[0]!.n;
    expect(net).toBe(0);
  });

  it("a confirmed booking the companion never answers is refunded after the window", async () => {
    const { caller, companion, callerToken, companionToken } = await setup();
    const s = json<Slots>(await call(h, "GET", `/v1/companions/${companion}/slots`, { token: callerToken }));
    const r = json<{ booking: Booking }>(await call(h, "POST", "/v1/bookings", { token: callerToken, body: { companionId: companion, startAt: firstFree(s), minutes: 30 } }));
    await call(h, "POST", `/v1/bookings/${r.booking.id}/confirm`, { token: companionToken });
    await h.db.query(`UPDATE bookings SET start_at = now() - interval '20 minutes' WHERE id = $1`, [r.booking.id]);
    expect(await balance(h, caller, "coins")).toBe(200);
    await sweepBookings(deps());
    expect(await balance(h, caller, "coins")).toBe(500);
    expect((await noteTitles(caller)).at(-1)).toBe("Your call with Test companion didn't happen");
    const list = json<{ upcoming: Booking[]; past: Booking[] }>(await call(h, "GET", "/v1/bookings", { token: companionToken }));
    expect(list.upcoming).toEqual([]);
    expect(list.past.map((b) => b.status)).toEqual(["missed"]);
  });
});
