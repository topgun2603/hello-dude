import "server-only";
import { cookies } from "next/headers";

/**
 * The admin panel keeps the API's tokens in httpOnly cookies, so page
 * scripts never see them. Every API call goes through /api/v1/* (see the
 * route handler there), which attaches the token and refreshes it.
 */
export const API_URL = process.env.PESU_API_URL ?? "http://127.0.0.1:9000";

const ACCESS = "pesu_admin_at";
const REFRESH = "pesu_admin_rt";
export const REFRESH_COOKIE = REFRESH;

const base = {
  httpOnly: true,
  sameSite: "strict" as const,
  secure: process.env.NODE_ENV === "production",
  path: "/",
};

export interface TokenPair { accessToken: string; refreshToken: string; expiresInSeconds: number }

export async function saveTokens(t: TokenPair): Promise<void> {
  const jar = await cookies();
  jar.set(ACCESS, t.accessToken, { ...base, maxAge: t.expiresInSeconds });
  jar.set(REFRESH, t.refreshToken, { ...base, maxAge: 30 * 24 * 3600 });
}

export async function clearTokens(): Promise<void> {
  const jar = await cookies();
  jar.delete(ACCESS);
  jar.delete(REFRESH);
}

export async function readTokens(): Promise<{ access?: string; refresh?: string }> {
  const jar = await cookies();
  return { access: jar.get(ACCESS)?.value, refresh: jar.get(REFRESH)?.value };
}

/** Swaps the refresh cookie for a new pair. Returns the new access token, or null (signed out). */
export async function refreshTokens(): Promise<string | null> {
  const { refresh } = await readTokens();
  if (!refresh) return null;
  const res = await fetch(`${API_URL}/v1/auth/refresh`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ refreshToken: refresh }),
    cache: "no-store",
  });
  if (!res.ok) {
    await clearTokens();
    return null;
  }
  const pair = (await res.json()) as TokenPair;
  await saveTokens(pair);
  return pair.accessToken;
}
