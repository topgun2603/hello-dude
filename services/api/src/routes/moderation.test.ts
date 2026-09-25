import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, getCall, resetState, setRate } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, webhook, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

const JPEG = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), Buffer.alloc(200, 7)]).toString("base64");
const PNG = Buffer.concat([Buffer.from([0x89, 0x50, 0x4e, 0x47]), Buffer.alloc(200, 7)]).toString("base64");

async function liveCall(type: "audio" | "video") {
  await setRate(h, "ta", type, type === "video" ? 25 : 10, 300);
  const caller = await createCaller(h, 500);
  const companion = await createCompanion(h);
  const callerToken = await tokenFor(h, caller, "caller");
  const start = json<{ callId: string; room: string }>(await call(h, "POST", "/v1/calls", {
    token: callerToken, body: { companionId: companion, type },
  }));
  await webhook(h, { event: "participant_joined", room: start.room, identity: caller });
  await webhook(h, { event: "participant_joined", room: start.room, identity: companion });
  return { caller, companion, callerToken, callId: start.callId };
}

describe("video moderation", () => {
  it("stores one flagged frame per cooldown, only from participants of a live video call", async () => {
    const { callerToken, callId, companion } = await liveCall("video");
    const flag = (token: string, frameBase64 = JPEG) => call(h, "POST", `/v1/calls/${callId}/moderation`, { token, body: { frameBase64, score: 0.94 } });

    expect(errorCode(await flag(callerToken, PNG))).toBe("NOT_A_JPEG");
    const first = await flag(callerToken);
    expect(first.statusCode).toBe(201);
    expect((await flag(callerToken)).statusCode).toBe(202); // cooldown: blur on the phone is enough
    const outsider = await tokenFor(h, await createCaller(h, 0), "caller");
    expect(errorCode(await flag(outsider))).toBe("NOT_YOUR_CALL");

    const rows = (await h.db.query<{ subject_id: string; storage_key: string }>(`SELECT subject_id, storage_key FROM moderation_flags`)).rows;
    expect(rows).toHaveLength(1);
    expect(rows[0]!.subject_id).toBe(companion); // the caller's phone flagged the companion's video
    expect(h.store.keys()).toContain(rows[0]!.storage_key);
  });

  it("a phone checking its own camera flags its own user", async () => {
    const { caller, callerToken, callId } = await liveCall("video");
    const res = await call(h, "POST", `/v1/calls/${callId}/moderation`, { token: callerToken, body: { frameBase64: JPEG, score: 0.91, own: true } });
    expect(res.statusCode).toBe(201);
    const rows = (await h.db.query<{ subject_id: string; detected_by: string }>(`SELECT subject_id, detected_by FROM moderation_flags`)).rows;
    expect(rows).toEqual([{ subject_id: caller, detected_by: caller }]);
  });

  it("refuses audio calls", async () => {
    const { callerToken, callId } = await liveCall("audio");
    expect(errorCode(await call(h, "POST", `/v1/calls/${callId}/moderation`, { token: callerToken, body: { frameBase64: JPEG, score: 0.9 } })))
      .toBe("NOT_A_VIDEO_CALL");
  });

  it("admin reviews the frame and suspends: account off, call ended, flag closed, all audited", async () => {
    const { callerToken, callId, companion } = await liveCall("video");
    await call(h, "POST", `/v1/calls/${callId}/moderation`, { token: callerToken, body: { frameBase64: JPEG, score: 0.97 } });

    const dash = json<{ openModeration: number }>(await call(h, "GET", "/v1/admin/dashboard", { token: admin }));
    expect(dash.openModeration).toBe(1);
    const [flag] = json<{ id: string; subject: { id: string; flags: number }; hasFrame: boolean; score: number }[]>(
      await call(h, "GET", "/v1/admin/moderation", { token: admin }));
    expect(flag).toMatchObject({ subject: { id: companion, flags: 1 }, hasFrame: true });
    expect(flag!.score).toBeCloseTo(0.97);

    const frame = await call(h, "GET", `/v1/admin/moderation/${flag!.id}/frame`, { token: admin });
    expect(frame.headers["content-type"]).toBe("image/jpeg");
    expect(frame.rawPayload.subarray(0, 2)).toEqual(Buffer.from([0xff, 0xd8]));

    expect((await call(h, "POST", `/v1/admin/moderation/${flag!.id}/resolve`, { token: admin, body: { decision: "suspend", note: "Clear nudity" } })).statusCode)
      .toBe(204);
    expect((await h.db.query(`SELECT status FROM users WHERE id = $1`, [companion])).rows[0]).toEqual({ status: "suspended" });
    expect(await getCall(h, callId)).toMatchObject({ status: "ended", end_reason: "admin" });
    expect(errorCode(await call(h, "POST", `/v1/admin/moderation/${flag!.id}/resolve`, { token: admin, body: { decision: "dismiss", note: "again" } })))
      .toBe("FLAG_CLOSED");
    expect(json(await call(h, "GET", "/v1/admin/moderation", { token: admin }))).toEqual([]);
    const actions = (await h.db.query<{ action: string }>(`SELECT action FROM audit_log ORDER BY id`)).rows.map((r) => r.action);
    expect(actions).toEqual(["moderation.view", "moderation.suspend"]);
  });
});
