/**
 * Forward-only migration runner. Applies db/migrations/*.sql in name order,
 * each in its own transaction, and records it in schema_migrations.
 * Applied files must never be edited — add a new migration instead.
 */
import { readdir, readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import path from "node:path";
import { createPool, tx, type Db } from "./pool.js";

const MIGRATIONS_DIR = fileURLToPath(new URL("../../../../db/migrations/", import.meta.url));
const LOCK_ID = 7_314_001; // pg_advisory_lock key so two deploys can't migrate at once

export async function runMigrations(db: Db, log: (msg: string) => void = () => {}): Promise<string[]> {
  const c = await db.connect();
  try {
    await c.query("SELECT pg_advisory_lock($1)", [LOCK_ID]);
    await c.query(
      `CREATE TABLE IF NOT EXISTS schema_migrations (
         name text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now())`,
    );
    const done = new Set(
      (await c.query<{ name: string }>("SELECT name FROM schema_migrations")).rows.map((r) => r.name),
    );
    const files = (await readdir(MIGRATIONS_DIR)).filter((f) => f.endsWith(".sql")).sort();
    const applied: string[] = [];
    for (const file of files) {
      if (done.has(file)) continue;
      const sql = await readFile(path.join(MIGRATIONS_DIR, file), "utf8");
      await tx(db, async (t) => {
        await t.query(sql);
        await t.query("INSERT INTO schema_migrations (name) VALUES ($1)", [file]);
      });
      applied.push(file);
      log(`applied ${file}`);
    }
    return applied;
  } finally {
    await c.query("SELECT pg_advisory_unlock($1)", [LOCK_ID]).catch(() => {});
    c.release();
  }
}

if (process.argv[1] && fileURLToPath(import.meta.url) === path.resolve(process.argv[1])) {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error("DATABASE_URL is not set");
  const db = createPool(url);
  runMigrations(db, console.log)
    .then((a) => console.log(a.length ? `${a.length} migration(s) applied` : "database is up to date"))
    .finally(() => db.end());
}
