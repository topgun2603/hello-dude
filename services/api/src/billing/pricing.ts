/**
 * The price frozen onto a call when it starts. The rate table gives the base;
 * perks adjust it here, in one place:
 * - VIP callers pay less per minute (the platform funds it; the companion's
 *   per-minute earnings are unchanged).
 * - Companions on higher levels earn a bit more per minute (rewards.ts).
 * Safety cap: a companion never earns more than ₹1 (100 paise) per coin the
 * caller pays for that minute — the same rule admin rates enforce — so perks
 * stacking up can't make a minute cost the platform more than it brings in.
 */
import type { DbClient } from "../db/pool.js";
import { activeVip, discounted, vipDiscountPct } from "../vip.js";
import { boostedPaise } from "../rewards.js";

export interface CallPrice { coinsPerMin: number; companionPaisePerMin: number }

/** Matches the admin rate rule COMPANION_SHARE_TOO_HIGH. */
export const MAX_PAISE_PER_COIN = 100;

export async function priceCall(c: DbClient, callerId: string, companionId: string, base: CallPrice): Promise<CallPrice> {
  let { coinsPerMin } = base;
  if (await activeVip(c, callerId)) coinsPerMin = discounted(coinsPerMin, await vipDiscountPct(c));
  const boosted = await boostedPaise(c, companionId, base.companionPaisePerMin);
  return { coinsPerMin, companionPaisePerMin: Math.min(boosted, coinsPerMin * MAX_PAISE_PER_COIN) };
}
