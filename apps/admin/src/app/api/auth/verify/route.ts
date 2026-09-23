import { API_URL, saveTokens, type TokenPair } from "@/lib/server/session";

const denied = (code: string, message: string, status = 403) =>
  Response.json({ error: { code, message } }, { status });

/**
 * Step 2: verify the OTP. Only admin accounts get a session; anyone else is
 * turned away and their fresh tokens are revoked straight away.
 */
export async function POST(request: Request) {
  const { phone, code } = (await request.json()) as { phone?: string; code?: string };
  const res = await fetch(`${API_URL}/v1/auth/otp/verify`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ phone, code }),
    cache: "no-store",
  });
  const body = await res.json();
  if (!res.ok) return Response.json(body, { status: res.status });

  const result = body as { status: string; tokens?: TokenPair; profile?: { role: string; displayName: string } };
  if (result.status !== "signed_in" || !result.tokens || result.profile?.role !== "admin") {
    if (result.tokens) {
      await fetch(`${API_URL}/v1/auth/logout`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ refreshToken: result.tokens.refreshToken }),
      }).catch(() => {});
    }
    return denied("NOT_ADMIN", "This number doesn't have admin access");
  }
  await saveTokens(result.tokens);
  return Response.json({ displayName: result.profile.displayName });
}
