/**
 * Admin panel API. Every route needs an admin access token, and every change
 * writes an audit_log row in the same transaction.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx, type DbClient } from "../db/pool.js";
import { bearer, me } from "../auth/guard.js";
import { can } from "../auth/permissions.js";
import { maskPhone } from "../auth/phone.js";
import { ApiError, conflict, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import { notify } from "../notifications.js";
import { activeVip } from "../vip.js";
import { VipPlan } from "./vip.js";
import { ONLINE_SET } from "../billing/engine.js";
import { goOffline, inAppIds, inAppSet } from "../presence.js";
import { LanguageCode } from "./profile.js";
import { endLivesOf } from "./lives.js";
import { endGroupsOf } from "./groups.js";

const IST_TODAY = `date_trunc('day', now() AT TIME ZONE 'Asia/Kolkata') AT TIME ZONE 'Asia/Kolkata'`;

async function audit(c: DbClient, actorId: string, action: string, targetType: string, targetId: string | number,
                     details: Record<string, unknown>): Promise<void> {
  await c.query(
    `INSERT INTO audit_log (actor_id, action, target_type, target_id, details) VALUES ($1, $2, $3, $4, $5)`,
    [actorId, action, targetType, String(targetId), JSON.stringify(details)],
  );
}

const CallRate = z.object({
  id: z.number().int(),
  language: z.string(),
  callType: z.enum(["audio", "video"]),
  coinsPerMin: z.number().int(),
  companionPaisePerMin: z.number().int(),
  effectiveFrom: z.date(),
  status: z.enum(["current", "scheduled", "past"]),
}).meta({ id: "AdminCallRate" });

const CoinPackage = z.object({
  id: z.number().int(),
  sku: z.string(),
  coins: z.number().int(),
  bonusCoins: z.number().int(),
  pricePaise: z.number().int(),
  label: z.string().nullable(),
  isActive: z.boolean(),
  sortOrder: z.number().int(),
}).meta({ id: "AdminCoinPackage" });

const AdminUser = z.object({
  id: z.uuid(),
  displayName: z.string(),
  phone: z.string().describe("Masked"),
  role: z.enum(["caller", "companion", "admin"]),
  status: z.enum(["active", "suspended", "banned", "deleted"]),
  primaryLanguage: z.string(),
  createdAt: z.date(),
  coins: z.number().int(),
  earningsPaise: z.number().int(),
  calls: z.number().int(),
  reportsAgainst: z.number().int(),
  kycStatus: z.enum(["pending", "approved", "rejected"]).nullable(),
  online: z.boolean().describe("Has the app open right now (or is taking calls)"),
  takingCalls: z.boolean().describe("Companion switched Online and taking calls"),
  lastSeenAt: z.date().nullable().describe("Latest of: app open, last online (companions), last sign-in, last call"),
  avatarId: z.number().int().describe("1 female, 2 male, 3 transgender illustrations; other ids are letter circles"),
}).meta({ id: "AdminUser" });

const Party = z.object({ id: z.uuid(), displayName: z.string() });

const AdminNote = z.object({
  id: z.number().int(), createdAt: z.date(), author: z.string(), body: z.string(),
}).meta({ id: "AdminNote" });

const AdminUserDetail = z.object({
  id: z.uuid(),
  displayName: z.string(),
  phone: z.string().describe("Masked"),
  gender: z.string(),
  role: z.enum(["caller", "companion", "admin"]),
  status: z.enum(["active", "suspended", "banned", "deleted"]),
  primaryLanguage: z.string(),
  languages: z.array(z.string()),
  avatarId: z.number().int(),
  createdAt: z.date(),
  termsAcceptedAt: z.date().nullable(),
  online: z.boolean().describe("Has the app open right now (or is taking calls)"),
  takingCalls: z.boolean().describe("Companion switched Online and taking calls"),
  lastActiveAt: z.date().nullable().describe("Last time the app was open"),
  lastSignInAt: z.date().nullable(),
  activeSessions: z.number().int(),
  devices: z.number().int(),
  coins: z.number().int(),
  earningsPaise: z.number().int(),
  stats: z.object({
    calls: z.number().int(), missedCalls: z.number().int(), minutes: z.number().int(),
    coinsSpent: z.number().int(), paiseEarned: z.number().int(),
    giftsSent: z.number().int(), giftsSentCoins: z.number().int(),
    giftsReceived: z.number().int(), giftsReceivedPaise: z.number().int(),
    favourites: z.number().int(), followers: z.number().int(),
    blockedBy: z.number().int(), blocking: z.number().int(), ratingsGiven: z.number().int(),
    reportsAgainst: z.number().int(), reportsMade: z.number().int(),
  }),
  companion: z.object({
    kycStatus: z.enum(["pending", "approved", "rejected"]).nullable(),
    kycVerifiedAt: z.date().nullable(),
    videoEnabled: z.boolean(),
    bio: z.string().nullable(),
    upiId: z.string().nullable().describe("Masked"),
    lastOnlineAt: z.date().nullable(),
    rating: z.number().nullable(),
    ratingCount: z.number().int(),
    academyPassed: z.number().int(),
    academyTotal: z.number().int(),
  }).nullable(),
  calls: z.array(z.object({
    id: z.uuid(), createdAt: z.date(), type: z.enum(["audio", "video"]), status: z.string(), language: z.string(),
    direction: z.enum(["outgoing", "incoming"]), other: Party, seconds: z.number().int().nullable(),
    minutes: z.number().int(), coins: z.number().int(), paise: z.number().int(), endReason: z.string().nullable(),
    stars: z.number().int().nullable(), giftCoins: z.number().int(),
  })),
  ledger: z.array(z.object({
    id: z.number().int(), createdAt: z.date(), wallet: z.enum(["coins", "earnings"]), type: z.string(),
    amount: z.number().int(), balanceAfter: z.number().int(), note: z.string().nullable(), callId: z.uuid().nullable(),
  })),
  purchases: z.array(z.object({
    id: z.uuid(), createdAt: z.date(), sku: z.string(), label: z.string().nullable(), pricePaise: z.number().int(),
    coins: z.number().int(), status: z.string(),
  })),
  payouts: z.array(z.object({
    id: z.uuid(), createdAt: z.date(), grossPaise: z.number().int(), tdsPaise: z.number().int(), netPaise: z.number().int(),
    upiId: z.string().describe("Masked"), status: z.string(), failureReason: z.string().nullable(), processedAt: z.date().nullable(),
  })),
  reports: z.array(z.object({
    id: z.uuid(), createdAt: z.date(), direction: z.enum(["against", "by"]),
    other: z.object({ id: z.uuid().nullable(), displayName: z.string() }).describe("id null = the automatic safety check"), reason: z.string(),
    details: z.string().nullable(), status: z.string(), callId: z.uuid().nullable(),
  })),
  refunds: z.array(z.object({
    id: z.uuid(), createdAt: z.date(), callId: z.uuid(), reason: z.string(), status: z.string(),
    coinsEligible: z.number().int(), coinsRefunded: z.number().int(), byUser: z.boolean(),
  })),
  audit: z.array(z.object({
    id: z.number().int(), createdAt: z.date(), actor: z.string(), action: z.string(), details: z.record(z.string(), z.unknown()),
  })),
  notes: z.array(AdminNote),
  vip: z.object({ expiresAt: z.date(), source: z.string() }).nullable(),
}).meta({ id: "AdminUserDetail" });

const Report = z.object({
  id: z.uuid(),
  createdAt: z.date(),
  reason: z.string(),
  details: z.string().nullable(),
  status: z.string(),
  callId: z.uuid().nullable(),
  reporter: z.object({ id: z.uuid().nullable(), displayName: z.string(), role: z.string() })
    .describe("id null = the automatic safety check (repeated contact-sharing attempts in chat)"),
  reported: z.object({ id: z.uuid(), displayName: z.string(), role: z.string(), status: z.string(), reportsAgainst: z.number().int() }),
  resolutionNote: z.string().nullable(),
  resolvedAt: z.date().nullable(),
  recording: z.enum(["recording", "ready", "failed", "deleted", "disabled"]).nullable(),
}).meta({ id: "AdminReport" });

const ModerationFlag = z.object({
  id: z.uuid(),
  createdAt: z.date(),
  score: z.number().describe("Model confidence 0–1 that the frame shows nudity"),
  status: z.enum(["open", "dismissed", "actioned"]),
  note: z.string().nullable(),
  reviewedAt: z.date().nullable(),
  reviewer: z.string().nullable(),
  hasFrame: z.boolean().describe("false once deleted under the retention policy"),
  call: z.object({ id: z.uuid(), type: z.enum(["audio", "video"]) }).nullable(),
  liveId: z.uuid().nullable(),
  groupId: z.uuid().nullable(),
  subject: z.object({ id: z.uuid(), displayName: z.string(), role: z.string(), status: z.string(), flags: z.number().int() })
    .describe("The person whose video was flagged"),
  detectedBy: z.object({ id: z.uuid(), displayName: z.string(), role: z.string() }),
}).meta({ id: "AdminModerationFlag" });

const AdminGift = z.object({
  id: z.number().int(), code: z.string(), name: z.string(), emoji: z.string(), coins: z.number().int(),
  isActive: z.boolean(), sortOrder: z.number().int(),
}).meta({ id: "AdminGift" });

/** Settings the admin may change, with safe bounds. */
const SETTINGS: Record<string, { min: number; max: number; label: string }> = {
  "gift.companion_share_bps": { min: 0, max: 8000, label: "Companion share of gifts (basis points)" },
  "coin.value_paise": { min: 10, max: 500, label: "Value of one coin for gift payouts (paise)" },
  "offer.first_recharge_hours": { min: 1, max: 168, label: "First-recharge offer window (hours after sign-up)" },
  "analytics.gst_pct": { min: 0, max: 40, label: "Analytics: GST included in pack prices (%)" },
  "analytics.store_fee_pct": { min: 0, max: 40, label: "Analytics: average store / payment fee (%)" },
  "analytics.target_margin_pct": { min: 0, max: 100, label: "Analytics: target margin on net revenue (%)" },
  "live.preview_seconds": { min: 0, max: 120, label: "Live: free preview per viewer (seconds)" },
  "live.coins_per_min": { min: 1, max: 1000, label: "Live: price per viewer per minute (coins)" },
  "live.companion_share_bps": { min: 0, max: 8000, label: "Live: companion share of each paid minute (basis points of coin value)" },
  "live.empty_end_minutes": { min: 2, max: 120, label: "Live: end a live after this long with nobody watching (minutes)" },
  "live.max_minutes": { min: 10, max: 720, label: "Live: longest a live can run (minutes)" },
  "live.max_per_day": { min: 1, max: 50, label: "Live: lives per companion per day" },
  "live.previews_per_day": { min: 0, max: 500, label: "Live: free previews per viewer per day" },
  "analytics.livekit_paise_per_viewer_minute": { min: 0, max: 1000, label: "Analytics: LiveKit cost per viewer-minute (paise)" },
  "live.max_viewers": { min: 1, max: 5000, label: "Live: most viewers at once" },
  "group.coins_per_min": { min: 1, max: 1000, label: "Group video: price per member per minute (coins)" },
  "group.companion_share_bps": { min: 0, max: 8000, label: "Group video: companion share of each member-minute (basis points of coin value)" },
  "group.min_members": { min: 2, max: 10, label: "Group video: members needed to start" },
  "group.max_members": { min: 2, max: 16, label: "Group video: most members" },
  "group.end_below": { min: 1, max: 10, label: "Group video: end when fewer members than this remain" },
  "group.lobby_timeout_minutes": { min: 2, max: 60, label: "Group video: close a lobby that doesn't fill after (minutes)" },
  "group.max_minutes": { min: 10, max: 360, label: "Group video: longest a group can run (minutes)" },
  "group.no_show_minutes": { min: 5, max: 60, label: "Group video: cancel a scheduled group if the host hasn't opened it after (minutes)" },
  "refund.window_days": { min: 1, max: 30, label: "Days a caller can ask for a refund" },
  "payout.min_paise": { min: 1000, max: 1_000_000, label: "Minimum withdrawal (paise)" },
  "payout.tds_bps": { min: 0, max: 3000, label: "TDS on withdrawals (basis points)" },
  "payout.tds_no_pan_bps": { min: 0, max: 3000, label: "TDS on withdrawals without a PAN (basis points)" },
  "referral.companion_bonus_paise": { min: 0, max: 100000, label: "Companion referral: bonus when an invited caller first recharges (paise)" },
  "chat.strikes_to_pause": { min: 1, max: 20, label: "Chat: blocked attempts in 24 h that pause chat" },
  "chat.pause_hours": { min: 1, max: 720, label: "Chat: how long a pause lasts (hours)" },
  "chat.strikes_to_review": { min: 1, max: 100, label: "Chat: blocked attempts in 30 days that file an automatic report" },
  "chat.requests_per_day": { min: 0, max: 100, label: "Chat: message requests a caller can send per day" },
  "chat.request_retry_days": { min: 0, max: 90, label: "Chat: days before asking again after a decline" },
  "invite.can_pay_minutes": { min: 1, max: 60, label: "Invites: minutes of voice a caller must afford to show 'Ready to call'" },
  "invite.per_companion_hour": { min: 0, max: 500, label: "Invites: max a companion can send per hour" },
  "invite.per_caller_hour": { min: 0, max: 100, label: "Invites: max a caller can receive per hour" },
  "checkin.day1": { min: 0, max: 100, label: "Daily bonus: Day 1 (coins)" },
  "checkin.day2": { min: 0, max: 100, label: "Daily bonus: Day 2 (coins)" },
  "checkin.day3": { min: 0, max: 100, label: "Daily bonus: Day 3 (coins)" },
  "checkin.day4": { min: 0, max: 100, label: "Daily bonus: Day 4 (coins)" },
  "checkin.day5": { min: 0, max: 100, label: "Daily bonus: Day 5 (coins)" },
  "checkin.day6": { min: 0, max: 100, label: "Daily bonus: Day 6 (coins)" },
  "checkin.day7": { min: 0, max: 200, label: "Daily bonus: Day 7 (coins)" },
  "referral.referrer_coins": { min: 0, max: 1000, label: "Invite: coins for the inviter" },
  "referral.referee_coins": { min: 0, max: 1000, label: "Invite: coins for the new friend" },
  "referral.max_rewarded": { min: 0, max: 10_000, label: "Invite: max rewarded friends per person" },
  "booking.window_days": { min: 1, max: 14, label: "Bookings: how many days ahead" },
  "booking.first_slot_minute": { min: 0, max: 1410, label: "Bookings: first slot (minutes after midnight IST)" },
  "booking.last_slot_minute": { min: 0, max: 1410, label: "Bookings: last slot (minutes after midnight IST)" },
  "booking.confirm_hours": { min: 1, max: 72, label: "Bookings: hours a companion has to confirm" },
  "vip.discount_pct": { min: 0, max: 50, label: "VIP: discount on call minutes (%)" },
  "companion.daily_goal_paise": { min: 0, max: 10_000_000, label: "Companions: daily earning goal (paise)" },
  "companion.streak_min_minutes": { min: 1, max: 1440, label: "Companions: minutes online for a streak day" },
};

