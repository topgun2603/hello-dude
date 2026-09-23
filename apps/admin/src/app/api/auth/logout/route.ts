import { API_URL, clearTokens, readTokens } from "@/lib/server/session";

export async function POST() {
  const { refresh } = await readTokens();
  if (refresh) {
    await fetch(`${API_URL}/v1/auth/logout`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ refreshToken: refresh }),
      cache: "no-store",
    }).catch(() => {});
  }
  await clearTokens();
  return new Response(null, { status: 204 });
}
