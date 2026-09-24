/** Browser-side calls to the admin API through the same-origin /api/v1 pass-through. */

export class ApiError extends Error {
  constructor(readonly status: number, readonly code: string, message: string) {
    super(message);
  }
}

export async function api<T>(path: string, init?: { method?: string; body?: unknown }): Promise<T> {
  const res = await fetch(`/api/v1/${path.replace(/^\//, "")}`, {
    method: init?.method ?? "GET",
    headers: init?.body === undefined ? undefined : { "content-type": "application/json" },
    body: init?.body === undefined ? undefined : JSON.stringify(init.body),
  });
  if (res.status === 401) {
    // Full reload on purpose: drops every cached admin query along with the dead session.
    window.location.href = "/login"; // eslint-disable-line @next/next/no-location-assign-relative-destination
    throw new ApiError(401, "UNAUTHORIZED", "Please sign in again");
  }
  const text = await res.text();
  const data = text ? JSON.parse(text) : null;
  if (!res.ok) {
    throw new ApiError(res.status, data?.error?.code ?? "ERROR", data?.error?.message ?? "Something went wrong");
  }
  return data as T;
}

// ---------------------------------------------------------------------------
// Response types (mirror services/api/src/routes/admin.ts)

export type CallType = "audio" | "video";

export interface Dashboard {
  live: { voiceCalls: number; videoCalls: number; ringing: number; companionsOnline: number; callersOnline: number; companionsInApp: number };
  today: { connectedCalls: number; minutesBilled: number; coinsSpent: number; companionEarningsPaise: number;
    purchasesPaise: number; newUsers: number; newCallers: number; newCompanions: number };
  /** Yesterday up to the same time of day. */
  yesterday: { connectedCalls: number; coinsSpent: number; newUsers: number };
  byHour: { hour: number; calls: number; coins: number }[];
  languages: { code: string; name: string; online: number; inCall: number; ringing: number }[];
  openReports: number;
  openReportsByReason: Record<string, number>;
  pendingKyc: number;
  pendingPayouts: { count: number; paise: number };
  flaggedPayouts: number;
  billingExceptions: number;
  openRefunds: number;
  openModeration: number;
  activity: DashboardEvent[];
}

export interface DashboardEvent {
  kind: "call" | "signup" | "kyc_submitted" | "kyc_approved" | "payout" | "report";
  at: string;
  user: { id: string; displayName: string; role: string; avatarId: number };
  otherName: string | null;
  callType: CallType | null;
  minutes: number | null;
  coins: number | null;
  paise: number | null;
}

export interface CallRate {
  id: number; language: string; callType: CallType; coinsPerMin: number; companionPaisePerMin: number;
  effectiveFrom: string; status: "current" | "scheduled" | "past";
}

export interface CoinPackage {
  id: number; sku: string; coins: number; bonusCoins: number; pricePaise: number;
  label: string | null; isActive: boolean; sortOrder: number;
}

export interface Report {
  id: string; createdAt: string; reason: string; details: string | null; status: string; callId: string | null;
  reporter: { id: string; displayName: string; role: string };
  reported: { id: string; displayName: string; role: string; status: string; reportsAgainst: number };
  resolutionNote: string | null; resolvedAt: string | null;
  recording: "recording" | "ready" | "failed" | "deleted" | "disabled" | null;
}

export interface AdminUser {
  id: string; displayName: string; phone: string; role: "caller" | "companion" | "admin";
  status: "active" | "suspended" | "banned" | "deleted"; primaryLanguage: string; createdAt: string;
  coins: number; earningsPaise: number; calls: number; reportsAgainst: number;
  kycStatus: "pending" | "approved" | "rejected" | null;
  /** App open right now (or taking calls). */
  online: boolean;
  /** Companion switched Online and taking calls. */
  takingCalls: boolean;
  /** Latest of: last online (companions), last sign-in, last call. */
  lastSeenAt: string | null;
  /** 1 female, 2 male, 3 transgender illustration; other ids show a letter. */
  avatarId: number;
}

export interface KycCase {
  userId: string; displayName: string; phone: string; gender: string; primaryLanguage: string;
  status: "submitted" | "approved" | "rejected" | "in_progress"; submittedAt: string | null;
  aadhaar: { name: string | null; dob: string | null; age: number | null; gender: string | null; last4: string | null; generatedAt: string | null };
  selfieBlinks: number | null; panLast4: string | null; upi: string | null; rejectReason: string | null; videoEnabled: boolean;
  documents: ("aadhaar_photo" | "selfie" | "pan")[];
  academy: { passed: number; total: number };
}

export type PayoutStatus = "requested" | "processing" | "paid" | "failed" | "rejected";
export interface AdminPayout {
  id: string; companion: { id: string; displayName: string; kycStatus: string };
  grossPaise: number; tdsPaise: number; netPaise: number; upi: string; status: PayoutStatus;
  flags: string[]; failureReason: string | null; providerRef: string | null; createdAt: string; processedAt: string | null;
}
export interface PayoutList {
  payouts: AdminPayout[];
  totals: { requestedPaise: number; requestedCount: number; flaggedCount: number; paidThisWeekPaise: number; tdsThisMonthPaise: number };
}

