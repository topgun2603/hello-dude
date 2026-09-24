/** Scheduled calls: slots, book (coins held), confirm/decline, cancel, start (design: Schedule.dc.html). */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, forbidden, notFound } from "../errors.js";
import {
  availableSlots, BookingError, bookingWhen, createBooking, decide, DURATIONS, lockBooking, type BookingRow,
} from "../bookings.js";
import { notify } from "../notifications.js";

const Party = z.object({ id: z.uuid(), displayName: z.string(), avatarId: z.number().int() });

const Booking = z.object({
  id: z.uuid(),
  status: z.enum(["requested", "confirmed", "declined", "expired", "cancelled", "started", "completed", "missed"]),
  startAt: z.date(),
  minutes: z.number().int(),
  callType: z.enum(["audio", "video"]),
  coinsPerMin: z.number().int(),
  heldCoins: z.number().int(),
  caller: Party,
  companion: Party,
  canStart: z.boolean().describe("Caller: the \"Call now\" window is open"),
}).meta({ id: "Booking" });

const rethrow = (e: unknown): never => {
  if (e instanceof BookingError) throw new ApiError(e.status, e.code, e.message);
  throw e;
};

export const bookingRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const base = { tags: ["bookings"], security: bearer };

  const load = async (ids: string[]) => {
    if (!ids.length) return [];
    const rows = (await db.query<BookingRow & { caller_name: string; caller_avatar: number; companion_name: string; companion_avatar: number }>(
      `SELECT b.*, cu.display_name AS caller_name, cu.avatar_id AS caller_avatar, co.display_name AS companion_name, co.avatar_id AS companion_avatar
         FROM bookings b JOIN users cu ON cu.id = b.caller_id JOIN users co ON co.id = b.companion_id
        WHERE b.id = ANY($1::uuid[]) ORDER BY b.start_at`, [ids])).rows;
    const now = Date.now();
    return rows.map((b) => ({
      id: b.id, status: b.status as z.infer<typeof Booking>["status"], startAt: b.start_at, minutes: b.minutes, callType: b.call_type,
      coinsPerMin: b.coins_per_min, heldCoins: b.held_coins,
      caller: { id: b.caller_id, displayName: b.caller_name, avatarId: b.caller_avatar },
      companion: { id: b.companion_id, displayName: b.companion_name, avatarId: b.companion_avatar },
      canStart: (b.status === "confirmed" || b.status === "started")
        && now >= b.start_at.getTime() - 5 * 60_000 && now <= b.start_at.getTime() + 15 * 60_000,
    }));
  };

  app.get("/companions/:id/slots", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Bookable times for the next few days (IST), and the durations offered",
      params: z.object({ id: z.uuid() }),
      response: {
        200: z.object({
          durations: z.array(z.number().int()),
          days: z.array(z.object({ date: z.string(), slots: z.array(z.object({ startAt: z.date(), available: z.boolean() })) })),
        }),
      },
    },
  }, async (req) => ({ durations: [...DURATIONS], days: await availableSlots(db, req.params.id, me(req).userId) }));

  app.post("/bookings", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Book a call with a favourite. Coins for the full duration are held now and returned if it doesn't happen.",
      body: z.object({
        companionId: z.uuid(), startAt: z.coerce.date(),
        minutes: z.number().int().refine((m) => (DURATIONS as readonly number[]).includes(m), "10, 20 or 30").describe("10, 20 or 30"),
        // Optional (not .default): the Dart generator emits invalid code for enum defaults.
        callType: z.enum(["audio", "video"]).nullish().describe("Default audio"),
      }),
      response: { 201: z.object({ booking: Booking, coins: z.number().int().describe("Wallet balance after the hold") }) },
    },
  }, async (req, reply) => {
    const callerId = me(req).userId;
    const r = await tx(db, (c) => createBooking(c, { callerId, companionId: req.body.companionId, startAt: req.body.startAt,
      minutes: req.body.minutes, type: req.body.callType ?? "audio" })).catch(rethrow);
    const [booking] = await load([r.id]);
    await notify(app.deps, req.body.companionId, {
      type: "booking_requested", title: `${booking!.caller.displayName} wants to call you`,
      body: `${bookingWhen(req.body.startAt)} · ${req.body.minutes} min · tap to confirm`, data: { bookingId: r.id },
    });
    reply.status(201);
    return { booking: booking!, coins: r.balance };
  });

  app.get("/bookings", {
    preHandler: requireAuth("caller", "companion"),
    schema: {
      ...base,
      summary: "My bookings: upcoming (and in progress) first, then the last 30 days",
      response: { 200: z.object({ upcoming: z.array(Booking), past: z.array(Booking) }) },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const rows = (await db.query<{ id: string; live: boolean }>(
      `SELECT id, status IN ('requested', 'confirmed', 'started') AS live FROM bookings
        WHERE (caller_id = $1 OR companion_id = $1) AND start_at > now() - interval '30 days'
        ORDER BY start_at DESC LIMIT 200`, [userId])).rows;
    const all = await load(rows.map((r) => r.id));
    const live = new Set(rows.filter((r) => r.live).map((r) => r.id));
    return { upcoming: all.filter((b) => live.has(b.id)), past: all.filter((b) => !live.has(b.id)).reverse() };
  });

  for (const action of ["confirm", "decline", "cancel", "start"] as const) {
    app.post(`/bookings/:id/${action}`, {
      preHandler: requireAuth(action === "confirm" || action === "decline" ? "companion" : "caller"),
      schema: {
        ...base,
        summary: {
          confirm: "Companion accepts the booked time",
          decline: "Companion declines; the caller's coins come back",
          cancel: "Caller cancels; the held coins come back in full",
          start: "Caller starts the booked call (from 5 min before to 15 min after). The hold comes back and the call is billed per minute.",
        }[action],
        params: z.object({ id: z.uuid() }),
        body: z.object({ note: z.string().trim().max(200).nullish() }).nullish(),
        response: { 200: Booking },
      },
    }, async (req) => {
      const userId = me(req).userId;
      const b = await tx(db, async (c) => {
        const b = await lockBooking(c, req.params.id);
        if (!b) throw notFound("BOOKING_NOT_FOUND");
        const mine = action === "confirm" || action === "decline" ? b.companion_id === userId : b.caller_id === userId;
        if (!mine) throw forbidden("NOT_YOUR_BOOKING");
        await decide(c, b, action, req.body?.note ?? undefined);
        return b;
      }).catch(rethrow);
      const [booking] = await load([b.id]);
      const at = bookingWhen(b.start_at);
      if (action === "confirm") {
        await notify(app.deps, b.caller_id, { type: "booking_confirmed", title: `${booking!.companion.displayName} confirmed your call`,
          body: `${at} · ${b.minutes} min`, data: { bookingId: b.id } });
      } else if (action === "decline") {
        await notify(app.deps, b.caller_id, { type: "booking_cancelled", title: `${booking!.companion.displayName} can't make it`,
          body: `${at} · ${b.held_coins} coins are back in your wallet`, data: { bookingId: b.id } });
      } else if (action === "cancel") {
        await notify(app.deps, b.companion_id, { type: "booking_cancelled", title: `${booking!.caller.displayName} cancelled`,
          body: `The call booked for ${at} is off`, data: { bookingId: b.id } });
      }
      return booking!;
    });
  }
};
