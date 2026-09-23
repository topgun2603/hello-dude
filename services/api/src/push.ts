/**
 * Push notifications through Firebase Cloud Messaging. The incoming-call push
 * is data-only and high priority so the app's background handler can show the
 * full-screen call UI (flutter_callkit_incoming) on a locked phone.
 */
import { readFileSync } from "node:fs";
import { cert, initializeApp, type App } from "firebase-admin/app";
import { getMessaging, type Message } from "firebase-admin/messaging";

export interface IncomingCallPush {
  callId: string;
  callType: "audio" | "video";
  callerName: string;
  callerAvatarId: number;
}

export interface Notice {
  title: string;
  body: string;
  /** Extra string data for the app (e.g. which screen to open). */
  data?: Record<string, string>;
}

export interface PushSender {
  incomingCall(fcmTokens: string[], push: IncomingCallPush): Promise<void>;
  notify(fcmTokens: string[], notice: Notice): Promise<void>;
}

/** Ring timeout is 45 s; a later delivery would ring for a call that is already missed. */
const RING_TTL_MS = 45_000;

export function logPushSender(log: (msg: string) => void): PushSender {
  return {
    async incomingCall(tokens, push) {
      log(`push incoming_call ${push.callId} (${push.callType}) to ${tokens.length} device(s)`);
    },
    async notify(tokens, notice) {
      log(`push notice "${notice.title}" to ${tokens.length} device(s)`);
    },
  };
}

/** FCM error codes meaning the token will never work again. */
const DEAD_TOKEN = new Set([
  "messaging/registration-token-not-registered",
  "messaging/invalid-registration-token",
  "messaging/invalid-argument",
]);

export function fcmPushSender(opts: {
  serviceAccountPath: string;
  /** Called with tokens FCM rejected for good, so they can be deleted. */
  onDeadTokens: (tokens: string[]) => Promise<void>;
  log: (msg: string, err?: unknown) => void;
}): PushSender {
  const credentials = JSON.parse(readFileSync(opts.serviceAccountPath, "utf8"));
  const app: App = initializeApp({ credential: cert(credentials) }, "pesu-push");
  const messaging = getMessaging(app);

  async function send(tokens: string[], build: (token: string) => Message, what: string) {
    if (!tokens.length) return;
    const res = await messaging.sendEach(tokens.map(build));
    const dead = res.responses.flatMap((r, i) => (!r.success && DEAD_TOKEN.has(r.error?.code ?? "") ? [tokens[i]!] : []));
    if (dead.length) await opts.onDeadTokens(dead);
    const failed = res.responses.filter((r) => !r.success && !DEAD_TOKEN.has(r.error?.code ?? ""));
    if (failed.length) opts.log(`push ${what}: ${failed.length}/${tokens.length} failed`, failed[0]?.error);
  }

  return {
    incomingCall: (tokens, p) => send(tokens, (token) => ({
      token,
      data: {
        type: "incoming_call", callId: p.callId, callType: p.callType,
        callerName: p.callerName, callerAvatarId: String(p.callerAvatarId),
      },
      android: { priority: "high", ttl: RING_TTL_MS },
    }), `incoming_call ${p.callId}`),

    notify: (tokens, n) => send(tokens, (token) => ({
      token,
      notification: { title: n.title, body: n.body },
      data: n.data,
      android: { priority: "high" },
    }), "notice"),
  };
}