export const adminRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, redis, engine, recorder, store } = app.deps;
  const base = { tags: ["admin"], security: bearer };

  // -------------------------------------------------------------------------
  const ActivityKind = z.enum(["call", "signup", "kyc_submitted", "kyc_approved", "payout", "report"]);
  app.get("/admin/dashboard", {
    preHandler: can("dashboard.view"),
    schema: {
      ...base,
      summary: "Live numbers and today's totals (India time)",
      response: {
        200: z.object({
          live: z.object({ voiceCalls: z.number().int(), videoCalls: z.number().int(), ringing: z.number().int(),
            companionsOnline: z.number().int().describe("Companions taking calls"),
            callersOnline: z.number().int().describe("Callers with the app open"),
            companionsInApp: z.number().int().describe("Companions with the app open (taking calls or not)") }),
          today: z.object({ connectedCalls: z.number().int(), minutesBilled: z.number().int(), coinsSpent: z.number().int(),
            companionEarningsPaise: z.number().int(), purchasesPaise: z.number().int(), newUsers: z.number().int(),
            newCallers: z.number().int(), newCompanions: z.number().int() }),
          yesterday: z.object({ connectedCalls: z.number().int(), coinsSpent: z.number().int(), newUsers: z.number().int() })
            .describe("Yesterday from midnight up to the same time of day as now, so the comparison is like for like"),
          byHour: z.array(z.object({ hour: z.number().int(), calls: z.number().int(), coins: z.number().int() })),
          languages: z.array(z.object({ code: z.string(), name: z.string(), online: z.number().int(), inCall: z.number().int(),
            ringing: z.number().int() })),
          openReports: z.number().int(),
          openReportsByReason: z.record(z.string(), z.number().int()),
          pendingKyc: z.number().int(),
          pendingPayouts: z.object({ count: z.number().int(), paise: z.number().int() }),
          flaggedPayouts: z.number().int().describe("Requested payouts carrying at least one risk flag"),
          billingExceptions: z.number().int(),
          openRefunds: z.number().int().describe("Refund requests waiting for a decision"),
          openModeration: z.number().int().describe("Video frames flagged for nudity, waiting for review"),
          activity: z.array(z.object({
            kind: ActivityKind,
            at: z.date(),
            user: z.object({ id: z.uuid(), displayName: z.string(), role: z.string(), avatarId: z.number().int() }),
            otherName: z.string().nullable().describe("call: the caller; report: the reported user"),
            callType: z.enum(["audio", "video"]).nullable(),
            minutes: z.number().int().nullable(),
            coins: z.number().int().nullable(),
            paise: z.number().int().nullable(),
          })).describe("Latest 8 events, newest first"),
        }),
      },
    },
  }, async () => {
    const online = await redis.smembers(ONLINE_SET);
    const inApp = await inAppIds(redis);
    const inAppByRole = inApp.length
      ? (await db.query<{ callers: number; companions: number }>(
          `SELECT count(*) FILTER (WHERE role = 'caller')::int AS callers, count(*) FILTER (WHERE role = 'companion')::int AS companions
             FROM users WHERE id = ANY($1::uuid[]) AND status = 'active'`, [inApp])).rows[0]!
      : { callers: 0, companions: 0 };
    const coinsSpent = (from: string, to: string) =>
      `(SELECT COALESCE(-sum(amount), 0) FROM ledger_entries WHERE type = 'call_debit' AND created_at >= ${from} AND created_at < ${to})::bigint
         - (SELECT COALESCE(sum(amount), 0) FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
             WHERE l.type = 'refund' AND w.kind = 'coins' AND l.created_at >= ${from} AND l.created_at < ${to})::bigint`;
    const yStart = `(${IST_TODAY} - interval '1 day')`, yEnd = `(now() - interval '1 day')`;
    const [live, today, byHour, languages, counts, reasons, activity] = await Promise.all([
      db.query<{ voice: number; video: number; ringing: number }>(
        `SELECT count(*) FILTER (WHERE status = 'active' AND type = 'audio')::int AS voice,
                count(*) FILTER (WHERE status = 'active' AND type = 'video')::int AS video,
                count(*) FILTER (WHERE status = 'ringing')::int AS ringing
           FROM calls WHERE status IN ('active', 'ringing')`),
      db.query<{ connected: number; minutes: number; coins: number; paise: number; purchases: number; new_users: number;
                 new_callers: number; new_companions: number; y_connected: number; y_coins: number; y_new_users: number }>(
        `SELECT (SELECT count(*) FROM calls WHERE started_at >= ${IST_TODAY})::int AS connected,
                (SELECT count(*) FROM call_ticks WHERE charged_at >= ${IST_TODAY})::int AS minutes,
                ${coinsSpent(IST_TODAY, "'infinity'")} AS coins,
                (SELECT COALESCE(sum(amount), 0) FROM ledger_entries WHERE type IN ('call_credit', 'refund_reversal') AND created_at >= ${IST_TODAY})::bigint AS paise,
                (SELECT COALESCE(sum(p.price_paise), 0) FROM purchases pu JOIN coin_packages p ON p.id = pu.package_id
                  WHERE pu.status = 'credited' AND pu.created_at >= ${IST_TODAY})::bigint AS purchases,
                (SELECT count(*) FROM users WHERE created_at >= ${IST_TODAY})::int AS new_users,
                (SELECT count(*) FROM users WHERE role = 'caller' AND created_at >= ${IST_TODAY})::int AS new_callers,
                (SELECT count(*) FROM users WHERE role = 'companion' AND created_at >= ${IST_TODAY})::int AS new_companions,
                (SELECT count(*) FROM calls WHERE started_at >= ${yStart} AND started_at < ${yEnd})::int AS y_connected,
                ${coinsSpent(yStart, yEnd)} AS y_coins,
                (SELECT count(*) FROM users WHERE created_at >= ${yStart} AND created_at < ${yEnd})::int AS y_new_users`),
      db.query<{ hour: number; calls: number; coins: number }>(
        `SELECT h.hour,
                (SELECT count(*) FROM calls c WHERE c.started_at >= ${IST_TODAY}
                   AND extract(hour FROM c.started_at AT TIME ZONE 'Asia/Kolkata') = h.hour)::int AS calls,
                (SELECT COALESCE(sum(t.coins_charged), 0) FROM call_ticks t WHERE t.charged_at >= ${IST_TODAY}
                   AND extract(hour FROM t.charged_at AT TIME ZONE 'Asia/Kolkata') = h.hour)::int AS coins
           FROM generate_series(0, 23) AS h(hour) ORDER BY h.hour`),
      db.query<{ code: string; name: string; online: number; in_call: number; ringing: number }>(
        `SELECT l.code, l.name,
                (SELECT count(*) FROM users u WHERE u.id = ANY($1::uuid[]) AND u.primary_language = l.code)::int AS online,
                (SELECT count(*) FROM calls c WHERE c.status = 'active' AND c.language_code = l.code)::int AS in_call,
                (SELECT count(*) FROM calls c WHERE c.status = 'ringing' AND c.language_code = l.code)::int AS ringing
           FROM languages l WHERE l.is_active
          ORDER BY array_position(ARRAY['ta','te','kn','ml','hi','bn','mr','en'], l.code)`, [online]),
      db.query<{ reports: number; kyc: number; payouts: number; payout_paise: number; flagged: number; exceptions: number; refunds: number; moderation: number }>(
        `SELECT (SELECT count(*) FROM reports WHERE status = 'open')::int AS reports,
                (SELECT count(*) FROM companion_profiles WHERE kyc_status = 'pending' AND kyc_submitted_at IS NOT NULL)::int AS kyc,
                (SELECT count(*) FROM payouts WHERE status = 'requested')::int AS payouts,
                (SELECT COALESCE(sum(gross_paise), 0) FROM payouts WHERE status = 'requested')::bigint AS payout_paise,
                (SELECT count(*) FROM payouts WHERE status = 'requested' AND cardinality(flags) > 0)::int AS flagged,
                (SELECT count(*) FROM billing_exceptions WHERE resolved_at IS NULL)::int AS exceptions,
                (SELECT count(*) FROM refund_requests WHERE status = 'requested')::int AS refunds,
                (SELECT count(*) FROM moderation_flags WHERE status = 'open')::int AS moderation`),
      db.query<{ reason: string; n: number }>(`SELECT reason, count(*)::int AS n FROM reports WHERE status = 'open' GROUP BY reason`),
      db.query<{ kind: z.infer<typeof ActivityKind>; at: Date; user_id: string; display_name: string; role: string; avatar_id: number;
                 other_name: string | null; call_type: "audio" | "video" | null; minutes: number | null; coins: number | null;
                 paise: number | null }>(
        // Each branch is capped at 8 so the union stays small however busy the day was.
        `SELECT e.*, u.display_name, u.role::text AS role, u.avatar_id FROM (
           (SELECT 'call' AS kind, c.ended_at AS at, c.companion_id AS user_id, cu.display_name AS other_name,
                   c.type::text AS call_type, c.minutes_charged AS minutes, c.coins_charged AS coins, NULL::bigint AS paise
              FROM calls c JOIN users cu ON cu.id = c.caller_id
             WHERE c.status = 'ended' AND c.started_at IS NOT NULL AND c.ended_at IS NOT NULL ORDER BY c.ended_at DESC LIMIT 8)
           UNION ALL
           (SELECT 'signup', created_at, id, NULL, NULL, NULL, NULL, NULL FROM users
             WHERE role <> 'admin' ORDER BY created_at DESC LIMIT 8)
           UNION ALL
           (SELECT 'kyc_submitted', kyc_submitted_at, user_id, NULL, NULL, NULL, NULL, NULL FROM companion_profiles
             WHERE kyc_submitted_at IS NOT NULL ORDER BY kyc_submitted_at DESC LIMIT 8)
           UNION ALL
           (SELECT 'kyc_approved', kyc_verified_at, user_id, NULL, NULL, NULL, NULL, NULL FROM companion_profiles
             WHERE kyc_status = 'approved' AND kyc_verified_at IS NOT NULL ORDER BY kyc_verified_at DESC LIMIT 8)
           UNION ALL
           (SELECT 'payout', created_at, companion_id, NULL, NULL, NULL, NULL, gross_paise FROM payouts
             ORDER BY created_at DESC LIMIT 8)
           UNION ALL
           (SELECT 'report', r.created_at, r.reporter_id, ru.display_name, NULL, NULL, NULL, NULL
              FROM reports r JOIN users ru ON ru.id = r.reported_id ORDER BY r.created_at DESC LIMIT 8)
         ) e JOIN users u ON u.id = e.user_id
         ORDER BY e.at DESC LIMIT 8`),
    ]);
    const l = live.rows[0]!, t = today.rows[0]!, c = counts.rows[0]!;
    return {
      live: { voiceCalls: l.voice, videoCalls: l.video, ringing: l.ringing, companionsOnline: online.length,
        callersOnline: inAppByRole.callers, companionsInApp: inAppByRole.companions },
      today: { connectedCalls: t.connected, minutesBilled: t.minutes, coinsSpent: t.coins, companionEarningsPaise: t.paise,
        purchasesPaise: t.purchases, newUsers: t.new_users, newCallers: t.new_callers, newCompanions: t.new_companions },
      yesterday: { connectedCalls: t.y_connected, coinsSpent: t.y_coins, newUsers: t.y_new_users },
      byHour: byHour.rows,
      languages: languages.rows.map(({ in_call, ...lang }) => ({ ...lang, inCall: in_call })),
      openReports: c.reports,
      openReportsByReason: Object.fromEntries(reasons.rows.map((r) => [r.reason, r.n])),
      pendingKyc: c.kyc,
      pendingPayouts: { count: c.payouts, paise: c.payout_paise },
      flaggedPayouts: c.flagged,
      billingExceptions: c.exceptions,
      openRefunds: c.refunds,
      openModeration: c.moderation,
      activity: activity.rows.map((e) => ({
        kind: e.kind, at: e.at, user: { id: e.user_id, displayName: e.display_name, role: e.role, avatarId: e.avatar_id }, otherName: e.other_name,
        callType: e.call_type, minutes: e.minutes, coins: e.coins, paise: e.paise,
      })),
    };
  });

  // -------------------------------------------------------------------------
  app.get("/admin/rates", {
    preHandler: can("pricing.manage"),
    schema: { ...base, summary: "All call rates: current, scheduled and past", response: { 200: z.array(CallRate) } },
  }, async () => {
    const rows = (await db.query<{ id: number; language_code: string; call_type: "audio" | "video"; coins_per_min: number;
      companion_paise_per_min: number; effective_from: Date; status: "current" | "scheduled" | "past" }>(
      `SELECT r.*, CASE
                WHEN r.effective_from > now() THEN 'scheduled'
                WHEN r.id = (SELECT r2.id FROM call_rates r2 WHERE r2.language_code = r.language_code AND r2.call_type = r.call_type
                               AND r2.effective_from <= now() ORDER BY r2.effective_from DESC LIMIT 1) THEN 'current'
                ELSE 'past' END AS status
         FROM call_rates r
        ORDER BY array_position(ARRAY['ta','te','kn','ml','hi','bn','mr','en'], r.language_code), r.call_type, r.effective_from DESC`,
    )).rows;
    return rows.map((r) => ({
      id: r.id, language: r.language_code, callType: r.call_type, coinsPerMin: r.coins_per_min,
      companionPaisePerMin: r.companion_paise_per_min, effectiveFrom: r.effective_from, status: r.status,
    }));
  });

  app.post("/admin/rates", {
    preHandler: can("pricing.manage"),
    schema: {
      ...base,
      summary: "Add a rate version. Calls already running keep their old rate.",
      body: z.object({
        language: LanguageCode,
        callType: z.enum(["audio", "video"]),
        coinsPerMin: z.number().int().min(1).max(1000),
        companionPaisePerMin: z.number().int().min(0).max(100_000),
        effectiveFrom: z.coerce.date().nullish().describe("Default: now"),
      }),
      response: { 201: CallRate },
    },
  }, async (req, reply) => {
    const b = req.body;
    // Never pay a companion more than ₹1 per coin the caller spends.
    if (b.companionPaisePerMin > b.coinsPerMin * 100) {
      throw new ApiError(400, "COMPANION_SHARE_TOO_HIGH", "Companion earnings can't be more than ₹1 per coin charged");
    }
    if (b.effectiveFrom && b.effectiveFrom.getTime() < Date.now() - 60_000) {
      throw new ApiError(400, "EFFECTIVE_IN_PAST", "A new rate can't start in the past");
    }
    const row = await tx(db, async (c) => {
      const lang = await c.query(`SELECT 1 FROM languages WHERE code = $1`, [b.language]);
      if (!lang.rowCount) throw new ApiError(400, "LANGUAGE_UNSUPPORTED");
      const r = (await c.query<{ id: number; effective_from: Date }>(
        `INSERT INTO call_rates (language_code, call_type, coins_per_min, companion_paise_per_min, effective_from)
         VALUES ($1, $2, $3, $4, COALESCE($5, now())) RETURNING id, effective_from`,
        [b.language, b.callType, b.coinsPerMin, b.companionPaisePerMin, b.effectiveFrom ?? null],
      )).rows[0]!;
      await audit(c, me(req).userId, "rate.create", "call_rate", r.id, { ...b });
      return r;
    });
    reply.status(201);
    return {
      id: row.id, language: b.language, callType: b.callType, coinsPerMin: b.coinsPerMin,
      companionPaisePerMin: b.companionPaisePerMin, effectiveFrom: row.effective_from,
      status: row.effective_from.getTime() > Date.now() ? "scheduled" as const : "current" as const,
    };
  });

  // -------------------------------------------------------------------------
  const toPackage = (p: { id: number; play_sku: string; coins: number; bonus_coins: number; price_paise: number;
                          label: string | null; is_active: boolean; sort_order: number }) => ({
    id: p.id, sku: p.play_sku, coins: p.coins, bonusCoins: p.bonus_coins, pricePaise: p.price_paise,
    label: p.label, isActive: p.is_active, sortOrder: p.sort_order,
  });

  app.get("/admin/coin-packages", {
    preHandler: can("pricing.manage"),
    schema: { ...base, response: { 200: z.array(CoinPackage) } },
  }, async () => (await db.query(`SELECT * FROM coin_packages ORDER BY sort_order, coins`)).rows.map(toPackage));

  const PackageBody = z.object({
    coins: z.number().int().min(1).max(1_000_000),
    bonusCoins: z.number().int().min(0).max(1_000_000),
    pricePaise: z.number().int().min(100).max(10_000_000),
    label: z.string().trim().max(24).nullish(),
    isActive: z.boolean(),
    sortOrder: z.number().int().min(0).max(1000),
  });

  app.put("/admin/coin-packages/:id", {
    preHandler: can("pricing.manage"),
    schema: {
      ...base,
      summary: "Edit a coin pack. The Google Play product price must be changed to match in Play Console.",
      params: z.object({ id: z.coerce.number().int() }),
      body: PackageBody,
      response: { 200: CoinPackage },
    },
  }, async (req) => {
    const b = req.body;
    return tx(db, async (c) => {
      const before = (await c.query(`SELECT * FROM coin_packages WHERE id = $1 FOR UPDATE`, [req.params.id])).rows[0];
      if (!before) throw notFound("PACKAGE_NOT_FOUND");
      const after = (await c.query(
        `UPDATE coin_packages SET coins = $2, bonus_coins = $3, price_paise = $4, label = $5, is_active = $6, sort_order = $7
          WHERE id = $1 RETURNING *`,
        [req.params.id, b.coins, b.bonusCoins, b.pricePaise, b.label || null, b.isActive, b.sortOrder],
      )).rows[0];
      await audit(c, me(req).userId, "package.update", "coin_package", req.params.id,
        { before: toPackage(before), after: toPackage(after) });
      return toPackage(after);
    });
  });

  app.post("/admin/coin-packages", {
    preHandler: can("pricing.manage"),
    schema: {
      ...base,
      summary: "Add a coin pack. Create the Google Play product with the same SKU first.",
      body: PackageBody.extend({ sku: z.string().regex(/^[a-z0-9_.]{3,100}$/, "Lowercase letters, digits, _ and . only") }),
      response: { 201: CoinPackage },
    },
  }, async (req, reply) => {
    const b = req.body;
    const row = await tx(db, async (c) => {
      const r = (await c.query(
        `INSERT INTO coin_packages (play_sku, coins, bonus_coins, price_paise, label, is_active, sort_order)
         VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (play_sku) DO NOTHING RETURNING *`,
        [b.sku, b.coins, b.bonusCoins, b.pricePaise, b.label || null, b.isActive, b.sortOrder],
      )).rows[0];
      if (!r) throw new ApiError(409, "SKU_EXISTS", "A pack with that Play SKU already exists");
      await audit(c, me(req).userId, "package.create", "coin_package", r.id, { ...b });
      return r;
    });
    reply.status(201);
    return toPackage(row);
  });

  // -------------------------------------------------------------------------
  app.get("/admin/reports", {
    preHandler: can("reports.review"),
    schema: {
      ...base,
      querystring: z.object({
        status: z.enum(["open", "actioned", "dismissed"]).default("open"),
        limit: z.coerce.number().int().min(1).max(1000).default(50),
      }),
      response: { 200: z.array(Report) },
    },
  }, async (req) => {
    const rows = (await db.query<{
      id: string; created_at: Date; reason: string; details: string | null; status: string; call_id: string | null;
      resolution_note: string | null; resolved_at: Date | null;
      r_id: string | null; r_name: string | null; r_role: string | null; t_id: string; t_name: string; t_role: string; t_status: string; t_reports: number;
      rec: "recording" | "ready" | "failed" | "deleted" | "disabled" | null;
    }>(
      `SELECT rp.id, rp.created_at, rp.reason, rp.details, rp.status, rp.call_id, rp.resolution_note, rp.resolved_at,
              r.id AS r_id, r.display_name AS r_name, r.role AS r_role,
              t.id AS t_id, t.display_name AS t_name, t.role AS t_role, t.status AS t_status,
              (SELECT rr.status FROM report_recordings rr WHERE rr.report_id = rp.id ORDER BY rr.started_at DESC LIMIT 1) AS rec,
              (SELECT count(*) FROM reports x WHERE x.reported_id = t.id)::int AS t_reports
         FROM reports rp LEFT JOIN users r ON r.id = rp.reporter_id JOIN users t ON t.id = rp.reported_id
        WHERE rp.status = $1 ORDER BY rp.created_at DESC LIMIT $2`,
      [req.query.status, req.query.limit],
    )).rows;
    return rows.map((r) => ({
      id: r.id, createdAt: r.created_at, reason: r.reason, details: r.details, status: r.status, callId: r.call_id,
      reporter: r.r_id ? { id: r.r_id, displayName: r.r_name!, role: r.r_role! } : { id: null, displayName: "Safety check (automatic)", role: "system" },
      reported: { id: r.t_id, displayName: r.t_name, role: r.t_role, status: r.t_status, reportsAgainst: r.t_reports },
      resolutionNote: r.resolution_note, resolvedAt: r.resolved_at, recording: r.rec,
    }));
  });

  /** Suspends a user everywhere: account, sessions, presence and any live call. */
  async function suspend(c: DbClient, userId: string, status: "suspended" | "banned") {
    await c.query(`UPDATE users SET status = $2 WHERE id = $1`, [userId, status]);
    await c.query(`UPDATE sessions SET revoked_at = now() WHERE user_id = $1 AND revoked_at IS NULL`, [userId]);
  }
  async function afterSuspend(userId: string) {
    await goOffline(redis, userId);
    const live = await db.query<{ id: string }>(
      `SELECT id FROM calls WHERE status IN ('ringing', 'active') AND (caller_id = $1 OR companion_id = $1)`, [userId],
    );
    for (const call of live.rows) await engine.endCall(call.id, "admin");
    await endLivesOf({ db, events: app.deps.events, rooms: app.deps.rooms, push: app.deps.push }, userId, "admin");
    await endGroupsOf({ db, events: app.deps.events, rooms: app.deps.rooms, push: app.deps.push }, userId, "admin");
  }

  // -------------------------------------------------------------------------
  // Video moderation: frames the app flagged as nudity (routes/moderation.ts).
  app.get("/admin/moderation", {
    preHandler: can("moderation.review"),
    schema: {
      ...base,
      summary: "Video frames flagged for nudity by the app, oldest open first",
      querystring: z.object({
        status: z.enum(["open", "dismissed", "actioned"]).default("open"),
        limit: z.coerce.number().int().min(1).max(1000).default(200),
      }),
      response: { 200: z.array(ModerationFlag) },
    },
  }, async (req) => (await db.query<{ id: string; created_at: Date; score: number; status: string; note: string | null;
    reviewed_at: Date | null; reviewer: string | null; has_frame: boolean; call_id: string | null; call_type: "audio" | "video" | null;
    live_id: string | null;
    group_id: string | null;
    subject_id: string; subject_name: string; subject_role: string; subject_status: string; subject_flags: number;
    detector_id: string; detector_name: string; detector_role: string }>(
    `SELECT m.id, m.created_at, m.score, m.status, m.note, m.reviewed_at, rv.display_name AS reviewer,
            m.storage_key IS NOT NULL AS has_frame, c.id AS call_id, c.type AS call_type, m.live_id, m.group_id,
            s.id AS subject_id, s.display_name AS subject_name, s.role AS subject_role, s.status AS subject_status,
            (SELECT count(*) FROM moderation_flags x WHERE x.subject_id = s.id)::int AS subject_flags,
            d.id AS detector_id, d.display_name AS detector_name, d.role AS detector_role
       FROM moderation_flags m
       LEFT JOIN calls c ON c.id = m.call_id
       JOIN users s ON s.id = m.subject_id
       JOIN users d ON d.id = m.detected_by
       LEFT JOIN users rv ON rv.id = m.reviewed_by
      WHERE m.status = $1
      ORDER BY m.created_at ${req.query.status === "open" ? "ASC" : "DESC"} LIMIT $2`, [req.query.status, req.query.limit],
  )).rows.map((m) => ({
    id: m.id, createdAt: m.created_at, score: m.score, status: m.status as "open" | "dismissed" | "actioned", note: m.note,
    reviewedAt: m.reviewed_at, reviewer: m.reviewer, hasFrame: m.has_frame,
    call: m.call_id ? { id: m.call_id, type: m.call_type! } : null, liveId: m.live_id, groupId: m.group_id,
    subject: { id: m.subject_id, displayName: m.subject_name, role: m.subject_role, status: m.subject_status, flags: m.subject_flags },
    detectedBy: { id: m.detector_id, displayName: m.detector_name, role: m.detector_role },
  })));

  app.get("/admin/moderation/:id/frame", {
    preHandler: can("moderation.review"),
    schema: {
      ...base,
      summary: "The flagged frame (decrypted). Every view is audit-logged.",
      params: z.object({ id: z.uuid() }),
    },
  }, async (req, reply) => {
    const m = (await db.query<{ storage_key: string | null; subject_id: string }>(
      `SELECT storage_key, subject_id FROM moderation_flags WHERE id = $1`, [req.params.id])).rows[0];
    if (!m) throw notFound("FLAG_NOT_FOUND");
    if (!m.storage_key) throw new ApiError(410, "FRAME_DELETED", "This frame was deleted under the retention policy");
    const bytes = await store.get(m.storage_key);
    await tx(db, (c) => audit(c, me(req).userId, "moderation.view", "user", m.subject_id, { flagId: req.params.id }));
    return reply.header("cache-control", "no-store, private").type("image/jpeg").send(bytes);
  });

  app.post("/admin/moderation/:id/resolve", {
    preHandler: can("moderation.review"),
    schema: {
      ...base,
      summary: "Dismiss a flagged frame (false alarm), or act on it by suspending or banning the person on video",
      params: z.object({ id: z.uuid() }),
      body: z.object({ decision: z.enum(["dismiss", "suspend", "ban"]), note: z.string().trim().min(3).max(500) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { decision, note } = req.body;
    const subject = await tx(db, async (c) => {
      const m = (await c.query<{ status: string; subject_id: string; subject_role: string }>(
        `SELECT m.status, m.subject_id, u.role AS subject_role FROM moderation_flags m JOIN users u ON u.id = m.subject_id
          WHERE m.id = $1 FOR UPDATE OF m`, [req.params.id])).rows[0];
      if (!m) throw notFound("FLAG_NOT_FOUND");
      if (m.status !== "open") throw conflict("FLAG_CLOSED", "This flag was already reviewed");
      if (decision !== "dismiss" && m.subject_role === "admin") throw new ApiError(400, "CANNOT_TARGET_ADMIN", "Admins can't be suspended here");
      await c.query(`UPDATE moderation_flags SET status = $2, reviewed_by = $3, reviewed_at = now(), note = $4 WHERE id = $1`,
        [req.params.id, decision === "dismiss" ? "dismissed" : "actioned", me(req).userId, note]);
      if (decision !== "dismiss") await suspend(c, m.subject_id, decision === "ban" ? "banned" : "suspended");
      await audit(c, me(req).userId, `moderation.${decision}`, "user", m.subject_id, { flagId: req.params.id, note });
      return m.subject_id;
    });
    if (decision !== "dismiss") await afterSuspend(subject);
    return reply.status(204).send(null);
  });

  app.post("/admin/reports/:id/resolve", {
    preHandler: can("reports.review"),
    schema: {
      ...base,
      summary: "Dismiss a report, or act on it by suspending the reported user",
      params: z.object({ id: z.uuid() }),
      body: z.object({ decision: z.enum(["dismiss", "suspend"]), note: z.string().trim().min(3).max(1000) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { decision, note } = req.body;
    const { reported, reporter } = await tx(db, async (c) => {
      const r = (await c.query<{ reported_id: string; reporter_id: string | null; status: string }>(
        `SELECT reported_id, reporter_id, status FROM reports WHERE id = $1 FOR UPDATE`, [req.params.id],
      )).rows[0];
      if (!r) throw notFound("REPORT_NOT_FOUND");
      if (r.status !== "open") throw new ApiError(409, "REPORT_CLOSED", "This report was already handled");
      await c.query(
        `UPDATE reports SET status = $2, handled_by = $3, resolution_note = $4, resolved_at = now() WHERE id = $1`,
        [req.params.id, decision === "dismiss" ? "dismissed" : "actioned", me(req).userId, note],
      );
      if (decision === "suspend") await suspend(c, r.reported_id, "suspended");
      await audit(c, me(req).userId, "report.resolve", "report", req.params.id, { decision, note, reportedId: r.reported_id });
      return { reported: r.reported_id, reporter: r.reporter_id };
    });
    if (decision === "suspend") await afterSuspend(reported);
    if (reporter) await notify(app.deps, reporter, decision === "suspend"
      ? { type: "report_actioned", title: "We acted on your report", body: "Thanks for keeping Hello Dude! safe." }
      : { type: "report_actioned", title: "We reviewed your report", body: "We didn't find a rule break this time. Thanks for telling us." });
    // Kit rule: the recording is deleted once the report is closed.
    const recs = (await db.query<{ id: string; egress_id: string | null; storage_key: string | null; status: string }>(
      `SELECT id, egress_id, storage_key, status FROM report_recordings WHERE report_id = $1 AND status IN ('recording', 'ready')`,
      [req.params.id])).rows;
    for (const r of recs) {
      if (r.status === "recording" && r.egress_id) await recorder.stop(r.egress_id).catch(() => {});
      if (r.storage_key) await store.delete(r.storage_key).catch(() => {});
      await db.query(`UPDATE report_recordings SET status = 'deleted', deleted_at = now() WHERE id = $1`, [r.id]);
    }
    return reply.status(204).send(null);
  });

  // -------------------------------------------------------------------------
  app.get("/admin/gifts", {
    preHandler: can("pricing.manage"),
    schema: { ...base, response: { 200: z.array(AdminGift) } },
  }, async () => (await db.query(`SELECT * FROM gifts ORDER BY sort_order, coins`)).rows.map((g) => ({
    id: g.id, code: g.code, name: g.name, emoji: g.emoji, coins: g.coins, isActive: g.is_active, sortOrder: g.sort_order,
  })));

  app.put("/admin/gifts/:id", {
    preHandler: can("pricing.manage"),
    schema: {
      ...base,
      params: z.object({ id: z.coerce.number().int() }),
      body: z.object({ name: z.string().trim().min(1).max(20), emoji: z.string().trim().min(1).max(8),
        coins: z.number().int().min(1).max(100_000), isActive: z.boolean(), sortOrder: z.number().int().min(0).max(1000) }),
      response: { 200: AdminGift },
    },
  }, async (req) => tx(db, async (c) => {
    const before = (await c.query(`SELECT * FROM gifts WHERE id = $1 FOR UPDATE`, [req.params.id])).rows[0];
    if (!before) throw notFound("GIFT_NOT_FOUND");
    const b = req.body;
    const g = (await c.query(
      `UPDATE gifts SET name = $2, emoji = $3, coins = $4, is_active = $5, sort_order = $6 WHERE id = $1 RETURNING *`,
      [req.params.id, b.name, b.emoji, b.coins, b.isActive, b.sortOrder])).rows[0];
    await audit(c, me(req).userId, "gift.update", "gift", req.params.id, { before: { coins: before.coins, isActive: before.is_active }, after: b });
    return { id: g.id, code: g.code, name: g.name, emoji: g.emoji, coins: g.coins, isActive: g.is_active, sortOrder: g.sort_order };
  }));

  app.post("/admin/gifts", {
    preHandler: can("pricing.manage"),
    schema: {
      ...base,
      summary: "Add a gift. Its code is made from the name and never changes (the app and ledger refer to it).",
      body: z.object({ name: z.string().trim().min(1).max(20), emoji: z.string().trim().min(1).max(8),
        coins: z.number().int().min(1).max(100_000), isActive: z.boolean().default(true) }),
      response: { 201: AdminGift },
    },
  }, async (req, reply) => {
    const b = req.body;
    const code = b.name.toLowerCase().normalize("NFKD").replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "") || "gift";
    const g = await tx(db, async (c) => {
      if ((await c.query(`SELECT 1 FROM gifts WHERE code = $1`, [code])).rowCount) {
        throw new ApiError(409, "GIFT_EXISTS", `A gift called "${b.name}" already exists`);
      }
      const row = (await c.query(
        `INSERT INTO gifts (code, name, emoji, coins, is_active, sort_order)
         VALUES ($1, $2, $3, $4, $5, (SELECT COALESCE(max(sort_order), 0) + 1 FROM gifts)) RETURNING *`,
        [code, b.name, b.emoji, b.coins, b.isActive])).rows[0];
      await audit(c, me(req).userId, "gift.create", "gift", row.id, { code, ...b });
      return row;
    });
    return reply.status(201).send({ id: g.id, code: g.code, name: g.name, emoji: g.emoji, coins: g.coins, isActive: g.is_active, sortOrder: g.sort_order });
  });

  app.get("/admin/settings", {
    preHandler: can("pricing.manage"),
    schema: {
      ...base,
      response: { 200: z.array(z.object({ key: z.string(), label: z.string(), value: z.number(), min: z.number(), max: z.number() })) },
    },
  }, async () => {
    const rows = (await db.query<{ key: string; value: unknown }>(`SELECT key, value FROM app_settings WHERE key = ANY($1)`, [Object.keys(SETTINGS)])).rows;
    return Object.entries(SETTINGS).map(([key, s]) => ({ key, ...s, value: Number(rows.find((r) => r.key === key)?.value ?? 0) }));
  });

  app.put("/admin/settings/:key", {
    preHandler: can("pricing.manage"),
    schema: {
      ...base,
      params: z.object({ key: z.string() }),
      body: z.object({ value: z.number().int() }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const s = SETTINGS[req.params.key];
    if (!s) throw notFound("SETTING_NOT_FOUND");
    if (req.body.value < s.min || req.body.value > s.max) throw new ApiError(400, "OUT_OF_RANGE", `${s.label} must be between ${s.min} and ${s.max}`);
    await tx(db, async (c) => {
      const before = (await c.query<{ value: unknown }>(`SELECT value FROM app_settings WHERE key = $1`, [req.params.key])).rows[0];
      await c.query(`INSERT INTO app_settings (key, value, updated_at) VALUES ($1, $2, now())
                     ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now()`, [req.params.key, JSON.stringify(req.body.value)]);
      await audit(c, me(req).userId, "setting.update", "setting", req.params.key, { from: before?.value ?? null, to: req.body.value });
    });
    return reply.status(204).send(null);
  });

  // -------------------------------------------------------------------------
  app.get("/admin/users", {
    preHandler: can("users.view"),
    schema: {
      ...base,
      summary: "Search callers or companions by name or the last digits of their number",
      querystring: z.object({
        role: z.enum(["caller", "companion", "admin"]).default("caller"),
        q: z.string().trim().max(40).optional(),
        status: z.enum(["active", "suspended", "banned"]).optional(),
        limit: z.coerce.number().int().min(1).max(1000).default(50),
        offset: z.coerce.number().int().min(0).default(0),
      }),
      response: { 200: z.object({ users: z.array(AdminUser), total: z.number().int() }) },
    },
  }, async (req) => {
    const { role, q, status, limit, offset } = req.query;
    const digits = q?.replace(/\D/g, "");
    const where = `u.role = $1 AND u.status <> 'deleted' AND ($2::text IS NULL OR u.status::text = $2)
      AND ($3::text IS NULL OR u.display_name ILIKE '%' || $3 || '%' OR ($4::text <> '' AND u.phone LIKE '%' || $4))`;
    const params = [role, status ?? null, q || null, digits ?? ""];
    const [rows, total] = await Promise.all([
      db.query<{ id: string; display_name: string; phone: string; role: z.infer<typeof AdminUser>["role"];
        status: z.infer<typeof AdminUser>["status"]; primary_language: string; created_at: Date; coins: number; earnings: number;
        calls: number; reports: number; kyc_status: "pending" | "approved" | "rejected" | null; last_seen: Date | null; avatar_id: number }>(
        `SELECT u.id, u.display_name, u.phone, u.role, u.status, u.primary_language, u.created_at, u.avatar_id,
                COALESCE((SELECT balance FROM wallets WHERE user_id = u.id AND kind = 'coins'), 0) AS coins,
                COALESCE((SELECT balance FROM wallets WHERE user_id = u.id AND kind = 'earnings'), 0) AS earnings,
                (SELECT count(*) FROM calls c WHERE c.started_at IS NOT NULL AND (c.caller_id = u.id OR c.companion_id = u.id))::int AS calls,
                (SELECT count(*) FROM reports r WHERE r.reported_id = u.id)::int AS reports,
                p.kyc_status,
                GREATEST(p.last_online_at, u.last_active_at,
                         (SELECT max(created_at) FROM sessions s WHERE s.user_id = u.id),
                         (SELECT max(COALESCE(c.ended_at, c.started_at)) FROM calls c
                           WHERE c.caller_id = u.id OR c.companion_id = u.id)) AS last_seen
           FROM users u LEFT JOIN companion_profiles p ON p.user_id = u.id
          WHERE ${where} ORDER BY u.created_at DESC LIMIT $5 OFFSET $6`,
        [...params, limit, offset]),
      db.query<{ n: number }>(`SELECT count(*)::int AS n FROM users u WHERE ${where}`, params),
    ]);
    const taking = new Set(await redis.smembers(ONLINE_SET));
    const inApp = await inAppSet(redis, rows.rows.map((u) => u.id));
    return {
      total: total.rows[0]!.n,
      users: rows.rows.map((u) => ({
        id: u.id, displayName: u.display_name, phone: maskPhone(u.phone), role: u.role, status: u.status,
        primaryLanguage: u.primary_language, createdAt: u.created_at, coins: u.coins, earningsPaise: u.earnings,
        calls: u.calls, reportsAgainst: u.reports, kycStatus: u.kyc_status,
        online: inApp.has(u.id) || taking.has(u.id), takingCalls: taking.has(u.id),
        lastSeenAt: inApp.has(u.id) ? new Date() : u.last_seen, avatarId: u.avatar_id,
      })),
    };
  });

  app.get("/admin/users/:id", {
    preHandler: can("users.view"),
    schema: {
      ...base,
      summary: "Everything about one caller or companion: profile, wallets, calls, money and safety history",
      params: z.object({ id: z.uuid() }),
      response: { 200: AdminUserDetail },
    },
  }, async (req) => {
    const id = req.params.id;
    const u = (await db.query<{ id: string; display_name: string; phone: string; gender: string; role: z.infer<typeof AdminUser>["role"];
      status: z.infer<typeof AdminUser>["status"]; primary_language: string; avatar_id: number; created_at: Date;
      terms_accepted_at: Date | null; kyc_status: "pending" | "approved" | "rejected" | null; kyc_verified_at: Date | null;
      video_enabled: boolean | null; bio: string | null; upi_id: string | null; rating_sum: number | null; rating_count: number | null;
      last_online_at: Date | null; last_active_at: Date | null }>(
      `SELECT u.id, u.display_name, u.phone, u.gender::text AS gender, u.role, u.status, u.primary_language, u.avatar_id,
              u.created_at, u.terms_accepted_at, p.kyc_status, p.kyc_verified_at, p.video_enabled, p.bio, p.upi_id,
              p.rating_sum, p.rating_count, p.last_online_at, u.last_active_at
         FROM users u LEFT JOIN companion_profiles p ON p.user_id = u.id WHERE u.id = $1`, [id])).rows[0];
    if (!u) throw notFound("USER_NOT_FOUND");

    const q = <T extends object>(sql: string) => db.query<T>(sql, [id]).then((r) => r.rows);
    const [languages, wallets, stats, calls, ledger, purchases, payouts, reports, refunds, extra, auditRows, notes] = await Promise.all([
      q<{ code: string }>(`SELECT language_code AS code FROM user_languages WHERE user_id = $1 ORDER BY 1`),
      q<{ kind: "coins" | "earnings"; balance: number }>(`SELECT kind, balance FROM wallets WHERE user_id = $1`),
      q<{ calls: number; minutes: number; coins: number; paise: number; missed: number }>(
        `SELECT count(*) FILTER (WHERE started_at IS NOT NULL)::int AS calls,
                COALESCE(sum(minutes_charged), 0)::bigint AS minutes,
                COALESCE(sum(coins_charged) FILTER (WHERE caller_id = $1), 0)::bigint AS coins,
                COALESCE(sum(paise_credited) FILTER (WHERE companion_id = $1), 0)::bigint AS paise,
                count(*) FILTER (WHERE status = 'missed')::int AS missed
           FROM calls WHERE caller_id = $1 OR companion_id = $1`),
      q<{ id: string; created_at: Date; type: "audio" | "video"; status: string; language_code: string; other_id: string;
          other_name: string; as_caller: boolean; seconds: number | null; minutes_charged: number; coins_charged: number;
          paise_credited: number; end_reason: string | null; stars: number | null; gift_coins: number }>(
        `SELECT c.id, c.created_at, c.type, c.status::text AS status, c.language_code,
                o.id AS other_id, o.display_name AS other_name, c.caller_id = $1 AS as_caller,
                EXTRACT(EPOCH FROM (c.ended_at - c.started_at))::int AS seconds,
                c.minutes_charged, c.coins_charged, c.paise_credited, c.end_reason, r.stars,
                COALESCE((SELECT sum(g.coins) FROM call_gifts g WHERE g.call_id = c.id), 0)::bigint AS gift_coins
           FROM calls c
           JOIN users o ON o.id = CASE WHEN c.caller_id = $1 THEN c.companion_id ELSE c.caller_id END
           LEFT JOIN call_ratings r ON r.call_id = c.id
          WHERE c.caller_id = $1 OR c.companion_id = $1
          ORDER BY c.created_at DESC LIMIT 500`),
      q<{ id: number; created_at: Date; kind: "coins" | "earnings"; type: string; amount: number; balance_after: number;
          note: string | null; call_id: string | null }>(
        `SELECT l.id, l.created_at, w.kind, l.type::text AS type, l.amount, l.balance_after, l.note, l.call_id
           FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
          WHERE w.user_id = $1 ORDER BY l.id DESC LIMIT 500`),
      q<{ id: string; created_at: Date; coins_credited: number; status: string; price_paise: number; label: string | null; sku: string }>(
        `SELECT p.id, p.created_at, p.coins_credited, p.status::text AS status, k.price_paise, k.label, k.play_sku AS sku
           FROM purchases p JOIN coin_packages k ON k.id = p.package_id
          WHERE p.user_id = $1 ORDER BY p.created_at DESC LIMIT 500`),
      q<{ id: string; created_at: Date; gross_paise: number; tds_paise: number; net_paise: number; upi_id: string;
          status: string; failure_reason: string | null; processed_at: Date | null }>(
        `SELECT id, created_at, gross_paise, tds_paise, net_paise, upi_id, status::text AS status, failure_reason, processed_at
           FROM payouts WHERE companion_id = $1 ORDER BY created_at DESC LIMIT 500`),
      q<{ id: string; created_at: Date; against: boolean; other_id: string | null; other_name: string | null; reason: string;
          details: string | null; status: string; call_id: string | null }>(
        `SELECT r.id, r.created_at, r.reported_id = $1 AS against, o.id AS other_id, o.display_name AS other_name,
                r.reason, r.details, r.status, r.call_id
           FROM reports r LEFT JOIN users o ON o.id = CASE WHEN r.reported_id = $1 THEN r.reporter_id ELSE r.reported_id END
          WHERE r.reported_id = $1 OR r.reporter_id = $1 ORDER BY r.created_at DESC LIMIT 500`),
      q<{ id: string; created_at: Date; call_id: string; reason: string; status: string; coins_eligible: number;
          coins_refunded: number; by_user: boolean }>(
        `SELECT f.id, f.created_at, f.call_id, f.reason, f.status::text AS status, f.coins_eligible, f.coins_refunded,
                f.user_id = $1 AS by_user
           FROM refund_requests f JOIN calls c ON c.id = f.call_id
          WHERE f.user_id = $1 OR c.companion_id = $1 ORDER BY f.created_at DESC LIMIT 500`),
      q<{ gifts_sent: number; gifts_sent_coins: number; gifts_received: number; gifts_received_paise: number;
          favourites: number; followers: number; blocked_by: number; blocking: number; active_sessions: number;
          last_sign_in: Date | null; devices: number; academy_passed: number; academy_total: number; ratings_given: number }>(
        `SELECT (SELECT count(*) FROM call_gifts WHERE sender_id = $1)::int AS gifts_sent,
                (SELECT COALESCE(sum(coins), 0) FROM call_gifts WHERE sender_id = $1)::bigint AS gifts_sent_coins,
                (SELECT count(*) FROM call_gifts WHERE receiver_id = $1)::int AS gifts_received,
                (SELECT COALESCE(sum(paise_credited), 0) FROM call_gifts WHERE receiver_id = $1)::bigint AS gifts_received_paise,
                (SELECT count(*) FROM favourites WHERE user_id = $1)::int AS favourites,
                (SELECT count(*) FROM favourites WHERE companion_id = $1)::int AS followers,
                (SELECT count(*) FROM blocks WHERE blocked_id = $1)::int AS blocked_by,
                (SELECT count(*) FROM blocks WHERE blocker_id = $1)::int AS blocking,
                (SELECT count(*) FROM sessions WHERE user_id = $1 AND revoked_at IS NULL AND expires_at > now())::int AS active_sessions,
                (SELECT max(created_at) FROM sessions WHERE user_id = $1) AS last_sign_in,
                (SELECT count(*) FROM devices WHERE user_id = $1)::int AS devices,
                (SELECT count(*) FROM academy_progress WHERE user_id = $1)::int AS academy_passed,
                (SELECT count(*) FROM academy_lessons)::int AS academy_total,
                (SELECT count(*) FROM call_ratings WHERE rater_id = $1)::int AS ratings_given`),
      q<{ id: number; created_at: Date; actor: string; action: string; details: Record<string, unknown> }>(
        `SELECT a.id, a.created_at, x.display_name AS actor, a.action, a.details
           FROM audit_log a JOIN users x ON x.id = a.actor_id
          WHERE a.target_id = $1::text ORDER BY a.id DESC LIMIT 100`),
      q<{ id: number; created_at: Date; author: string; body: string }>(
        `SELECT n.id, n.created_at, a.display_name AS author, n.body
           FROM admin_notes n JOIN users a ON a.id = n.author_id
          WHERE n.user_id = $1 ORDER BY n.id DESC LIMIT 50`),
    ]);
    const s = stats[0]!;
    const e = extra[0]!;
    const taking = (await redis.sismember(ONLINE_SET, id)) === 1;
    const inApp = (await inAppSet(redis, [id])).has(id);
    const maskUpi = (v: string) => v.replace(/^(.{2}).*(@.*)$/, "$1••••$2");
    return {
      id: u.id, displayName: u.display_name, phone: maskPhone(u.phone), gender: u.gender, role: u.role, status: u.status,
      primaryLanguage: u.primary_language, languages: languages.map((l) => l.code), avatarId: u.avatar_id,
      createdAt: u.created_at, termsAcceptedAt: u.terms_accepted_at, online: inApp || taking, takingCalls: taking,
      lastActiveAt: inApp ? new Date() : u.last_active_at,
      lastSignInAt: e.last_sign_in, activeSessions: e.active_sessions, devices: e.devices,
      coins: wallets.find((w) => w.kind === "coins")?.balance ?? 0,
      earningsPaise: wallets.find((w) => w.kind === "earnings")?.balance ?? 0,
      stats: {
        calls: s.calls, missedCalls: s.missed, minutes: s.minutes, coinsSpent: s.coins, paiseEarned: s.paise,
        giftsSent: e.gifts_sent, giftsSentCoins: e.gifts_sent_coins, giftsReceived: e.gifts_received,
        giftsReceivedPaise: e.gifts_received_paise, favourites: e.favourites, followers: e.followers,
        blockedBy: e.blocked_by, blocking: e.blocking, ratingsGiven: e.ratings_given,
        reportsAgainst: reports.filter((r) => r.against).length, reportsMade: reports.filter((r) => !r.against).length,
      },
      companion: u.role === "companion" ? {
        kycStatus: u.kyc_status, kycVerifiedAt: u.kyc_verified_at, videoEnabled: u.video_enabled ?? false, bio: u.bio,
        upiId: u.upi_id ? maskUpi(u.upi_id) : null, lastOnlineAt: u.last_online_at,
        rating: u.rating_count ? Math.round((u.rating_sum! / u.rating_count) * 10) / 10 : null, ratingCount: u.rating_count ?? 0,
        academyPassed: e.academy_passed, academyTotal: e.academy_total,
      } : null,
      calls: calls.map((c) => ({
        id: c.id, createdAt: c.created_at, type: c.type, status: c.status, language: c.language_code,
        direction: c.as_caller ? "outgoing" as const : "incoming" as const, other: { id: c.other_id, displayName: c.other_name },
        seconds: c.seconds, minutes: c.minutes_charged, coins: c.coins_charged, paise: c.paise_credited,
        endReason: c.end_reason, stars: c.stars, giftCoins: c.gift_coins,
      })),
      ledger: ledger.map((l) => ({ id: l.id, createdAt: l.created_at, wallet: l.kind, type: l.type, amount: l.amount,
        balanceAfter: l.balance_after, note: l.note, callId: l.call_id })),
      purchases: purchases.map((p) => ({ id: p.id, createdAt: p.created_at, sku: p.sku, label: p.label,
        pricePaise: p.price_paise, coins: p.coins_credited, status: p.status })),
      payouts: payouts.map((p) => ({ id: p.id, createdAt: p.created_at, grossPaise: p.gross_paise, tdsPaise: p.tds_paise,
        netPaise: p.net_paise, upiId: maskUpi(p.upi_id), status: p.status, failureReason: p.failure_reason, processedAt: p.processed_at })),
      reports: reports.map((r) => ({ id: r.id, createdAt: r.created_at, direction: r.against ? "against" as const : "by" as const,
        other: { id: r.other_id, displayName: r.other_name ?? "Safety check (automatic)" }, reason: r.reason, details: r.details, status: r.status, callId: r.call_id })),
      refunds: refunds.map((f) => ({ id: f.id, createdAt: f.created_at, callId: f.call_id, reason: f.reason, status: f.status,
        coinsEligible: f.coins_eligible, coinsRefunded: f.coins_refunded, byUser: f.by_user })),
      audit: auditRows.map((a) => ({ id: a.id, createdAt: a.created_at, actor: a.actor, action: a.action, details: a.details })),
      notes: notes.map((n) => ({ id: n.id, createdAt: n.created_at, author: n.author, body: n.body })),
      vip: await activeVip(db, id),
    };
  });

  /** Locks the target account; admins and deleted accounts can't be acted on here. */
  async function targetUser(c: DbClient, id: string) {
    const u = (await c.query<{ role: "caller" | "companion" | "admin"; status: string; display_name: string }>(
      `SELECT role, status, display_name FROM users WHERE id = $1 FOR UPDATE`, [id])).rows[0];
    if (!u || u.status === "deleted") throw notFound("USER_NOT_FOUND");
    if (u.role === "admin") throw new ApiError(400, "CANNOT_TARGET_ADMIN", "This works on callers and companions only");
    return u;
  }

  app.post("/admin/users/:id/notes", {
    preHandler: can("users.manage"),
    schema: {
      ...base,
      summary: "Add a private admin note to a caller or companion",
      params: z.object({ id: z.uuid() }),
      body: z.object({ body: z.string().trim().min(1).max(2000) }),
      response: { 201: AdminNote },
    },
  }, async (req, reply) => {
    const note = await tx(db, async (c) => {
      await targetUser(c, req.params.id);
      const n = (await c.query<{ id: number; created_at: Date }>(
        `INSERT INTO admin_notes (user_id, author_id, body) VALUES ($1, $2, $3) RETURNING id, created_at`,
        [req.params.id, me(req).userId, req.body.body])).rows[0]!;
      const author = (await c.query<{ display_name: string }>(`SELECT display_name FROM users WHERE id = $1`, [me(req).userId])).rows[0]!;
      await audit(c, me(req).userId, "user.note", "user", req.params.id, { noteId: n.id });
      return { id: n.id, createdAt: n.created_at, author: author.display_name, body: req.body.body };
    });
    return reply.status(201).send(note);
  });

  app.post("/admin/users/:id/coins", {
    preHandler: can("users.coins"),
    schema: {
      ...base,
      summary: "Give a caller free coins (goodwill / compensation). Written to the ledger and the audit log",
      params: z.object({ id: z.uuid() }),
      body: z.object({
        coins: z.number().int().min(1).max(10_000),
        reason: z.string().trim().min(3).max(500),
        requestId: z.uuid().describe("Generated by the panel per attempt; a retried click can't credit twice"),
      }),
      response: { 200: z.object({ coins: z.number().int() }) },
    },
  }, async (req) => {
    const { coins, reason, requestId } = req.body;
    const balance = await tx(db, async (c) => {
      const u = await targetUser(c, req.params.id);
      if (u.role !== "caller") throw new ApiError(400, "NOT_A_CALLER", "Coins can only be sent to callers");
      const done = await c.query(`SELECT 1 FROM ledger_entries WHERE idempotency_key = $1`, [`admin_coins:${requestId}`]);
      if (done.rowCount) throw conflict("DUPLICATE_REQUEST", "These coins were already sent");
      const after = await post(c, req.params.id, "coins", "adjustment", coins, `admin_coins:${requestId}`, { note: `From support: ${reason}` });
      await audit(c, me(req).userId, "user.coins", "user", req.params.id, { coins, reason, balanceAfter: after });
      return after!;
    });
    await notify(app.deps, req.params.id, {
      type: "support_coins", title: `You got ${coins} free ${coins === 1 ? "coin" : "coins"} 🎉`, body: "A gift from the Hello Dude! team. Happy talking!",
    });
    return { coins: balance };
  });

  app.post("/admin/users/:id/vip", {
    preHandler: can("users.vip"),
    schema: {
      ...base,
      summary: "Give a caller VIP for some days (extends an active VIP). Audited; the caller is notified.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ days: z.number().int().min(1).max(366), reason: z.string().trim().min(3).max(500) }),
      response: { 200: z.object({ expiresAt: z.date() }) },
    },
  }, async (req) => {
    const { days, reason } = req.body;
    const expiresAt = await tx(db, async (c) => {
      const u = await targetUser(c, req.params.id);
      if (u.role !== "caller") throw new ApiError(400, "NOT_A_CALLER", "VIP is for callers");
      const current = await activeVip(c, req.params.id);
      const from = current ? current.expiresAt : new Date();
      const until = new Date(from.getTime() + days * 86_400_000);
      await c.query(
        `INSERT INTO vip_subscriptions (user_id, source, starts_at, expires_at, granted_by, note) VALUES ($1, 'admin', now(), $2, $3, $4)`,
        [req.params.id, until, me(req).userId, reason]);
      await audit(c, me(req).userId, "user.vip_grant", "user", req.params.id, { days, reason, expiresAt: until.toISOString() });
      return until;
    });
    await notify(app.deps, req.params.id, {
      type: "vip", title: "You're VIP 👑", body: `Enjoy cheaper calls, first pick and a free Rose every week, until ${expiresAt.toLocaleDateString("en-IN", { day: "numeric", month: "short", timeZone: "Asia/Kolkata" })}.`,
    });
    return { expiresAt };
  });

  app.post("/admin/users/:id/vip/revoke", {
    preHandler: can("users.vip"),
    schema: {
      ...base,
      summary: "End someone's VIP now (e.g. a mistaken grant). Play subscriptions must also be refunded in Play Console.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ reason: z.string().trim().min(3).max(500) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    await tx(db, async (c) => {
      await targetUser(c, req.params.id);
      const r = await c.query(`UPDATE vip_subscriptions SET cancelled_at = now() WHERE user_id = $1 AND cancelled_at IS NULL AND expires_at > now()`,
        [req.params.id]);
      if (!r.rowCount) throw new ApiError(409, "NOT_VIP", "This person isn't VIP");
      await audit(c, me(req).userId, "user.vip_revoke", "user", req.params.id, { reason: req.body.reason });
    });
    return reply.status(204).send(null);
  });

  app.get("/admin/vip-plans", {
    preHandler: can("engagement.manage"),
    schema: { ...base, summary: "VIP plans (prices must match the Play Console products)", response: { 200: z.array(VipPlan) } },
  }, async () => (await db.query<{ id: number; play_sku: string; months: number; price_paise: number; label: string | null; is_active: boolean; sort_order: number }>(
    `SELECT * FROM vip_plans ORDER BY sort_order, months`)).rows.map((p) => ({
    id: p.id, sku: p.play_sku, months: p.months, pricePaise: p.price_paise, label: p.label, isActive: p.is_active, sortOrder: p.sort_order,
  })));

  app.put("/admin/vip-plans/:id", {
    preHandler: can("engagement.manage"),
    schema: {
      ...base,
      summary: "Change a VIP plan's price, badge or visibility",
      params: z.object({ id: z.coerce.number().int() }),
      body: z.object({ pricePaise: z.number().int().min(100).max(10_000_000), label: z.string().trim().max(24).nullish(), isActive: z.boolean() }),
      response: { 200: VipPlan },
    },
  }, async (req) => tx(db, async (c) => {
    const before = (await c.query(`SELECT * FROM vip_plans WHERE id = $1 FOR UPDATE`, [req.params.id])).rows[0];
    if (!before) throw notFound("PLAN_NOT_FOUND");
    const p = (await c.query<{ id: number; play_sku: string; months: number; price_paise: number; label: string | null; is_active: boolean; sort_order: number }>(
      `UPDATE vip_plans SET price_paise = $2, label = $3, is_active = $4 WHERE id = $1 RETURNING *`,
      [req.params.id, req.body.pricePaise, req.body.label || null, req.body.isActive])).rows[0]!;
    await audit(c, me(req).userId, "vip_plan.update", "vip_plan", p.id, { before: { pricePaise: before.price_paise, label: before.label, isActive: before.is_active }, after: req.body });
    return { id: p.id, sku: p.play_sku, months: p.months, pricePaise: p.price_paise, label: p.label, isActive: p.is_active, sortOrder: p.sort_order };
  }));

  app.post("/admin/users/:id/message", {
    preHandler: can("users.manage"),
    schema: {
      ...base,
      summary: "Send a push notification to one caller or companion",
      params: z.object({ id: z.uuid() }),
      body: z.object({ title: z.string().trim().min(1).max(60), body: z.string().trim().min(1).max(300) }),
      response: { 200: z.object({ devices: z.number().int().describe("Devices it was sent to; 0 means the user has no app installed with notifications on") }) },
    },
  }, async (req) => {
    const tokens = await tx(db, async (c) => {
      await targetUser(c, req.params.id);
      const rows = (await c.query<{ fcm_token: string }>(`SELECT fcm_token FROM devices WHERE user_id = $1`, [req.params.id])).rows;
      await audit(c, me(req).userId, "user.message", "user", req.params.id, { title: req.body.title, body: req.body.body, devices: rows.length });
      return rows.map((r) => r.fcm_token);
    });
    await notify(app.deps, req.params.id, { type: "admin_message", title: req.body.title, body: req.body.body });
    return { devices: tokens.length };
  });

  app.post("/admin/users/:id/status", {
    preHandler: can("users.manage"),
    schema: {
      ...base,
      summary: "Suspend, ban or reactivate an account",
      params: z.object({ id: z.uuid() }),
      body: z.object({ status: z.enum(["active", "suspended", "banned"]), reason: z.string().trim().min(3).max(500) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    const { status, reason } = req.body;
    if (req.params.id === me(req).userId) throw new ApiError(400, "CANNOT_TARGET_SELF", "You can't change your own account");
    await tx(db, async (c) => {
      const u = (await c.query<{ status: string }>(`SELECT status FROM users WHERE id = $1 AND status <> 'deleted' FOR UPDATE`,
        [req.params.id])).rows[0];
      if (!u) throw notFound("USER_NOT_FOUND");
      if (status === "active") await c.query(`UPDATE users SET status = 'active' WHERE id = $1`, [req.params.id]);
      else await suspend(c, req.params.id, status);
      await audit(c, me(req).userId, "user.status", "user", req.params.id, { from: u.status, to: status, reason });
    });
    if (status !== "active") await afterSuspend(req.params.id);
    return reply.status(204).send(null);
  });

  // -------------------------------------------------------------------------
  app.get("/admin/audit", {
    preHandler: can("audit.view"),
    schema: {
      ...base,
      summary: "Latest admin actions",
      querystring: z.object({ limit: z.coerce.number().int().min(1).max(1000).default(50) }),
      response: {
        200: z.array(z.object({
          id: z.number().int(), createdAt: z.date(), actor: z.string(), action: z.string(),
          targetType: z.string(), targetId: z.string(), details: z.record(z.string(), z.unknown()),
        })),
      },
    },
  }, async (req) => (await db.query<{ id: number; created_at: Date; actor: string; action: string; target_type: string;
    target_id: string; details: Record<string, unknown> }>(
    `SELECT a.id, a.created_at, u.display_name AS actor, a.action, a.target_type, a.target_id, a.details
       FROM audit_log a JOIN users u ON u.id = a.actor_id ORDER BY a.id DESC LIMIT $1`, [req.query.limit],
  )).rows.map((a) => ({ id: a.id, createdAt: a.created_at, actor: a.actor, action: a.action,
    targetType: a.target_type, targetId: a.target_id, details: a.details })));
};
