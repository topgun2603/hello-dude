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
import type { TokenService } from "./auth/tokens.js";
import "./auth/guard.js";
import { CallError, type BillingEngine } from "./billing/engine.js";
import type { RoomControl, UserEvents, WebhookVerifier } from "./billing/ports.js";
import { registerRealtime } from "./realtime.js";
import type { PushSender } from "./push.js";
import type { ObjectStore } from "./storage.js";
import type { PayoutProvider } from "./payouts/provider.js";
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
import type { LegalInfo } from "./legal/pages.js";

export interface AppDeps {
  db: Db;
  redis: Redis;
  engine: BillingEngine;
  rooms: RoomControl;
  events: UserEvents;
  otp: OtpService;
  tokens: TokenService;
  push: PushSender;
  webhooks: WebhookVerifier;
  store: ObjectStore;
  kycKey: Buffer;
  uidaiCerts: string[];
  payouts: PayoutProvider;
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
  NOT_A_COMPANION: 409, VIDEO_NOT_ENABLED: 409, CALLER_INACTIVE: 403,
};

export const OPERATION_IDS: Record<string, string> = {
  "POST /v1/auth/otp/send": "sendOtp",
  "POST /v1/auth/otp/verify": "verifyOtp",
  "POST /v1/auth/signup": "signUp",
  "POST /v1/auth/refresh": "refreshTokens",
  "POST /v1/auth/logout": "logout",
  "GET /v1/languages": "listLanguages",
  "GET /v1/me": "getMe",
  "PATCH /v1/me": "updateMe",
  "PUT /v1/devices": "registerDevice",
  "GET /v1/wallet": "getWallet",
  "GET /v1/coin-packages": "listCoinPackages",
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
  "POST /v1/companion/kyc/aadhaar": "uploadAadhaar",
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
      return reply.status(CALL_ERROR_STATUS[err.code]).send({ error: { code: err.code, message: err.code } });
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
  }, { prefix: "/v1" });
  await app.register(legalHtmlRoutes);

  return app;
}
