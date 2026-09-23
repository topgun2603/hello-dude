import type { Db, DbClient } from "./db/pool.js";

/** Numeric operational setting from app_settings (see migration 0006). */
export async function numberSetting(db: Db | DbClient, key: string, fallback: number): Promise<number> {
  const row = (await db.query<{ value: unknown }>(`SELECT value FROM app_settings WHERE key = $1`, [key])).rows[0];
  const n = Number(row?.value);
  return Number.isFinite(n) ? n : fallback;
}
