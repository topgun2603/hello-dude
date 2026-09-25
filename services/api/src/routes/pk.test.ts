import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { sweepBattles } from "./pk.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`TRUNCATE pk_battles, lives, live_viewers, live_passes, live_gifts, live_ticks, user_badges CASCADE`);
  await setRate(h, "ta", "audio", 10, 300);
});

type Battle = { id: string; status: string; a: { hostId: string; score: number }; b: { hostId: string; score: number };
  endsAt: string | null; winnerHostId: string | null };

async function host() {
  const id = await createCompanion(h);
  const token = await tokenFor(h, id, "companion");
  const live = json<{ live: { id: string } }>(await call(h, "POST", "/v1/lives", { token, body: { title: "Evening chat in Tamil" } }));
  return { id, token, liveId: live.live.id };
}
/** A viewer who has paid for a minute of `liveId`. */
async function viewer(liveId: string) {
  const id = await createCaller(h, 1000);
  const token = await tokenFor(h, id, "caller");
  await call(h, "POST", `/v1/lives/${liveId}/join`, { token, body: {} });
  await h.db.query(`UPDATE live_viewers SET preview_started_at = now() - interval '1 hour' WHERE live_id = $1 AND user_id = $2`, [liveId, id]);
  expect((await call(h, "POST", `/v1/lives/${liveId}/join`, { token, body: { pay: true } })).statusCode).toBe(200);
  return { id, token };
}
const giftId = async (coins: number) =>
  (await h.db.query<{ id: number }>(`SELECT id FROM gifts WHERE is_active ORDER BY abs(coins - $1) LIMIT 1`, [coins])).rows[0]!.id;
const gift = (liveId: string, token: string, id: number, toHostId?: string) =>
  call(h, "POST", `/v1/lives/${liveId}/gifts`, { token, body: { giftId: id, clientRef: randomUUID(), toHostId } });

async function battle() {
  const [a, b] = [await host(), await host()];
  const r = await call(h, "POST", `/v1/lives/${a.liveId}/pk`, { token: a.token, body: { opponentLiveId: b.liveId } });
  expect(r.statusCode).toBe(201);
  const inv = json<Battle>(r);
  expect(h.events.of(b.id, "live_event").map((e) => (e.event as { event: { kind: string } }).event.kind)).toContain("pk_invite");
  return { a, b, id: inv.id };
}

describe("PK battles", () => {
  it("challenge → accept → gifts to either side score → time up → winner badge", async () => {
    const { a, b, id } = await battle();
    expect(errorCode(await call(h, "POST", `/v1/pk/${id}/accept`, { token: a.token }))).toBe("NOT_INVITED");
    const started = json<Battle>(await call(h, "POST", `/v1/pk/${id}/accept`, { token: b.token }));
    expect(started.status).toBe("active");
    expect(started.endsAt).not.toBeNull();

    const va = await viewer(a.liveId);
    const g = await giftId(10);
    const coins = (await h.db.query<{ coins: number }>(`SELECT coins FROM gifts WHERE id = $1`, [g])).rows[0]!.coins;
    expect((await gift(a.liveId, va.token, g)).statusCode).toBe(201);
    // From live A, gift host B (the other side) twice.
    expect((await gift(a.liveId, va.token, g, b.id)).statusCode).toBe(201);
    expect((await gift(a.liveId, va.token, g, b.id)).statusCode).toBe(201);
    // Someone not in the battle can't be named.
    expect(errorCode(await gift(a.liveId, va.token, g, randomUUID()))).toBe("NOT_IN_BATTLE");

    const view = json<{ battle: Battle; other: { livekitRoom: string } | null }>(
      await call(h, "GET", `/v1/pk/${id}?fromLiveId=${a.liveId}`, { token: va.token }));
    expect([view.battle.a.score, view.battle.b.score]).toEqual([coins, 2 * coins]);
    expect(view.other).not.toBeNull();
    expect(h.events.of(b.id, "live_event").map((e) => (e.event as { event: { kind: string } }).event.kind)).toContain("pk_score");
    // B earned the gift share for gifts sent from A's live.
    const earnings = (await h.db.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'earnings'`, [b.id])).rows[0]!.balance;
    expect(earnings).toBeGreaterThan(0);

    await h.db.query(`UPDATE pk_battles SET ends_at = now() - interval '1 second', started_at = started_at - interval '10 minutes' WHERE id = $1`, [id]);
    await h.db.query(`UPDATE live_gifts SET created_at = created_at - interval '5 minutes'`);
    expect(await sweepBattles({ db: h.db, events: h.events, rooms: h.rooms })).toBe(1);
    const done = json<{ battle: Battle }>(await call(h, "GET", `/v1/pk/${id}?fromLiveId=${b.liveId}`, { token: b.token })).battle;
    expect(done).toMatchObject({ status: "ended", winnerHostId: b.id });
    expect([done.a.score, done.b.score]).toEqual([coins, 2 * coins]);
    expect((await h.db.query(`SELECT 1 FROM user_badges WHERE user_id = $1 AND kind = 'pk_win'`, [b.id])).rowCount).toBe(1);
    // Over: cross-side gifts are refused again.
    expect(errorCode(await gift(a.liveId, va.token, g, b.id))).toBe("NOT_IN_BATTLE");
  });

  it("one battle at a time; decline; invites expire; a live ending ends the battle", async () => {
    const { a, b, id } = await battle();
    const c = await host();
    expect(errorCode(await call(h, "POST", `/v1/lives/${c.liveId}/pk`, { token: c.token, body: { opponentLiveId: b.liveId } }))).toBe("IN_BATTLE");
    expect(json<Battle>(await call(h, "POST", `/v1/pk/${id}/decline`, { token: b.token })).status).toBe("declined");

    const r = json<Battle>(await call(h, "POST", `/v1/lives/${c.liveId}/pk`, { token: c.token, body: { opponentLiveId: b.liveId } }));
    await h.db.query(`UPDATE pk_battles SET created_at = now() - interval '1 minute' WHERE id = $1`, [r.id]);
    await sweepBattles({ db: h.db, events: h.events, rooms: h.rooms });
    expect(errorCode(await call(h, "POST", `/v1/pk/${r.id}/accept`, { token: b.token }))).toBe("INVITE_OVER");

    const again = json<Battle>(await call(h, "POST", `/v1/lives/${a.liveId}/pk`, { token: a.token, body: { opponentLiveId: b.liveId } }));
    await call(h, "POST", `/v1/pk/${again.id}/accept`, { token: b.token });
    expect((await call(h, "POST", `/v1/lives/${a.liveId}/end`, { token: a.token })).statusCode).toBeLessThan(300);
    expect(await sweepBattles({ db: h.db, events: h.events, rooms: h.rooms })).toBe(1);
    const ended = (await h.db.query<{ status: string; winner_host: string | null }>(`SELECT status, winner_host FROM pk_battles WHERE id = $1`, [again.id])).rows[0]!;
    expect(ended).toEqual({ status: "ended", winner_host: null }); // 0–0 is a draw
  });

  it("a stranger can't read a battle or get the other room's token", async () => {
    const { b, id } = await battle();
    await call(h, "POST", `/v1/pk/${id}/accept`, { token: b.token });
    const stranger = await tokenFor(h, await createCaller(h, 0), "caller");
    expect(errorCode(await call(h, "GET", `/v1/pk/${id}?fromLiveId=${b.liveId}`, { token: stranger }))).toBe("NOT_IN_BATTLE");
  });
});
