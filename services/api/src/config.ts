import { z } from "zod";

const Env = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  PORT: z.coerce.number().int().default(9000),
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url(),
  JWT_SECRET: z.string().min(32, "JWT_SECRET must be at least 32 characters"),

  LIVEKIT_URL: z.string().url(),
  LIVEKIT_KEY: z.string().min(1),
  LIVEKIT_SECRET: z.string().min(1),
  // true with LiveKit Cloud when its webhooks can't reach this API (see engine.pollRooms).
  LIVEKIT_POLL: z.enum(["true", "false"]).default("false").transform((v) => v === "true"),

  // 'dev' accepts DEV_OTP_CODE for every number and sends nothing. Refused in production.
  OTP_PROVIDER: z.enum(["dev", "msg91"]).default("dev"),
  DEV_OTP_CODE: z.string().regex(/^\d{6}$/).default("123456"),
  MSG91_AUTH_KEY: z.string().optional(),
  // Staging (a public test server): NODE_ENV=production but test keys and simulated payouts are
  // allowed, and OTP_PROVIDER=dev only works for DEV_OTP_NUMBERS (comma-separated mobiles).
  STAGING: z.enum(["true", "false"]).default("false").transform((v) => v === "true"),
  DEV_OTP_NUMBERS: z.string().default("")
    .transform((v) => v.split(",").map((n) => n.trim().replace(/^\+?91/, "")).filter(Boolean)),
  MSG91_TEMPLATE_ID: z.string().optional(),

  // KYC: every document is AES-256-GCM encrypted with this key (32 bytes, base64).
  KYC_ENCRYPTION_KEY: z.string().min(40),
  KYC_STORAGE_DIR: z.string().default(".data/kyc"),
  // S3-compatible bucket for KYC files, photos and snapshots (AWS ap-south-1 or Cloudflare R2).
  // Unset = encrypted files under KYC_STORAGE_DIR. For R2: S3_REGION=auto and
  // S3_ENDPOINT=https://<account-id>.r2.cloudflarestorage.com
  S3_BUCKET: z.string().optional(),
  S3_REGION: z.string().default("ap-south-1"),
  S3_ENDPOINT: z.string().url().optional(),
  S3_ACCESS_KEY_ID: z.string().optional(),
  S3_SECRET_ACCESS_KEY: z.string().optional(),
  // PEM files trusted to sign Aadhaar offline e-KYC XML (UIDAI's certificate in production), comma-separated.
  UIDAI_CERT_PATHS: z.string().default(""),

  // Razorpay (coin purchases inside the app, User Choice Billing). Unset = buying coins is off.
  RAZORPAY_KEY_ID: z.string().optional(),
  RAZORPAY_KEY_SECRET: z.string().optional(),
  // Dashboard → Webhooks secret. Unset = webhooks refused; the app's verify call still credits.
  RAZORPAY_WEBHOOK_SECRET: z.string().optional(),

  // RazorpayX payouts to UPI (same key id/secret as Razorpay + the RazorpayX account number).
  // Unset = simulated payouts (dev only; refused in production).
  RAZORPAYX_ACCOUNT_NUMBER: z.string().optional(),
  RAZORPAYX_WEBHOOK_SECRET: z.string().optional(),

  // Firebase service-account key file (never commit it). Unset in dev = pushes are only logged.
  FIREBASE_SERVICE_ACCOUNT_PATH: z.string().optional(),

  // Company details for the Terms / Privacy / Grievance pages. Unset = page shows as a draft.
  LEGAL_COMPANY_NAME: z.string().optional(),
  LEGAL_COMPANY_ADDRESS: z.string().optional(),
  LEGAL_SUPPORT_EMAIL: z.string().email().optional(),
  LEGAL_GRIEVANCE_OFFICER_NAME: z.string().optional(),
  LEGAL_GRIEVANCE_EMAIL: z.string().email().optional(),
  LEGAL_JURISDICTION_CITY: z.string().optional(),
  LEGAL_EFFECTIVE_DATE: z.string().optional(),
});

export type Config = z.infer<typeof Env>;

export function loadConfig(env: NodeJS.ProcessEnv = process.env): Config {
  const cfg = Env.parse(env);
  const live = cfg.NODE_ENV === "production" && !cfg.STAGING;
  if (live && cfg.OTP_PROVIDER === "dev") {
    throw new Error("OTP_PROVIDER=dev is not allowed in production");
  }
  if (cfg.STAGING && cfg.OTP_PROVIDER === "dev" && cfg.DEV_OTP_NUMBERS.length === 0) {
    throw new Error("STAGING with OTP_PROVIDER=dev needs DEV_OTP_NUMBERS (the test accounts)");
  }
  if (cfg.OTP_PROVIDER === "msg91" && (!cfg.MSG91_AUTH_KEY || !cfg.MSG91_TEMPLATE_ID)) {
    throw new Error("MSG91_AUTH_KEY and MSG91_TEMPLATE_ID are required when OTP_PROVIDER=msg91");
  }
  if (!!cfg.RAZORPAY_KEY_ID !== !!cfg.RAZORPAY_KEY_SECRET) {
    throw new Error("Set both RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET (or neither)");
  }
  if (live && cfg.RAZORPAY_KEY_ID?.startsWith("rzp_test_")) {
    throw new Error("Razorpay test keys are not allowed in production");
  }
  if (cfg.RAZORPAYX_ACCOUNT_NUMBER && !(cfg.RAZORPAY_KEY_ID && cfg.RAZORPAY_KEY_SECRET)) {
    throw new Error("RAZORPAYX_ACCOUNT_NUMBER needs RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET");
  }
  if (live && !cfg.RAZORPAYX_ACCOUNT_NUMBER) {
    throw new Error("RAZORPAYX_ACCOUNT_NUMBER is required in production (simulated payouts would mark withdrawals paid)");
  }
  if (cfg.NODE_ENV === "production" && !cfg.FIREBASE_SERVICE_ACCOUNT_PATH) {
    throw new Error("FIREBASE_SERVICE_ACCOUNT_PATH is required in production (incoming calls need push)");
  }
  return cfg;
}
