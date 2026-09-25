import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { resetState, createCaller } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, signUp, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { OTP_MAX_ATTEMPTS, OtpService } from "../auth/otp.js";
import { normalizeIndianMobile } from "../auth/phone.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); h.otpCodes.codes.clear(); });

describe("phone numbers", () => {
  it("normalizes Indian mobiles to E.164 and rejects everything else", () => {
    expect(normalizeIndianMobile("98765 43210")).toBe("+919876543210");
    expect(normalizeIndianMobile("+91-98765-43210")).toBe("+919876543210");
    expect(normalizeIndianMobile("09876543210")).toBe("+919876543210");
    expect(normalizeIndianMobile("5876543210")).toBeNull();   // Indian mobiles start 6–9
    expect(normalizeIndianMobile("+14155550100")).toBeNull();
  });

  it("answers 400 VALIDATION for a bad number", async () => {
    const r = await call(h, "POST", "/v1/auth/otp/send", { body: { phone: "12345" } });
    expect(r.statusCode).toBe(400);
    expect(errorCode(r)).toBe("VALIDATION");
  });
});

describe("OTP sign-up and sign-in", () => {
  it("new number: OTP → signup token → account with wallets, language and consent", async () => {
    const { userId, profile } = await signUp(h, "9876543210", { displayName: "Arun", avatarId: 4 });

    expect(profile).toMatchObject({
      displayName: "Arun", avatarId: 4, gender: "male", role: "caller",
      primaryLanguage: "ta", languages: ["ta"], phone: "+91 ••••••3210", companion: null,
    });
    const u = (await h.db.query(`SELECT terms_accepted_at FROM users WHERE id = $1`, [userId])).rows[0];
    expect(u.terms_accepted_at).toBeInstanceOf(Date);
    const wallets = (await h.db.query(`SELECT kind FROM wallets WHERE user_id = $1 ORDER BY kind`, [userId])).rows;
    expect(wallets.map((w) => w.kind)).toEqual(["coins", "earnings"]);
  });

  it("accepts null for optional fields, as the generated Dart client sends them", async () => {
    const { profile } = await signUp(h, "9876543210", { displayName: null, avatarId: null });
    expect(profile).toMatchObject({ displayName: "New friend", avatarId: 2 }); // male -> male avatar
  });

  it("uses a friendly default name when none is given", async () => {
    const { profile } = await signUp(h, "9876543210");
    expect(profile).toMatchObject({ displayName: "New friend", avatarId: 2 });
  });

  it("picks the illustrated avatar for the gender: 1 female, 2 male, 3 other", async () => {
    const female = await signUp(h, "9876500001", { gender: "female" });
    const other = await signUp(h, "9876500002", { gender: "other" });
    expect([female.profile, other.profile]).toMatchObject([{ avatarId: 1 }, { avatarId: 3 }]);
  });

  it("women (and transgender sign-ups) join as companions; men as callers", async () => {
    const woman = await signUp(h, "9876500011", { gender: "female" });
    const trans = await signUp(h, "9876500012", { gender: "other" });
    const man = await signUp(h, "9876500013", { gender: "male" });
    expect(woman.profile).toMatchObject({ role: "companion", companion: { kycStatus: "pending" } });
    expect(trans.profile).toMatchObject({ role: "companion" });
    expect(man.profile).toMatchObject({ role: "caller" });
    // Their token is a companion token: companion routes work, caller-only ones don't.
    expect((await call(h, "GET", "/v1/companion/kyc", { token: woman.accessToken })).statusCode).toBe(200);
    expect((await call(h, "GET", "/v1/companions/online", { token: man.accessToken })).statusCode).toBe(200);
    expect((await call(h, "POST", "/v1/companion/apply", { token: woman.accessToken, body: { firstName: "Priya" } })).statusCode).toBe(403);
  });

  it("existing number: OTP signs straight in", async () => {
    await signUp(h, "9876543210");
    await h.redis.flushdb(); // clear the resend cooldown
    await call(h, "POST", "/v1/auth/otp/send", { body: { phone: "9876543210" } });
    const code = h.otpCodes.codes.get("+919876543210");
    const r = await call(h, "POST", "/v1/auth/otp/verify", { body: { phone: "9876543210", code } });
    expect(json(r)).toMatchObject({ status: "signed_in", profile: { phone: "+91 ••••••3210" } });
    expect(json(r)).not.toHaveProperty("signupToken");
  });

  it("a code works once, wrong codes are counted, and too many kill the code", async () => {
    await call(h, "POST", "/v1/auth/otp/send", { body: { phone: "9876543210" } });
    const code = h.otpCodes.codes.get("+919876543210")!;
    const wrong = code === "000000" ? "111111" : "000000";

    const bad = await call(h, "POST", "/v1/auth/otp/verify", { body: { phone: "9876543210", code: wrong } });
    expect([bad.statusCode, errorCode(bad)]).toEqual([400, "OTP_INVALID"]);
    const ok = await call(h, "POST", "/v1/auth/otp/verify", { body: { phone: "9876543210", code } });
    expect(ok.statusCode).toBe(200);
    const again = await call(h, "POST", "/v1/auth/otp/verify", { body: { phone: "9876543210", code } });
    expect(errorCode(again)).toBe("OTP_EXPIRED");

    await h.redis.flushdb();
    await call(h, "POST", "/v1/auth/otp/send", { body: { phone: "9876543210" } });
    const fresh = h.otpCodes.codes.get("+919876543210")!;
    for (let i = 0; i < OTP_MAX_ATTEMPTS; i++) {
      await call(h, "POST", "/v1/auth/otp/verify", { body: { phone: "9876543210", code: fresh === "000000" ? "111111" : "000000" } });
    }
    const locked = await call(h, "POST", "/v1/auth/otp/verify", { body: { phone: "9876543210", code: fresh } });
    expect([locked.statusCode, errorCode(locked)]).toEqual([429, "OTP_TOO_MANY_ATTEMPTS"]);
  });

  it("enforces a 30 s resend cooldown and 3 sends per 10 minutes", async () => {
    const send = () => call(h, "POST", "/v1/auth/otp/send", { body: { phone: "9876543210" } });
    expect((await send()).statusCode).toBe(200);
    const r = await send();
    expect([r.statusCode, errorCode(r)]).toEqual([429, "OTP_COOLDOWN"]);

    for (let i = 0; i < 2; i++) { await h.redis.del("otp:cooldown:+919876543210"); expect((await send()).statusCode).toBe(200); }
    await h.redis.del("otp:cooldown:+919876543210");
    expect(errorCode(await send())).toBe("OTP_TOO_MANY_SENDS");
  });

  it("stores only a hash of the code, never the code", async () => {
    await call(h, "POST", "/v1/auth/otp/send", { body: { phone: "9876543210" } });
    const code = h.otpCodes.codes.get("+919876543210")!;
    const stored = await h.redis.hgetall("otp:+919876543210");
    expect(JSON.stringify(stored)).not.toContain(code);
  });

  it("requires the 18+ confirmation and a supported language", async () => {
    await call(h, "POST", "/v1/auth/otp/send", { body: { phone: "9876543210" } });
    const verify = await call(h, "POST", "/v1/auth/otp/verify", {
      body: { phone: "9876543210", code: h.otpCodes.codes.get("+919876543210") },
    });
    const { signupToken } = json<{ signupToken: string }>(verify);

    const noAge = await call(h, "POST", "/v1/auth/signup", { body: { signupToken, gender: "male", language: "ta" } });
    expect(errorCode(noAge)).toBe("VALIDATION");
    const badLang = await call(h, "POST", "/v1/auth/signup", {
      body: { signupToken, gender: "male", language: "fr", ageConfirmed: true },
    });
    expect(errorCode(badLang)).toBe("LANGUAGE_UNSUPPORTED");
    const forged = await call(h, "POST", "/v1/auth/signup", {
      body: { signupToken: signupToken + "x", gender: "male", language: "ta", ageConfirmed: true },
    });
    expect(errorCode(forged)).toBe("SIGNUP_TOKEN_INVALID");
  });
});

