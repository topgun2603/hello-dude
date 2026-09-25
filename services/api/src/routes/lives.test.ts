import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";
import { CallError } from "../billing/engine.js";
import { sweepLives } from "./lives.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.db.query(`TRUNCATE lives, live_viewers, live_passes, live_gifts, live_ticks CASCADE`);
  await setRate(h, "ta", "audio", 10, 300);
  h.rooms.identities.clear();
  (h.rooms as unknown as { removed: unknown[] }).removed.length = 0;
});

type Join = { live: { id: string }; livekitRoom: string; token: string; access: { kind: string; minutes: number }; coinsLeft: number | null;
  pricing: { previewSeconds: number; coinsPerMin: number } };

async function world(coins = 500) {
  const hostId = await createCompanion(h);
  const host = await tokenFor(h, hostId, "companion");
  const viewerId = await createCaller(h, coins);
  const viewer = await tokenFor(h, viewerId, "caller");
  const started = await call(h, "POST", "/v1/lives", { token: host, body: { title: "Evening chat in Tamil", language: null } });
  expect(started.statusCode).toBe(201);
  const live = json<Join>(started);
  return { hostId, host, viewerId, viewer, live, liveId: live.live.id, room: live.livekitRoom };
}
type W = Awaited<ReturnType<typeof world>>;
const balance = async (userId: string, kind: "coins" | "earnings") =>
  (await h.db.query<{ balance: number }>(`SELECT balance FROM wallets WHERE user_id = $1 AND kind = $2`, [userId, kind])).rows[0]!.balance;
const endPreview = (liveId: string, userId: string) =>
  h.db.query(`UPDATE live_viewers SET preview_started_at = now() - interval '1 hour' WHERE live_id = $1 AND user_id = $2`, [liveId, userId]);
const join = (w: W, pay?: boolean) => call(h, "POST", `/v1/lives/${w.liveId}/join`, { token: w.viewer, body: pay === undefined ? {} : { pay } });
/** Pretend a minute has passed since the last charge, with the viewer in the LiveKit room. */
const nextMinute = async (w: W, userId = w.viewerId) => {
  await h.db.query(`UPDATE live_viewers SET last_charged_at = now() - interval '61 seconds' WHERE live_id = $1 AND user_id = $2`, [w.liveId, userId]);
  h.rooms.identities.set(w.room, new Set([w.hostId, userId]));
  return sweepLives({ db: h.db, events: h.events, rooms: h.rooms });
};
const sweep = () => sweepLives({ db: h.db, events: h.events, rooms: h.rooms });
const ticks = async (liveId: string) =>
  (await h.db.query<{ minute_no: number }>(`SELECT minute_no FROM live_ticks WHERE live_id = $1 ORDER BY minute_no`, [liveId])).rows.map((r) => r.minute_no);
const kinds = (userId: string) => h.events.of(userId, "live_event").map((e) => (e.event as { event: { kind: string } }).event.kind);

describe("going live", () => {
  it("host gets a publish token; video must be unlocked; one live at a time; shows in the feed with the price", async () => {
    const w = await world();
    expect(w.live.access.kind).toBe("host");
    expect(w.live.token).not.toContain(":listen");
    expect(errorCode(await call(h, "POST", "/v1/lives", { token: w.host, body: { title: "Another one" } }))).toBe("ALREADY_LIVE");
    const locked = await tokenFor(h, await createCompanion(h, { video: false }), "companion");
    expect(errorCode(await call(h, "POST", "/v1/lives", { token: locked, body: { title: "No video yet" } }))).toBe("VIDEO_LOCKED");
    const feed = json<{ lives: { id: string }[]; pricing: { coinsPerMin: number } }>(await call(h, "GET", "/v1/lives", { token: w.viewer }));
    expect(feed.lives.map((l) => l.id)).toContain(w.liveId);
    expect(feed.pricing.coinsPerMin).toBe(3);
  });

  it("no 1:1 calls while live, and nothing is charged", async () => {
    const w = await world();
    await h.redis.sadd("online:companions", w.hostId);
    const before = await balance(w.viewerId, "coins");
    await expect(h.engine.startCall(w.viewerId, w.hostId, "audio")).rejects.toMatchObject({ code: "BUSY" });
    await expect(h.engine.startCall(w.viewerId, w.hostId, "audio")).rejects.toBeInstanceOf(CallError);
    expect(await balance(w.viewerId, "coins")).toBe(before);
  });

  it("at most 4 lives a day per companion", async () => {
    const w = await world();
    for (let i = 0; i < 3; i++) {
      await call(h, "POST", `/v1/lives/${w.liveId}/end`, { token: w.host });
      const again = json<Join>(await call(h, "POST", "/v1/lives", { token: w.host, body: { title: `Round ${i + 2}` } }));
      w.liveId = again.live.id;
    }
    await call(h, "POST", `/v1/lives/${w.liveId}/end`, { token: w.host });
    expect(errorCode(await call(h, "POST", "/v1/lives", { token: w.host, body: { title: "Fifth" } }))).toBe("LIVE_DAILY_LIMIT");
  });
});

