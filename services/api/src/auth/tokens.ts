/**
 * Access tokens: 15-minute HS256 JWTs carrying the user id and role.
 * Signup tokens: 15-minute JWTs proving a phone number was OTP-verified.
 * Refresh tokens: random 32 bytes, stored hashed in `sessions`, rotated on use.
 */
import { createHash, randomBytes, randomUUID } from "node:crypto";
import { jwtVerify, SignJWT } from "jose";
import { tx, type Db } from "../db/pool.js";
import { unauthorized } from "../errors.js";

export type Role = "caller" | "companion" | "admin";
export interface AccessClaims { userId: string; role: Role }
export interface TokenPair { accessToken: string; refreshToken: string; expiresInSeconds: number }

const ACCESS_TTL_S = 15 * 60;
const SIGNUP_TTL_S = 15 * 60;
const REFRESH_TTL_DAYS = 30;
const ISSUER = "pesu-api";

const sha256 = (s: string) => createHash("sha256").update(s).digest();

export class TokenService {
  private readonly key: Uint8Array;

  constructor(private readonly db: Db, secret: string) {
    this.key = new TextEncoder().encode(secret);
  }

  async issue(userId: string, role: Role, familyId: string = randomUUID()): Promise<TokenPair> {
    const refreshToken = randomBytes(32).toString("base64url");
    await this.db.query(
      `INSERT INTO sessions (user_id, token_hash, family_id, expires_at)
       VALUES ($1, $2, $3, now() + $4 * interval '1 day')`,
      [userId, sha256(refreshToken), familyId, REFRESH_TTL_DAYS],
    );
    const accessToken = await new SignJWT({ role, typ: "access" })
      .setProtectedHeader({ alg: "HS256" })
      .setSubject(userId).setIssuer(ISSUER).setIssuedAt().setExpirationTime(`${ACCESS_TTL_S}s`)
      .sign(this.key);
    return { accessToken, refreshToken, expiresInSeconds: ACCESS_TTL_S };
  }

  async verifyAccess(token: string): Promise<AccessClaims> {
    try {
      const { payload } = await jwtVerify(token, this.key, { issuer: ISSUER, algorithms: ["HS256"] });
      if (payload.typ !== "access" || !payload.sub) throw new Error("wrong token type");
      return { userId: payload.sub, role: payload.role as Role };
    } catch {
      throw unauthorized("TOKEN_INVALID");
    }
  }

  /**
   * Swaps a refresh token for a new pair. Reusing an old (rotated) token means
   * it was copied, so every session in that family is revoked.
   */
  async refresh(refreshToken: string): Promise<TokenPair> {
    const session = await tx(this.db, async (c) => {
      const s = (await c.query<{ id: string; user_id: string; family_id: string; revoked: boolean; expired: boolean; role: Role; status: string }>(
        `SELECT s.id, s.user_id, s.family_id, s.revoked_at IS NOT NULL AS revoked,
                s.expires_at < now() AS expired, u.role, u.status
           FROM sessions s JOIN users u ON u.id = s.user_id
          WHERE s.token_hash = $1 FOR UPDATE OF s`,
        [sha256(refreshToken)],
      )).rows[0];
      if (!s) return null;
      if (s.revoked) {
        await c.query(`UPDATE sessions SET revoked_at = now() WHERE family_id = $1 AND revoked_at IS NULL`, [s.family_id]);
        return null;
      }
      await c.query(`UPDATE sessions SET revoked_at = now() WHERE id = $1`, [s.id]);
      if (s.expired || s.status !== "active") return null;
      return s;
    });
    if (!session) throw unauthorized("REFRESH_INVALID");
    return this.issue(session.user_id, session.role, session.family_id);
  }

  async revoke(refreshToken: string): Promise<void> {
    await this.db.query(
      `UPDATE sessions SET revoked_at = now() WHERE token_hash = $1 AND revoked_at IS NULL`,
      [sha256(refreshToken)],
    );
  }

  async signupToken(phone: string): Promise<string> {
    return new SignJWT({ typ: "signup", phone })
      .setProtectedHeader({ alg: "HS256" })
      .setIssuer(ISSUER).setIssuedAt().setExpirationTime(`${SIGNUP_TTL_S}s`)
      .sign(this.key);
  }

  async verifySignup(token: string): Promise<string> {
    try {
      const { payload } = await jwtVerify(token, this.key, { issuer: ISSUER, algorithms: ["HS256"] });
      if (payload.typ !== "signup" || typeof payload.phone !== "string") throw new Error("wrong token type");
      return payload.phone;
    } catch {
      throw unauthorized("SIGNUP_TOKEN_INVALID");
    }
  }
}
