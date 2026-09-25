import { mkdtemp, readdir, readFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { randomBytes } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { tx } from "../db/pool.js";
import { ensureWallets, post } from "../billing/ledger.js";
import { ONLINE_SET } from "../billing/engine.js";
import { localEncryptedStore, open, seal } from "../storage.js";
import { balance, createCaller, resetState } from "../../test/fixtures.js";
import { TINY_JPEG } from "../../test/aadhaar-fixture.js";
import { call, createAppHarness, errorCode, json, signUp, tokenFor, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
let adminToken: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  adminToken = await tokenFor(h, adminId, "admin");
});

const b64 = (b: Buffer) => b.toString("base64");
const PNG = Buffer.from("89504e470d0a1a0a0000000d49484452", "hex");

/** A caller who applied: returns their companion token. */
async function applicant(firstName = "Priya") {
  const userId = await createCaller(h, 0);
  const callerToken = await tokenFor(h, userId, "caller");
  const r = await call(h, "POST", "/v1/companion/apply", { token: callerToken, body: { firstName, bio: null } });
  expect(r.statusCode).toBe(200);
  const body = json<{ tokens: { accessToken: string }; profile: { role: string; displayName: string } }>(r);
  return { userId, token: body.tokens.accessToken, profile: body.profile, callerToken };
}

/** YYYY-MM-DD for someone `years` old today. */
const bornYearsAgo = (years: number) => {
  const d = new Date();
  d.setUTCFullYear(d.getUTCFullYear() - years);
  return d.toISOString().slice(0, 10);
};
const confirmAge = (token: string, birthDate = "1998-08-15") =>
  call(h, "POST", "/v1/companion/kyc/age", { token, body: { birthDate, confirm18: true } });

/** Runs every KYC step and submits (with a PAN unless `pan` is false). */
async function submitted(firstName = "Priya", pan = true) {
  const a = await applicant(firstName);
  expect((await confirmAge(a.token)).statusCode).toBe(200);
  expect((await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(TINY_JPEG), blinks: 2 } })).statusCode).toBe(200);
  if (pan) {
    expect((await call(h, "POST", "/v1/companion/kyc/pan", { token: a.token, body: { panNumber: "abcpe1234f", imageBase64: b64(PNG) } })).statusCode).toBe(200);
  }
  expect((await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "priya@okaxis" } })).statusCode).toBe(200);
  const s = await call(h, "POST", "/v1/companion/kyc/submit", { token: a.token });
  expect(json(s)).toMatchObject({ status: "submitted" });
  return a;
}

async function approved(pan = true) {
  const a = await submitted("Priya", pan);
  expect((await call(h, "POST", `/v1/admin/kyc/${a.userId}/decision`, {
    token: adminToken, body: { decision: "approve", reason: "Photos match" },
  })).statusCode).toBe(204);
  return a;
}

describe("becoming a companion", () => {
  it("switches the account to companion mode with fresh tokens; caller tokens stop refreshing", async () => {
    const userId = await createCaller(h, 0);
    const old = await h.tokens.issue(userId, "caller");
    const r = json<{ profile: { role: string; displayName: string; companion: object } }>(await call(h, "POST", "/v1/companion/apply", {
      token: old.accessToken, body: { firstName: "Priya" },
    }));
    expect(r.profile).toMatchObject({ role: "companion", displayName: "Priya", companion: { kycStatus: "pending", videoEnabled: false } });
    expect((await call(h, "POST", "/v1/auth/refresh", { body: { refreshToken: old.refreshToken } })).statusCode).toBe(401);
  });

  it("can't go online before approval", async () => {
    const a = await applicant();
    expect(errorCode(await call(h, "POST", "/v1/companion/presence", { token: a.token, body: { online: true } }))).toBe("KYC_NOT_APPROVED");
  });
});

