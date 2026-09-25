import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { ApiError } from "../errors.js";
import { normalizeIndianMobile } from "../auth/phone.js";
import { phoneVerifierNotConfigured } from "../auth/firebase-auth.js";
import type { Role } from "../auth/tokens.js";
import { ensureWallets } from "../billing/ledger.js";
import { normaliseCode } from "../growth.js";
import { notify } from "../notifications.js";
import { numberSetting } from "../settings.js";
import { assertLanguagesActive, Gender, LanguageCode, loadProfile, Profile, TokenPair } from "./profile.js";

const Phone = z.string().min(10).max(20).transform((v, ctx) => {
  const e164 = normalizeIndianMobile(v);
  if (!e164) {
    ctx.addIssue({ code: "custom", message: "Enter a 10-digit Indian mobile number" });
    return z.NEVER;
  }
  return e164;
});

const DEFAULT_DISPLAY_NAME = "New friend";
/** Women and transgender sign-ups are companions only (owner, 2026-09-24); men are callers. */
export const roleForGender = (gender: string) => (gender === "male" ? "caller" as const : "companion" as const);

/** Illustrated avatars: 1 female, 2 male, 3 transgender (see migration 0019). */
export const avatarForGender = (g: "male" | "female" | "other") => (g === "female" ? 1 : g === "male" ? 2 : 3);

// One flat object (not a oneOf) so generated clients stay simple.
const OtpVerifyResult = z.object({
  status: z.enum(["signed_in", "needs_signup"]),
  tokens: TokenPair.optional().describe("Set when status = signed_in"),
  profile: Profile.optional().describe("Set when status = signed_in"),
  signupToken: z.string().optional().describe("Set when status = needs_signup"),
}).meta({ id: "OtpVerifyResult" });