describe("per-minute billing", () => {
  it("free preview, then the viewer must agree before anything is charged", async () => {
    const w = await world();
    const p = json<Join>(await join(w));
    expect(p.access.kind).toBe("preview");
    expect(p.token).toContain(":listen");
    await endPreview(w.liveId, w.viewerId);
    expect(errorCode(await join(w))).toBe("PAY_TO_WATCH");
    expect(await balance(w.viewerId, "coins")).toBe(500);

    const paid = json<Join>(await join(w, true));
    expect(paid.access).toMatchObject({ kind: "paying", minutes: 1 });
    expect(paid.coinsLeft).toBe(497);
    // Companion share: 3 coins × coin value × 25% (defaults: 80 paise → 60 paise).
    expect(await balance(w.hostId, "earnings")).toBe(Math.round((3 * 80 * 2500) / 10_000));
  });

  it("charges once per minute while in the room — never twice for the same minute", async () => {
    const w = await world();
    await join(w);
    await endPreview(w.liveId, w.viewerId);
    await join(w, true);
    h.rooms.identities.set(w.room, new Set([w.hostId, w.viewerId]));
    expect((await sweep()).charged).toBe(0); // minute 1 still running
    expect((await nextMinute(w)).charged).toBe(1);
    expect((await sweep()).charged).toBe(0); // same minute, swept again
    expect((await nextMinute(w)).charged).toBe(1);
    expect(await ticks(w.liveId)).toEqual([1, 2, 3]);
    expect(await balance(w.viewerId, "coins")).toBe(491);
    expect(kinds(w.viewerId)).toContain("charged");
  });

  it("warns when the next minute can't be paid, then removes the viewer — balance never goes negative", async () => {
    const w = await world(5);
    await join(w);
    await endPreview(w.liveId, w.viewerId);
    expect(json<Join>(await join(w, true)).coinsLeft).toBe(2);
    await nextMinute(w);
    expect(kinds(w.viewerId)).toContain("access");
    expect((h.rooms as unknown as { removed: { identity: string }[] }).removed.map((r) => r.identity)).toContain(w.viewerId);
    expect(await balance(w.viewerId, "coins")).toBe(2);
    expect(await ticks(w.liveId)).toEqual([1]);

    // Not enough for even one minute: refused, nothing charged.
    const poorId = await createCaller(h, 1);
    const poor = { ...w, viewerId: poorId, viewer: await tokenFor(h, poorId, "caller") };
    await join(poor);
    await endPreview(w.liveId, poorId);
    expect(errorCode(await join(poor, true))).toBe("INSUFFICIENT_BALANCE");
    expect(await balance(poorId, "coins")).toBe(1);
  });

  it("leaving stops the charge; viewers not in the LiveKit room aren't charged; preview-only viewers are removed", async () => {
    const w = await world();
    await join(w);
    await endPreview(w.liveId, w.viewerId);
    await join(w, true);
    await call(h, "POST", `/v1/lives/${w.liveId}/leave`, { token: w.viewer });
    await nextMinute(w);
    expect(await ticks(w.liveId)).toEqual([1]);

    // Paying but not actually in the room (per LiveKit): no charge.
    await join(w, true); // opting in again pays the next minute now
    await h.db.query(`UPDATE live_viewers SET last_charged_at = now() - interval '61 seconds' WHERE live_id = $1`, [w.liveId]);
    h.rooms.identities.set(w.room, new Set([w.hostId]));
    await sweep();
    expect(await ticks(w.liveId)).toEqual([1, 2]);

    // Someone whose preview ended without agreeing is removed from the room, unpaid.
    const lurkerId = await createCaller(h, 100);
    await call(h, "POST", `/v1/lives/${w.liveId}/join`, { token: await tokenFor(h, lurkerId, "caller"), body: {} });
    await endPreview(w.liveId, lurkerId);
    h.rooms.identities.set(w.room, new Set([w.hostId, lurkerId]));
    expect((await sweep()).removed).toBe(1);
    expect(await balance(lurkerId, "coins")).toBe(100);
  });

  it("free previews are capped per day", async () => {
    await h.db.query(`INSERT INTO app_settings (key, value) VALUES ('live.previews_per_day', '1') ON CONFLICT (key) DO UPDATE SET value = '1'`);
    try {
      const a = await world();
      const b = await world();
      expect(json<Join>(await call(h, "POST", `/v1/lives/${a.liveId}/join`, { token: a.viewer, body: {} })).access.kind).toBe("preview");
      // Same viewer, second live today: no free preview left.
      expect(errorCode(await call(h, "POST", `/v1/lives/${b.liveId}/join`, { token: a.viewer, body: {} }))).toBe("PAY_TO_WATCH");
    } finally {
      await h.db.query(`UPDATE app_settings SET value = '20' WHERE key = 'live.previews_per_day'`);
    }
  });
});

