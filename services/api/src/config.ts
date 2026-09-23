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

  // 'dev' accepts DEV_OTP_CODE for every number and sends nothing. Refused in production.
  OTP_PROVIDER: z.enum(["dev", "msg91"]).default("dev"),
  DEV_OTP_CODE: z.string().regex(/^\d{6}$/).default("123456"),
  MSG91_AUTH_KEY: z.string().optional(),
  MSG91_TEMPLATE_ID: z.string().optional(),

  // KYC: every document is AES-256-GCM encrypted with this key (32 bytes, base64).
  KYC_ENCRYPTION_KEY: z.string().min(40),
  KYC_STORAGE_DIR: z.string().default(".data/kyc"),
  // PEM files trusted to sign Aadhaar offline e-KYC XML (UIDAI's certificate in production), comma-separated.
  UIDAI_CERT_PATHS: z.string().default(""),

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
  if (cfg.NODE_ENV === "production" && cfg.OTP_PROVIDER === "dev") {
    throw new Error("OTP_PROVIDER=dev is not allowed in production");
  }
  if (cfg.OTP_PROVIDER === "msg91" && (!cfg.MSG91_AUTH_KEY || !cfg.MSG91_TEMPLATE_ID)) {
    throw new Error("MSG91_AUTH_KEY and MSG91_TEMPLATE_ID are required when OTP_PROVIDER=msg91");
  }
  if (cfg.NODE_ENV === "production" && !cfg.FIREBASE_SERVICE_ACCOUNT_PATH) {
    throw new Error("FIREBASE_SERVICE_ACCOUNT_PATH is required in production (incoming calls need push)");
  }
  return cfg;
}
