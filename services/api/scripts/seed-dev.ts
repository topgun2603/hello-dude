/**
 * DEV ONLY. Creates four demo companions (as in the Home design), puts them
 * online for 24 h, and gives every caller account 500 coins so calls can be
 * tried from the phone. Safe to run repeatedly.
 */
import { Redis } from "ioredis";
import { loadConfig } from "../src/config.js";
import { createPool, tx } from "../src/db/pool.js";
import { ensureWallets, post } from "../src/billing/ledger.js";
import { ONLINE_SET } from "../src/billing/engine.js";

const cfg = loadConfig();
if (cfg.NODE_ENV === "production") throw new Error("seed-dev must never run in production");

const DEMO = [
  { name: "Priya", phone: "+916000000001", avatar: 1, langs: ["ta", "en"] },
  { name: "Kavya", phone: "+916000000002", avatar: 1, langs: ["ta", "en"] },
  { name: "Divya", phone: "+916000000003", avatar: 1, langs: ["ta"] },
  { name: "Meena", phone: "+916000000004", avatar: 1, langs: ["ta", "te"] },
];
const DEMO_COINS = 500;

const db = createPool(cfg.DATABASE_URL);
const redis = new Redis(cfg.REDIS_URL);

for (const d of DEMO) {
  const id = await tx(db, async (c) => {
    const userId = (await c.query<{ id: string }>(
      `INSERT INTO users (phone, gender, role, display_name, avatar_id, primary_language, terms_accepted_at)
       VALUES ($1, 'female', 'companion', $2, $3, $4, now())
       ON CONFLICT (phone) DO UPDATE SET display_name = EXCLUDED.display_name, avatar_id = EXCLUDED.avatar_id RETURNING id`,
      [d.phone, d.name, d.avatar, d.langs[0]],
    )).rows[0]!.id;
    await c.query(
      `INSERT INTO companion_profiles (user_id, kyc_status, kyc_verified_at, video_enabled, bio)
       VALUES ($1, 'approved', now(), true, 'Demo companion') ON CONFLICT (user_id) DO NOTHING`, [userId],
    );
    await c.query(
      `INSERT INTO user_languages (user_id, language_code) SELECT $1, unnest($2::text[]) ON CONFLICT DO NOTHING`,
      [userId, d.langs],
    );
    await ensureWallets(c, userId);
    return userId;
  });
  await redis.multi().set(`presence:hb:${id}`, "1", "EX", 24 * 3600).sadd(ONLINE_SET, id).exec();
  console.log(`companion ${d.name} online (dev login: ${d.phone.slice(3)} / OTP ${cfg.DEV_OTP_CODE})`);
}

// Demo callers, so the caller side can be tried after your own number became a companion.
const DEMO_CALLERS = [
  { name: "Arjun", phone: "+916100000001", avatar: 2, lang: "ta" },
  { name: "Karthik", phone: "+916100000002", avatar: 2, lang: "ta" },
  { name: "Vijay", phone: "+916100000003", avatar: 2, lang: "te" },
  { name: "Suresh", phone: "+916100000004", avatar: 2, lang: "kn" },
  { name: "Rahul", phone: "+916100000005", avatar: 2, lang: "hi" },
];
for (const d of DEMO_CALLERS) {
  await tx(db, async (c) => {
    const userId = (await c.query<{ id: string }>(
      `INSERT INTO users (phone, gender, role, display_name, avatar_id, primary_language, terms_accepted_at)
       VALUES ($1, 'male', 'caller', $2, $3, $4, now())
       ON CONFLICT (phone) DO UPDATE SET display_name = EXCLUDED.display_name, avatar_id = EXCLUDED.avatar_id RETURNING id`,
      [d.phone, d.name, d.avatar, d.lang],
    )).rows[0]!.id;
    await c.query(
      `INSERT INTO user_languages (user_id, language_code) VALUES ($1, $2) ON CONFLICT DO NOTHING`, [userId, d.lang],
    );
    await ensureWallets(c, userId);
  });
  console.log(`caller ${d.name} (dev login: ${d.phone.slice(3)} / OTP ${cfg.DEV_OTP_CODE})`);
}

const callers = (await db.query<{ id: string; balance: number }>(
  `SELECT u.id, w.balance FROM users u JOIN wallets w ON w.user_id = u.id AND w.kind = 'coins'
    WHERE u.role = 'caller' AND u.status = 'active'`,
)).rows;
for (const c of callers.filter((c) => c.balance < DEMO_COINS)) {
  await tx(db, (t) => post(t, c.id, "coins", "bonus", DEMO_COINS - c.balance,
    `dev:topup:${c.id}:${Date.now()}`, { note: "Dev test coins" }));
}
console.log(`${callers.length} caller(s) topped up to ${DEMO_COINS} coins`);

await db.end();
redis.disconnect();
