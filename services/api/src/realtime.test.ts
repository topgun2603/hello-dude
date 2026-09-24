import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { WebSocket as WsClient, type WebSocket } from "ws";
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

  it("admin sees a caller as online while their app is connected, with a last-active time after", async () => {
    const caller = await createCaller(h, 0);
    const adminId = (await h.db.query<{ id: string }>(
      `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
    )).rows[0]!.id;
    const admin = await tokenFor(h, adminId, "admin");
    type Detail = { online: boolean; takingCalls: boolean; lastActiveAt: string | null };
    const detail = async () => json<Detail>(await call(h, "GET", `/v1/admin/users/${caller}`, { token: admin }));
    const listed = async () => json<{ users: { id: string; online: boolean }[] }>(
      await call(h, "GET", "/v1/admin/users?role=caller", { token: admin })).users.find((u) => u.id === caller)!;

    expect(await detail()).toMatchObject({ online: false, takingCalls: false, lastActiveAt: null });
    // A real socket (injectWS never delivers the client's close to the server).
    const address = await h.app.listen({ port: 0, host: "127.0.0.1" });
    const ws = new WsClient(`${address.replace("http", "ws")}/v1/ws?token=${encodeURIComponent(await tokenFor(h, caller, "caller"))}`);
    await new Promise((r) => ws.once("message", r));
    await new Promise((r) => setTimeout(r, 50));
    expect(await detail()).toMatchObject({ online: true, takingCalls: false });
    expect((await listed()).online).toBe(true);
    const dash = json<{ live: { callersOnline: number; companionsInApp: number } }>(await call(h, "GET", "/v1/admin/dashboard", { token: admin }));
    expect(dash.live).toMatchObject({ callersOnline: 1, companionsInApp: 0 });

    ws.close();
    for (let i = 0; i < 100 && (await detail()).online; i++) await new Promise((r) => setTimeout(r, 30));
    const after = await detail();
    expect(after.online).toBe(false);
    expect(after.lastActiveAt).not.toBeNull();
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
