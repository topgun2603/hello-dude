import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, optionalAuth, requireAuth } from "../auth/guard.js";
import { numberSetting } from "../settings.js";

const LedgerEntry = z.object({
  id: z.number().int(),
  type: z.string(),
  amount: z.number().int().describe("Signed: negative = debit"),
  balanceAfter: z.number().int(),
  callId: z.uuid().nullable(),
  note: z.string().nullable(),
  createdAt: z.date(),
}).meta({ id: "LedgerEntry" });

export const walletRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;

  app.get("/wallet", {
    preHandler: requireAuth(),
    schema: {
      tags: ["wallet"],
      security: bearer,
      response: { 200: z.object({ coins: z.number().int(), earningsPaise: z.number().int() }) },
    },
  }, async (req) => {
    const rows = (await db.query<{ kind: "coins" | "earnings"; balance: number }>(
      `SELECT kind, balance FROM wallets WHERE user_id = $1`, [me(req).userId],
    )).rows;
    const of = (k: string) => rows.find((r) => r.kind === k)?.balance ?? 0;
    return { coins: of("coins"), earningsPaise: of("earnings") };
  });

  app.get("/coin-packages", {
    preHandler: optionalAuth(),
    schema: {
      tags: ["wallet"],
      summary: "Coin packs for sale (Google Play SKUs). Signed-in new users also get the first-recharge offer.",
      response: {
        200: z.array(z.object({
          sku: z.string(), coins: z.number().int(), bonusCoins: z.number().int(),
          pricePaise: z.number().int(), label: z.string().nullable(),
          firstRecharge: z.boolean(), offerEndsAt: z.date().nullable(),
        })),
      },
    },
  }, async (req) => {
    // Welcome offer: only for accounts with no purchase yet, within N hours of sign-up.
    const hours = await numberSetting(db, "offer.first_recharge_hours", 24);
    const eligible = req.auth ? (await db.query<{ ends: Date }>(
      `SELECT u.created_at + $2 * interval '1 hour' AS ends FROM users u
        WHERE u.id = $1 AND u.created_at + $2 * interval '1 hour' > now()
          AND NOT EXISTS (SELECT 1 FROM purchases p WHERE p.user_id = u.id AND p.status = 'credited')`,
      [req.auth.userId, hours])).rows[0] : undefined;
    const rows = (await db.query<{ play_sku: string; coins: number; bonus_coins: number; price_paise: number; label: string | null; first_recharge_only: boolean }>(
      `SELECT play_sku, coins, bonus_coins, price_paise, label, first_recharge_only FROM coin_packages
        WHERE is_active AND (NOT first_recharge_only OR $1) ORDER BY first_recharge_only DESC, sort_order, coins`,
      [!!eligible])).rows;
    return rows.map((p) => ({
      sku: p.play_sku, coins: p.coins, bonusCoins: p.bonus_coins, pricePaise: p.price_paise, label: p.label,
      firstRecharge: p.first_recharge_only, offerEndsAt: p.first_recharge_only ? eligible!.ends : null,
    }));
  });

  app.get("/wallet/ledger", {
    preHandler: requireAuth(),
    schema: {
      tags: ["wallet"],
      security: bearer,
      summary: "Every coin in or out, newest first. Page with `before` = last id seen.",
      querystring: z.object({
        kind: z.enum(["coins", "earnings"]).default("coins"),
        before: z.coerce.number().int().positive().optional(),
        limit: z.coerce.number().int().min(1).max(100).default(30),
      }),
      response: { 200: z.object({ entries: z.array(LedgerEntry), nextBefore: z.number().int().nullable() }) },
    },
  }, async (req) => {
    const { kind, before, limit } = req.query;
    const rows = (await db.query<{
      id: number; type: string; amount: number; balance_after: number; call_id: string | null; note: string | null; created_at: Date;
    }>(
      `SELECT l.id, l.type, l.amount, l.balance_after, l.call_id, l.note, l.created_at
         FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id
        WHERE w.user_id = $1 AND w.kind = $2 AND ($3::bigint IS NULL OR l.id < $3)
        ORDER BY l.id DESC LIMIT $4`,
      [me(req).userId, kind, before ?? null, limit],
    )).rows;
    return {
      entries: rows.map((r) => ({
        id: r.id, type: r.type, amount: r.amount, balanceAfter: r.balance_after,
        callId: r.call_id, note: r.note, createdAt: r.created_at,
      })),
      nextBefore: rows.length === limit ? rows[rows.length - 1]!.id : null,
    };
  });
};