describe("sessions", () => {
  it("refresh rotates the token; reusing an old one logs out the whole family", async () => {
    const first = await signUp(h, "9876543210");
    const r1 = await call(h, "POST", "/v1/auth/refresh", { body: { refreshToken: first.refreshToken } });
    expect(r1.statusCode).toBe(200);
    const second = json<{ refreshToken: string; accessToken: string }>(r1);

    const stolen = await call(h, "POST", "/v1/auth/refresh", { body: { refreshToken: first.refreshToken } });
    expect([stolen.statusCode, errorCode(stolen)]).toEqual([401, "REFRESH_INVALID"]);
    const legit = await call(h, "POST", "/v1/auth/refresh", { body: { refreshToken: second.refreshToken } });
    expect(legit.statusCode).toBe(401);
  });

  it("logout revokes the refresh token", async () => {
    const s = await signUp(h, "9876543210");
    expect((await call(h, "POST", "/v1/auth/logout", { body: { refreshToken: s.refreshToken } })).statusCode).toBe(204);
    expect((await call(h, "POST", "/v1/auth/refresh", { body: { refreshToken: s.refreshToken } })).statusCode).toBe(401);
  });

  it("a suspended account can't refresh", async () => {
    const s = await signUp(h, "9876543210");
    await h.db.query(`UPDATE users SET status = 'suspended' WHERE id = $1`, [s.userId]);
    expect((await call(h, "POST", "/v1/auth/refresh", { body: { refreshToken: s.refreshToken } })).statusCode).toBe(401);
  });

  it("protected routes need a valid access token", async () => {
    expect((await call(h, "GET", "/v1/me")).statusCode).toBe(401);
    expect(errorCode(await call(h, "GET", "/v1/me", { token: "nonsense" }))).toBe("TOKEN_INVALID");
  });
});

