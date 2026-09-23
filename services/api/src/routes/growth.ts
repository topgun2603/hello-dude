/** Daily check-in, Invite friends and the Share card (designs CheckIn, Referral, ShareCard). */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import { tx } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { checkinState, claimCheckin, IST_TODAY_SQL, referralCode } from "../growth.js";
import { numberSetting } from "../settings.js";

const CheckIn = z.object({
  day: z.number().int().describe("Streak day of today's claim, 1–7"),
  claimedToday: z.boolean(),
  todayCoins: z.number().int(),
  streak: z.number().int().describe("Consecutive days claimed"),
  days: z.array(z.object({ day: z.number().int(), coins: z.number().int(), state: z.enum(["claimed", "today", "upcoming"]) })),
}).meta({ id: "CheckIn" });

/** Public link a friend opens; the app can pick the code up from it (App Links later). */
const inviteLink = (code: string) => `https://hellodude.app/r/${code}`;

export const growthRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const base = { tags: ["growth"], security: bearer };

  const view = async (userId: string) => {
    const s = await checkinState(db, userId);
    return {
      day: s.day, claimedToday: s.claimedToday, todayCoins: s.rewards[s.day - 1] ?? 0, streak: s.streak,
      days: s.rewards.map((coins, i) => ({
        day: i + 1, coins,
        state: i + 1 < s.day ? "claimed" as const : i + 1 === s.day ? (s.claimedToday ? "claimed" as const : "today" as const) : "upcoming" as const,
      })),
    };
  };

  app.get("/checkin", {
    preHandler: requireAuth("caller"),
    schema: { ...base, summary: "Daily bonus: today's streak day and the 7-day reward ladder", response: { 200: CheckIn } },
  }, async (req) => view(me(req).userId));

  app.post("/checkin/claim", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Claim today's bonus (once per IST day; repeating is harmless)",
      response: { 200: z.object({ credited: z.number().int().describe("0 if today was already claimed"), coins: z.number().int().nullable(), checkin: CheckIn }) },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const r = await tx(db, (c) => claimCheckin(c, userId));
    return { credited: r.coins, coins: r.balance, checkin: await view(userId) };
  });

  app.get("/referral", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "Invite friends: my code, the reward and how many friends joined",
      response: {
        200: z.object({
          code: z.string(), link: z.string(),
          referrerCoins: z.number().int(), refereeCoins: z.number().int(),
          joined: z.number().int(), rewarded: z.number().int(), coinsEarned: z.number().int(),
        }),
      },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const code = await referralCode(db, userId);
    const [referrerCoins, refereeCoins, stats] = await Promise.all([
      numberSetting(db, "referral.referrer_coins", 50),
      numberSetting(db, "referral.referee_coins", 50),
      db.query<{ joined: number; rewarded: number; earned: number }>(
        `SELECT count(*)::int AS joined, count(*) FILTER (WHERE status = 'rewarded')::int AS rewarded,
                COALESCE(sum(referrer_coins), 0)::int AS earned
           FROM referrals WHERE referrer_id = $1`, [userId]),
    ]);
    const s = stats.rows[0]!;
    return { code, link: inviteLink(code), referrerCoins, refereeCoins, joined: s.joined, rewarded: s.rewarded, coinsEarned: s.earned };
  });

  app.get("/share-card", {
    preHandler: requireAuth("caller"),
    schema: {
      ...base,
      summary: "What the share card shows: today's talk time, language and invite code (never who they talked to)",
      response: {
        200: z.object({
          todayMinutes: z.number().int(), language: z.string(), code: z.string(), link: z.string(), refereeCoins: z.number().int(),
        }),
      },
    },
  }, async (req) => {
    const userId = me(req).userId;
    const [code, refereeCoins, stats] = await Promise.all([
      referralCode(db, userId),
      numberSetting(db, "referral.referee_coins", 50),
      db.query<{ minutes: number; language: string }>(
        `SELECT COALESCE((SELECT sum(minutes_charged) FROM calls
                           WHERE caller_id = $1 AND (created_at AT TIME ZONE 'Asia/Kolkata')::date = ${IST_TODAY_SQL}), 0)::int AS minutes,
                (SELECT primary_language FROM users WHERE id = $1) AS language`, [userId]),
    ]);
    return { todayMinutes: stats.rows[0]!.minutes, language: stats.rows[0]!.language, code, link: inviteLink(code), refereeCoins };
  });
};
