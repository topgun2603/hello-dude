import { readFile } from "node:fs/promises";
import Fastify, { type FastifyInstance } from "fastify";
import swagger from "@fastify/swagger";
import swaggerUi from "@fastify/swagger-ui";
import {
  hasZodFastifySchemaValidationErrors, jsonSchemaTransform, jsonSchemaTransformObject, serializerCompiler, validatorCompiler,
  type ZodTypeProvider,
} from "fastify-type-provider-zod";
import type { Redis } from "ioredis";
import type { Db } from "./db/pool.js";
import { ApiError } from "./errors.js";
import type { OtpService } from "./auth/otp.js";
import type { PhoneVerifier } from "./auth/firebase-auth.js";
import type { TokenService } from "./auth/tokens.js";
import "./auth/guard.js";
import { CallError, type BillingEngine } from "./billing/engine.js";
import type { RoomControl, UserEvents, WebhookVerifier } from "./billing/ports.js";
import { registerRealtime } from "./realtime.js";
import type { PushSender } from "./push.js";
import type { ObjectStore } from "./storage.js";
import type { PayoutProvider } from "./payouts/provider.js";
import type { RazorpayGateway } from "./payments/razorpay.js";
import { paymentRoutes, razorpayWebhookRoutes } from "./routes/payments.js";
import type { Recorder } from "./recording.js";
import { giftRoutes } from "./routes/gifts.js";
import { favouriteRoutes } from "./routes/favourites.js";
import { refundRoutes } from "./routes/refunds.js";
import { academyRoutes } from "./routes/academy.js";
import { accountRoutes } from "./routes/account.js";
import { authRoutes } from "./routes/auth.js";
import { meRoutes } from "./routes/me.js";
import { walletRoutes } from "./routes/wallet.js";
import { companionRoutes } from "./routes/companions.js";
import { callRoutes } from "./routes/calls.js";
import { safetyRoutes } from "./routes/safety.js";
import { webhookRoutes } from "./routes/webhooks.js";
import { adminRoutes } from "./routes/admin.js";
import { adminCompanionRoutes } from "./routes/admin-companions.js";
import { companionOnboardingRoutes } from "./routes/companion.js";
import { legalApiRoutes, legalHtmlRoutes } from "./routes/legal.js";
import { moderationRoutes } from "./routes/moderation.js";
import { notificationRoutes } from "./routes/notifications.js";
import { growthRoutes } from "./routes/growth.js";
import { chatRoutes } from "./routes/chat.js";
import { bookingRoutes } from "./routes/bookings.js";
import { vipRoutes } from "./routes/vip.js";
import { rewardsRoutes } from "./routes/rewards.js";
import { roomRoutes } from "./routes/rooms.js";
import { staffRoutes } from "./routes/staff.js";
import { analyticsRoutes } from "./routes/analytics.js";
import { liveRoutes } from "./routes/lives.js";
import { groupRoutes } from "./routes/groups.js";
import { inviteRoutes } from "./routes/invites.js";
import { leaderboardRoutes } from "./routes/leaderboards.js";
import { pkRoutes } from "./routes/pk.js";
import { photoRoutes } from "./routes/photos.js";
import { promotionRoutes } from "./routes/promotions.js";
import type { LegalInfo } from "./legal/pages.js";

export interface AppDeps {
  db: Db;
  redis: Redis;
  engine: BillingEngine;
  rooms: RoomControl;
  events: UserEvents;
  otp: OtpService;
  /** Firebase phone sign-in for the mobile app (the admin panel uses `otp`). */
  phoneAuth?: PhoneVerifier;
  tokens: TokenService;
  push: PushSender;
  webhooks: WebhookVerifier;
  store: ObjectStore;
  kycKey: Buffer;
  uidaiCerts: string[];
  payouts: PayoutProvider;
  /** Razorpay coin purchases; unset = buying coins is off (503 PAYMENTS_OFF). */
  razorpay?: RazorpayGateway;
  recorder: Recorder;
  liveKitUrl: string;
  logger?: boolean;
  /** false skips the WebSocket endpoint (spec export). */
  realtime?: boolean;
  /** Company details filled into the legal pages; missing ones show as drafts. */
  legal?: LegalInfo;
  /** Serves /dev/* helper pages. Only true when OTP_PROVIDER=dev. */
  devTools?: boolean;
}

