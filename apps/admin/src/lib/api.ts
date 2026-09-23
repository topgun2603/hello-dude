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
  live: { voiceCalls: number; videoCalls: number; ringing: number; companionsOnline: number };
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
  user: { id: string; displayName: string; role: string };
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
  kycStatus: "pending" | "approved" | "rejected" | null; online: boolean;
  /** Latest of: last online (companions), last sign-in, last call. */
  lastSeenAt: string | null;
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
  online: boolean; lastSignInAt: string | null; activeSessions: number; devices: number; coins: number; earningsPaise: number;
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
}
export interface AdminNote { id: number; createdAt: string; author: string; body: string }

export type ModerationStatus = "open" | "dismissed" | "actioned";
/** A video frame the app's on-device check flagged as nudity. */
export interface ModerationFlag {
  id: string; createdAt: string; score: number; status: ModerationStatus; note: string | null;
  reviewedAt: string | null; reviewer: string | null; hasFrame: boolean;
  call: { id: string; type: CallType };
  subject: { id: string; displayName: string; role: string; status: string; flags: number };
  detectedBy: { id: string; displayName: string; role: string };
}
