/**
 * Admin analytics: everything for a date range (India time), compared with the
 * period just before it — daily trends, breakdowns, leaderboards and an
 * estimated margin. Needs the "analytics.view" permission.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { Db } from "../db/pool.js";
import { bearer } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { ApiError } from "../errors.js";
import { numberSetting } from "../settings.js";

const IST = "Asia/Kolkata";
const day = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);

const Totals = z.object({
  connectedCalls: z.number().int(),
  missedCalls: z.number().int().describe("Rang but never connected (missed, declined, failed)"),
  minutes: z.number().int().describe("Billed minutes"),
  avgCallSeconds: z.number().int(),
  coinsSpent: z.number().int().describe("Calls + gifts, minus refunds"),
  coinsOnCalls: z.number().int(),
  coinsOnGifts: z.number().int(),
  coinsOnLives: z.number().int(),
  coinsOnGroups: z.number().int(),
  coinsRefunded: z.number().int(),
  salesPaise: z.number().int().describe("Coin packs sold (gross, incl. GST)"),
  purchases: z.number().int(),
  companionEarningsPaise: z.number().int().describe("Calls + gifts + bonuses, after reversals"),
  newCallers: z.number().int(),
  newCompanions: z.number().int(),
  activeCallers: z.number().int().describe("Callers with at least one connected call"),
  payingCallers: z.number().int(),
  avgRating: z.number().nullable(),
  ratings: z.number().int(),
  companionOnlineMinutes: z.number().int(),
}).meta({ id: "AnalyticsTotals" });
type Totals = z.infer<typeof Totals>;

const Person = { id: z.uuid(), displayName: z.string(), avatarId: z.number().int() };

const Analytics = z.object({
  range: z.object({ from: day, to: day, days: z.number().int() }),
  previous: z.object({ from: day, to: day }),
  totals: Totals,
  previousTotals: Totals,
  margin: z.object({
    gstPct: z.number(),
    storeFeePct: z.number(),
    netRevenuePaise: z.number().int().describe("Sales ÷ (1 + GST) × (1 − store fee)"),
    companionCostPaise: z.number().int(),
    infraPaise: z.number().int().describe("Estimated LiveKit cost: (live viewer-minutes + 2 × group member-minutes + 2 × call minutes) × setting"),
    marginPaise: z.number().int(),
    marginPct: z.number().nullable(),
    targetPct: z.number().describe("Setting analytics.target_margin_pct"),
  }).describe("Estimate: store fees vary by payment method"),
  daily: z.array(z.object({
    date: day, calls: z.number().int(), minutes: z.number().int(), coinsSpent: z.number().int(),
    salesPaise: z.number().int(), earningsPaise: z.number().int(), newCallers: z.number().int(),
    newCompanions: z.number().int(), activeCallers: z.number().int(),
  })),
  byLanguage: z.array(z.object({ code: z.string(), name: z.string(), calls: z.number().int(), minutes: z.number().int(), coins: z.number().int() })),
  byType: z.array(z.object({ type: z.enum(["audio", "video"]), calls: z.number().int(), minutes: z.number().int(), coins: z.number().int() })),
  byHour: z.array(z.object({ hour: z.number().int(), calls: z.number().int(), minutes: z.number().int() })),
  topRated: z.array(z.object({ ...Person, rating: z.number(), ratings: z.number().int() })),
  mostActive: z.array(z.object({ ...Person, talkMinutes: z.number().int(), calls: z.number().int(), onlineMinutes: z.number().int() })),
  topEarners: z.array(z.object({ ...Person, earnedPaise: z.number().int(), calls: z.number().int() })),
  topSpenders: z.array(z.object({ ...Person, coinsSpent: z.number().int(), calls: z.number().int(), purchasesPaise: z.number().int() })),
  mostReported: z.array(z.object({ ...Person, role: z.string(), reports: z.number().int() })),
}).meta({ id: "AdminAnalytics" });

/** SQL for the start of an IST calendar day given as a $n date parameter. */
const startOf = (p: string) => `((${p}::date)::timestamp AT TIME ZONE '${IST}')`;
const endOf = (p: string) => `((${p}::date + 1)::timestamp AT TIME ZONE '${IST}')`;
const istDay = (col: string) => `to_char((${col} AT TIME ZONE '${IST}')::date, 'YYYY-MM-DD')`;

