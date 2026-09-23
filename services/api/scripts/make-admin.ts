/**
 * Gives a phone number admin access (creates the account if needed).
 *   npm run make-admin -- 9876543210
 * Admins sign in to the admin panel with phone OTP like everyone else.
 */
import { loadConfig } from "../src/config.js";
import { createPool, tx } from "../src/db/pool.js";
import { ensureWallets } from "../src/billing/ledger.js";
import { normalizeIndianMobile, maskPhone } from "../src/auth/phone.js";

const phone = normalizeIndianMobile(process.argv[2] ?? "");
if (!phone) {
  console.error("usage: npm run make-admin -- <10-digit mobile number>");
  process.exit(1);
}

const db = createPool(loadConfig().DATABASE_URL);
const created = await tx(db, async (c) => {
  const existing = (await c.query<{ id: string; role: string }>(`SELECT id, role FROM users WHERE phone = $1`, [phone])).rows[0];
  if (existing?.role === "companion") {
    throw new Error("That number belongs to a companion; use a separate number for admin access");
  }
  if (existing) {
    await c.query(`UPDATE users SET role = 'admin', status = 'active' WHERE id = $1`, [existing.id]);
    return false;
  }
  const id = (await c.query<{ id: string }>(
    `INSERT INTO users (phone, gender, role, display_name, primary_language, terms_accepted_at)
     VALUES ($1, 'other', 'admin', 'Admin', 'en', now()) RETURNING id`, [phone],
  )).rows[0]!.id;
  await ensureWallets(c, id);
  return true;
});
// Existing sessions still carry the old role; make them sign in again.
await db.query(`UPDATE sessions SET revoked_at = now() WHERE user_id = (SELECT id FROM users WHERE phone = $1) AND revoked_at IS NULL`, [phone]);
console.log(`${maskPhone(phone)} is now an admin${created ? " (new account)" : ""}. Sign in at the admin panel with OTP.`);
await db.end();
