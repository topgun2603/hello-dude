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
import { payoutsFromConfig } from "./payouts/provider.js";
import { checkProcessingPayouts } from "./payouts/finish.js";
import { sendDailyBonusReminders, sendRateReminders } from "./reminders.js";
import { sweepBookings } from "./bookings.js";
import { payBonuses } from "./rewards.js";
import { sweepRooms } from "./routes/rooms.js";
import { sweepLives } from "./routes/lives.js";
import { sweepBattles } from "./routes/pk.js";
import { sweepGroups } from "./routes/groups.js";
import { announceLevelUps, awardBadges, rewardCompanionInvites } from "./routes/leaderboards.js";
import { fcmPushSender, logPushSender } from "./push.js";
import { parseKey, storeFromConfig } from "./storage.js";

const SWEEP_EVERY_MS = 30_000;
const RETENTION_EVERY_MS = 60 * 60_000;
const REMINDERS_EVERY_MS = 5 * 60_000;

const cfg = loadConfig();
const db = createPool(cfg.DATABASE_URL);
const redis = new Redis(cfg.REDIS_URL);
const rooms = liveKitRooms(cfg.LIVEKIT_URL, cfg.LIVEKIT_KEY, cfg.LIVEKIT_SECRET);
const engine = new BillingEngine({
  db, redis,
  rooms,
  events: redisUserEvents(redis),
  pollRooms: cfg.LIVEKIT_POLL,
});

const stop = new AbortController();
for (const signal of ["SIGINT", "SIGTERM"] as const) process.once(signal, () => stop.abort());

const sweeper = setInterval(async () => {
  try {
    const dropped = await dropStalePresence(redis);
    if (dropped) console.log(`presence: ${dropped} companion(s) went offline (no heartbeat)`);
    await engine.sweep();
    const r = await sweepRooms({ db, events: redisUserEvents(redis), rooms });
    if (r.left || r.ended) console.log("voice rooms:", r);
  } catch (err) {
    console.error("sweep failed", err);
  }
}, SWEEP_EVERY_MS);

const store = storeFromConfig(cfg, parseKey(cfg.KYC_ENCRYPTION_KEY));
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
    // Growth: weekly/event badges, caller level-ups, companion-invite rewards (all run-once safe).
    const badges = await awardBadges({ db, push, events });
    const levels = await announceLevelUps({ db, push, events });
    const invites = await rewardCompanionInvites({ db, push, events });
    if (badges || levels || invites) console.log(`growth: ${badges} badges, ${levels} level-ups, ${invites} invite bonuses`);
  } catch (err) {
    console.error("reminders failed", err);
  }
}
const remindersTimer = setInterval(reminders, REMINDERS_EVERY_MS);

// Lives: previews and passes run out by the second; check every 10 s.
const livesTimer = setInterval(async () => {
  try {
    const r = await sweepLives({ db, events: redisUserEvents(redis), rooms, push });
    if (r.ended || r.removed) console.log("lives:", r);
    const pk = await sweepBattles({ db, events: redisUserEvents(redis), rooms });
    if (pk) console.log("pk battles ended:", pk);
  } catch (err) {
    console.error("lives sweep failed", err);
  }
}, 10_000);

// Group video: per-minute charges, lobbies, reminders, ending thin groups.
const groupsTimer = setInterval(async () => {
  try {
    const r = await sweepGroups({ db, events: redisUserEvents(redis), rooms, push });
    if (r.ended || r.removed) console.log("groups:", r);
  } catch (err) {
    console.error("groups sweep failed", err);
  }
}, 10_000);

// Bookings need minute precision (reminders 10 min before, expiry, refunds).
const bookingsTimer = setInterval(async () => {
  try {
    const b = await sweepBookings({ db, push, events });
    if (b.expired || b.reminded || b.closed) console.log("bookings:", b);
    const bonuses = await payBonuses({ db, push, events });
    if (bonuses) console.log(`bonuses: paid ${bonuses}`);
  } catch (err) {
    console.error("bookings sweep failed", err);
  }
}, 60_000);
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

// Payouts the bank hasn't confirmed yet: ask RazorpayX (backup for a lost webhook).
const payouts = payoutsFromConfig(cfg);
const payoutsTimer = setInterval(async () => {
  try {
    const r = await checkProcessingPayouts({ db, push, events }, payouts);
    if (r.paid || r.failed) console.log("payouts confirmed:", r);
  } catch (err) {
    console.error("payout check failed", err);
  }
}, 5 * 60_000);

console.log("worker started: billing every 2 s, sweep every 30 s, reminders every 5 min, retention hourly");
await engine.runWorker(stop.signal);
clearInterval(sweeper);
clearInterval(retentionTimer);
clearInterval(payoutsTimer);
clearInterval(remindersTimer);
clearInterval(bookingsTimer);
clearInterval(livesTimer);
clearInterval(groupsTimer);
await db.end();
redis.disconnect();
console.log("worker stopped");