async function totals(db: Db, from: string, to: string): Promise<Totals> {
  const S = startOf("$1"), E = endOf("$2");
  const r = (await db.query<Record<string, string | number | null>>(
    `SELECT
       (SELECT count(*) FROM calls WHERE started_at >= ${S} AND started_at < ${E}) AS connected_calls,
       (SELECT count(*) FROM calls WHERE started_at IS NULL AND status IN ('missed', 'rejected', 'failed')
          AND created_at >= ${S} AND created_at < ${E}) AS missed_calls,
       (SELECT COALESCE(sum(minutes_charged), 0) FROM calls WHERE started_at >= ${S} AND started_at < ${E}) AS minutes,
       (SELECT COALESCE(avg(EXTRACT(EPOCH FROM (ended_at - started_at))), 0) FROM calls
          WHERE started_at >= ${S} AND started_at < ${E} AND ended_at IS NOT NULL) AS avg_call_seconds,
       (SELECT COALESCE(-sum(l.amount) FILTER (WHERE l.type = 'call_debit'), 0) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.kind = 'coins' AND l.created_at >= ${S} AND l.created_at < ${E}) AS coins_on_calls,
       (SELECT COALESCE(-sum(l.amount) FILTER (WHERE l.type = 'gift_debit'), 0) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.kind = 'coins' AND l.created_at >= ${S} AND l.created_at < ${E}) AS coins_on_gifts,
       (SELECT COALESCE(-sum(l.amount) FILTER (WHERE l.type IN ('live_debit', 'live_pass_debit')), 0) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.kind = 'coins' AND l.created_at >= ${S} AND l.created_at < ${E}) AS coins_on_lives,
       (SELECT COALESCE(-sum(l.amount) FILTER (WHERE l.type = 'group_debit'), 0) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.kind = 'coins' AND l.created_at >= ${S} AND l.created_at < ${E}) AS coins_on_groups,
       (SELECT COALESCE(sum(l.amount) FILTER (WHERE l.type = 'refund'), 0) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.kind = 'coins' AND l.created_at >= ${S} AND l.created_at < ${E}) AS coins_refunded,
       (SELECT COALESCE(sum(cp.price_paise), 0) FROM purchases p JOIN coin_packages cp ON cp.id = p.package_id
          WHERE p.status = 'credited' AND p.created_at >= ${S} AND p.created_at < ${E}) AS sales_paise,
       (SELECT count(*) FROM purchases WHERE status = 'credited' AND created_at >= ${S} AND created_at < ${E}) AS purchases,
       (SELECT COALESCE(sum(l.amount), 0) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.kind = 'earnings' AND l.type IN ('call_credit', 'gift_credit', 'live_pass_credit', 'live_credit', 'group_credit', 'bonus', 'refund_reversal')
            AND l.created_at >= ${S} AND l.created_at < ${E}) AS earnings_paise,
       (SELECT count(*) FROM users WHERE role = 'caller' AND created_at >= ${S} AND created_at < ${E}) AS new_callers,
       (SELECT count(*) FROM users WHERE role = 'companion' AND created_at >= ${S} AND created_at < ${E}) AS new_companions,
       (SELECT count(DISTINCT caller_id) FROM calls WHERE started_at >= ${S} AND started_at < ${E}) AS active_callers,
       (SELECT count(DISTINCT user_id) FROM purchases WHERE status = 'credited' AND created_at >= ${S} AND created_at < ${E}) AS paying_callers,
       (SELECT round(avg(r.stars)::numeric, 2) FROM call_ratings r JOIN calls c ON c.id = r.call_id
          WHERE r.rater_id = c.caller_id AND r.created_at >= ${S} AND r.created_at < ${E}) AS avg_rating,
       (SELECT count(*) FROM call_ratings r JOIN calls c ON c.id = r.call_id
          WHERE r.rater_id = c.caller_id AND r.created_at >= ${S} AND r.created_at < ${E}) AS ratings,
       (SELECT COALESCE(sum(minutes), 0) FROM companion_online_minutes WHERE day >= $1::date AND day <= $2::date) AS online_minutes`,
    [from, to])).rows[0]!;
  const n = (k: string) => Math.round(Number(r[k] ?? 0));
  const coinsOnCalls = n("coins_on_calls"), coinsOnGifts = n("coins_on_gifts"), coinsOnLives = n("coins_on_lives"), coinsOnGroups = n("coins_on_groups"), coinsRefunded = n("coins_refunded");
  return {
    connectedCalls: n("connected_calls"), missedCalls: n("missed_calls"), minutes: n("minutes"),
    avgCallSeconds: n("avg_call_seconds"),
    coinsSpent: coinsOnCalls + coinsOnGifts + coinsOnLives + coinsOnGroups - coinsRefunded,
    coinsOnCalls, coinsOnGifts, coinsOnLives, coinsOnGroups, coinsRefunded,
    salesPaise: n("sales_paise"), purchases: n("purchases"), companionEarningsPaise: n("earnings_paise"),
    newCallers: n("new_callers"), newCompanions: n("new_companions"), activeCallers: n("active_callers"),
    payingCallers: n("paying_callers"), avgRating: r.avg_rating === null ? null : Number(r.avg_rating),
    ratings: n("ratings"), companionOnlineMinutes: n("online_minutes"),
  };
}

