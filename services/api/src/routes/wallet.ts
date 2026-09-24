import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, optionalAuth, requireAuth } from "../auth/guard.js";
import { numberSetting } from "../settings.js";

const LedgerEntry = z.object({
  id: z.number().int(),
  type: z.string(),
  amount: z.number().int().describe("Signed: negative = debit"),
  balanceAfter: z.number().int(),
  callId: z.uuid().nullable(),
  note: z.string().nullable(),
  createdAt: z.date(),
}).meta({ id: "LedgerEntry" });

/** One line in the coin history: a whole call is one line, everything else is one ledger row. */
const HistoryItem = z.object({
  key: z.string().describe("Stable id for the line"),
  kind: z.enum(["call", "gift", "purchase", "bonus", "refund", "booking", "adjustment", "live", "group"]),
  title: z.string(),
  subtitle: z.string().nullable(),
  amount: z.number().int().describe("Signed coins: negative = spent"),
  at: z.date(),
  callId: z.uuid().nullable(),
  callType: z.enum(["audio", "video"]).nullable(),
  otherName: z.string().nullable(),
  otherAvatarId: z.number().int().nullable(),
}).meta({ id: "CoinHistoryItem" });

const HistorySummary = z.object({
  spent: z.number().int(),
  added: z.number().int(),
  calls: z.number().int().describe("Coins spent on calls"),
  gifts: z.number().int(),
  lives: z.number().int().describe("Coins on lives"),
  groups: z.number().int().describe("Coins on group video"),
  bookings: z.number().int().describe("Coins held for booked calls, net of releases"),
  purchases: z.number().int(),
  bonuses: z.number().int().describe("Daily, invite and support bonuses"),
  refunds: z.number().int(),
}).meta({ id: "CoinHistorySummary" });

const KIND_SQL = `CASE
    WHEN g.type = 'call_debit' THEN 'call'
    WHEN g.type = 'gift_debit' THEN 'gift'
    WHEN g.type = 'purchase' THEN 'purchase'
    WHEN g.type = 'refund' THEN 'refund'
    WHEN g.type IN ('booking_hold', 'booking_release') THEN 'booking'
    WHEN g.type = 'adjustment' THEN 'adjustment'
    WHEN g.type IN ('live_pass_debit', 'live_debit') THEN 'live'
    WHEN g.type = 'group_debit' THEN 'group'
    ELSE 'bonus' END`;

