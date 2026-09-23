import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import type { WebSocket } from "ws";
import { createCaller, createCompanion, resetState, setRate } from "../test/fixtures.js";
import { call, createAppHarness, json, tokenFor, webhook, type AppHarness } from "../test/app-harness.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); });

/** Opens /v1/ws and collects every message (the harness publishes through RecordingEvents, so
 *  here we publish to Redis directly the way redisUserEvents does in production). */
async function connect(token: string) {
  const ws: WebSocket = await h.app.injectWS(`/v1/ws?token=${encodeURIComponent(token)}`);
  const got: Record<string, unknown>[] = [];
  ws.on("message", (m) => got.push(JSON.parse(m.toString())));
  const next = async (t: string) => {
    for (let i = 0; i < 50; i++) {
      const hit = got.find((e) => e.t === t);
      if (hit) return hit;
      await new Promise((r) => setTimeout(r, 20));
    }
    throw new Error(`no ${t} event; got ${JSON.stringify(got)}`);
  };
  return { ws, got, next };
}

describe("realtime WebSocket", () => {
  it("delivers events published for the user, and only for that user", async () => {
    const a = await createCaller(h, 0);
    const b = await createCaller(h, 0);
    const sa = await connect(await tokenFor(h, a, "caller"));
    const sb = await connect(await tokenFor(h, b, "caller"));
    await sa.next("hello");
    await sb.next("hello");

    await h.redis.publish(`user:${a}`, JSON.stringify({ t: "low_balance", callId: "c1" }));
    expect(await sa.next("low_balance")).toEqual({ t: "low_balance", callId: "c1" });
    await new Promise((r) => setTimeout(r, 100));
    expect(sb.got.map((e) => e.t)).toEqual(["hello"]);
    sa.ws.close(); sb.ws.close();
  });

  it("refuses a connection without a valid token", async () => {
    const ws: WebSocket = await h.app.injectWS("/v1/ws?token=nope");
    const code = await new Promise<number>((r) => ws.on("close", (c) => r(c)));
    expect(code).toBe(4401);
  });
});

describe("call events", () => {
  it("companion hears incoming_call; caller hears call_accepted; both hear call_connected", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    const callerToken = await tokenFor(h, caller, "caller");
    const companionToken = await tokenFor(h, companion, "companion");

    const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
      token: callerToken, body: { companionId: companion, type: "audio" },
    }));
    expect(h.events.of(companion, "incoming_call")[0]?.event).toMatchObject({
      callId: start.callId, callType: "audio", caller: { id: caller, displayName: "Test caller" },
    });

    await call(h, "POST", `/v1/calls/${start.callId}/accept`, { token: companionToken });
    expect(h.events.of(caller, "call_accepted")).toHaveLength(1);

    await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
    await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
    expect(h.events.of(caller, "call_connected")[0]?.event).toMatchObject({ coinsPerMin: 10, balanceAfterFirstMinute: 90 });
    expect(h.events.of(companion, "call_connected")[0]?.event).toMatchObject({ balanceAfterFirstMinute: null });
  });
});
