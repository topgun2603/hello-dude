import { z } from "zod";
import type { Db, DbClient } from "../db/pool.js";
import { maskPhone } from "../auth/phone.js";
import { ApiError, notFound } from "../errors.js";

export const Gender = z.enum(["male", "female", "other"]);
export const LanguageCode = z.string().regex(/^[a-z]{2}$/);

export const Profile = z.object({
  id: z.uuid(),
  displayName: z.string(),
  avatarId: z.number().int(),
  gender: Gender,
  role: z.enum(["caller", "companion", "admin"]),
  primaryLanguage: z.string(),
  languages: z.array(z.string()),
  phone: z.string().describe("Masked, e.g. +91 ••••••3210"),
  companion: z.object({
    kycStatus: z.enum(["pending", "approved", "rejected"]),
    videoEnabled: z.boolean(),
  }).nullable(),
}).meta({ id: "Profile" });
export type Profile = z.infer<typeof Profile>;

export const TokenPair = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  expiresInSeconds: z.number().int(),
}).meta({ id: "TokenPair" });

export async function loadProfile(db: Db | DbClient, userId: string): Promise<Profile> {
  const row = (await db.query<{
    id: string; display_name: string; avatar_id: number; gender: Profile["gender"]; role: Profile["role"];
    primary_language: string; phone: string; languages: string[] | null;
    kyc_status: "pending" | "approved" | "rejected" | null; video_enabled: boolean | null;
  }>(
    `SELECT u.id, u.display_name, u.avatar_id, u.gender, u.role, u.primary_language, u.phone,
            (SELECT array_agg(language_code ORDER BY language_code) FROM user_languages WHERE user_id = u.id) AS languages,
            p.kyc_status, p.video_enabled
       FROM users u LEFT JOIN companion_profiles p ON p.user_id = u.id
      WHERE u.id = $1 AND u.status <> 'deleted'`,
    [userId],
  )).rows[0];
  if (!row) throw notFound("USER_NOT_FOUND");
  return {
    id: row.id,
    displayName: row.display_name,
    avatarId: row.avatar_id,
    gender: row.gender,
    role: row.role,
    primaryLanguage: row.primary_language,
    languages: row.languages ?? [row.primary_language],
    phone: maskPhone(row.phone),
    companion: row.kyc_status ? { kycStatus: row.kyc_status, videoEnabled: row.video_enabled ?? false } : null,
  };
}

export async function assertLanguagesActive(db: Db | DbClient, codes: string[]): Promise<void> {
  const r = await db.query<{ n: number }>(
    `SELECT count(*)::int AS n FROM languages WHERE code = ANY($1) AND is_active`, [codes],
  );
  if (r.rows[0]!.n !== new Set(codes).size) {
    throw new ApiError(400, "LANGUAGE_UNSUPPORTED", "That language is not available yet");
  }
}
