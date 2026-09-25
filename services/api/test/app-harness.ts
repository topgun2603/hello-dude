import { expect } from "vitest";
import type { FastifyInstance, LightMyRequestResponse } from "fastify";
import { buildApp } from "../src/app.js";
import { OtpService, type OtpSender } from "../src/auth/otp.js";
import { TokenService, type Role } from "../src/auth/tokens.js";
import type { RoomWebhookEvent, WebhookVerifier } from "../src/billing/ports.js";
import type { IncomingCallPush, Notice, PushSender } from "../src/push.js";
import { createHarness, type Harness } from "./fixtures.js";
import { memoryStore } from "../src/storage.js";
import { simulatedPayouts } from "../src/payouts/provider.js";
import { checkoutSignature, hmacHex, type RazorpayGateway, type RazorpayOrder, type RazorpayPayment } from "../src/payments/razorpay.js";
import type { Recorder } from "../src/recording.js";
import type { PhoneVerifier } from "../src/auth/firebase-auth.js";
import { ApiError } from "../src/errors.js";
import { makeTestSigner, type TestSigner } from "./aadhaar-fixture.js";
import { randomBytes } from "node:crypto";

export const TEST_JWT_SECRET = "test-secret-that-is-at-least-32-characters-long";
export const WEBHOOK_AUTH = "test-signature";

export class CapturingOtp implements OtpSender {
  readonly codes = new Map<string, string>();
  async send(phone: string, code: string) { this.codes.set(phone, code); }
}

/** Pretends to record: remembers what was started and stopped. */
export class FakeRecorder implements Recorder {
  enabled = true;
  readonly started: string[] = [];
  readonly stopped: string[] = [];
  async start(room: string, reportId: string) { this.started.push(room); return { egressId: `eg_${reportId}`, storageKey: `recordings/${reportId}` }; }
  async stop(egressId: string) { this.stopped.push(egressId); }
}

export class RecordingPush implements PushSender {
  readonly sent: { tokens: string[]; push: IncomingCallPush }[] = [];
  async incomingCall(tokens: string[], push: IncomingCallPush) { this.sent.push({ tokens, push }); }
  readonly notices: { tokens: string[]; notice: Notice }[] = [];
  async notify(tokens: string[], notice: Notice) { this.notices.push({ tokens, notice }); }
}

/** Stands in for Firebase: the ID token "firebase:<phone>" verifies as that phone. */
export const fakeFirebase: PhoneVerifier = {
  async verifyIdToken(idToken) {
    if (!idToken.startsWith("firebase:")) throw new ApiError(401, "FIREBASE_TOKEN_INVALID", "Sign-in expired, verify your number again");
    return idToken.slice("firebase:".length);
  },
};

/** Accepts JSON bodies whose Authorization header is WEBHOOK_AUTH. */
export const fakeWebhooks: WebhookVerifier = {
  async verify(raw, auth) {
    if (auth !== WEBHOOK_AUTH) throw new Error("bad signature");
    return JSON.parse(raw) as RoomWebhookEvent;
  },
};

export interface AppHarness extends Harness {
  app: FastifyInstance;
  tokens: TokenService;
  otpCodes: CapturingOtp;
  push: RecordingPush;
  store: ReturnType<typeof memoryStore>;
  uidai: TestSigner;
  recorder: FakeRecorder;
  razorpay: FakeRazorpay;
}

export const RZP_TEST_SECRET = "rzp_test_secret_for_tests";
export const RZP_WEBHOOK_SECRET = "rzp_webhook_secret_for_tests";

