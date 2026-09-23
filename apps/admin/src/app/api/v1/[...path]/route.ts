import { API_URL, readTokens, refreshTokens } from "@/lib/server/session";

/**
 * Same-origin pass-through to the Pesu API for the admin UI. Adds the access
 * token from the httpOnly cookie, refreshes it once on 401, and only lets
 * admin endpoints (plus the language list) through.
 */
const ALLOWED = [/^admin\//, /^languages$/];

async function forward(request: Request, ctx: { params: Promise<{ path: string[] }> }) {
  const { path } = await ctx.params;
  const joined = path.join("/");
  if (!ALLOWED.some((re) => re.test(joined))) {
    return Response.json({ error: { code: "NOT_FOUND", message: "Not found" } }, { status: 404 });
  }
  const url = `${API_URL}/v1/${joined}${new URL(request.url).search}`;
  const body = request.method === "GET" || request.method === "HEAD" ? undefined : await request.text();

  const send = (token: string | undefined) =>
    fetch(url, {
      method: request.method,
      headers: {
        ...(body ? { "content-type": "application/json" } : {}),
        ...(token ? { authorization: `Bearer ${token}` } : {}),
      },
      body,
      cache: "no-store",
    });

  let { access } = await readTokens();
  if (!access) access = (await refreshTokens()) ?? undefined;
  let res = await send(access);
  if (res.status === 401) {
    const fresh = await refreshTokens();
    if (fresh) res = await send(fresh);
  }
  // Bytes, not text: KYC images must pass through unchanged (and uncached).
  return new Response(res.status === 204 ? null : await res.arrayBuffer(), {
    status: res.status,
    headers: {
      "content-type": res.headers.get("content-type") ?? "application/json",
      "cache-control": res.headers.get("cache-control") ?? "no-store",
    },
  });
}

export { forward as GET, forward as POST, forward as PUT, forward as PATCH, forward as DELETE };
