import sharp from "sharp";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState } from "../../test/fixtures.js";
import { call, createAppHarness, errorCode, json, tokenFor, type AppHarness } from "../../test/app-harness.js";

let h: AppHarness;
let admin: string;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => {
  await resetState(h);
  await h.redis.del(...(await h.redis.keys("photo:uploads:*")), "photo:none");
  const adminId = (await h.db.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language) VALUES ('+919999900000', 'other', 'admin', 'Ops', 'en') RETURNING id`,
  )).rows[0]!.id;
  admin = await tokenFor(h, adminId, "admin");
});

/** A JPEG with camera EXIF and a GPS position, like a phone photo. */
const phonePhoto = (w = 1200, h2 = 1600) => sharp({ create: { width: w, height: h2, channels: 3, background: { r: 200, g: 120, b: 90 } } })
  .withExif({ IFD0: { Make: "TestPhone", Model: "X1" }, IFD3: { GPSLatitudeRef: "N", GPSLatitude: "13/1 5/1 0/1" } })
  .jpeg().toBuffer();

type MyPhoto = { status: string; photoUrl: string | null; pendingUrl: string | null; rejectReason: string | null };
const upload = async (token: string, img: Buffer) => call(h, "PUT", "/v1/me/photo", { token, body: { imageBase64: img.toString("base64") } });
const fetchPhoto = (url: string) => h.app.inject({ method: "GET", url });
async function companion() {
  const id = await createCompanion(h);
  return { id, token: await tokenFor(h, id, "companion") };
}
const cardPhoto = async (viewer: string, companionId: string) =>
  json<{ companion: { photoUrl: string | null } }>(await call(h, "GET", `/v1/companions/${companionId}`, { token: viewer })).companion.photoUrl;
const decide = (userId: string, decision: "approve" | "reject", reason?: string) =>
  call(h, "POST", `/v1/admin/photos/${userId}/decision`, { token: admin, body: { decision, reason: reason ?? null } });

describe("companion photos", () => {
  it("callers can't upload; tiny or non-images are refused", async () => {
    const caller = await tokenFor(h, await createCaller(h, 0), "caller");
    expect((await upload(caller, await phonePhoto())).statusCode).toBe(403);
    const c = await companion();
    expect(errorCode(await upload(c.token, await phonePhoto(100, 100)))).toBe("PHOTO_TOO_SMALL");
    expect(errorCode(await upload(c.token, Buffer.concat([Buffer.from([0xff, 0xd8, 0xff]), Buffer.alloc(300, 1)])))).toBe("NOT_AN_IMAGE");
  });

  it("uploads are cleaned (no EXIF/GPS, 720×720) and hidden until an admin approves", async () => {
    const c = await companion();
    const caller = await tokenFor(h, await createCaller(h, 0), "caller");
    const res = await upload(c.token, await phonePhoto());
    expect(res.statusCode, res.body).toBe(200);
    const mine = json<MyPhoto>(res);
    expect(mine.status).toBe("pending");
    expect(mine.photoUrl).toBeNull();
    expect(await cardPhoto(caller, c.id)).toBeNull();

    // The companion can preview what's under review; it's the cleaned file.
    const pending = await fetchPhoto(mine.pendingUrl!);
    expect(pending.statusCode).toBe(200);
    const meta = await sharp(pending.rawPayload).metadata();
    expect(meta.exif).toBeUndefined();
    expect([meta.width, meta.height]).toEqual([720, 720]);

    const queue = json<{ user: { id: string }; pendingUrl: string; hasSelfie: boolean }[]>(await call(h, "GET", "/v1/admin/photos", { token: admin }));
    expect(queue.map((q) => q.user.id)).toEqual([c.id]);
    expect((await decide(c.id, "approve")).statusCode).toBe(204);

    const url = await cardPhoto(caller, c.id);
    expect(url).toMatch(/^\/v1\/photos\//);
    const img = await fetchPhoto(url!);
    expect(img.statusCode).toBe(200);
    expect(img.headers["content-type"]).toBe("image/jpeg");
    expect((await h.db.query(`SELECT 1 FROM notifications WHERE user_id = $1 AND type = 'photo_decided'`, [c.id])).rowCount).toBe(1);
    expect((await h.db.query(`SELECT 1 FROM audit_log WHERE action = 'photo.approve' AND target_id = $1`, [c.id])).rowCount).toBe(1);
  });

  it("links are signed: tampered or expired links and replaced photos are 404", async () => {
    const c = await companion();
    await upload(c.token, await phonePhoto());
    await decide(c.id, "approve");
    const url = json<MyPhoto>(await call(h, "GET", "/v1/me/photo", { token: c.token })).photoUrl!;
    expect((await fetchPhoto(url.replace(/sig=.{4}/, "sig=AAAA"))).statusCode).toBe(404);
    expect((await fetchPhoto(url.replace(/exp=\d+/, "exp=1000"))).statusCode).toBe(404);
    // A new approved photo retires the old link.
    await upload(c.token, await phonePhoto(900, 900));
    await decide(c.id, "approve");
    expect((await fetchPhoto(url)).statusCode).toBe(404);
  });

  it("rejecting needs a reason, keeps the previous photo, and tells the companion", async () => {
    const c = await companion();
    await upload(c.token, await phonePhoto());
    await decide(c.id, "approve");
    await upload(c.token, await phonePhoto(800, 800));
    expect(errorCode(await decide(c.id, "reject"))).toBe("REASON_REQUIRED");
    expect((await decide(c.id, "reject", "Please use a photo of your face")).statusCode).toBe(204);
    const mine = json<MyPhoto>(await call(h, "GET", "/v1/me/photo", { token: c.token }));
    expect(mine.status).toBe("approved");
    expect(mine.pendingUrl).toBeNull();
    expect(mine.photoUrl).not.toBeNull();

    const fresh = await companion();
    await upload(fresh.token, await phonePhoto());
    await decide(fresh.id, "reject", "Blurry");
    expect(json<MyPhoto>(await call(h, "GET", "/v1/me/photo", { token: fresh.token }))).toMatchObject({ status: "rejected", rejectReason: "Blurry" });
  });

  it("removing the photo brings the avatar back", async () => {
    const c = await companion();
    const caller = await tokenFor(h, await createCaller(h, 0), "caller");
    await upload(c.token, await phonePhoto());
    await decide(c.id, "approve");
    expect(await cardPhoto(caller, c.id)).not.toBeNull();
    expect(json<MyPhoto>(await call(h, "DELETE", "/v1/me/photo", { token: c.token })).status).toBe("none");
    expect(await cardPhoto(caller, c.id)).toBeNull();
  });
});
