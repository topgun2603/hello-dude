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
import type { Recorder } from "../src/recording.js";
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
}

export async function createAppHarness(): Promise<AppHarness> {
  const h = createHarness();
  const tokens = new TokenService(h.db, TEST_JWT_SECRET);
  const otpCodes = new CapturingOtp();
  const push = new RecordingPush();
  const store = memoryStore();
  const uidai = await makeTestSigner();
  const recorder = new FakeRecorder();
  const app = await buildApp({
    db: h.db, redis: h.redis, engine: h.engine, rooms: h.rooms, events: h.events, tokens, push,
    otp: new OtpService(h.redis, otpCodes, TEST_JWT_SECRET),
    webhooks: fakeWebhooks,
    store, kycKey: randomBytes(32), uidaiCerts: [uidai.certPem], payouts: simulatedPayouts(), recorder,
    liveKitUrl: "wss://livekit.test",
    logger: false,
  });
  await app.ready();
  return { ...h, app, tokens, otpCodes, push, store, uidai, recorder };
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
