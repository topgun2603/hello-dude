import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { markInApp } from "../presence.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.redis.del(...(await h.redis.keys("invite*")), "invite:none");
  await h.db.query(`DELETE FROM app_settings WHERE key LIKE 'invite.%'`);
  await setRate(h, "ta", "audio", 10, 300);
});

type Caller = { id: string; canPay: boolean; isNew: boolean; callsWithYou: number; favouritedYou: boolean; invitedRecently: boolean };

describe("callers online, for companions", () => {
  it("lists callers with the app open: fans and regulars first, who can pay, new; blocked ones hidden", async () => {
    const companion = await createCompanion(h);
    const token = await tokenFor(h, companion, "companion");
    const rich = await createCaller(h, 500);
    const broke = await createCaller(h, 5);
    const fan = await createCaller(h, 100);
    const blocked = await createCaller(h, 100);
    const offline = await createCaller(h, 100);
    await h.db.query(`INSERT INTO favourites (user_id, companion_id) VALUES ($1, $2)`, [fan, companion]);
    await h.db.query(`INSERT INTO blocks (blocker_id, blocked_id) VALUES ($1, $2)`, [companion, blocked]);
    for (const id of [rich, broke, fan, blocked]) await markInApp(h.redis, id);
    void offline;

    const r = json<{ callers: Caller[]; canInvite: boolean }>(await call(h, "GET", "/v1/companion/callers", { token }));
    expect(r.callers.map((c) => c.id)).toEqual([fan, rich, broke]);
    expect(r.callers.find((c) => c.id === rich)).toMatchObject({ canPay: true, isNew: true, callsWithYou: 0 });
    expect(r.callers.find((c) => c.id === broke)!.canPay).toBe(false); // 5 coins < 3 min × 10
    expect(r.callers[0]!.favouritedYou).toBe(true);
    expect(r.canInvite).toBe(true); // createCompanion puts her online
    // Callers can't see this list.
    expect((await call(h, "GET", "/v1/companion/callers", { token: await tokenFor(h, rich, "caller") })).statusCode).toBe(403);
  });

  it("invites: he gets 'X wants to talk'; once an hour per caller; she must be online", async () => {
    const companion = await createCompanion(h);
    const token = await tokenFor(h, companion, "companion");
    const caller = await createCaller(h, 100);
    await markInApp(h.redis, caller);
    const invite = () => call(h, "POST", "/v1/companion/invites", { token, body: { callerId: caller } });

    expect((await invite()).statusCode).toBe(201);
    expect(h.events.of(caller, "call_invite")).toHaveLength(1);
    const note = (await h.db.query<{ title: string }>(`SELECT title FROM notifications WHERE user_id = $1 AND type = 'call_invite'`, [caller])).rows;
    expect(note).toEqual([{ title: "Test companion wants to talk" }]);
    expect(errorCode(await invite())).toBe("INVITED_RECENTLY");
    const list = json<{ callers: Caller[] }>(await call(h, "GET", "/v1/companion/callers", { token }));
    expect(list.callers[0]!.invitedRecently).toBe(true);

    const offline = await createCompanion(h, { online: false });
    expect(errorCode(await call(h, "POST", "/v1/companion/invites", {
      token: await tokenFor(h, offline, "companion"), body: { callerId: caller } }))).toBe("GO_ONLINE");
  });

  it("a caller gets at most a few invites an hour", async () => {
    await h.db.query(`INSERT INTO app_settings (key, value) VALUES ('invite.per_caller_hour', '2')`);
    const caller = await createCaller(h, 100);
    const send = async () => call(h, "POST", "/v1/companion/invites", {
      token: await tokenFor(h, await createCompanion(h), "companion"), body: { callerId: caller } });
    expect((await send()).statusCode).toBe(201);
    expect((await send()).statusCode).toBe(201);
    expect(errorCode(await send())).toBe("CALLER_BUSY_WITH_INVITES");
  });
});