export const authRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, otp, tokens } = app.deps;
  const phoneAuth = app.deps.phoneAuth ?? phoneVerifierNotConfigured;

  /** After the number is proven (OTP or Firebase): sign in, or start sign-up. */
  async function signInOrSignup(phone: string) {
    const user = (await db.query<{ id: string; role: Role; status: string }>(
      `SELECT id, role, status FROM users WHERE phone = $1`, [phone],
    )).rows[0];
    if (!user || user.status === "deleted") {
      return { status: "needs_signup" as const, signupToken: await tokens.signupToken(phone) };
    }
    if (user.status !== "active") throw new ApiError(403, "ACCOUNT_BLOCKED", "This account has been suspended");
    return {
      status: "signed_in" as const,
      tokens: await tokens.issue(user.id, user.role),
      profile: await loadProfile(db, user.id),
    };
  }

  app.post("/auth/otp/send", {
    schema: {
      tags: ["auth"],
      summary: "Send a 6-digit code to a mobile number",
      body: z.object({ phone: Phone }),
      response: { 200: z.object({ expiresInSeconds: z.number(), resendAfterSeconds: z.number() }) },
    },
  }, async (req) => otp.send(req.body.phone));

  app.post("/auth/otp/verify", {
    schema: {
      tags: ["auth"],
      summary: "Verify the code. Existing users get tokens; new numbers get a signup token.",
      body: z.object({ phone: Phone, code: z.string().regex(/^\d{6}$/) }),
      response: { 200: OtpVerifyResult },
    },
  }, async (req) => {
    const { phone, code } = req.body;
    await otp.verify(phone, code);
    return signInOrSignup(phone);
  });

  app.post("/auth/firebase", {
    schema: {
      tags: ["auth"],
      summary: "Mobile app sign-in: the app verified the number with Firebase Auth and sends its ID token. "
        + "Indian (+91) mobiles only. Same result as otp/verify.",
      body: z.object({ idToken: z.string().min(20).max(8192) }),
      response: { 200: OtpVerifyResult },
    },
  }, async (req) => {
    const verified = await phoneAuth.verifyIdToken(req.body.idToken);
    const phone = normalizeIndianMobile(verified);
    if (!phone) throw new ApiError(400, "PHONE_NOT_SUPPORTED", "Only Indian mobile numbers can use the app");
    return signInOrSignup(phone);
  });

  app.post("/auth/signup", {
    schema: {
      tags: ["auth"],
      summary: "Create the account after OTP (Main + Language screens). Women (and transgender sign-ups) join as " +
        "companions, men as callers.",
      body: z.object({
        signupToken: z.string(),
        gender: Gender,
        language: LanguageCode,
        // nullish: generated clients send null for fields they leave empty.
        displayName: z.string().trim().min(1).max(30).nullish(),
        avatarId: z.number().int().min(1).max(50).nullish(),
        ageConfirmed: z.literal(true).describe("User confirmed they are 18+ and accepted the terms"),
        referralCode: z.string().trim().max(20).nullish().describe("A friend's invite code (optional)"),
      }),
      response: { 201: z.object({ tokens: TokenPair, profile: Profile }) },
    },
  }, async (req, reply) => {
    const phone = await tokens.verifySignup(req.body.signupToken);
    const { gender, language, displayName, avatarId } = req.body;
    const code = req.body.referralCode ? normaliseCode(req.body.referralCode) : "";
    await assertLanguagesActive(db, [language]);

    const { userId, referrerId } = await tx(db, async (c) => {
      // A number deleted earlier (DPDP erasure) signs up again as a fresh account.
      const existing = (await c.query<{ status: string }>(`SELECT status FROM users WHERE phone = $1`, [phone])).rows[0];
      if (existing && existing.status !== "deleted") throw new ApiError(409, "ALREADY_REGISTERED", "This number already has an account");
      if (existing) await c.query(`UPDATE users SET phone = phone || ':deleted:' || id WHERE phone = $1`, [phone]);

      const id = (await c.query<{ id: string }>(
        `INSERT INTO users (phone, gender, display_name, avatar_id, primary_language, terms_accepted_at, role)
         VALUES ($1, $2, $3, $4, $5, now(), $6) RETURNING id`,
        [phone, gender, displayName ?? DEFAULT_DISPLAY_NAME, avatarId ?? avatarForGender(gender), language, roleForGender(gender)],
      )).rows[0]!.id;
      if (roleForGender(gender) === "companion") {
        await c.query(`INSERT INTO companion_profiles (user_id) VALUES ($1)`, [id]);
      }
      await c.query(`INSERT INTO user_languages (user_id, language_code) VALUES ($1, $2)`, [id, language]);
      await ensureWallets(c, id);
      let referrerId: string | null = null;
      if (code) {
        const ref = (await c.query<{ id: string }>(
          `SELECT id FROM users WHERE referral_code = $1 AND status = 'active'`, [code])).rows[0];
        if (!ref) throw new ApiError(400, "INVALID_REFERRAL_CODE", "That invite code doesn't exist. Check it, or leave it empty.");
        await c.query(`INSERT INTO referrals (referrer_id, referee_id, code) VALUES ($1, $2, $3)`, [ref.id, id, code]);
        referrerId = ref.id;
      }
      return { userId: id, referrerId };
    });
    if (referrerId) {
      const companion = (await db.query<{ role: string }>(`SELECT role FROM users WHERE id = $1`, [referrerId])).rows[0]?.role === "companion";
      const body = companion
        ? `You'll get ₹${(await numberSetting(db, "referral.companion_bonus_paise", 2500)) / 100} after their first recharge`
        : `You'll both get ${await numberSetting(db, "referral.referrer_coins", 50)} coins after their first recharge`;
      await notify(app.deps, referrerId, { type: "referral_joined", title: `${displayName ?? DEFAULT_DISPLAY_NAME} joined with your code`, body });
    }
    reply.status(201);
    return { tokens: await tokens.issue(userId, roleForGender(gender)), profile: await loadProfile(db, userId) };
  });

  app.post("/auth/refresh", {
    schema: {
      tags: ["auth"],
      summary: "Swap a refresh token for a new token pair (the old one stops working)",
      body: z.object({ refreshToken: z.string().min(10) }),
      response: { 200: TokenPair },
    },
  }, async (req) => tokens.refresh(req.body.refreshToken));

  app.post("/auth/logout", {
    schema: {
      tags: ["auth"],
      body: z.object({ refreshToken: z.string().min(10) }),
      response: { 204: z.null() },
    },
  }, async (req, reply) => {
    await tokens.revoke(req.body.refreshToken);
    return reply.status(204).send(null);
  });
};