declare module "fastify" {
  interface FastifyInstance { deps: AppDeps }
}

const CALL_ERROR_STATUS: Record<CallError["code"], number> = {
  OFFLINE: 409, BUSY: 409, BLOCKED: 403, NO_RATE: 409, INSUFFICIENT_BALANCE: 402,
  NOT_A_COMPANION: 409, VIDEO_NOT_ENABLED: 409, VOICE_OFF: 409, CALLER_INACTIVE: 403,
};

/** What the app shows when a call can't start. */
const CALL_ERROR_MESSAGE: Record<CallError["code"], string> = {
  OFFLINE: "They just went offline. Try someone else.",
  BUSY: "They're on another call right now.",
  BLOCKED: "You can't call this person.",
  NO_RATE: "Calls in this language aren't open yet.",
  INSUFFICIENT_BALANCE: "Not enough coins for the first minute. Add coins to call.",
  NOT_A_COMPANION: "This person isn't taking calls.",
  VIDEO_NOT_ENABLED: "They aren't taking video calls right now. Try a voice call.",
  VOICE_OFF: "They only take video calls right now.",
  CALLER_INACTIVE: "Your account can't make calls right now. Contact support.",
};

export const OPERATION_IDS: Record<string, string> = {
  "POST /v1/auth/otp/send": "sendOtp",
  "POST /v1/auth/otp/verify": "verifyOtp",
  "POST /v1/auth/firebase": "signInWithFirebase",
  "POST /v1/auth/signup": "signUp",
  "POST /v1/auth/refresh": "refreshTokens",
  "POST /v1/auth/logout": "logout",
  "GET /v1/languages": "listLanguages",
  "GET /v1/me": "getMe",
  "PATCH /v1/me": "updateMe",
  "PUT /v1/devices": "registerDevice",
  "GET /v1/wallet": "getWallet",
  "GET /v1/coin-packages": "listCoinPackages",
  "POST /v1/payments/razorpay/order": "createRazorpayOrder",
  "POST /v1/payments/razorpay/verify": "verifyRazorpayPayment",
  "GET /v1/wallet/ledger": "listLedger",
  "GET /v1/companions/online": "listOnlineCompanions",
  "POST /v1/companion/presence": "setPresence",
  "POST /v1/calls": "startCall",
  "POST /v1/calls/match": "matchCall",
  "POST /v1/calls/:id/accept": "acceptCall",
  "POST /v1/calls/:id/reject": "rejectCall",
  "POST /v1/calls/:id/end": "endCall",
  "GET /v1/calls": "listCalls",
  "GET /v1/calls/:id": "getCall",
  "POST /v1/calls/:id/rating": "rateCall",
  "POST /v1/blocks": "blockUser",
  "DELETE /v1/blocks/:userId": "unblockUser",
  "GET /v1/blocks": "listBlocks",
  "POST /v1/reports": "reportUser",
  "GET /v1/admin/dashboard": "adminDashboard",
  "GET /v1/admin/rates": "adminListRates",
  "POST /v1/admin/rates": "adminCreateRate",
  "GET /v1/admin/coin-packages": "adminListPackages",
  "PUT /v1/admin/coin-packages/:id": "adminUpdatePackage",
  "POST /v1/admin/coin-packages": "adminCreatePackage",
  "GET /v1/admin/reports": "adminListReports",
  "POST /v1/admin/reports/:id/resolve": "adminResolveReport",
  "GET /v1/admin/users": "adminListUsers",
  "GET /v1/admin/users/:id": "adminGetUser",
  "POST /v1/admin/users/:id/notes": "adminAddUserNote",
  "POST /v1/admin/users/:id/coins": "adminSendCoins",
  "POST /v1/admin/users/:id/message": "adminSendMessage",
  "GET /v1/legal": "listLegalPages",
  "GET /v1/legal/:id": "getLegalPage",
  "POST /v1/calls/:id/moderation": "flagVideoFrame",
  "POST /v1/calls/:id/verify-connected": "verifyCallConnected",
  "GET /v1/notifications": "listNotifications",
  "GET /v1/notifications/unread-count": "unreadNotificationCount",
  "POST /v1/notifications/read": "markNotificationsRead",
  "GET /v1/checkin": "getCheckIn",
  "POST /v1/checkin/claim": "claimCheckIn",
  "GET /v1/referral": "getReferral",
  "GET /v1/share-card": "getShareCard",
  "GET /v1/companions/:id": "getCompanion",
  "GET /v1/chats": "listChats",
  "POST /v1/chats/with/:userId": "openChat",
  "GET /v1/chats/:id/messages": "getChatMessages",
  "POST /v1/chats/:id/messages": "sendChatMessage",
  "POST /v1/chats/:id/read": "markChatRead",
  "GET /v1/companions/:id/slots": "getBookingSlots",
  "POST /v1/bookings": "createBooking",
  "GET /v1/bookings": "listBookings",
  "POST /v1/bookings/:id/confirm": "confirmBooking",
  "POST /v1/bookings/:id/decline": "declineBooking",
  "POST /v1/bookings/:id/cancel": "cancelBooking",
  "POST /v1/bookings/:id/start": "startBooking",
  "GET /v1/vip": "getVip",
  "GET /v1/companion/rewards": "getCompanionRewards",
  "GET /v1/room-categories": "listRoomCategories",
  "PUT /v1/companion/call-types": "setCompanionCallTypes",
  "GET /v1/wallet/history": "getCoinHistory",
  "GET /v1/admin/me": "adminMe",
  "GET /v1/admin/analytics": "adminAnalytics",
  "GET /v1/lives": "listLives",
  "POST /v1/lives": "startLive",
  "POST /v1/lives/:id/host-heartbeat": "liveHostHeartbeat",
  "POST /v1/lives/:id/end": "endLive",
  "POST /v1/lives/:id/join": "joinLive",
  "POST /v1/lives/:id/heartbeat": "liveHeartbeat",
  "POST /v1/lives/:id/leave": "leaveLive",
  "POST /v1/lives/:id/messages": "sendLiveMessage",
  "GET /v1/lives/:id/messages": "liveChatHistory",
  "POST /v1/lives/:id/react": "sendLiveReaction",
  "POST /v1/lives/:id/gifts": "sendLiveGift",
  "POST /v1/lives/:id/moderation": "flagLiveFrame",
  "POST /v1/lives/:id/snapshot": "uploadLiveSnapshot",
  "GET /v1/lives/:id/snapshot/:file": "getLiveSnapshot",
  "GET /v1/admin/lives": "adminListLives",
  "POST /v1/admin/lives/:id/end": "adminEndLive",
  "GET /v1/groups": "listGroups",
  "POST /v1/groups": "createGroup",
  "POST /v1/groups/:id/open": "openGroup",
  "POST /v1/groups/:id/host-heartbeat": "groupHostHeartbeat",
  "POST /v1/groups/:id/end": "endGroup",
  "POST /v1/groups/:id/book": "bookGroupSeat",
  "POST /v1/groups/:id/cancel-booking": "cancelGroupSeat",
  "POST /v1/groups/:id/join": "joinGroup",
  "POST /v1/groups/:id/heartbeat": "groupHeartbeat",
  "POST /v1/groups/:id/leave": "leaveGroup",
  "POST /v1/groups/:id/messages": "sendGroupMessage",
  "POST /v1/groups/:id/react": "sendGroupReaction",
  "POST /v1/groups/:id/gifts": "sendGroupGift",
  "POST /v1/groups/:id/moderation": "flagGroupFrame",
  "POST /v1/groups/:id/report": "reportInGroup",
  "GET /v1/admin/groups": "adminListGroups",
  "POST /v1/admin/groups/:id/end": "adminEndGroup",
  "GET /v1/me/photo": "getMyPhoto",
  "PUT /v1/me/photo": "uploadMyPhoto",
  "DELETE /v1/me/photo": "deleteMyPhoto",
  "GET /v1/photos/:userId/:file": "getPhoto",
  "GET /v1/admin/photos": "adminListPhotos",
  "POST /v1/admin/photos/:userId/decision": "adminDecidePhoto",
  "GET /v1/admin/roles": "adminListRoles",
  "POST /v1/admin/roles": "adminCreateRole",
  "PUT /v1/admin/roles/:code": "adminUpdateRole",
  "DELETE /v1/admin/roles/:code": "adminDeleteRole",
  "GET /v1/admin/staff": "adminListStaff",
  "POST /v1/admin/staff": "adminAddStaff",
  "PUT /v1/admin/staff/:id": "adminUpdateStaff",
  "GET /v1/promotions/current": "getCurrentPromotion",
  "POST /v1/promotions/:id/events": "logPromotionEvent",
  "GET /v1/admin/promotions": "adminListPromotions",
  "POST /v1/admin/promotions": "adminCreatePromotion",
  "PUT /v1/admin/promotions/:id": "adminUpdatePromotion",
  "POST /v1/admin/promotions/:id/active": "adminSetPromotionActive",
  "DELETE /v1/admin/promotions/:id": "adminDeletePromotion",
  "GET /v1/rooms": "listRooms",
  "POST /v1/rooms": "startRoom",
  "GET /v1/rooms/:id": "getRoom",
  "POST /v1/rooms/:id/join": "joinRoom",
  "POST /v1/rooms/:id/heartbeat": "roomHeartbeat",
  "POST /v1/rooms/:id/leave": "leaveRoom",
  "POST /v1/rooms/:id/hand": "raiseHand",
  "POST /v1/rooms/:id/stage/:userId": "setRoomStage",
  "POST /v1/rooms/:id/token": "roomToken",
  "POST /v1/rooms/:id/messages": "sendRoomMessage",
  "POST /v1/rooms/:id/react": "sendRoomReaction",
  "POST /v1/rooms/:id/gifts": "sendRoomGift",
  "GET /v1/admin/rooms": "adminListRooms",
  "POST /v1/admin/rooms/:id/end": "adminEndRoom",
  "GET /v1/admin/companion-levels": "adminListCompanionLevels",
  "PUT /v1/admin/companion-levels/:level": "adminUpdateCompanionLevel",
  "GET /v1/admin/bonus-campaigns": "adminListBonusCampaigns",
  "POST /v1/admin/bonus-campaigns": "adminCreateBonusCampaign",
  "PUT /v1/admin/bonus-campaigns/:id": "adminUpdateBonusCampaign",
  "POST /v1/admin/users/:id/vip": "adminGrantVip",
  "POST /v1/admin/users/:id/vip/revoke": "adminRevokeVip",
  "GET /v1/admin/vip-plans": "adminListVipPlans",
  "PUT /v1/admin/vip-plans/:id": "adminUpdateVipPlan",
  "GET /v1/admin/moderation": "adminListModerationFlags",
  "GET /v1/admin/moderation/:id/frame": "adminGetModerationFrame",
  "POST /v1/admin/moderation/:id/resolve": "adminResolveModerationFlag",
  "POST /v1/admin/users/:id/status": "adminSetUserStatus",
  "GET /v1/admin/audit": "adminAuditLog",
  "GET /v1/admin/kyc": "adminKycQueue",
  "GET /v1/admin/kyc/:userId/files/:doc": "adminKycFile",
  "POST /v1/admin/kyc/:userId/decision": "adminKycDecision",
  "POST /v1/admin/companions/:userId/video": "adminSetVideo",
  "GET /v1/admin/payouts": "adminListPayouts",
  "POST /v1/admin/payouts/:id/approve": "adminApprovePayout",
  "POST /v1/admin/payouts/:id/reject": "adminRejectPayout",
  "POST /v1/companion/apply": "applyAsCompanion",
  "GET /v1/companion/kyc": "getKyc",
  "POST /v1/companion/kyc/age": "confirmCompanionAge",
  "POST /v1/companion/kyc/voice": "uploadVoiceIntro",
  "POST /v1/chats/requests": "sendChatRequest",
  "GET /v1/companion/callers": "listOnlineCallers",
  "GET /v1/leaderboards": "getLeaderboard",
  "POST /v1/lives/:id/pk": "challengePk",
  "POST /v1/pk/:id/accept": "acceptPk",
  "POST /v1/pk/:id/decline": "declinePk",
  "GET /v1/pk/:id": "getPk",
  "POST /v1/pk/:id/end": "endPk",
  "GET /v1/events/current": "getCurrentEvent",
  "GET /v1/me/level": "getMyLevel",
  "GET /v1/admin/events": "adminListEvents",
  "POST /v1/admin/events": "adminCreateEvent",
  "PUT /v1/admin/events/:id": "adminUpdateEvent",
  "GET /v1/admin/caller-levels": "adminListCallerLevels",
  "PUT /v1/admin/caller-levels/:level": "adminUpdateCallerLevel",
  "POST /v1/companion/invites": "inviteCaller",
  "GET /v1/chats/requests": "listChatRequests",
  "POST /v1/chats/requests/:id/accept": "acceptChatRequest",
  "POST /v1/chats/requests/:id/decline": "declineChatRequest",
  "POST /v1/companion/kyc/selfie": "uploadSelfie",
  "POST /v1/companion/kyc/pan": "uploadPan",
  "PUT /v1/companion/upi": "setUpi",
  "POST /v1/companion/kyc/submit": "submitKyc",
  "GET /v1/companion/home": "companionHome",
  "GET /v1/companion/earnings": "companionEarnings",
  "POST /v1/companion/payouts": "requestPayout",
  "GET /v1/gifts": "listGifts",
  "POST /v1/calls/:id/gifts": "sendGift",
  "GET /v1/favourites": "listFavourites",
  "PUT /v1/favourites/:companionId": "addFavourite",
  "DELETE /v1/favourites/:companionId": "removeFavourite",
  "POST /v1/calls/:id/refund-request": "requestRefund",
  "GET /v1/admin/refunds": "adminListRefunds",
  "POST /v1/admin/refunds/:id/decide": "adminDecideRefund",
  "GET /v1/companion/academy": "getAcademy",
  "POST /v1/companion/academy/:lessonId/answers": "answerLessonQuiz",
  "POST /v1/me/delete": "deleteAccount",
  "GET /v1/admin/gifts": "adminListGifts",
  "PUT /v1/admin/gifts/:id": "adminUpdateGift",
  "POST /v1/admin/gifts": "adminCreateGift",
  "GET /v1/admin/settings": "adminListSettings",
  "PUT /v1/admin/settings/:key": "adminUpdateSetting",
};

