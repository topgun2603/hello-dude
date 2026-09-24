/** VIP screen (design: Vip.dc.html). Buying goes through Google Play once Play Billing is live. */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { activeVip, vipDiscountPct, weeklyGift } from "../vip.js";

export const VipPlan = z.object({
  id: z.number().int(), sku: z.string(), months: z.number().int(), pricePaise: z.number().int(),
  label: z.string().nullable(), isActive: z.boolean(), sortOrder: z.number().int(),
}).meta({ id: "VipPlan" });

export const vipRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;

  app.get("/vip", {
    preHandler: requireAuth("caller"),
    schema: {
      tags: ["vip"],
      security: bearer,
      summary: "My VIP status, the perks and the plans on sale",
      response: {
        200: z.object({
          active: z.boolean(),
          expiresAt: z.date().nullable(),
          source: z.enum(["play", "admin"]).nullable(),
          discountPct: z.number().int(),
          weeklyGift: z.object({ name: z.string(), emoji: z.string(), used: z.boolean() }).nullable(),
          plans: z.array(VipPlan),
          purchasable: z.boolean().describe("false until Google Play Billing is set up"),
        }),
      },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const [vip, pct, plans] = await Promise.all([
      activeVip(db, userId),
      vipDiscountPct(db),
      db.query<{ id: number; play_sku: string; months: number; price_paise: number; label: string | null; is_active: boolean; sort_order: number }>(
        `SELECT * FROM vip_plans WHERE is_active ORDER BY sort_order, months`),
    ]);
    const credit = vip ? await weeklyGift(db, userId) : null;
    const gift = credit ? (await db.query<{ name: string; emoji: string }>(`SELECT name, emoji FROM gifts WHERE id = $1`, [credit.giftId])).rows[0] : null;
    return {
      active: !!vip, expiresAt: vip?.expiresAt ?? null, source: (vip?.source as "play" | "admin" | undefined) ?? null,
      discountPct: pct,
      weeklyGift: gift && credit ? { name: gift.name, emoji: gift.emoji, used: credit.used } : null,
      plans: plans.rows.map((p) => ({ id: p.id, sku: p.play_sku, months: p.months, pricePaise: p.price_paise, label: p.label,
        isActive: p.is_active, sortOrder: p.sort_order })),
      purchasable: false,
    };
  });
};
