/**
 * Sends a test push to every phone registered for a user.
 *   npm run push:test -- 6000000001            # plain notification
 *   npm run push:test -- 6000000001 --call     # fake incoming call (full-screen ringing)
 */
import { loadConfig } from "../src/config.js";
import { createPool } from "../src/db/pool.js";
import { fcmPushSender } from "../src/push.js";

const cfg = loadConfig();
if (!cfg.FIREBASE_SERVICE_ACCOUNT_PATH) throw new Error("Set FIREBASE_SERVICE_ACCOUNT_PATH in .env first");
const [digits, flag] = process.argv.slice(2);
if (!digits || !/^\d{10}$/.test(digits)) throw new Error("Usage: npm run push:test -- <10-digit phone> [--call]");

const db = createPool(cfg.DATABASE_URL);
const devices = (await db.query<{ fcm_token: string; display_name: string }>(
  `SELECT d.fcm_token, u.display_name FROM devices d JOIN users u ON u.id = d.user_id WHERE u.phone = $1`,
  [`+91${digits}`],
)).rows;
if (!devices.length) {
  console.log("No registered phone for that user: sign in on the app first (it registers its push token).");
} else {
  const push = fcmPushSender({
    serviceAccountPath: cfg.FIREBASE_SERVICE_ACCOUNT_PATH,
    onDeadTokens: async (tokens) => {
      await db.query(`DELETE FROM devices WHERE fcm_token = ANY($1)`, [tokens]);
      console.log(`removed ${tokens.length} dead token(s)`);
    },
    log: (msg, err) => console.error(msg, err),
  });
  const tokens = devices.map((d) => d.fcm_token);
  if (flag === "--call") {
    await push.incomingCall(tokens, {
      callId: crypto.randomUUID(), callType: "audio", callerName: "Test caller", callerAvatarId: 1,
    });
  } else {
    await push.notify(tokens, { title: "Hello Dude! 👋", body: `Test notification for ${devices[0]!.display_name}` });
  }
  console.log(`sent to ${tokens.length} device(s)`);
}
await db.end();
