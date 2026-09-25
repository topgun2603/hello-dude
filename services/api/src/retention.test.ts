import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { createCaller, createCompanion, resetState, setRate } from "../test/fixtures.js";
import { createAppHarness, type AppHarness } from "../test/app-harness.js";
import { runRetention } from "./retention.js";

let h: AppHarness;
beforeAll(async () => { h = await createAppHarness(); });
afterAll(async () => { await h.app.close(); await h.db.end(); h.redis.disconnect(); });
beforeEach(async () => { await resetState(h); });

const run = () => runRetention({ db: h.db, store: h.store, recorder: h.recorder });
const ago = (days: number) => new Date(Date.now() - days * 86_400_000);

async function session(userId: string, expires: Date, revoked: Date | null = null) {
  await h.db.query(
    `INSERT INTO sessions (user_id, token_hash, family_id, expires_at, revoked_at) VALUES ($1, gen_random_bytes(32), gen_random_uuid(), $2, $3)`,
    [userId, expires, revoked]);
}

async function call(caller: string, companion: string): Promise<string> {
  const rate = (await h.db.query<{ id: number }>(`SELECT id FROM call_rates LIMIT 1`)).rows[0]!.id;
  return (await h.db.query<{ id: string }>(
    `INSERT INTO calls (caller_id, companion_id, type, language_code, rate_id, coins_per_min, companion_paise_per_min, room_name, status)
     VALUES ($1, $2, 'video', 'ta', $3, 10, 300, gen_random_uuid()::text, 'ended') RETURNING id`, [caller, companion, rate])).rows[0]!.id;
}

describe("retention", () => {
  it("deletes only what the privacy policy says has expired", async () => {
    await setRate(h, "ta", "video", 25, 700);
    const caller = await createCaller(h, 0);

    // Sessions: expired/revoked > 30 days ago go; recent ones stay.
    await session(caller, ago(40));
    await session(caller, ago(-10), ago(31));
    await session(caller, ago(5));
    await session(caller, ago(-30));

    // Recording of a closed report is deleted even if the close step missed it; open report keeps it.
    const companion = await createCompanion(h);
    const callId = await call(caller, companion);
    for (const [status, key] of [["dismissed", "recordings/closed"], ["open", "recordings/open"]] as const) {
      const report = (await h.db.query<{ id: string }>(
        `INSERT INTO reports (reporter_id, reported_id, call_id, reason, status) VALUES ($1, $2, $3, 'abuse', $4) RETURNING id`,
        [caller, companion, callId, status])).rows[0]!.id;
      await h.store.put(key, Buffer.from("audio"));
      await h.db.query(`INSERT INTO report_recordings (report_id, call_id, storage_key, status) VALUES ($1, $2, $3, 'ready')`, [report, callId, key]);
    }

    // Rejected KYC: old → wiped (PAN kept only if they were paid); recent → kept.
    const kyc = async (reviewedDaysAgo: number, paid: boolean) => {
      const id = await createCompanion(h, { kyc: "pending" });
      await h.db.query(
        `UPDATE companion_profiles SET kyc_status = 'rejected', kyc_reviewed_at = $2, aadhaar_name = 'X', aadhaar_last4 = '1234',
                pan_last4 = '9999', pan_encrypted = '\\x01' WHERE user_id = $1`, [id, ago(reviewedDaysAgo)]);
      await h.store.put(`kyc/${id}/selfie`, Buffer.from("img"));
      await h.db.query(`INSERT INTO kyc_documents (user_id, doc_type, storage_key) VALUES ($1, 'selfie', $2)`, [id, `kyc/${id}/selfie`]);
      if (paid) {
        await h.db.query(`INSERT INTO payouts (companion_id, gross_paise, net_paise, upi_id, status) VALUES ($1, 10000, 9900, 'a@b', 'paid')`, [id]);
      }
      return id;
    };
    const oldRejected = await kyc(100, false);
    const oldRejectedPaid = await kyc(100, true);
    const recentRejected = await kyc(10, false);

    // Moderation frames: reviewed > 30 days ago → frame deleted; open ones stay.
    const frame = async (status: string, reviewedDaysAgo: number | null, key: string) => {
      await h.store.put(key, Buffer.from("jpg"));
      await h.db.query(
        `INSERT INTO moderation_flags (call_id, subject_id, detected_by, score, storage_key, status, reviewed_at)
         VALUES ($1, $2, $3, 0.93, $4, $5, $6)`, [callId, companion, caller, key, status, reviewedDaysAgo === null ? null : ago(reviewedDaysAgo)]);
    };
    await frame("dismissed", 40, "moderation/old");
    await frame("actioned", 5, "moderation/recent");
    await frame("open", null, "moderation/open");

    expect(await run()).toEqual({ sessions: 2, recordings: 1, rejectedKyc: 2, frames: 1, notifications: 0, chatMessages: 0, liveSnapshots: 0 });

    expect((await h.db.query(`SELECT count(*)::int AS n FROM sessions`)).rows[0]).toEqual({ n: 2 });
    expect(h.store.keys().sort()).toEqual([
      `kyc/${recentRejected}/selfie`, "moderation/open", "moderation/recent", "recordings/open",
    ].sort());
    const fields = async (id: string) => (await h.db.query(
      `SELECT aadhaar_name, pan_last4, (SELECT count(*)::int FROM kyc_documents WHERE user_id = $1) AS docs FROM companion_profiles WHERE user_id = $1`, [id])).rows[0];
    expect(await fields(oldRejected)).toEqual({ aadhaar_name: null, pan_last4: null, docs: 0 });
    expect(await fields(oldRejectedPaid)).toEqual({ aadhaar_name: null, pan_last4: "9999", docs: 0 });
    expect(await fields(recentRejected)).toEqual({ aadhaar_name: "X", pan_last4: "9999", docs: 1 });
    expect((await h.db.query(`SELECT count(*)::int AS n FROM moderation_flags WHERE frame_deleted_at IS NOT NULL AND storage_key IS NULL`)).rows[0])
      .toEqual({ n: 1 });

    // Running again finds nothing new.
    expect(await run()).toEqual({ sessions: 0, recordings: 0, rejectedKyc: 0, frames: 0, notifications: 0, chatMessages: 0, liveSnapshots: 0 });
  });
});
