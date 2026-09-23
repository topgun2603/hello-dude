/**
 * Companion academy (Training design): lessons unlock in order; each has a
 * short quiz that must be answered fully correctly. All lessons passed is one
 * of the conditions for an admin to unlock video calls.
 */
import { z } from "zod";
import type { FastifyPluginAsyncZod } from "fastify-type-provider-zod";
import type { Db, DbClient } from "../db/pool.js";
import { bearer, me, requireAuth } from "../auth/guard.js";
import { ApiError, conflict, notFound } from "../errors.js";

interface QuizItem { q: string; options: string[]; answer: number }

export async function academyProgress(db: Db | DbClient, userId: string): Promise<{ passed: number; total: number }> {
  const r = (await db.query<{ passed: number; total: number }>(
    `SELECT (SELECT count(*) FROM academy_progress WHERE user_id = $1)::int AS passed,
            (SELECT count(*) FROM academy_lessons)::int AS total`, [userId])).rows[0]!;
  return r;
}

const Lesson = z.object({
  id: z.number().int(), position: z.number().int(), title: z.string(), minutes: z.number().int(),
  body: z.string(), videoUrl: z.string().nullable(),
  status: z.enum(["done", "available", "locked"]),
  quiz: z.array(z.object({ q: z.string(), options: z.array(z.string()) })),
}).meta({ id: "AcademyLesson" });

export const academyRoutes: FastifyPluginAsyncZod = async (app) => {
  const { db } = app.deps;
  const companion = requireAuth("companion");
  const base = { tags: ["companion"], security: bearer };

  async function lessons(userId: string) {
    const rows = (await db.query<{ id: number; position: number; title: string; minutes: number; body: string; video_url: string | null; quiz: QuizItem[]; done: boolean }>(
      `SELECT l.*, EXISTS (SELECT 1 FROM academy_progress p WHERE p.user_id = $1 AND p.lesson_id = l.id) AS done
         FROM academy_lessons l ORDER BY l.position`, [userId])).rows;
    let unlocked = true;
    return rows.map((l) => {
      const status = l.done ? "done" as const : unlocked ? "available" as const : "locked" as const;
      if (!l.done) unlocked = false; // only the first unfinished lesson is open
      return { ...l, status };
    });
  }

  app.get("/companion/academy", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Lessons, in order, with my progress (quiz answers are not included)",
      response: { 200: z.object({ passed: z.number().int(), total: z.number().int(), videoUnlocked: z.boolean(), lessons: z.array(Lesson) }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    const list = await lessons(userId);
    const video = (await db.query<{ video_enabled: boolean }>(`SELECT video_enabled FROM companion_profiles WHERE user_id = $1`, [userId])).rows[0];
    return {
      passed: list.filter((l) => l.status === "done").length,
      total: list.length,
      videoUnlocked: video?.video_enabled ?? false,
      lessons: list.map((l) => ({
        id: l.id, position: l.position, title: l.title, minutes: l.minutes, body: l.body, videoUrl: l.video_url, status: l.status,
        quiz: l.quiz.map(({ q, options }) => ({ q, options })),
      })),
    };
  });

  app.post("/companion/academy/:lessonId/answers", {
    preHandler: companion,
    schema: {
      ...base,
      summary: "Submit quiz answers (option index per question). All must be right to pass.",
      params: z.object({ lessonId: z.coerce.number().int() }),
      body: z.object({ answers: z.array(z.number().int().min(0)).min(1).max(20) }),
      response: { 200: z.object({ passed: z.boolean(), correct: z.array(z.boolean()) }) },
    },
  }, async (req) => {
    const { userId } = me(req);
    const lesson = (await lessons(userId)).find((l) => l.id === req.params.lessonId);
    if (!lesson) throw notFound("LESSON_NOT_FOUND");
    if (lesson.status === "locked") throw conflict("LESSON_LOCKED", "Finish the earlier lessons first");
    if (req.body.answers.length !== lesson.quiz.length) throw new ApiError(400, "ANSWER_COUNT", `Answer all ${lesson.quiz.length} questions`);
    const correct = lesson.quiz.map((item, i) => item.answer === req.body.answers[i]);
    const passed = correct.every(Boolean);
    if (passed) {
      await db.query(`INSERT INTO academy_progress (user_id, lesson_id) VALUES ($1, $2) ON CONFLICT DO NOTHING`, [userId, lesson.id]);
    }
    return { passed, correct };
  });
};