describe("KYC", () => {
  it("walks through age → selfie → UPI → submit (PAN optional), then locks; no Aadhaar", async () => {
    const a = await applicant();
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/age", { token: a.token, body: { birthDate: "1998-08-15", confirm18: false } })))
      .toBe("VALIDATION"); // must tick "I am 18+"
    const s1 = json<{ age: object; status: string }>(await confirmAge(a.token, "1998-08-15"));
    expect(s1).toMatchObject({ status: "in_progress", age: { done: true, birthDate: "1998-08-15", age: expect.any(Number) } });

    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/submit", { token: a.token }))).toBe("KYC_INCOMPLETE");
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(TINY_JPEG), blinks: 1 } })))
      .toBe("VALIDATION"); // must blink twice
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(Buffer.from("not an image")), blinks: 2 } })))
      .toBe("IMAGE_INVALID");
    await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(TINY_JPEG), blinks: 3 } });
    expect(errorCode(await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "not-a-upi" } }))).toBe("VALIDATION");
    const s4 = json<{ upi: object; pan: object }>(await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "Priya.R@okaxis" } }));
    expect(s4.upi).toEqual({ done: true, masked: "priy••••@okaxis" });
    expect(s4.pan).toEqual({ done: false, last4: null });

    // No PAN needed to submit.
    expect(json(await call(h, "POST", "/v1/companion/kyc/submit", { token: a.token }))).toMatchObject({ status: "submitted" });
    expect(errorCode(await confirmAge(a.token))).toBe("KYC_LOCKED");
    expect(h.store.keys()).toEqual([`kyc/${a.userId}/selfie`]);
    expect((await call(h, "POST", "/v1/companion/kyc/aadhaar", { token: a.token, body: {} })).statusCode).toBe(404);
  });

  it("PAN is optional, checked, stored only encrypted, and can be added after approval", async () => {
    const a = await approved(false);
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/pan", { token: a.token, body: { panNumber: "ABCCE1234F", imageBase64: b64(PNG) } })))
      .toBe("VALIDATION"); // 4th letter C = company, not a person
    const s = json<{ pan: object }>(await call(h, "POST", "/v1/companion/kyc/pan", { token: a.token, body: { panNumber: "ABCPE1234F", imageBase64: b64(PNG) } }));
    expect(s.pan).toEqual({ done: true, last4: "234F" });
    const pan = (await h.db.query<{ pan_encrypted: Buffer }>(`SELECT pan_encrypted FROM companion_profiles WHERE user_id = $1`, [a.userId])).rows[0]!;
    expect(pan.pan_encrypted.toString("latin1")).not.toContain("ABCPE1234F");
  });

  it("auto-rejects anyone under 18", async () => {
    const a = await applicant();
    expect(errorCode(await confirmAge(a.token, bornYearsAgo(16)))).toBe("UNDER_18");
    expect(json(await call(h, "GET", "/v1/companion/kyc", { token: a.token }))).toMatchObject({ status: "rejected", rejectReason: "Under 18" });
    expect(errorCode(await confirmAge((await applicant("Kavya")).token, "2999-01-01"))).toBe("BAD_DATE");
  });
});

describe("admin KYC review", () => {
  it("lists submitted cases, serves decrypted images (audited), and approval lets them go online", async () => {
    const a = await submitted();
    const queue = json<{ userId: string; declared: { birthDate: string }; documents: string[]; selfieBlinks: number }[]>(
      await call(h, "GET", "/v1/admin/kyc", { token: adminToken }));
    expect(queue).toHaveLength(1);
    expect(queue[0]).toMatchObject({ userId: a.userId, declared: { birthDate: "1998-08-15" }, documents: ["pan", "selfie"], selfieBlinks: 2 });

    const img = await h.app.inject({ method: "GET", url: `/v1/admin/kyc/${a.userId}/files/selfie`, headers: { authorization: `Bearer ${adminToken}` } });
    expect(img.headers["content-type"]).toBe("image/jpeg");
    expect(img.headers["cache-control"]).toContain("no-store");
    expect(img.rawPayload.equals(TINY_JPEG)).toBe(true);
    const callerView = await h.app.inject({ method: "GET", url: `/v1/admin/kyc/${a.userId}/files/selfie`, headers: { authorization: `Bearer ${a.token}` } });
    expect(callerView.statusCode).toBe(403);

    await call(h, "POST", `/v1/admin/kyc/${a.userId}/decision`, { token: adminToken, body: { decision: "approve", reason: "Photos match" } });
    expect((await call(h, "POST", "/v1/companion/presence", { token: a.token, body: { online: true } })).statusCode).toBe(200);
    const actions = (await h.db.query<{ action: string }>(`SELECT action FROM audit_log ORDER BY id`)).rows.map((r) => r.action);
    expect(actions).toEqual(["kyc.view", "kyc.approve"]);
    expect(errorCode(await call(h, "POST", `/v1/admin/kyc/${a.userId}/decision`, { token: adminToken, body: { decision: "reject", reason: "late" } })))
      .toBe("KYC_NOT_SUBMITTED");
  });

  it("rejection shows the reason to the companion and lets them fix and resubmit", async () => {
    const a = await submitted();
    await call(h, "POST", `/v1/admin/kyc/${a.userId}/decision`, { token: adminToken, body: { decision: "reject", reason: "Selfie too dark" } });
    expect(json(await call(h, "GET", "/v1/companion/kyc", { token: a.token }))).toMatchObject({ status: "rejected", rejectReason: "Selfie too dark" });
    await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(TINY_JPEG), blinks: 2 } });
    expect(json(await call(h, "POST", "/v1/companion/kyc/submit", { token: a.token }))).toMatchObject({ status: "submitted", rejectReason: null });
  });

  it("video is unlocked separately, only for approved companions", async () => {
    const pending = await submitted("Kavya");
    expect(errorCode(await call(h, "POST", `/v1/admin/companions/${pending.userId}/video`, { token: adminToken, body: { enabled: true, reason: "academy done" } })))
      .toBe("KYC_NOT_APPROVED");
  });
});

