import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";
import { sendRateReminders } from "../reminders.js";
import { notify } from "../notifications.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  h.push.notices.length = 0;
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

type Inbox = { unread: number; items: { id: number; type: string; title: string; body: string; data: Record<string, string>; read: boolean }[] };

describe("notifications inbox", () => {
  it("stores, pushes, pages, and marks read", async () => {
    const caller = await createCaller(h, 0);
    await h.db.query(`INSERT INTO devices (fcm_token, user_id) VALUES ('tok-1', $1)`, [caller]);
    const token = await tokenFor(h, caller, "caller");
    const deps = { db: h.db, push: h.push, events: h.events };
    for (let i = 1; i <= 3; i++) await notify(deps, caller, { type: "admin_message", title: `Hello ${i}`, body: "b", data: { k: String(i) } });

    expect(h.push.notices.map((n) => [n.tokens, n.notice.title, n.notice.data?.type])).toEqual([
      [["tok-1"], "Hello 1", "admin_message"], [["tok-1"], "Hello 2", "admin_message"], [["tok-1"], "Hello 3", "admin_message"],
    ]);
    expect(h.push.notices[0]!.notice.data?.notificationId).toMatch(/^\d+$/);
    expect(h.events.sent.filter((e) => e.event.t === "notification")).toHaveLength(3);

    const page1 = json<Inbox>(await call(h, "GET", "/v1/notifications?limit=2", { token }));
    expect(page1.unread).toBe(3);
    expect(page1.items.map((n) => n.title)).toEqual(["Hello 3", "Hello 2"]);
    const page2 = json<Inbox>(await call(h, "GET", `/v1/notifications?before=${page1.items[1]!.id}`, { token }));
    expect(page2.items.map((n) => n.title)).toEqual(["Hello 1"]);

    expect(json(await call(h, "POST", "/v1/notifications/read", { token, body: { ids: [page1.items[0]!.id] } }))).toEqual({ unread: 2 });
    expect(json(await call(h, "POST", "/v1/notifications/read", { token, body: { ids: [] } }))).toEqual({ unread: 2 }); // empty list = nothing
    expect(json(await call(h, "POST", "/v1/notifications/read", { token, body: { all: true } }))).toEqual({ unread: 0 });
    expect(json(await call(h, "GET", "/v1/notifications/unread-count", { token }))).toEqual({ unread: 0 });

    // Someone else's inbox is not visible.
    const other = await tokenFor(h, await createCaller(h, 0), "caller");
    expect(json<Inbox>(await call(h, "GET", "/v1/notifications", { token: other })).items).toEqual([]);
  });

  it("refund decisions, report outcomes and support coins land in the inbox", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    const callerToken = await tokenFor(h, caller, "caller");
    const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", { token: callerToken, body: { companionId: companion, type: "audio" } }));
    await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
    await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
    await h.db.query(`UPDATE calls SET started_at = now() - interval '5 minutes' WHERE id = $1`, [start.callId]); // past the grace period
    await call(h, "POST", `/v1/calls/${start.callId}/end`, { token: callerToken });
    await call(h, "POST", `/v1/calls/${start.callId}/refund-request`, { token: callerToken, body: { reason: "call_dropped" } });
    const [refund] = json<{ id: string }[]>(await call(h, "GET", "/v1/admin/refunds", { token: admin }));
    await call(h, "POST", `/v1/admin/refunds/${refund!.id}/decide`, { token: admin, body: { decision: "approve", note: "Dropped twice" } });

    await call(h, "POST", "/v1/reports", { token: callerToken, body: { userId: companion, callId: start.callId, reason: "abuse" } });
    const [report] = json<{ id: string }[]>(await call(h, "GET", "/v1/admin/reports", { token: admin }));
    await call(h, "POST", `/v1/admin/reports/${report!.id}/resolve`, { token: admin, body: { decision: "dismiss", note: "Nothing found" } });

    const inbox = json<Inbox>(await call(h, "GET", "/v1/notifications", { token: callerToken }));
    expect(inbox.items.map((n) => [n.type, n.title])).toEqual([
      ["report_actioned", "We reviewed your report"],
      ["refund_decided", "Refund approved"],
    ]);
    expect(inbox.items[1]!.body).toBe("+10 coins back in your wallet");
    expect(inbox.items[1]!.data).toEqual({ callId: start.callId });
  });

  it("asks once to rate a paid call nobody rated", async () => {
    await setRate(h, "ta", "audio", 10, 300);
    const caller = await createCaller(h, 100);
    const companion = await createCompanion(h);
    const rate = (await h.db.query<{ id: number }>(`SELECT id FROM call_rates LIMIT 1`)).rows[0]!.id;
    const callId = (await h.db.query<{ id: string }>(
      `INSERT INTO calls (caller_id, companion_id, type, language_code, rate_id, coins_per_min, companion_paise_per_min, room_name, status,
                          started_at, ended_at, minutes_charged)
       VALUES ($1, $2, 'audio', 'ta', $3, 10, 300, 'r1', 'ended', now() - interval '30 minutes', now() - interval '20 minutes', 3) RETURNING id`,
      [caller, companion, rate])).rows[0]!.id;
    const deps = { db: h.db, push: h.push, events: h.events };
    expect(await sendRateReminders(deps)).toBe(1);
    expect(await sendRateReminders(deps)).toBe(0); // only once
    const n = (await h.db.query<{ title: string; data: { callId: string } }>(`SELECT title, data FROM notifications WHERE user_id = $1`, [caller])).rows;
    expect(n).toEqual([{ title: "How was your call with Test companion?", data: { callId } }]);
    expect(h.push.notices).toEqual([]); // inbox only, no buzz
  });
});
