/**
 * Background worker: charges due call minutes, repairs stuck calls, drops
 * companions whose heartbeat stopped, and deletes data the Privacy Policy says
 * must go (retention.ts). Run one or more instances next to the API.
 * (Payouts, notifications and the other BullMQ jobs join this process later.)
 */
import { Redis } from "ioredis";
import { loadConfig } from "./config.js";
import { createPool } from "./db/pool.js";
import { BillingEngine } from "./billing/engine.js";
import { liveKitRooms, redisUserEvents } from "./billing/ports.js";
import { dropStalePresence } from "./presence.js";
import { disabledRecorder } from "./recording.js";
import { runRetention } from "./retention.js";
import { sendDailyBonusReminders, sendRateReminders } from "./reminders.js";
import { fcmPushSender, logPushSender } from "./push.js";
import { localEncryptedStore, parseKey } from "./storage.js";

const SWEEP_EVERY_MS = 30_000;
const RETENTION_EVERY_MS = 60 * 60_000;
const REMINDERS_EVERY_MS = 5 * 60_000;

const cfg = loadConfig();
const db = createPool(cfg.DATABASE_URL);
const redis = new Redis(cfg.REDIS_URL);
const engine = new BillingEngine({
  db, redis,
  rooms: liveKitRooms(cfg.LIVEKIT_URL, cfg.LIVEKIT_KEY, cfg.LIVEKIT_SECRET),
  events: redisUserEvents(redis),
});

const stop = new AbortController();
for (const signal of ["SIGINT", "SIGTERM"] as const) process.once(signal, () => stop.abort());

const sweeper = setInterval(async () => {
  try {
    const dropped = await dropStalePresence(redis);
    if (dropped) console.log(`presence: ${dropped} companion(s) went offline (no heartbeat)`);
    await engine.sweep();
  } catch (err) {
    console.error("sweep failed", err);
  }
}, SWEEP_EVERY_MS);

const store = localEncryptedStore(cfg.KYC_STORAGE_DIR, parseKey(cfg.KYC_ENCRYPTION_KEY));
const events = redisUserEvents(redis);
const push = cfg.FIREBASE_SERVICE_ACCOUNT_PATH
  ? fcmPushSender({
      serviceAccountPath: cfg.FIREBASE_SERVICE_ACCOUNT_PATH,
      onDeadTokens: async (tokens) => { await db.query(`DELETE FROM devices WHERE fcm_token = ANY($1)`, [tokens]); },
      log: (msg, err) => console.warn(msg, err),
    })
  : logPushSender((m) => console.log(m));

async function reminders() {
  try {
    const rate = await sendRateReminders({ db, push, events });
    const bonus = await sendDailyBonusReminders({ db, push, events });
    if (rate || bonus) console.log(`reminders: ${rate} rate-your-call, ${bonus} daily bonus`);
  } catch (err) {
    console.error("reminders failed", err);
  }
}
const remindersTimer = setInterval(reminders, REMINDERS_EVERY_MS);
async function retention() {
  try {
    const r = await runRetention({ db, store, recorder: disabledRecorder });
    if (Object.values(r).some(Boolean)) console.log("retention: deleted", r);
  } catch (err) {
    console.error("retention failed", err);
  }
}
void retention();
const retentionTimer = setInterval(retention, RETENTION_EVERY_MS);

console.log("worker started: billing every 2 s, sweep every 30 s, reminders every 5 min, retention hourly");
await engine.runWorker(stop.signal);
clearInterval(sweeper);
clearInterval(retentionTimer);
clearInterval(remindersTimer);
await db.end();
redis.disconnect();
console.log("worker stopped");