describe("women companions: voice intro and joining bonus", () => {
  /** A fake m4a header (the server only checks the container type). */
  const M4A = Buffer.concat([Buffer.from([0, 0, 0, 0x20]), Buffer.from("ftypM4A "), Buffer.alloc(400, 3)]);
  type Kyc = { status: string; voice: { needed: boolean; done: boolean; sentence: string | null } };

  async function woman(phone = "9811100001") {
    const w = await signUp(h, phone, { gender: "female", displayName: "Divya" });
    const token = w.accessToken;
    expect((await confirmAge(token)).statusCode).toBe(200);
    await call(h, "POST", "/v1/companion/kyc/selfie", { token, body: { imageBase64: b64(TINY_JPEG), blinks: 2 } });
    await call(h, "PUT", "/v1/companion/upi", { token, body: { upiId: "divya@okaxis" } });
    return { userId: w.userId, token };
  }

  it("needs the voice intro to submit; the sentence is random; admins can play it", async () => {
    const w = await woman();
    const k = json<Kyc>(await call(h, "GET", "/v1/companion/kyc", { token: w.token }));
    expect(k.voice).toMatchObject({ needed: true, done: false });
    // In her language (she signed up with Tamil), ending in 4 random digits.
    expect(k.voice.sentence).toMatch(/[஀-௿].* \d \d \d \d\.$/);
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/submit", { token: w.token }))).toBe("KYC_INCOMPLETE");
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/voice", { token: w.token, body: { audioBase64: b64(TINY_JPEG) } }))).toBe("AUDIO_INVALID");
    expect(json<Kyc>(await call(h, "POST", "/v1/companion/kyc/voice", { token: w.token, body: { audioBase64: b64(M4A) } })).voice.done).toBe(true);
    expect(json(await call(h, "POST", "/v1/companion/kyc/submit", { token: w.token }))).toMatchObject({ status: "submitted" });

    const queue = json<{ userId: string; voice: { needed: boolean; sentence: string } ; documents: string[] }[]>(
      await call(h, "GET", "/v1/admin/kyc", { token: adminToken }));
    expect(queue[0]).toMatchObject({ userId: w.userId, voice: { needed: true, sentence: k.voice.sentence }, documents: ["selfie", "voice"] });
    const clip = await h.app.inject({ method: "GET", url: `/v1/admin/kyc/${w.userId}/files/voice`, headers: { authorization: `Bearer ${adminToken}` } });
    expect(clip.headers["content-type"]).toBe("audio/mp4");
  });

  it("approval pays the ₹10 joining bonus once and deletes the voice clip", async () => {
    const w = await woman();
    await call(h, "GET", "/v1/companion/kyc", { token: w.token });
    await call(h, "POST", "/v1/companion/kyc/voice", { token: w.token, body: { audioBase64: b64(M4A) } });
    await call(h, "POST", "/v1/companion/kyc/submit", { token: w.token });
    expect((await call(h, "POST", `/v1/admin/kyc/${w.userId}/decision`, { token: adminToken, body: { decision: "approve", reason: "Voice and selfie match" } })).statusCode).toBe(204);
    expect(await balance(h, w.userId, "earnings")).toBe(1000);
    expect(h.store.keys()).not.toContain(`kyc/${w.userId}/voice`);
    const note = (await h.db.query<{ body: string }>(`SELECT body FROM notifications WHERE user_id = $1 AND type = 'kyc_decided'`, [w.userId])).rows[0]!;
    expect(note.body).toContain("₹10 joining bonus");
    // A man who applies gets no voice step and no bonus.
    const m = await approved();
    expect(await balance(h, m.userId, "earnings")).toBe(0);
    expect(json<Kyc>(await call(h, "GET", "/v1/companion/kyc", { token: m.token })).voice).toEqual({ needed: false, done: false, sentence: null });
  });

  it("a rejection deletes the clip and asks for a new recording with a new sentence", async () => {
    const w = await woman();
    const first = json<Kyc>(await call(h, "GET", "/v1/companion/kyc", { token: w.token })).voice.sentence;
    await call(h, "POST", "/v1/companion/kyc/voice", { token: w.token, body: { audioBase64: b64(M4A) } });
    await call(h, "POST", "/v1/companion/kyc/submit", { token: w.token });
    await call(h, "POST", `/v1/admin/kyc/${w.userId}/decision`, { token: adminToken, body: { decision: "reject", reason: "Voice doesn't match", redo: ["voice"] } });
    const k = json<Kyc>(await call(h, "GET", "/v1/companion/kyc", { token: w.token }));
    expect(k).toMatchObject({ status: "rejected", voice: { needed: true, done: false } });
    expect(k.voice.sentence).not.toBeNull();
    expect(h.store.keys()).not.toContain(`kyc/${w.userId}/voice`);
    expect(await balance(h, w.userId, "earnings")).toBe(0);
    expect(first).not.toBeNull();
  });
});