export async function buildApp(deps: AppDeps): Promise<FastifyInstance> {
  const app = Fastify({
    logger: deps.logger === false ? false : {
      redact: ["req.headers.authorization", "req.headers.cookie"],
    },
  }).withTypeProvider<ZodTypeProvider>();

  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  app.decorate("deps", deps);
  // Some clients send "content-type: application/json" with no body on POSTs that take none.
  app.removeContentTypeParser("application/json");
  app.addContentTypeParser("application/json", { parseAs: "string" }, (_req, body, done) => {
    const text = (body as string).trim();
    if (!text) return done(null, undefined);
    try {
      done(null, JSON.parse(text));
    } catch (e) {
      (e as { statusCode?: number }).statusCode = 400;
      done(e as Error, undefined);
    }
  });
  app.decorateRequest("auth", null);

  await app.register(swagger, {
    openapi: {
      info: { title: "Hello Dude! API", version: "0.1.0" },
      components: { securitySchemes: { bearer: { type: "http", scheme: "bearer", bearerFormat: "JWT" } } },
    },
    transform: jsonSchemaTransform,
    transformObject: jsonSchemaTransformObject,
  });
  await app.register(swaggerUi, { routePrefix: "/docs" });

  app.setErrorHandler((err, req, reply) => {
    if (hasZodFastifySchemaValidationErrors(err)) {
      return reply.status(400).send({
        error: { code: "VALIDATION", message: "Some fields are not valid", details: err.validation },
      });
    }
    if (err instanceof ApiError) {
      return reply.status(err.status).send({ error: { code: err.code, message: err.message } });
    }
    if (err instanceof CallError) {
      return reply.status(CALL_ERROR_STATUS[err.code]).send({ error: { code: err.code, message: CALL_ERROR_MESSAGE[err.code] } });
    }
    const status = (err as { statusCode?: number }).statusCode;
    if (status && status < 500) {
      return reply.status(status).send({ error: { code: "BAD_REQUEST", message: (err as Error).message } });
    }
    req.log.error(err);
    return reply.status(500).send({ error: { code: "INTERNAL", message: "Something went wrong" } });
  });

  // Stable operation names become method names in the generated Dart client.
  app.addHook("onRoute", (route) => {
    const id = OPERATION_IDS[`${route.method} ${route.url}`];
    if (id && route.schema) route.schema = { ...route.schema, operationId: id } as typeof route.schema;
  });

  if (deps.realtime !== false) await registerRealtime(app, deps.redis);

  if (deps.devTools) {
    const page = await readFile(new URL("./dev/companion.html", import.meta.url), "utf8");
    app.get("/dev/companion", { schema: { hide: true } }, async (_req, reply) => reply.type("text/html").send(page));
  }

  app.get("/health", { schema: { hide: true } }, async () => ({ ok: true }));
  app.get("/openapi.json", { schema: { hide: true } }, async () => app.swagger());

  await app.register(async (v1) => {
    await v1.register(authRoutes);
    await v1.register(meRoutes);
    await v1.register(walletRoutes);
    await v1.register(companionRoutes);
    await v1.register(callRoutes);
    await v1.register(safetyRoutes);
    await v1.register(webhookRoutes);
    await v1.register(razorpayWebhookRoutes);
    await v1.register(paymentRoutes);
    await v1.register(adminRoutes);
    await v1.register(adminCompanionRoutes);
    await v1.register(companionOnboardingRoutes);
    await v1.register(giftRoutes);
    await v1.register(favouriteRoutes);
    await v1.register(refundRoutes);
    await v1.register(academyRoutes);
    await v1.register(accountRoutes);
    await v1.register(legalApiRoutes);
    await v1.register(moderationRoutes);
    await v1.register(notificationRoutes);
    await v1.register(growthRoutes);
    await v1.register(chatRoutes);
    await v1.register(bookingRoutes);
    await v1.register(vipRoutes);
    await v1.register(rewardsRoutes);
    await v1.register(roomRoutes);
    await v1.register(staffRoutes);
    await v1.register(analyticsRoutes);
    await v1.register(liveRoutes);
    await v1.register(groupRoutes);
    await v1.register(inviteRoutes);
    await v1.register(leaderboardRoutes);
    await v1.register(pkRoutes);
    await v1.register(photoRoutes);
    await v1.register(promotionRoutes);
  }, { prefix: "/v1" });
  await app.register(legalHtmlRoutes);

  return app;
}
