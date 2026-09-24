import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, conflict, forbidden, notFound } from "../errors.js";
import { post } from "../billing/ledger.js";
import { numberSetting } from "../settings.js";
import { spendWeeklyGift } from "../vip.js";

export const Gift = z.object({
  id: z.number().int(), code: z.string(), name: z.string(), emoji: z.string(), coins: z.number().int(),
}).meta({ id: "Gift" });

/** Companion's share of a gift, in paise. */
export async function giftPaise(db: Parameters<typeof numberSetting>[0], coins: number): Promise<number> {
  const [valuePaise, shareBps] = await Promise.all([
    numberSetting(db, "coin.value_paise", 80),
    numberSetting(db, "gift.companion_share_bps", 4000),
  ]);
  return Math.round((coins * valuePaise * shareBps) / 10_000);
}

export const giftRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db, events } = app.deps;

  app.get("/gifts", {
    schema: { tags: ["calls"], summary: "Gifts a caller can send during a call", response: { 200: z.array(Gift) } },
  }, async () => (await db.query(
    `SELECT id, code, name, emoji, coins FROM gifts WHERE is_active ORDER BY sort_order, coins`)).rows);

  app.post("/calls/:id/gifts", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["calls"],
      security: bearer,
      summary: "Send a gift during a live call. clientRef makes a retried tap safe.",
      params: z.object({ id: z.uuid() }),
      body: z.object({ giftId: z.number().int(), clientRef: z.uuid() }),
      response: { 201: z.object({ gift: Gift, coinsLeft: z.number().int() }) },
    },
  }, async (req, reply) => {
    const { userId } = me(req);
    const { giftId, clientRef } = req.body;
    const gift = (await db.query<{ id: number; code: string; name: string; emoji: string; coins: number }>(
      `SELECT id, code, name, emoji, coins FROM gifts WHERE id = $1 AND is_active`, [giftId])).rows[0];
    if (!gift) throw notFound("GIFT_NOT_FOUND");
    const paise = await giftPaise(db, gift.coins);

    const result = await tx(db, async (c) => {
      const call = (await c.query<{ caller_id: string; companion_id: string; status: string; coins_per_min: number }>(
        `SELECT caller_id, companion_id, status, coins_per_min FROM calls WHERE id = $1 FOR UPDATE`, [req.params.id])).rows[0];
      if (!call) throw notFound("CALL_NOT_FOUND");
      if (call.caller_id !== userId) throw forbidden("NOT_YOUR_CALL");
      if (call.status !== "active") throw conflict("CALL_NOT_ACTIVE", "Gifts can only be sent during a call");

      const ins = await c.query<{ id: string }>(
        `INSERT INTO call_gifts (call_id, sender_id, receiver_id, gift_id, coins, paise_credited, client_ref)
         VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (client_ref) DO NOTHING RETURNING id`,
        [req.params.id, userId, call.companion_id, gift.id, gift.coins, paise, clientRef]);
      const balance = async () => (await c.query<{ balance: number }>(
        `SELECT balance FROM wallets WHERE user_id = $1 AND kind = 'coins'`, [userId])).rows[0]?.balance ?? 0;
      if (!ins.rowCount) return { duplicate: true as const, coinsLeft: await balance(), call };

      const giftRowId = ins.rows[0]!.id;
      // VIP: this week's free Rose costs the caller nothing (the companion is still paid).
      const free = await spendWeeklyGift(c, userId, gift.id, giftRowId);
      if (free) await c.query(`UPDATE call_gifts SET coins = 0 WHERE id = $1`, [giftRowId]);
      const left = free ? await balance() : await post(c, userId, "coins", "gift_debit", -gift.coins, `gift:${giftRowId}:debit`,
        { callId: req.params.id, note: `${gift.name} gift` });
      if (left === null) throw new ApiError(402, "INSUFFICIENT_BALANCE", `You need ${gift.coins} coins for a ${gift.name}`);
      if (paise > 0) {
        await post(c, call.companion_id, "earnings", "gift_credit", paise, `gift:${giftRowId}:credit`,
          { callId: req.params.id, note: `${gift.name} gift` });
      }
      return { duplicate: false as const, coinsLeft: left, call };
    });

    if (!result.duplicate) {
      await events.publish(result.call.companion_id, {
        t: "gift_received", callId: req.params.id, gift: { name: gift.name, emoji: gift.emoji, coins: gift.coins }, paiseEarned: paise,
      });
      if (result.coinsLeft < result.call.coins_per_min) await events.publish(userId, { t: "low_balance", callId: req.params.id });
    }
    reply.status(201);
    return { gift, coinsLeft: result.coinsLeft };
  });
};