describe("controls", () => {
  it("empty lives: warned at half time, ended at the limit", async () => {
    const w = await world();
    h.rooms.identities.set(w.room, new Set([w.hostId]));
    await sweep(); // starts the empty clock
    await h.db.query(`UPDATE lives SET empty_since = now() - interval '6 minutes' WHERE id = $1`, [w.liveId]);
    await sweep();
    expect(kinds(w.hostId)).toContain("empty_warning");
    await h.db.query(`UPDATE lives SET empty_since = now() - interval '11 minutes' WHERE id = $1`, [w.liveId]);
    expect((await sweep()).ended).toBe(1);
    expect(errorCode(await join(w))).toBe("LIVE_ENDED");
  });

  it("someone watching resets the empty clock", async () => {
    const w = await world();
    await h.db.query(`UPDATE lives SET empty_since = now() - interval '9 minutes' WHERE id = $1`, [w.liveId]);
    await join(w);
    h.rooms.identities.set(w.room, new Set([w.hostId, w.viewerId]));
    await sweep();
    expect((await h.db.query<{ empty_since: Date | null }>(`SELECT empty_since FROM lives WHERE id = $1`, [w.liveId])).rows[0]!.empty_since).toBeNull();
  });

  it("lives end at the maximum length; quiet hosts end their live", async () => {
    const w = await world();
    await h.db.query(`UPDATE lives SET started_at = now() - interval '181 minutes' WHERE id = $1`, [w.liveId]);
    expect((await sweep()).ended).toBe(1);

    const q = await world();
    await h.db.query(`UPDATE lives SET host_seen_at = now() - interval '5 minutes' WHERE id = $1`, [q.liveId]);
    expect((await sweep()).ended).toBe(1);
    expect(h.rooms.closed).toContain(q.room);
  });
});

describe("in the live", () => {
  it("chat needs a paid minute; hearts reach the host; gifts pay the host", async () => {
    const w = await world();
    await join(w);
    expect(errorCode(await call(h, "POST", `/v1/lives/${w.liveId}/messages`, { token: w.viewer, body: { body: "hi!" } }))).toBe("PAY_TO_WATCH");
    expect((await call(h, "POST", `/v1/lives/${w.liveId}/react`, { token: w.viewer, body: { emoji: "❤️" } })).statusCode).toBe(204);
    expect(kinds(w.hostId)).toContain("reaction");

    await endPreview(w.liveId, w.viewerId);
    await join(w, true);
    expect((await call(h, "POST", `/v1/lives/${w.liveId}/messages`, { token: w.viewer, body: { body: "hi!" } })).statusCode).toBe(204);

    const gift = (await h.db.query<{ id: number }>(`SELECT id FROM gifts WHERE is_active ORDER BY coins LIMIT 1`)).rows[0]!;
    const before = await balance(w.hostId, "earnings");
    expect((await call(h, "POST", `/v1/lives/${w.liveId}/gifts`, { token: w.viewer, body: { giftId: gift.id, clientRef: randomUUID() } })).statusCode).toBe(201);
    expect(await balance(w.hostId, "earnings")).toBeGreaterThan(before);
  });

  it("coin history shows one line for the live", async () => {
    const w = await world();
    await join(w);
    await endPreview(w.liveId, w.viewerId);
    await join(w, true);
    await nextMinute(w);
    const hist = json<{ items: { kind: string; title: string; subtitle: string; amount: number }[]; summary: { lives: number } }>(
      await call(h, "GET", "/v1/wallet/history", { token: w.viewer }));
    expect(hist.items.find((i) => i.kind === "live")).toMatchObject({ title: "Live with Test companion", subtitle: "2 min", amount: -6 });
    expect(hist.summary.lives).toBe(6);
  });

  it("admins can end a live (audited)", async () => {
    const w = await world();
    const adminId = (await h.db.query<{ id: string }>(
      `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`)).rows[0]!.id;
    const admin = await tokenFor(h, adminId, "admin");
    expect(json<{ id: string; status: string }[]>(await call(h, "GET", "/v1/admin/lives", { token: admin }))[0]).toMatchObject({ id: w.liveId, status: "live" });
    expect((await call(h, "POST", `/v1/admin/lives/${w.liveId}/end`, { token: admin, body: { reason: "Policy check" } })).statusCode).toBe(204);
    expect((await h.db.query(`SELECT 1 FROM audit_log WHERE action = 'live.end'`)).rowCount).toBe(1);
  });
});