describe("rejections name what to redo", () => {
  const M4A = Buffer.concat([Buffer.from([0, 0, 0, 0x20]), Buffer.from("ftypM4A "), Buffer.alloc(400, 3)]);
  type Kyc = { status: string; redo: string[]; voice: { done: boolean }; pan: { done: boolean } };
  const kyc = async (token: string) => json<Kyc>(await call(h, "GET", "/v1/companion/kyc", { token }));
  const reject = (userId: string, reason: string, redo: string[]) =>
    call(h, "POST", `/v1/admin/kyc/${userId}/decision`, { token: adminToken, body: { decision: "reject", reason, redo } });

  async function submittedWoman() {
    const w = await signUp(h, "9811100077", { gender: "female", displayName: "Divya" });
    const token = w.accessToken;
    await confirmAge(token);
    await call(h, "POST", "/v1/companion/kyc/selfie", { token, body: { imageBase64: b64(TINY_JPEG), blinks: 2 } });
    await call(h, "PUT", "/v1/companion/upi", { token, body: { upiId: "divya@okaxis" } });
    await call(h, "POST", "/v1/companion/kyc/pan", { token, body: { panNumber: "ABCPE1234F", imageBase64: b64(PNG) } });
    await kyc(token);
    await call(h, "POST", "/v1/companion/kyc/voice", { token, body: { audioBase64: b64(M4A) } });
    expect(json(await call(h, "POST", "/v1/companion/kyc/submit", { token }))).toMatchObject({ status: "submitted" });
    return { userId: w.userId, token };
  }

  it("a PAN rejection keeps the voice intro; re-uploading the PAN sends it back to review by itself", async () => {
    const w = await submittedWoman();
    expect((await reject(w.userId, "PAN photo is unreadable — please upload a clear photo", ["pan"])).statusCode).toBe(204);
    expect(await kyc(w.token)).toMatchObject({ status: "rejected", redo: ["pan"], voice: { done: true }, pan: { done: false } });
    // Submitting without the PAN is refused; sending the PAN resubmits.
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/submit", { token: w.token }))).toBe("KYC_INCOMPLETE");
    const after = json<Kyc>(await call(h, "POST", "/v1/companion/kyc/pan", { token: w.token, body: { panNumber: "ABCPE9999F", imageBase64: b64(PNG) } }));
    expect(after).toMatchObject({ status: "submitted", redo: [] });
    const queue = json<{ userId: string; voice: { checkedAt: string | null } }[]>(await call(h, "GET", "/v1/admin/kyc", { token: adminToken }));
    expect(queue.find((q) => q.userId === w.userId)!.voice.checkedAt).not.toBeNull(); // already heard, clip deleted
  });

  it("with several items, it goes back only after all of them are sent", async () => {
    const w = await submittedWoman();
    await reject(w.userId, "Selfie too dark, and please record the voice again", ["selfie", "voice"]);
    await kyc(w.token); // gets a new sentence
    expect(json<Kyc>(await call(h, "POST", "/v1/companion/kyc/voice", { token: w.token, body: { audioBase64: b64(M4A) } })))
      .toMatchObject({ status: "rejected", redo: ["selfie"] });
    expect(json<Kyc>(await call(h, "POST", "/v1/companion/kyc/selfie", { token: w.token, body: { imageBase64: b64(TINY_JPEG), blinks: 2 } })))
      .toMatchObject({ status: "submitted", redo: [] });
  });
});

