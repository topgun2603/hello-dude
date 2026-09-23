import { API_URL } from "@/lib/server/session";

/** Step 1 of admin sign-in: ask the API to send the OTP. */
export async function POST(request: Request) {
  const { phone } = (await request.json()) as { phone?: string };
  const res = await fetch(`${API_URL}/v1/auth/otp/send`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ phone }),
    cache: "no-store",
  });
  return new Response(await res.text(), { status: res.status, headers: { "content-type": "application/json" } });
}