export type RefundStatus = "requested" | "approved" | "rejected";
export interface AdminRefund {
  id: string; status: RefundStatus; reason: "call_dropped" | "couldnt_hear" | "wrong_language" | "other";
  details: string | null; coinsEligible: number; coinsRefunded: number; note: string | null; createdAt: string;
  call: { id: string; type: string; startedAt: string | null; durationSeconds: number | null; minutesCharged: number; endReason: string | null };
  caller: { id: string; displayName: string; refundsBefore: number };
  companion: { id: string; displayName: string };
}

export interface AdminGift { id: number; code: string; name: string; emoji: string; coins: number; isActive: boolean; sortOrder: number }
export interface AdminSetting { key: string; label: string; value: number; min: number; max: number }

export interface AuditEntry {
  id: number; createdAt: string; actor: string; action: string; targetType: string; targetId: string;
  details: Record<string, unknown>;
}

export interface Party { id: string; displayName: string }
export interface UserCall {
  id: string; createdAt: string; type: CallType; status: string; language: string; direction: "outgoing" | "incoming";
  other: Party; seconds: number | null; minutes: number; coins: number; paise: number; endReason: string | null;
  stars: number | null; giftCoins: number;
}
export interface UserLedgerEntry {
  id: number; createdAt: string; wallet: "coins" | "earnings"; type: string; amount: number; balanceAfter: number;
  note: string | null; callId: string | null;
}
export interface UserPurchase { id: string; createdAt: string; sku: string; label: string | null; pricePaise: number; coins: number; status: string }
export interface UserPayout {
  id: string; createdAt: string; grossPaise: number; tdsPaise: number; netPaise: number; upiId: string; status: string;
  failureReason: string | null; processedAt: string | null;
}
export interface UserReport {
  id: string; createdAt: string; direction: "against" | "by"; other: Party; reason: string; details: string | null;
  status: string; callId: string | null;
}
export interface UserRefund {
  id: string; createdAt: string; callId: string; reason: string; status: string; coinsEligible: number; coinsRefunded: number; byUser: boolean;
}
export interface UserAudit { id: number; createdAt: string; actor: string; action: string; details: Record<string, unknown> }

/** GET admin/users/:id — one caller or companion with their full history. */
export interface AdminUserDetail {
  id: string; displayName: string; phone: string; gender: string; role: AdminUser["role"]; status: AdminUser["status"];
  primaryLanguage: string; languages: string[]; avatarId: number; createdAt: string; termsAcceptedAt: string | null;
  online: boolean; takingCalls: boolean; lastActiveAt: string | null; lastSignInAt: string | null; activeSessions: number; devices: number; coins: number; earningsPaise: number;
  stats: {
    calls: number; missedCalls: number; minutes: number; coinsSpent: number; paiseEarned: number;
    giftsSent: number; giftsSentCoins: number; giftsReceived: number; giftsReceivedPaise: number;
    favourites: number; followers: number; blockedBy: number; blocking: number; ratingsGiven: number;
    reportsAgainst: number; reportsMade: number;
  };
  companion: {
    kycStatus: "pending" | "approved" | "rejected" | null; kycVerifiedAt: string | null; videoEnabled: boolean; bio: string | null;
    upiId: string | null; lastOnlineAt: string | null; rating: number | null; ratingCount: number;
    academyPassed: number; academyTotal: number;
  } | null;
  calls: UserCall[]; ledger: UserLedgerEntry[]; purchases: UserPurchase[]; payouts: UserPayout[];
  reports: UserReport[]; refunds: UserRefund[]; audit: UserAudit[]; notes: AdminNote[];
  vip: { expiresAt: string; source: string } | null;
}
export interface AdminNote { id: number; createdAt: string; author: string; body: string }

export type ModerationStatus = "open" | "dismissed" | "actioned";
/** A video frame the app's on-device check flagged as nudity. */
export interface ModerationFlag {
  id: string; createdAt: string; score: number; status: ModerationStatus; note: string | null;
  reviewedAt: string | null; reviewer: string | null; hasFrame: boolean;
  /** The call it came from, or null for a frame from a live stream. */
  call: { id: string; type: CallType } | null;
  liveId: string | null;
  groupId: string | null;
  subject: { id: string; displayName: string; role: string; status: string; flags: number };
  detectedBy: { id: string; displayName: string; role: string };
}

// --- v2 engagement (routes/rewards.ts, routes/vip.ts, routes/rooms.ts) ---------
export interface CompanionLevel { level: number; name: string; minHours: number; minRating: number; boostPct: number }
export interface BonusCampaign {
  id: number; title: string; rewardPaise: number; requiredMinutes: number; windowStart: number; windowEnd: number;
  weekdays: number[]; startsOn: string; endsOn: string | null; isActive: boolean;
}
export interface VipPlan { id: number; sku: string; months: number; pricePaise: number; label: string | null; isActive: boolean; sortOrder: number }
export interface LiveRoom {
  id: string; title: string; category: string; categoryName: string; language: string;
  host: { id: string; displayName: string; avatarId: number }; listeners: number; createdAt: string;
}