describe("earnings and withdrawals", () => {
  async function withEarnings(paise: number) {
    const a = await approved();
    await tx(h.db, async (c) => {
      await ensureWallets(c, a.userId);
      await post(c, a.userId, "earnings", "call_credit", paise, `test:earn:${a.userId}:${paise}`);
    });
    // The UPI was set moments ago; make it look old so it doesn't flag every test.
    await h.db.query(`UPDATE companion_profiles SET upi_updated_at = now() - interval '3 days' WHERE user_id = $1`, [a.userId]);
    return a;
  }

  it("withdraws everything: balance drops now, 1% TDS, one open withdrawal at a time", async () => {
    const a = await withEarnings(124_000);
    const e = json<{ availablePaise: number; canWithdraw: boolean; upi: string }>(await call(h, "GET", "/v1/companion/earnings", { token: a.token }));
    expect(e).toMatchObject({ availablePaise: 124_000, canWithdraw: true, upi: "pri••••@okaxis" });

    const p = json<{ grossPaise: number; tdsPaise: number; netPaise: number; status: string }>(
      await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }));
    expect(p).toMatchObject({ grossPaise: 124_000, tdsPaise: 1_240, netPaise: 122_760, status: "requested" });
    expect(await balance(h, a.userId, "earnings")).toBe(0);
    expect(errorCode(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }))).toBe("PAYOUT_PENDING");
    expect(errorCode(await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "other@ybl" } }))).toBe("PAYOUT_PENDING");
  });

  it("without a PAN, withdrawals carry 20% TDS (and the app is told)", async () => {
    const a = await approved(false);
    await tx(h.db, (c) => post(c, a.userId, "earnings", "call_credit", 50_000, `test:nopan:${a.userId}`));
    await h.db.query(`UPDATE companion_profiles SET upi_updated_at = now() - interval '3 days' WHERE user_id = $1`, [a.userId]);
    expect(json(await call(h, "GET", "/v1/companion/earnings", { token: a.token })))
      .toMatchObject({ panOnFile: false, tdsBps: 2000, tdsWithPanBps: 100, tdsNoPanBps: 2000 });
    const p = json<{ tdsPaise: number; netPaise: number }>(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }));
    expect(p).toMatchObject({ tdsPaise: 10_000, netPaise: 40_000 });
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/pan", { token: a.token, body: { panNumber: "ABCPE1234F", imageBase64: b64(PNG) } })))
      .toBe("PAYOUT_PENDING");
  });

  it("admin approval pays via the provider", async () => {
    const a = await withEarnings(50_000);
    const p = json<{ id: string }>(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: { amountPaise: 20_000 } }));
    const list = json<{ payouts: { id: string; flags: string[] }[]; totals: { requestedCount: number } }>(
      await call(h, "GET", "/v1/admin/payouts", { token: adminToken }));
    expect(list.totals.requestedCount).toBe(1);
    expect(list.payouts[0]).toMatchObject({ id: p.id, flags: [] });

    const paid = json<{ status: string; providerRef: string }>(await call(h, "POST", `/v1/admin/payouts/${p.id}/approve`, { token: adminToken }));
    expect(paid.status).toBe("paid");
    expect(paid.providerRef).toMatch(/^sim_/);
    expect(await balance(h, a.userId, "earnings")).toBe(30_000);
    expect(errorCode(await call(h, "POST", `/v1/admin/payouts/${p.id}/approve`, { token: adminToken }))).toBe("PAYOUT_NOT_PENDING");
  });

  it("a payout that fails at the bank goes back to the balance", async () => {
    const a = await withEarnings(50_000);
    await h.db.query(`UPDATE companion_profiles SET upi_id = 'willfail@okaxis' WHERE user_id = $1`, [a.userId]);
    const p = json<{ id: string }>(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }));
    expect(await balance(h, a.userId, "earnings")).toBe(0);
    const r = json<{ status: string; failureReason: string }>(await call(h, "POST", `/v1/admin/payouts/${p.id}/approve`, { token: adminToken }));
    expect(r.status).toBe("failed");
    expect(await balance(h, a.userId, "earnings")).toBe(50_000);
  });

  it("RazorpayX: 'processing' payouts are finished by the webhook or the worker check, once", async () => {
    const { razorpayXResult } = await import("../payouts/provider.js");
    const { checkProcessingPayouts } = await import("../payouts/finish.js");
    const { hmacHex } = await import("../payments/razorpay.js");
    const states = new Map<string, string>();
    const fake = {
      name: "razorpayx-fake",
      async send() { states.set("pout_1", "processing"); return razorpayXResult({ id: "pout_1", status: "processing" }); },
      async status(ref: string) { return razorpayXResult({ id: ref, status: states.get(ref) ?? "processing" }); },
      webhookSignatureOk: (raw: string, sig: string | undefined) => hmacHex("x-secret", raw) === sig,
    };
    const original = h.app.deps.payouts;
    h.app.deps.payouts = fake;
    try {
      const a = await withEarnings(50_000);
      const p = json<{ id: string }>(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }));
      const r = json<{ status: string; providerRef: string }>(await call(h, "POST", `/v1/admin/payouts/${p.id}/approve`, { token: adminToken }));
      expect(r).toMatchObject({ status: "processing", providerRef: "pout_1" });
      await h.db.query(`UPDATE payouts SET approved_at = now() - interval '10 minutes' WHERE id = $1`, [p.id]);

      // Worker: still processing at the bank → nothing changes.
      const deps = { db: h.db, push: h.push, events: h.events };
      expect(await checkProcessingPayouts(deps, fake)).toEqual({ paid: 0, failed: 0 });

      // Webhook: bad signature refused; a failure (reversed) returns the money once.
      const hook = (event: string, status: string, secret = "x-secret") => {
        const payload = JSON.stringify({ event, payload: { payout: { entity: { id: "pout_1", status, reference_id: p.id } } } });
        return h.app.inject({ method: "POST", url: "/v1/webhooks/razorpayx", payload,
          headers: { "content-type": "application/json", "x-razorpay-signature": hmacHex(secret, payload) } });
      };
      expect((await hook("payout.reversed", "reversed", "wrong")).statusCode).toBe(401);
      expect((await hook("payout.reversed", "reversed")).statusCode).toBe(200);
      expect((await hook("payout.reversed", "reversed")).statusCode).toBe(200);
      expect(await balance(h, a.userId, "earnings")).toBe(50_000);

      // Another withdrawal, confirmed by the worker check this time.
      const p2 = json<{ id: string }>(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }));
      states.set("pout_1", "processing");
      await call(h, "POST", `/v1/admin/payouts/${p2.id}/approve`, { token: adminToken });
      await h.db.query(`UPDATE payouts SET approved_at = now() - interval '10 minutes', provider_ref = 'pout_2' WHERE id = $1`, [p2.id]);
      states.set("pout_2", "processed");
      expect(await checkProcessingPayouts(deps, fake)).toEqual({ paid: 1, failed: 0 });
      expect(await checkProcessingPayouts(deps, fake)).toEqual({ paid: 0, failed: 0 });
      expect(await balance(h, a.userId, "earnings")).toBe(0);
      const notes = (await h.db.query<{ type: string }>(`SELECT type FROM notifications WHERE user_id = $1 AND type LIKE 'payout_%' ORDER BY id`, [a.userId])).rows;
      expect(notes.map((n) => n.type)).toEqual(["payout_failed", "payout_paid"]);
    } finally {
      h.app.deps.payouts = original;
    }
  });

  it("an admin rejection goes back to the balance", async () => {
    const a = await withEarnings(50_000);
    const p = json<{ id: string }>(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }));
    await call(h, "POST", `/v1/admin/payouts/${p.id}/reject`, { token: adminToken, body: { reason: "Name mismatch on UPI" } });
    expect(await balance(h, a.userId, "earnings")).toBe(50_000);
    const mine = json<{ payouts: { status: string; failureReason: string }[] }>(await call(h, "GET", "/v1/companion/earnings", { token: a.token }));
    expect(mine.payouts[0]).toMatchObject({ status: "rejected", failureReason: "Name mismatch on UPI" });
  });

  it("enforces the minimum and flags a UPI change right before a withdrawal", async () => {
    const a = await withEarnings(9_000);
    expect(errorCode(await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} }))).toBe("BELOW_MINIMUM");
    await tx(h.db, (c) => post(c, a.userId, "earnings", "call_credit", 10_000, `test:more:${a.userId}`));
    await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "newupi@ybl" } });
    await call(h, "POST", "/v1/companion/payouts", { token: a.token, body: {} });
    const list = json<{ payouts: { flags: string[] }[]; totals: { flaggedCount: number } }>(await call(h, "GET", "/v1/admin/payouts", { token: adminToken }));
    expect(list.payouts[0]!.flags).toEqual(["upi_changed_recently"]);
    expect(list.totals.flaggedCount).toBe(1);
  });

  it("companion home shows status and today's numbers", async () => {
    const a = await approved();
    await call(h, "POST", "/v1/companion/presence", { token: a.token, body: { online: true } });
    const home = json(await call(h, "GET", "/v1/companion/home", { token: a.token }));
    expect(home).toMatchObject({ kycStatus: "approved", online: true, videoEnabled: false, today: { earnedPaise: 0, calls: 0 }, recent: [] });
    expect(await h.redis.sismember(ONLINE_SET, a.userId)).toBe(1);
  });
});