const toDate = (d: Date) => d.toISOString().slice(0, 10);
const addDays = (s: string, n: number) => toDate(new Date(Date.parse(`${s}T00:00:00Z`) + n * 86_400_000));
const istToday = () => new Intl.DateTimeFormat("en-CA", { timeZone: IST }).format(new Date());

export const analyticsRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;

  app.get("/admin/analytics", {
    preHandler: can("analytics.view"),
    schema: {
      tags: ["admin"],
      security: bearer,
      summary: "Analytics for a date range (India time, both days included), with the previous period for comparison",
      querystring: z.object({
        from: day.optional().describe("Default: 29 days before `to`"),
        to: day.optional().describe("Default: today"),
        minRatings: z.coerce.number().int().min(1).max(100).default(3).describe("Ratings needed to appear in Top rated"),
      }),
      response: { 200: Analytics },
    },
  }, async (req) => {
    const to = req.query.to ?? istToday();
    const from = req.query.from ?? addDays(to, -29);
    const days = Math.round((Date.parse(to) - Date.parse(from)) / 86_400_000) + 1;
    if (days < 1) throw new ApiError(400, "BAD_RANGE", "The start date must be on or before the end date");
    if (days > 366) throw new ApiError(400, "BAD_RANGE", "Pick at most a year");
    const prevTo = addDays(from, -1), prevFrom = addDays(prevTo, -(days - 1));
    const S = startOf("$1"), E = endOf("$2"), args = [from, to];

    const targetPct = await numberSetting(db, "analytics.target_margin_pct", 75);
    const infraPerMin = await numberSetting(db, "analytics.livekit_paise_per_viewer_minute", 9);
    const liveMinutes = (await db.query<{ n: number }>(
      `SELECT count(*)::int AS n FROM live_ticks WHERE created_at >= ${startOf("$1")} AND created_at < ${endOf("$2")}`, [from, to])).rows[0]!.n;
    // Group video: everyone sends and receives video, so count each member-minute twice.
    const groupMinutes = (await db.query<{ n: number }>(
      `SELECT count(*)::int AS n FROM group_ticks WHERE created_at >= ${startOf("$1")} AND created_at < ${endOf("$2")}`, [from, to])).rows[0]!.n;
    const [cur, prev, gstPct, feePct, dailyRows, lang, type, hour, rated, active, earners, spenders, reported] = await Promise.all([
      totals(db, from, to),
      totals(db, prevFrom, prevTo),
      numberSetting(db, "analytics.gst_pct", 18),
      numberSetting(db, "analytics.store_fee_pct", 15),
      db.query<Record<string, string | number>>(
        `WITH d AS (SELECT to_char(g, 'YYYY-MM-DD') AS date FROM generate_series($1::date, $2::date, interval '1 day') g),
         c AS (SELECT ${istDay("started_at")} AS date, count(*) AS calls, sum(minutes_charged) AS minutes,
                      count(DISTINCT caller_id) AS active_callers
                 FROM calls WHERE started_at >= ${S} AND started_at < ${E} GROUP BY 1),
         coins AS (SELECT ${istDay("l.created_at")} AS date,
                          -sum(l.amount) FILTER (WHERE l.type IN ('call_debit', 'gift_debit', 'live_pass_debit', 'live_debit', 'group_debit')) - COALESCE(sum(l.amount) FILTER (WHERE l.type = 'refund'), 0) AS spent
                     FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
                    WHERE w.kind = 'coins' AND l.created_at >= ${S} AND l.created_at < ${E} GROUP BY 1),
         earn AS (SELECT ${istDay("l.created_at")} AS date, sum(l.amount) AS paise
                    FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
                   WHERE w.kind = 'earnings' AND l.type IN ('call_credit', 'gift_credit', 'live_pass_credit', 'live_credit', 'group_credit', 'bonus', 'refund_reversal')
                     AND l.created_at >= ${S} AND l.created_at < ${E} GROUP BY 1),
         sales AS (SELECT ${istDay("p.created_at")} AS date, sum(cp.price_paise) AS paise
                     FROM purchases p JOIN coin_packages cp ON cp.id = p.package_id
                    WHERE p.status = 'credited' AND p.created_at >= ${S} AND p.created_at < ${E} GROUP BY 1),
         u AS (SELECT ${istDay("created_at")} AS date, count(*) FILTER (WHERE role = 'caller') AS callers,
                      count(*) FILTER (WHERE role = 'companion') AS companions
                 FROM users WHERE created_at >= ${S} AND created_at < ${E} GROUP BY 1)
         SELECT d.date, COALESCE(c.calls, 0) AS calls, COALESCE(c.minutes, 0) AS minutes, COALESCE(c.active_callers, 0) AS active_callers,
                COALESCE(coins.spent, 0) AS coins_spent, COALESCE(earn.paise, 0) AS earnings, COALESCE(sales.paise, 0) AS sales,
                COALESCE(u.callers, 0) AS new_callers, COALESCE(u.companions, 0) AS new_companions
           FROM d LEFT JOIN c USING (date) LEFT JOIN coins USING (date) LEFT JOIN earn USING (date)
           LEFT JOIN sales USING (date) LEFT JOIN u USING (date) ORDER BY d.date`, args),
      db.query<{ code: string; name: string; calls: string; minutes: string; coins: string }>(
        `SELECT l.code, l.name, count(c.id) AS calls, COALESCE(sum(c.minutes_charged), 0) AS minutes,
                COALESCE(sum(c.coins_charged), 0) AS coins
           FROM languages l LEFT JOIN calls c ON c.language_code = l.code AND c.started_at >= ${S} AND c.started_at < ${E}
          GROUP BY l.code, l.name ORDER BY count(c.id) DESC, l.code`, args),
      db.query<{ type: "audio" | "video"; calls: string; minutes: string; coins: string }>(
        `SELECT type::text AS type, count(*) AS calls, COALESCE(sum(minutes_charged), 0) AS minutes, COALESCE(sum(coins_charged), 0) AS coins
           FROM calls WHERE started_at >= ${S} AND started_at < ${E} GROUP BY type ORDER BY type`, args),
      db.query<{ hour: number; calls: string; minutes: string }>(
        `SELECT h AS hour, count(c.id) AS calls, COALESCE(sum(c.minutes_charged), 0) AS minutes
           FROM generate_series(0, 23) h
           LEFT JOIN calls c ON EXTRACT(HOUR FROM c.started_at AT TIME ZONE '${IST}')::int = h
                            AND c.started_at >= ${S} AND c.started_at < ${E}
          GROUP BY h ORDER BY h`, args),
      db.query<{ id: string; display_name: string; avatar_id: number; rating: string; ratings: string }>(
        `SELECT u.id, u.display_name, u.avatar_id, round(avg(r.stars)::numeric, 2) AS rating, count(*) AS ratings
           FROM call_ratings r JOIN calls c ON c.id = r.call_id JOIN users u ON u.id = c.companion_id
          WHERE r.rater_id = c.caller_id AND r.created_at >= ${S} AND r.created_at < ${E}
          GROUP BY u.id HAVING count(*) >= $3 ORDER BY avg(r.stars) DESC, count(*) DESC LIMIT 10`, [...args, req.query.minRatings]),
      db.query<{ id: string; display_name: string; avatar_id: number; talk: string; calls: string; online: string }>(
        `SELECT u.id, u.display_name, u.avatar_id,
                COALESCE((SELECT sum(EXTRACT(EPOCH FROM (c.ended_at - c.started_at))) / 60 FROM calls c
                  WHERE c.companion_id = u.id AND c.started_at >= ${S} AND c.started_at < ${E} AND c.ended_at IS NOT NULL), 0) AS talk,
                (SELECT count(*) FROM calls c WHERE c.companion_id = u.id AND c.started_at >= ${S} AND c.started_at < ${E}) AS calls,
                COALESCE((SELECT sum(minutes) FROM companion_online_minutes m WHERE m.user_id = u.id AND m.day >= $1::date AND m.day <= $2::date), 0) AS online
           FROM users u WHERE u.role = 'companion'
          ORDER BY talk DESC, online DESC LIMIT 10`, args),
      db.query<{ id: string; display_name: string; avatar_id: number; paise: string; calls: string }>(
        `SELECT u.id, u.display_name, u.avatar_id, sum(l.amount) AS paise,
                (SELECT count(*) FROM calls c WHERE c.companion_id = u.id AND c.started_at >= ${S} AND c.started_at < ${E}) AS calls
           FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id JOIN users u ON u.id = w.user_id
          WHERE w.kind = 'earnings' AND l.type IN ('call_credit', 'gift_credit', 'live_pass_credit', 'live_credit', 'group_credit', 'bonus', 'refund_reversal')
            AND l.created_at >= ${S} AND l.created_at < ${E}
          GROUP BY u.id HAVING sum(l.amount) > 0 ORDER BY sum(l.amount) DESC LIMIT 10`, args),
      db.query<{ id: string; display_name: string; avatar_id: number; coins: string; calls: string; purchases: string }>(
        `SELECT u.id, u.display_name, u.avatar_id,
                -sum(l.amount) FILTER (WHERE l.type IN ('call_debit', 'gift_debit', 'live_pass_debit', 'live_debit', 'group_debit')) - COALESCE(sum(l.amount) FILTER (WHERE l.type = 'refund'), 0) AS coins,
                (SELECT count(*) FROM calls c WHERE c.caller_id = u.id AND c.started_at >= ${S} AND c.started_at < ${E}) AS calls,
                COALESCE((SELECT sum(cp.price_paise) FROM purchases p JOIN coin_packages cp ON cp.id = p.package_id
                  WHERE p.user_id = u.id AND p.status = 'credited' AND p.created_at >= ${S} AND p.created_at < ${E}), 0) AS purchases
           FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id JOIN users u ON u.id = w.user_id
          WHERE w.kind = 'coins' AND u.role = 'caller' AND l.type IN ('call_debit', 'gift_debit', 'live_pass_debit', 'live_debit', 'group_debit', 'refund')
            AND l.created_at >= ${S} AND l.created_at < ${E}
          GROUP BY u.id HAVING -sum(l.amount) FILTER (WHERE l.type IN ('call_debit', 'gift_debit', 'live_pass_debit', 'live_debit', 'group_debit')) > 0
          ORDER BY coins DESC LIMIT 10`, args),
      db.query<{ id: string; display_name: string; avatar_id: number; role: string; reports: string }>(
        `SELECT u.id, u.display_name, u.avatar_id, u.role::text AS role, count(*) AS reports
           FROM reports r JOIN users u ON u.id = r.reported_id
          WHERE r.created_at >= ${S} AND r.created_at < ${E}
          GROUP BY u.id ORDER BY count(*) DESC LIMIT 10`, args),
    ]);

    const n = (v: unknown) => Math.round(Number(v ?? 0));
    const person = (r: { id: string; display_name: string; avatar_id: number }) => ({ id: r.id, displayName: r.display_name, avatarId: r.avatar_id });
    const net = Math.round((cur.salesPaise / (1 + gstPct / 100)) * (1 - feePct / 100));
    const infraPaise = Math.round((liveMinutes + 2 * groupMinutes + 2 * cur.minutes) * infraPerMin);
    const marginPaise = net - cur.companionEarningsPaise - infraPaise;

    return {
      range: { from, to, days },
      previous: { from: prevFrom, to: prevTo },
      totals: cur,
      previousTotals: prev,
      margin: {
        gstPct, storeFeePct: feePct, netRevenuePaise: net, companionCostPaise: cur.companionEarningsPaise, infraPaise,
        marginPaise, marginPct: net > 0 ? Math.round((marginPaise / net) * 1000) / 10 : null, targetPct,
      },
      daily: dailyRows.rows.map((r) => ({
        date: String(r.date), calls: n(r.calls), minutes: n(r.minutes), coinsSpent: n(r.coins_spent), salesPaise: n(r.sales),
        earningsPaise: n(r.earnings), newCallers: n(r.new_callers), newCompanions: n(r.new_companions), activeCallers: n(r.active_callers),
      })),
      byLanguage: lang.rows.map((r) => ({ code: r.code, name: r.name, calls: n(r.calls), minutes: n(r.minutes), coins: n(r.coins) })),
      byType: type.rows.map((r) => ({ type: r.type, calls: n(r.calls), minutes: n(r.minutes), coins: n(r.coins) })),
      byHour: hour.rows.map((r) => ({ hour: n(r.hour), calls: n(r.calls), minutes: n(r.minutes) })),
      topRated: rated.rows.map((r) => ({ ...person(r), rating: Number(r.rating), ratings: n(r.ratings) })),
      mostActive: active.rows.filter((r) => n(r.talk) > 0 || n(r.online) > 0)
        .map((r) => ({ ...person(r), talkMinutes: n(r.talk), calls: n(r.calls), onlineMinutes: n(r.online) })),
      topEarners: earners.rows.map((r) => ({ ...person(r), earnedPaise: n(r.paise), calls: n(r.calls) })),
      topSpenders: spenders.rows.map((r) => ({ ...person(r), coinsSpent: n(r.coins), calls: n(r.calls), purchasesPaise: n(r.purchases) })),
      mostReported: reported.rows.map((r) => ({ ...person(r), role: r.role, reports: n(r.reports) })),
    };
  });
};