/** In-memory Razorpay: orders get ids, tests decide what each payment looks like. */
export class FakeRazorpay implements RazorpayGateway {
  readonly keyId = "rzp_test_key";
  orders: RazorpayOrder[] = [];
  payments = new Map<string, RazorpayPayment>();
  captured: string[] = [];
  private n = 0;
  async createOrder(amount: number): Promise<RazorpayOrder> {
    const o = { id: `order_${++this.n}`, amount, currency: "INR", status: "created" };
    this.orders.push(o);
    return o;
  }
  async fetchPayment(id: string): Promise<RazorpayPayment> {
    const p = this.payments.get(id);
    if (!p) throw new Error(`no payment ${id}`);
    return p;
  }
  async capture(id: string): Promise<RazorpayPayment> {
    this.captured.push(id);
    const p = { ...(await this.fetchPayment(id)), status: "captured" as const };
    this.payments.set(id, p);
    return p;
  }
  checkoutSignatureOk(orderId: string, paymentId: string, signature: string): boolean {
    return checkoutSignature(RZP_TEST_SECRET, orderId, paymentId) === signature;
  }
  webhookSignatureOk(raw: string, signature: string | undefined): boolean {
    return hmacHex(RZP_WEBHOOK_SECRET, raw) === signature;
  }
  /** A payment Razorpay would report for [orderId]. */
  pay(orderId: string, overrides: Partial<RazorpayPayment> = {}): RazorpayPayment {
    const order = this.orders.find((o) => o.id === orderId)!;
    const p: RazorpayPayment = { id: `pay_${++this.n}`, order_id: orderId, amount: order.amount, currency: "INR",
      status: "captured", amount_refunded: 0, ...overrides };
    this.payments.set(p.id, p);
    return p;
  }
}

export async function createAppHarness(): Promise<AppHarness> {
  const h = createHarness();
  const tokens = new TokenService(h.db, TEST_JWT_SECRET);
  const otpCodes = new CapturingOtp();
  const push = new RecordingPush();
  const store = memoryStore();
  const uidai = await makeTestSigner();
  const recorder = new FakeRecorder();
  const razorpay = new FakeRazorpay();
  const app = await buildApp({
    db: h.db, redis: h.redis, engine: h.engine, rooms: h.rooms, events: h.events, tokens, push,
    otp: new OtpService(h.redis, otpCodes, TEST_JWT_SECRET),
    phoneAuth: fakeFirebase,
    webhooks: fakeWebhooks,
    store, kycKey: randomBytes(32), uidaiCerts: [uidai.certPem], payouts: simulatedPayouts(), recorder, razorpay,
    liveKitUrl: "wss://livekit.test",
    logger: false,
  });
  await app.ready();
  return { ...h, app, tokens, otpCodes, push, store, uidai, recorder, razorpay };
}

/** Access token for a user created by the fixtures. */
export async function tokenFor(h: AppHarness, userId: string, role: Role): Promise<string> {
  return (await h.tokens.issue(userId, role)).accessToken;
}

type Method = "GET" | "POST" | "PATCH" | "PUT" | "DELETE";

export function call(h: AppHarness, method: Method, url: string, opts: { token?: string; body?: unknown } = {}) {
  return h.app.inject({
    method, url,
    headers: opts.token ? { authorization: `Bearer ${opts.token}` } : {},
    ...(opts.body !== undefined ? { payload: opts.body as object } : {}),
  });
}

export function webhook(h: AppHarness, event: RoomWebhookEvent, auth = WEBHOOK_AUTH) {
  return h.app.inject({
    method: "POST", url: "/v1/webhooks/livekit",
    headers: { authorization: auth, "content-type": "application/webhook+json" },
    payload: JSON.stringify(event),
  });
}

export const json = <T = Record<string, unknown>>(r: LightMyRequestResponse) => r.json() as T;
export const errorCode = (r: LightMyRequestResponse) => (r.json() as { error: { code: string } }).error.code;

/** Full OTP sign-up through the API. Returns the new user's tokens and id. */
export async function signUp(h: AppHarness, phone: string, extra: Record<string, unknown> = {}) {
  expect((await call(h, "POST", "/v1/auth/otp/send", { body: { phone } })).statusCode).toBe(200);
  const e164 = [...h.otpCodes.codes.keys()].at(-1)!;
  const verify = await call(h, "POST", "/v1/auth/otp/verify", { body: { phone, code: h.otpCodes.codes.get(e164) } });
  const { signupToken } = json<{ signupToken: string }>(verify);
  const res = await call(h, "POST", "/v1/auth/signup", {
    body: { signupToken, gender: "male", language: "ta", ageConfirmed: true, ...extra },
  });
  expect(res.statusCode).toBe(201);
  const body = json<{ tokens: { accessToken: string; refreshToken: string }; profile: { id: string } }>(res);
  return { ...body.tokens, userId: body.profile.id, profile: body.profile };
}
