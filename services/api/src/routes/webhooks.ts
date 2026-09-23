import type { FastifyPluginAsync } from "fastify";

/**
 * LiveKit webhooks. The signature covers the raw body, so this route reads the
 * body as text instead of parsed JSON.
 *
 *   participant_joined  both caller and companion present -> call connected (minute 1 charged)
 *   participant_left    whoever left hung up
 *   room_finished       room closed for any other reason
 *
 * Every handler is idempotent, so LiveKit's retries are harmless.
 */
export const webhookRoutes: FastifyPluginAsync = async (app) => {
  const { db, redis, engine, webhooks } = app.deps;

  // Only inside this plugin: keep the raw text (the signature covers the exact bytes).
  app.removeContentTypeParser("application/json");
  app.addContentTypeParser(["application/webhook+json", "application/json"], { parseAs: "string" },
    (_req, body, done) => done(null, body));

  app.post("/webhooks/livekit", { schema: { hide: true } }, async (req, reply) => {
    let event;
    try {
      event = await webhooks.verify(req.body as string, req.headers.authorization);
    } catch {
      return reply.status(401).send({ error: { code: "BAD_SIGNATURE", message: "Invalid webhook signature" } });
    }
    if (!event.room?.startsWith("call_")) return reply.status(200).send({ ok: true });

    const call = (await db.query<{ id: string; caller_id: string; companion_id: string; status: string }>(
      `SELECT id, caller_id, companion_id, status FROM calls WHERE room_name = $1`, [event.room],
    )).rows[0];
    if (!call) return reply.status(200).send({ ok: true });

    const joinedKey = `room:joined:${event.room}`;
    switch (event.event) {
      case "participant_joined": {
        if (event.identity !== call.caller_id && event.identity !== call.companion_id) break;
        await redis.multi().sadd(joinedKey, event.identity).expire(joinedKey, 6 * 3600).exec();
        const joined = await redis.smembers(joinedKey);
        if (joined.includes(call.caller_id) && joined.includes(call.companion_id)) {
          await engine.onCallConnected(call.id);
        }
        break;
      }
      case "participant_left":
        if (event.identity === call.caller_id) await engine.endCall(call.id, "caller_hangup");
        else if (event.identity === call.companion_id) await engine.endCall(call.id, "companion_hangup");
        break;
      case "room_finished":
        await engine.endCall(call.id, "network");
        await redis.del(joinedKey);
        break;
    }
    return reply.status(200).send({ ok: true });
  });
};
