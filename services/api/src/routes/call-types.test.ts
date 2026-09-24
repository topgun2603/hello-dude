import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await setRate(h, "ta", "audio", 10, 300);
  await setRate(h, "ta", "video", 25, 700);
});

type Listed = { id: string; audioEnabled: boolean; videoEnabled: boolean; rates: { audioCoinsPerMin: number | null; videoCoinsPerMin: number | null } };

async function world(opts: { video?: boolean } = {}) {
  const companion = await createCompanion(h, opts);
  const caller = await tokenFor(h, await createCaller(h, 500), "caller");
  const me = await tokenFor(h, companion, "companion");
  const setTypes = (audio: boolean, video: boolean) =>
    call(h, "PUT", "/v1/companion/call-types", { token: me, body: { audio, video } });
  const start = (type: "audio" | "video") => call(h, "POST", "/v1/calls", { token: caller, body: { companionId: companion, type } });
  const listed = async () =>
    json<{ companions: Listed[] }>(await call(h, "GET", "/v1/companions/online", { token: caller })).companions[0]!;
  const match = (type: "audio" | "video") => call(h, "POST", "/v1/calls/match", { token: caller, body: { type } });
  return { companion, caller, me, setTypes, start, listed, match };
}

describe("companions choose voice, video or both", () => {
  it("both by default; the home screen shows the switches", async () => {
    const w = await world();
    expect(await w.listed()).toMatchObject({ audioEnabled: true, videoEnabled: true, rates: { audioCoinsPerMin: 10, videoCoinsPerMin: 25 } });
    const home = json<{ takesAudio: boolean; takesVideo: boolean; videoEnabled: boolean }>(
      await call(h, "GET", "/v1/companion/home", { token: w.me }));
    expect(home).toMatchObject({ takesAudio: true, takesVideo: true, videoEnabled: true });
  });

  it("voice only: video calls and video matches skip them", async () => {
    const w = await world();
    expect(json(await w.setTypes(true, false))).toEqual({ takesAudio: true, takesVideo: false });
    expect(await w.listed()).toMatchObject({ audioEnabled: true, videoEnabled: false, rates: { videoCoinsPerMin: null } });
    expect(errorCode(await w.start("video"))).toBe("VIDEO_NOT_ENABLED");
    expect(errorCode(await w.match("video"))).toBe("NO_COMPANION_AVAILABLE");
    expect((await w.start("audio")).statusCode).toBe(201);
  });

  it("video only: voice calls and voice matches skip them", async () => {
    const w = await world();
    await w.setTypes(false, true);
    expect(await w.listed()).toMatchObject({ audioEnabled: false, videoEnabled: true, rates: { audioCoinsPerMin: null } });
    expect(errorCode(await w.start("audio"))).toBe("VOICE_OFF");
    expect(errorCode(await w.match("audio"))).toBe("NO_COMPANION_AVAILABLE");
    expect((await w.match("video")).statusCode).toBe(201);
  });

  it("at least one kind; video can't be chosen while locked, and locking it again turns voice back on", async () => {
    const w = await world();
    expect((await w.setTypes(false, false)).statusCode).toBe(400);

    const locked = await world({ video: false });
    expect(errorCode(await locked.setTypes(false, true))).toBe("VIDEO_LOCKED");
    expect((await locked.setTypes(true, false)).statusCode).toBe(200);

    // A video-only companion whose video gets locked by an admin takes voice again.
    await w.setTypes(false, true);
    const adminId = (await h.db.query<{ id: string }>(
      `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
    )).rows[0]!.id;
    const lock = await call(h, "POST", `/v1/admin/companions/${w.companion}/video`,
      { token: await tokenFor(h, adminId, "admin"), body: { enabled: false, reason: "Video policy check" } });
    expect(lock.statusCode).toBe(204);
    const row = (await h.db.query<{ takes_audio: boolean }>(`SELECT takes_audio FROM companion_profiles WHERE user_id = $1`, [w.companion])).rows[0]!;
    expect(row.takes_audio).toBe(true);
  });

  it("callers can't use it", async () => {
    const w = await world();
    expect(errorCode(await call(h, "PUT", "/v1/companion/call-types", { token: w.caller, body: { audio: true, video: true } })))
      .toBe("WRONG_ROLE");
  });
});