describe("live tab: paging, filters, snapshots", () => {
  type Page = { lives: { id: string; title: string; language: string; snapshotUrl: string | null }[]; total: number };
  async function goLive(title: string, language = "ta") {
    const id = await createCompanion(h, { language });
    const token = await tokenFor(h, id, "companion");
    const live = json<Join>(await call(h, "POST", "/v1/lives", { token, body: { title, language: null } }));
    return { id, token, liveId: live.live.id };
  }

  it("pages with a total, and filters by language, favourites and name", async () => {
    const viewerId = await createCaller(h, 100);
    const viewer = await tokenFor(h, viewerId, "caller");
    const made = [];
    for (let i = 0; i < 5; i++) made.push(await goLive(`Evening chat ${i}`, i < 3 ? "ta" : "te"));
    const page = async (qs: string) => json<Page>(await call(h, "GET", `/v1/lives?${qs}`, { token: viewer }));

    const first = await page("limit=2&offset=0&sort=new");
    expect(first.total).toBe(5);
    expect(first.lives.map((l) => l.title)).toEqual(["Evening chat 4", "Evening chat 3"]);
    expect((await page("limit=2&offset=4&sort=new")).lives.map((l) => l.title)).toEqual(["Evening chat 0"]);

    expect((await page("language=te")).total).toBe(2);
    await h.db.query(`INSERT INTO favourites (user_id, companion_id) VALUES ($1, $2)`, [viewerId, made[1]!.id]);
    expect((await page("favourites=true")).lives.map((l) => l.id)).toEqual([made[1]!.liveId]);
    // for_you puts favourites first.
    expect((await page("sort=for_you")).lives[0]!.id).toBe(made[1]!.liveId);
    expect((await page("q=chat%203")).lives.map((l) => l.title)).toEqual(["Evening chat 3"]);
    expect((await page("q=%25")).total).toBe(0); // wildcards are literal
  });

  it("host snapshots show on the card through a signed link, only while live", async () => {
    const sharp = (await import("sharp")).default;
    const l = await goLive("Snapshot test");
    const viewer = await tokenFor(h, await createCaller(h, 100), "caller");
    const card = async () => json<Page>(await call(h, "GET", "/v1/lives", { token: viewer })).lives.find((x) => x.id === l.liveId)!;
    expect((await card()).snapshotUrl).toBeNull();

    const frame = await sharp({ create: { width: 640, height: 480, channels: 3, background: { r: 10, g: 200, b: 90 } } }).jpeg().toBuffer();
    const up = await call(h, "POST", `/v1/lives/${l.liveId}/snapshot`, { token: l.token, body: { frameBase64: frame.toString("base64") } });
    expect(up.statusCode).toBe(204);
    const url = (await card()).snapshotUrl!;
    const img = await h.app.inject({ method: "GET", url });
    expect(img.statusCode).toBe(200);
    expect((await sharp(img.rawPayload).metadata()).width).toBe(360);
    expect((await h.app.inject({ method: "GET", url: url.replace(/sig=.{3}/, "sig=zzz") })).statusCode).toBe(404);

    // Viewers can't upload; ended lives stop serving.
    expect((await call(h, "POST", `/v1/lives/${l.liveId}/snapshot`, { token: viewer, body: { frameBase64: frame.toString("base64") } })).statusCode).toBe(403);
    await call(h, "POST", `/v1/lives/${l.liveId}/end`, { token: l.token });
    expect((await h.app.inject({ method: "GET", url })).statusCode).toBe(404);
  });
});
