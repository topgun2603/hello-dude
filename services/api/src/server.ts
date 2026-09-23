import { Redis } from "ioredis";
import { buildApp } from "./app.js";
import { loadConfig } from "./config.js";
import { createPool } from "./db/pool.js";
import { devOtpSender, msg91OtpSender, OtpService } from "./auth/otp.js";
import { TokenService } from "./auth/tokens.js";
import { BillingEngine } from "./billing/engine.js";
import { liveKitRooms, liveKitWebhooks, redisUserEvents } from "./billing/ports.js";
import { fcmPushSender, logPushSender } from "./push.js";
import { readFile } from "node:fs/promises";
import { localEncryptedStore, parseKey } from "./storage.js";
import { simulatedPayouts } from "./payouts/provider.js";
import { disabledRecorder } from "./recording.js";

const cfg = loadConfig();
const db = createPool(cfg.DATABASE_URL);
const redis = new Redis(cfg.REDIS_URL);
const rooms = liveKitRooms(cfg.LIVEKIT_URL, cfg.LIVEKIT_KEY, cfg.LIVEKIT_SECRET);
const events = redisUserEvents(redis);
const engine = new BillingEngine({ db, redis, rooms, events });

const isDev = cfg.OTP_PROVIDER === "dev";
const kycKey = parseKey(cfg.KYC_ENCRYPTION_KEY);
const uidaiCerts = await Promise.all(cfg.UIDAI_CERT_PATHS.split(",").map((p) => p.trim()).filter(Boolean)
  .map((p) => readFile(p, "utf8")));
// Real FCM when a service-account key is configured; otherwise pushes are only logged.
const push = cfg.FIREBASE_SERVICE_ACCOUNT_PATH
  ? fcmPushSender({
      serviceAccountPath: cfg.FIREBASE_SERVICE_ACCOUNT_PATH,
      onDeadTokens: async (tokens) => { await db.query(`DELETE FROM devices WHERE fcm_token = ANY($1)`, [tokens]); },
      log: (msg, err) => app.log.warn({ err }, msg),
    })
  : logPushSender((m) => app.log.info(m));
const otpSender = isDev ? devOtpSender(console.log) : msg91OtpSender(cfg.MSG91_AUTH_KEY!, cfg.MSG91_TEMPLATE_ID!);

const app = await buildApp({
  db, redis, engine, rooms, events,
  otp: new OtpService(redis, otpSender, cfg.JWT_SECRET, isDev ? cfg.DEV_OTP_CODE : undefined),
  tokens: new TokenService(db, cfg.JWT_SECRET),
  push,
  webhooks: liveKitWebhooks(cfg.LIVEKIT_KEY, cfg.LIVEKIT_SECRET),
  store: localEncryptedStore(cfg.KYC_STORAGE_DIR, kycKey),
  kycKey,
  uidaiCerts,
  payouts: simulatedPayouts(),
  recorder: disabledRecorder,
  liveKitUrl: cfg.LIVEKIT_URL.replace(/^http/, "ws"),
  devTools: isDev,
  legal: {
    companyName: cfg.LEGAL_COMPANY_NAME, companyAddress: cfg.LEGAL_COMPANY_ADDRESS, supportEmail: cfg.LEGAL_SUPPORT_EMAIL,
    grievanceOfficerName: cfg.LEGAL_GRIEVANCE_OFFICER_NAME, grievanceEmail: cfg.LEGAL_GRIEVANCE_EMAIL,
    jurisdictionCity: cfg.LEGAL_JURISDICTION_CITY, effectiveDate: cfg.LEGAL_EFFECTIVE_DATE,
  },
});

for (const signal of ["SIGINT", "SIGTERM"] as const) {
  process.once(signal, async () => {
    await app.close();
    await db.end();
    redis.disconnect();
  });
}

await app.listen({ port: cfg.PORT, host: "0.0.0.0" });
if (isDev) app.log.warn(`DEV OTP mode: every number accepts ${cfg.DEV_OTP_CODE}`);
if (!uidaiCerts.length) app.log.warn("UIDAI_CERT_PATHS is empty: Aadhaar uploads will be refused");
app.log.warn("Payouts use the SIMULATOR (no real money moves)");
app.log.warn("Report recording is DISABLED until LiveKit Egress + S3 are configured");