describe("profile", () => {
  it("lists languages Tamil first", async () => {
    const r = json<{ code: string }[]>(await call(h, "GET", "/v1/languages"));
    expect(r.map((l) => l.code)).toEqual(["ta", "te", "kn", "ml", "hi", "bn", "mr", "en"]);
  });

  it("updates name, avatar and languages; the primary language is always included", async () => {
    const s = await signUp(h, "9876543210");
    const r = await call(h, "PATCH", "/v1/me", {
      token: s.accessToken, body: { displayName: "Karthik", primaryLanguage: "en", languages: ["ta"] },
    });
    expect(json(r)).toMatchObject({ displayName: "Karthik", primaryLanguage: "en", languages: ["en", "ta"] });
  });

  it("PATCH ignores fields sent as null (Dart client) and changes only the rest", async () => {
    const s = await signUp(h, "9876543210", { displayName: "Arun" });
    const r = await call(h, "PATCH", "/v1/me", {
      token: s.accessToken, body: { displayName: null, avatarId: null, primaryLanguage: "te", languages: null },
    });
    expect(r.statusCode).toBe(200);
    expect(json(r)).toMatchObject({ displayName: "Arun", primaryLanguage: "te", languages: ["ta", "te"] });
  });

  it("registers a device for pushes", async () => {
    const s = await signUp(h, "9876543210");
    const token = "f".repeat(40);
    expect((await call(h, "PUT", "/v1/devices", { token: s.accessToken, body: { fcmToken: token } })).statusCode).toBe(204);
    const rows = (await h.db.query(`SELECT user_id FROM devices WHERE fcm_token = $1`, [token])).rows;
    expect(rows).toEqual([{ user_id: s.userId }]);
  });
});

describe("wallet", () => {
  it("shows balances and pages through the ledger newest first", async () => {
    const caller = await createCaller(h, 100);
    const { post } = await import("../billing/ledger.js");
    const { tx } = await import("../db/pool.js");
    await tx(h.db, async (c) => {
      for (let i = 1; i <= 4; i++) await post(c, caller, "coins", "bonus", i, `test:bonus:${i}`);
    });
    const token = await tokenFor(h, caller, "caller");

    expect(json(await call(h, "GET", "/v1/wallet", { token }))).toEqual({ coins: 110, earningsPaise: 0 });
    const p1 = json<{ entries: { amount: number }[]; nextBefore: number }>(
      await call(h, "GET", "/v1/wallet/ledger?limit=3", { token }));
    expect(p1.entries.map((e) => e.amount)).toEqual([4, 3, 2]);
    const p2 = json<{ entries: { amount: number }[]; nextBefore: number | null }>(
      await call(h, "GET", `/v1/wallet/ledger?limit=3&before=${p1.nextBefore}`, { token }));
    expect(p2.entries.map((e) => e.amount)).toEqual([1, 100]);
    expect(p2.nextBefore).toBeNull();
  });
});

describe("request bodies", () => {
  it("treats an empty JSON body as no body, and rejects broken JSON with 400", async () => {
    const s = await signUp(h, "9876543210");
    const empty = await h.app.inject({ method: "POST", url: "/v1/auth/logout", headers: { "content-type": "application/json" }, payload: "" });
    expect(empty.statusCode).toBe(400); // logout needs a body: validation error, not a parser crash
    expect(errorCode(empty)).toBe("VALIDATION");
    const broken = await h.app.inject({ method: "POST", url: "/v1/auth/logout", headers: { "content-type": "application/json" }, payload: "{nope" });
    expect(broken.statusCode).toBe(400);
    void s;
  });
});

describe("docs", () => {
  it("serves an OpenAPI spec for generating the Dart client", async () => {
    const spec = json<{ openapi: string; paths: Record<string, unknown> }>(await call(h, "GET", "/openapi.json"));
    expect(spec.openapi).toMatch(/^3\./);
    expect(Object.keys(spec.paths)).toEqual(expect.arrayContaining([
      "/v1/auth/otp/send", "/v1/auth/signup", "/v1/me", "/v1/wallet", "/v1/calls", "/v1/calls/match",
      "/v1/calls/{id}", "/v1/companions/online",
    ]));
    expect(Object.keys(spec.paths)).not.toContain("/v1/webhooks/livekit");
    // Every documented operation has a stable name for the Dart client.
    const ops = Object.values(spec.paths).flatMap((p) => Object.values(p as Record<string, { operationId?: string }>));
    expect(ops.filter((o) => !o.operationId)).toEqual([]);
  });
});

describe("staging OTP allow-list", () => {
  it("the fixed dev code only works for listed test numbers", async () => {
    const sent: string[] = [];
    const otp = new OtpService(h.redis, { async send(p) { sent.push(p); } }, "x".repeat(32), "123456",
      (phone) => ["6100000001"].includes(phone.replace(/^\+91/, "")));
    await otp.send("+916100000001");
    await otp.verify("+916100000001", "123456");
    await expect(otp.send("+919876543210")).rejects.toMatchObject({ status: 403, code: "OTP_NOT_ALLOWED" });
    await expect(otp.verify("+919876543210", "123456")).rejects.toMatchObject({ code: "OTP_EXPIRED" });
    expect(sent).toEqual(["+916100000001"]);
  });
});