export const walletRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;

  app.get("/wallet", {
    preHandler: requireAuth(),
    schema: {
      tags: ["wallet"],
      security: bearer,
      response: { 200: z.object({ coins: z.number().int(), earningsPaise: z.number().int() }) },
    },
  }, async (req) => {
    const rows = (await db.query<{ kind: "coins" | "earnings"; balance: number }>(
      `SELECT kind, balance FROM wallets WHERE user_id = $1`, [me(req).userId],
    )).rows;
    const of = (k: string) => rows.find((r) => r.kind === k)?.balance ?? 0;
    return { coins: of("coins"), earningsPaise: of("earnings") };
  });

  app.get("/coin-packages", {
    preHandler: optionalAuth(),
    schema: {
      tags: ["wallet"],
      summary: "Coin packs for sale (Google Play SKUs). Signed-in new users also get the first-recharge offer.",
      response: {
        200: z.array(z.object({
          sku: z.string(), coins: z.number().int(), bonusCoins: z.number().int(),
          pricePaise: z.number().int(), label: z.string().nullable(),
          firstRecharge: z.boolean(), offerEndsAt: z.date().nullable(),
        })),
      },
    },
  }, async (req) => {
    // Welcome offer: only for accounts with no purchase yet, within N hours of sign-up.
    const hours = await numberSetting(db, "offer.first_recharge_hours", 24);
    const eligible = req.auth ? (await db.query<{ ends: Date }>(
      `SELECT u.created_at + $2 * interval '1 hour' AS ends FROM users u
        WHERE u.id = $1 AND u.created_at + $2 * interval '1 hour' > now()
          AND NOT EXISTS (SELECT 1 FROM purchases p WHERE p.user_id = u.id AND p.status = 'credited')`,
      [req.auth.userId, hours])).rows[0] : undefined;
    const rows = (await db.query<{ play_sku: string; coins: number; bonus_coins: number; price_paise: number; label: string | null; first_recharge_only: boolean }>(
      `SELECT play_sku, coins, bonus_coins, price_paise, label, first_recharge_only FROM coin_packages
        WHERE is_active AND (NOT first_recharge_only OR $1) ORDER BY first_recharge_only DESC, sort_order, coins`,
      [!!eligible])).rows;
    return rows.map((p) => ({
      sku: p.play_sku, coins: p.coins, bonusCoins: p.bonus_coins, pricePaise: p.price_paise, label: p.label,
      firstRecharge: p.first_recharge_only, offerEndsAt: p.first_recharge_only ? eligible!.ends : null,
    }));
  });

  app.get("/wallet/history", {
    preHandler: requireAuth(),
    schema: {
      tags: ["wallet"],
      security: bearer,
      summary: "Coin history for people: one line per call (all its minutes), gifts, top-ups, bonuses, refunds; with totals for the same filters",
      querystring: z.object({
        filter: z.enum(["all", "spent", "added"]).optional().describe("Leave out for all"),
        from: z.coerce.date().optional(),
        to: z.coerce.date().optional(),
        cursor: z.string().max(80).optional().describe("nextCursor from the previous page"),
        limit: z.coerce.number().int().min(1).max(50).default(20),
      }),
      response: { 200: z.object({ items: z.array(HistoryItem), nextCursor: z.string().nullable(), summary: HistorySummary }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    const { filter, from, to, cursor, limit } = req.query;
    // Newest first by ledger id (exact, unlike rounded timestamps); a call sorts by its last minute.
    const after = cursor && /^\d+$/.test(cursor) ? cursor : null;
    // $1 user, $2 from, $3 to — the page and the totals use the same range.
    const entries = `
      SELECT l.id, l.type::text AS type, l.amount, l.call_id, l.live_id, l.group_id, l.note, l.created_at
        FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
       WHERE w.user_id = $1 AND w.kind = 'coins'
         AND ($2::timestamptz IS NULL OR l.created_at >= $2) AND ($3::timestamptz IS NULL OR l.created_at < $3)`;
    const [page, totals] = await Promise.all([
      db.query<{
        key: string; type: string; amount: string; minutes: number; at: Date; max_id: string; call_id: string | null; note: string | null;
        kind: z.infer<typeof HistoryItem>["kind"]; call_type: "audio" | "video" | null; other_name: string | null; other_avatar: number | null;
      }>(
        `WITH e AS (${entries}),
         g AS (
           SELECT CASE WHEN type = 'call_debit' THEN 'call:' || call_id::text
                       WHEN type = 'live_debit' THEN 'live:' || live_id::text
                       WHEN type = 'group_debit' THEN 'group:' || group_id::text ELSE 'l:' || id::text END AS key,
                  min(type) AS type, sum(amount)::bigint AS amount, count(*)::int AS minutes,
                  max(created_at) AS at, max(id) AS max_id, (array_agg(call_id))[1] AS call_id,
                  (array_agg(live_id))[1] AS live_id, (array_agg(group_id))[1] AS group_id, min(note) AS note
             FROM e GROUP BY 1
         )
         SELECT g.*, ${KIND_SQL} AS kind, c.type::text AS call_type,
                COALESCE(o.display_name, lh.display_name, gh.display_name) AS other_name,
                COALESCE(o.avatar_id, lh.avatar_id, gh.avatar_id) AS other_avatar
           FROM g LEFT JOIN calls c ON c.id = g.call_id
           LEFT JOIN users o ON o.id = CASE WHEN c.caller_id = $1 THEN c.companion_id ELSE c.caller_id END
           LEFT JOIN lives lv ON lv.id = g.live_id
           LEFT JOIN users lh ON lh.id = lv.host_id
           LEFT JOIN group_sessions gs ON gs.id = g.group_id
           LEFT JOIN users gh ON gh.id = gs.host_id
          WHERE g.amount <> 0
            AND ($4::text IS NULL OR $4 = 'all' OR ($4 = 'spent' AND g.amount < 0) OR ($4 = 'added' AND g.amount > 0))
            AND ($5::bigint IS NULL OR g.max_id < $5)
          ORDER BY g.max_id DESC LIMIT $6`,
        [userId, from ?? null, to ?? null, filter ?? null, after, limit]),
      db.query<Record<keyof z.infer<typeof HistorySummary>, string>>(
        `WITH e AS (${entries})
         SELECT COALESCE(-sum(amount) FILTER (WHERE amount < 0 AND type <> 'booking_hold'), 0)
                  + COALESCE(-sum(amount) FILTER (WHERE type IN ('booking_hold', 'booking_release')), 0) AS spent,
                COALESCE(sum(amount) FILTER (WHERE amount > 0 AND type <> 'booking_release'), 0) AS added,
                COALESCE(-sum(amount) FILTER (WHERE type = 'call_debit'), 0) AS calls,
                COALESCE(-sum(amount) FILTER (WHERE type = 'gift_debit'), 0) AS gifts,
                COALESCE(-sum(amount) FILTER (WHERE type IN ('live_pass_debit', 'live_debit')), 0) AS lives,
                COALESCE(-sum(amount) FILTER (WHERE type = 'group_debit'), 0) AS groups,
                COALESCE(-sum(amount) FILTER (WHERE type IN ('booking_hold', 'booking_release')), 0) AS bookings,
                COALESCE(sum(amount) FILTER (WHERE type = 'purchase'), 0) AS purchases,
                COALESCE(sum(amount) FILTER (WHERE type IN ('bonus', 'daily_bonus', 'referral_bonus', 'adjustment') AND amount > 0), 0) AS bonuses,
                COALESCE(sum(amount) FILTER (WHERE type = 'refund'), 0) AS refunds
           FROM e`, [userId, from ?? null, to ?? null]),
    ]);

    const who = (name: string | null) => name ?? "someone";
    const items = page.rows.map((r) => {
      const amount = Number(r.amount);
      const callWord = r.call_type === "video" ? "Video call" : "Voice call";
      const [title, subtitle] = ((): [string, string | null] => {
        switch (r.kind) {
          case "call": return [`${callWord} with ${who(r.other_name)}`, `${r.minutes} min`];
          case "gift": return [r.note ?? "Gift", r.other_name ? `To ${r.other_name}` : null];
          case "purchase": return ["Coins added", "Google Play"];
          case "refund": return ["Refund", r.other_name ? `${callWord} with ${r.other_name}` : r.note];
          case "booking": return [amount < 0 ? "Held for a booked call" : "Booked call hold released", r.note];
          case "adjustment": return [amount > 0 ? "Coins from support" : "Correction by support", r.note];
          case "live": return r.type === "live_debit"
            ? [`Live with ${who(r.other_name)}`, `${r.minutes} min`]
            : ["Live pass", r.note];
          case "group": return [`Group video with ${who(r.other_name)}`, `${r.minutes} min`];
          default: return [r.note ?? "Bonus", null];
        }
      })();
      return {
        key: r.key, kind: r.kind, title, subtitle, amount, at: r.at, callId: r.call_id,
        callType: r.call_type, otherName: r.other_name, otherAvatarId: r.other_avatar,
      };
    });
    const last = page.rows[page.rows.length - 1];
    const t = totals.rows[0]!;
    const n = (k: keyof typeof t) => Number(t[k]);
    return {
      items,
      nextCursor: page.rows.length === limit && last ? String(last.max_id) : null,
      summary: {
        spent: n("spent"), added: n("added"), calls: n("calls"), gifts: n("gifts"), lives: n("lives"), groups: n("groups"), bookings: n("bookings"),
        purchases: n("purchases"), bonuses: n("bonuses"), refunds: n("refunds"),
      },
    };
  });

  app.get("/wallet/ledger", {
    preHandler: requireAuth(),
    schema: {
      tags: ["wallet"],
      security: bearer,
      summary: "Every coin in or out, newest first. Page with `before` = last id seen.",
      querystring: z.object({
        kind: z.enum(["coins", "earnings"]).default("coins"),
        before: z.coerce.number().int().positive().optional(),
        limit: z.coerce.number().int().min(1).max(100).default(30),
      }),
      response: { 200: z.object({ entries: z.array(LedgerEntry), nextBefore: z.number().int().nullable() }) },
    },
  }, async (req) => {
    const { kind, before, limit } = req.query;
    const rows = (await db.query<{
      id: number; type: string; amount: number; balance_after: number; call_id: string | null; note: string | null; created_at: Date;
    }>(
      `SELECT l.id, l.type, l.amount, l.balance_after, l.call_id, l.note, l.created_at
         FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
        WHERE w.user_id = $1 AND w.kind = $2 AND ($3::bigint IS NULL OR l.id < $3)
        ORDER BY l.id DESC LIMIT $4`,
      [me(req).userId, kind, before ?? null, limit],
    )).rows;
    return {
      entries: rows.map((r) => ({
        id: r.id, type: r.type, amount: r.amount, balanceAfter: r.balance_after,
        callId: r.call_id, note: r.note, createdAt: r.created_at,
      })),
      nextBefore: rows.length === limit ? rows[rows.length - 1]!.id : null,
    };
  });
};