describe("encrypted storage", () => {
  it("writes only ciphertext to disk and detects tampering", async () => {
    const key = randomBytes(32);
    const dir = await mkdtemp(path.join(tmpdir(), "pesu-kyc-"));
    const store = localEncryptedStore(dir, key);
    const secret = Buffer.from("AADHAAR-PHOTO-BYTES");
    await store.put("kyc/u1/selfie", secret);
    const onDisk = await readFile(path.join(dir, "kyc", "u1", (await readdir(path.join(dir, "kyc", "u1")))[0]!));
    expect(onDisk.includes(secret)).toBe(false);
    expect((await store.get("kyc/u1/selfie")).equals(secret)).toBe(true);

    const sealed = seal(key, secret);
    sealed[sealed.length - 1]! ^= 1;
    expect(() => open(key, sealed)).toThrow();
    await expect(localEncryptedStore(dir, key).put("../escape", secret)).rejects.toThrow(/bad object key/);
  });
});

describe("shared-phone fraud check", () => {
  it("flags a withdrawal when her phone has been used by 3+ accounts; the raw id is never stored", async () => {
    const { riskFlags } = await import("./companion.js");
    const companion = await signUp(h, "9876511111");
    const register = (token: string, deviceId: string, fcm: string) => call(h, "PUT", "/v1/devices", {
      token, body: { fcmToken: fcm.padEnd(24, "x"), deviceId },
    });
    const companionId = companion.userId;
    expect((await register(companion.accessToken, "android-abc123", "fcm-a")).statusCode).toBe(204);
    expect(await tx(h.db, (c) => riskFlags(c, companionId))).not.toContain("shared_device");

    const second = await signUp(h, "9876511112");
    await register(second.accessToken, "android-abc123", "fcm-a"); // same phone, same push token
    expect(await tx(h.db, (c) => riskFlags(c, companionId))).not.toContain("shared_device");
    const third = await signUp(h, "9876511113");
    await register(third.accessToken, "android-abc123", "fcm-b");
    expect(await tx(h.db, (c) => riskFlags(c, companionId))).toContain("shared_device");

    const stored = (await h.db.query<{ device_hash: string }>(`SELECT DISTINCT device_hash FROM device_accounts`)).rows;
    expect(stored).toHaveLength(1);
    expect(stored[0]!.device_hash).toMatch(/^[0-9a-f]{64}$/);
  });
});
