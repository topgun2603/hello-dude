import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, resetState } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); });

// The harness's fake Firebase verifies "firebase:<phone>" as that phone.
const firebase = (idToken: string) => call(h, "POST", "/v1/auth/firebase", { body: { idToken } });

describe("Firebase phone sign-in (mobile app)", () => {
  it("a new Indian number gets a signup token, and sign-up then works", async () => {
    const r = await firebase("firebase:+919812345678");
    expect(r.statusCode).toBe(200);
    const { status, signupToken } = json<{ status: string; signupToken: string }>(r);
    expect(status).toBe("needs_signup");

    const signup = await call(h, "POST", "/v1/auth/signup", {
      body: { signupToken, gender: "female", language: "ta", ageConfirmed: true },
    });
    expect(signup.statusCode).toBe(201);
    const u = (await h.db.query(`SELECT phone, avatar_id FROM users WHERE phone = '+919812345678'`)).rows[0];
    expect(u).toEqual({ phone: "+919812345678", avatar_id: 1 });
  });

  it("an existing account is signed straight in", async () => {
    const id = await createCaller(h, 0);
    const phone = (await h.db.query<{ phone: string }>(`SELECT phone FROM users WHERE id = $1`, [id])).rows[0]!.phone;
    const r = json<{ status: string; tokens: { accessToken: string }; profile: { id: string } }>(await firebase(`firebase:${phone}`));
    expect(r.status).toBe("signed_in");
    expect(r.profile.id).toBe(id);
    expect(r.tokens.accessToken.length).toBeGreaterThan(20);
  });

  it("only Indian mobiles: foreign and landline-style numbers are refused", async () => {
    expect(errorCode(await firebase("firebase:+14155550100"))).toBe("PHONE_NOT_SUPPORTED");
    expect(errorCode(await firebase("firebase:+911123456789"))).toBe("PHONE_NOT_SUPPORTED");
    expect(await h.db.query(`SELECT 1 FROM users`).then((r) => r.rowCount)).toBe(0);
  });

  it("an invalid or expired Firebase token is refused", async () => {
    const r = await firebase("not-a-real-firebase-id-token");
    expect(r.statusCode).toBe(401);
    expect(errorCode(r)).toBe("FIREBASE_TOKEN_INVALID");
  });

  it("a suspended account can't sign in this way either", async () => {
    const id = await createCaller(h, 0);
    const phone = (await h.db.query<{ phone: string }>(
      `UPDATE users SET status = 'suspended' WHERE id = $1 RETURNING phone`, [id])).rows[0]!.phone;
    expect(errorCode(await firebase(`firebase:${phone}`))).toBe("ACCOUNT_BLOCKED");
  });
});
