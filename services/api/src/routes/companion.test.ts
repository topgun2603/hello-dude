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
import { makeTestAadhaarZip, TINY_JPEG } from "../../test/aadhaar-fixture.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";

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

async function aadhaar(token: string, opts: Parameters<typeof makeTestAadhaarZip>[1] = {}) {
  const zip = await makeTestAadhaarZip(h.uidai, { shareCode: "AB12", ...opts });
  return call(h, "POST", "/v1/companion/kyc/aadhaar", { token, body: { zipBase64: b64(zip), shareCode: "AB12" } });
}

/** Runs every KYC step and submits. */
async function submitted(firstName = "Priya", last4 = "1234") {
  const a = await applicant(firstName);
  expect((await aadhaar(a.token, { last4, name: `${firstName} R` })).statusCode).toBe(200);
  expect((await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(TINY_JPEG), blinks: 2 } })).statusCode).toBe(200);
  expect((await call(h, "POST", "/v1/companion/kyc/pan", { token: a.token, body: { panNumber: "abcpe1234f", imageBase64: b64(PNG) } })).statusCode).toBe(200);
  expect((await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "priya@okaxis" } })).statusCode).toBe(200);
  const s = await call(h, "POST", "/v1/companion/kyc/submit", { token: a.token });
  expect(json(s)).toMatchObject({ status: "submitted" });
  return a;
}

async function approved() {
  const a = await submitted();
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
  it("walks through Aadhaar → selfie → PAN → UPI → submit, then locks", async () => {
    const a = await applicant();
    const s1 = json<{ aadhaar: object; status: string }>(await aadhaar(a.token, { name: "Priya Raman", dob: "15-08-1998", last4: "4321" }));
    expect(s1).toMatchObject({ status: "in_progress", aadhaar: { done: true, name: "Priya Raman", last4: "4321", age: expect.any(Number) } });

    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/submit", { token: a.token }))).toBe("KYC_INCOMPLETE");
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(TINY_JPEG), blinks: 1 } })))
      .toBe("VALIDATION"); // must blink twice
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(Buffer.from("not an image")), blinks: 2 } })))
      .toBe("IMAGE_INVALID");
    await call(h, "POST", "/v1/companion/kyc/selfie", { token: a.token, body: { imageBase64: b64(TINY_JPEG), blinks: 3 } });
    expect(errorCode(await call(h, "POST", "/v1/companion/kyc/pan", { token: a.token, body: { panNumber: "ABCCE1234F", imageBase64: b64(PNG) } })))
      .toBe("VALIDATION"); // 4th letter C = company, not a person
    const s3 = json<{ pan: object }>(await call(h, "POST", "/v1/companion/kyc/pan", { token: a.token, body: { panNumber: "ABCPE1234F", imageBase64: b64(PNG) } }));
    expect(s3.pan).toEqual({ done: true, last4: "234F" });
    expect(errorCode(await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "not-a-upi" } }))).toBe("VALIDATION");
    const s4 = json<{ upi: object }>(await call(h, "PUT", "/v1/companion/upi", { token: a.token, body: { upiId: "Priya.R@okaxis" } }));
    expect(s4.upi).toEqual({ done: true, masked: "priy••••@okaxis" });

    expect(json(await call(h, "POST", "/v1/companion/kyc/submit", { token: a.token }))).toMatchObject({ status: "submitted" });
    expect(errorCode(await aadhaar(a.token))).toBe("KYC_LOCKED");

    // Stored: the ZIP, the Aadhaar photo, the selfie and the PAN card; the PAN number only encrypted.
    expect(h.store.keys().sort()).toEqual([`kyc/${a.userId}/aadhaar_offline`, `kyc/${a.userId}/aadhaar_photo`, `kyc/${a.userId}/pan`, `kyc/${a.userId}/selfie`]);
    const pan = (await h.db.query<{ pan_encrypted: Buffer }>(`SELECT pan_encrypted FROM companion_profiles WHERE user_id = $1`, [a.userId])).rows[0]!;
    expect(pan.pan_encrypted.toString("latin1")).not.toContain("ABCPE1234F");
  });

  it("auto-rejects anyone under 18", async () => {
    const a = await applicant();
    const minorDob = new Date(Date.now() - 16 * 365.25 * 86_400_000);
    const dob = `${String(minorDob.getUTCDate()).padStart(2, "0")}-${String(minorDob.getUTCMonth() + 1).padStart(2, "0")}-${minorDob.getUTCFullYear()}`;
    expect(errorCode(await aadhaar(a.token, { dob }))).toBe("AADHAAR_UNDER_18");
    expect(json(await call(h, "GET", "/v1/companion/kyc", { token: a.token }))).toMatchObject({ status: "rejected", rejectReason: "Under 18" });
  });

  it("wants a fresh download from UIDAI", async () => {
    const a = await applicant();
    expect(errorCode(await aadhaar(a.token, { generatedAt: new Date(Date.now() - 4 * 86_400_000) }))).toBe("AADHAAR_ZIP_TOO_OLD");
  });

  it("refuses the same Aadhaar on a second account", async () => {
    const first = await applicant("Priya");
    await aadhaar(first.token, { name: "Priya Raman", last4: "5555" });
    const second = await applicant("Priya");
    expect(errorCode(await aadhaar(second.token, { name: "Priya Raman", last4: "5555" }))).toBe("AADHAAR_ALREADY_USED");
  });
});

describe("admin KYC review", () => {
  it("lists submitted cases, serves decrypted images (audited), and approval lets them go online", async () => {
    const a = await submitted();
    const queue = json<{ userId: string; aadhaar: { name: string }; documents: string[]; selfieBlinks: number }[]>(
      await call(h, "GET", "/v1/admin/kyc", { token: adminToken }));
    expect(queue).toHaveLength(1);
    expect(queue[0]).toMatchObject({ userId: a.userId, aadhaar: { name: "Priya R" }, documents: ["aadhaar_photo", "pan", "selfie"], selfieBlinks: 2 });

    const img = await h.app.inject({ method: "GET", url: `/v1/admin/kyc/${a.userId}/files/aadhaar_photo`, headers: { authorization: `Bearer ${adminToken}` } });
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
    const pending = await submitted("Kavya", "7777");
    expect(errorCode(await call(h, "POST", `/v1/admin/companions/${pending.userId}/video`, { token: adminToken, body: { enabled: true, reason: "academy done" } })))
      .toBe("KYC_NOT_APPROVED");
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