export type PromotionCta = "wallet" | "vip" | "checkin" | "referral" | "online" | "rooms" | "rewards" | "none";
export type PromotionTheme = "brand" | "gold" | "green";
export type PromotionAudience = "all" | "callers" | "companions" | "never_paid" | "paid";
export type PromotionFrequency = "every_open" | "daily" | "once";
/** App-open offers popup (services/api/src/routes/promotions.ts). */
export interface Promotion {
  id: number; title: string; body: string; highlight: string | null; badge: string | null; emoji: string | null;
  ctaLabel: string; ctaAction: PromotionCta; theme: PromotionTheme; confetti: boolean;
  audience: PromotionAudience; frequency: PromotionFrequency; priority: number; isActive: boolean;
  startsAt: string; endsAt: string | null; status: "live" | "scheduled" | "ended" | "off";
  shown: number; clicked: number; shownToday: number; clickedToday: number; reach: number; createdAt: string;
}

// --- Staff and roles (services/api/src/routes/staff.ts, auth/permissions.ts) ---
export type Permission =
  | "dashboard.view" | "audit.view" | "analytics.view" | "users.view" | "users.manage" | "users.coins" | "users.vip"
  | "kyc.review" | "companions.video" | "reports.review" | "moderation.review" | "rooms.manage"
  | "payouts.view" | "payouts.decide" | "refunds.review" | "pricing.manage" | "engagement.manage"
  | "promotions.manage" | "staff.manage";
export interface AdminMe { id: string; displayName: string; roleCode: string; roleName: string; permissions: Permission[] }
export interface AdminRole {
  code: string; name: string; description: string; permissions: Permission[];
  isSystem: boolean; isAdmin: boolean; members: number;
}
export interface PermissionInfo { code: Permission; group: string; label: string }
export interface AdminStaff {
  id: string; displayName: string; phone: string; roleCode: string; roleName: string;
  active: boolean; isMe: boolean; createdAt: string; lastSignInAt: string | null;
}

// --- Analytics (services/api/src/routes/analytics.ts) ---
export interface AnalyticsTotals {
  connectedCalls: number; missedCalls: number; minutes: number; avgCallSeconds: number;
  coinsSpent: number; coinsOnCalls: number; coinsOnGifts: number; coinsOnLives: number; coinsRefunded: number;
  salesPaise: number; purchases: number; companionEarningsPaise: number;
  newCallers: number; newCompanions: number; activeCallers: number; payingCallers: number;
  avgRating: number | null; ratings: number; companionOnlineMinutes: number;
}
interface AnalyticsPerson { id: string; displayName: string; avatarId: number }
export interface AdminAnalytics {
  range: { from: string; to: string; days: number };
  previous: { from: string; to: string };
  totals: AnalyticsTotals;
  previousTotals: AnalyticsTotals;
  margin: { gstPct: number; storeFeePct: number; netRevenuePaise: number; companionCostPaise: number; infraPaise: number; marginPaise: number; marginPct: number | null; targetPct: number };
  daily: { date: string; calls: number; minutes: number; coinsSpent: number; salesPaise: number; earningsPaise: number; newCallers: number; newCompanions: number; activeCallers: number }[];
  byLanguage: { code: string; name: string; calls: number; minutes: number; coins: number }[];
  byType: { type: "audio" | "video"; calls: number; minutes: number; coins: number }[];
  byHour: { hour: number; calls: number; minutes: number }[];
  topRated: (AnalyticsPerson & { rating: number; ratings: number })[];
  mostActive: (AnalyticsPerson & { talkMinutes: number; calls: number; onlineMinutes: number })[];
  topEarners: (AnalyticsPerson & { earnedPaise: number; calls: number })[];
  topSpenders: (AnalyticsPerson & { coinsSpent: number; calls: number; purchasesPaise: number })[];
  mostReported: (AnalyticsPerson & { role: string; reports: number })[];
}

// --- Companion profile photos (services/api/src/routes/photos.ts) ---
export interface PendingPhoto {
  user: { id: string; displayName: string; avatarId: number; kycStatus: string | null };
  submittedAt: string;
  /** Signed path under /v1 — load through the /api proxy. */
  pendingUrl: string;
  currentUrl: string | null;
  hasSelfie: boolean;
}

// --- Group video (services/api/src/routes/groups.ts) ---
export interface AdminGroup {
  id: string; title: string; language: string; status: "scheduled" | "lobby" | "live" | "ended";
  host: { id: string; displayName: string; avatarId: number };
  members: number; paidMinutes: number; minuteCoins: number; giftCoins: number; openFlags: number;
  scheduledAt: string | null; startedAt: string | null; endedAt: string | null; endReason: string | null;
}

// --- Lives (services/api/src/routes/lives.ts) ---
export interface AdminLive {
  id: string; title: string; language: string; status: "live" | "ended";
  host: { id: string; displayName: string; avatarId: number };
  viewers: number; peakViewers: number; paidMinutes: number; minuteCoins: number; giftCoins: number; openFlags: number;
  startedAt: string; endedAt: string | null; endReason: string | null;
}
