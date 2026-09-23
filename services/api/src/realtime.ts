/**
 * WebSocket push: GET /v1/ws?token=<access token>.
 *
 * Anything published to Redis channel `user:<id>` (billing engine, call routes)
 * is forwarded to every socket that user has open. Redis pub/sub means this
 * works with several API instances behind a load balancer.
 * The server pings every 25 s so dead mobile connections are noticed.
 */
import websocket from "@fastify/websocket";
import type { FastifyInstance } from "fastify";
import type { Redis } from "ioredis";
import type { WebSocket } from "ws";

const PING_EVERY_MS = 25_000;

export async function registerRealtime(app: FastifyInstance, redis: Redis): Promise<void> {
  const sockets = new Map<string, Set<WebSocket>>();
  const sub = redis.duplicate();
  await sub.psubscribe("user:*");
  sub.on("pmessage", (_pattern, channel, message) => {
    for (const ws of sockets.get(channel.slice("user:".length)) ?? []) ws.send(message);
  });
  app.addHook("onClose", async () => { sub.disconnect(); });

  await app.register(websocket);
  app.get("/v1/ws", { websocket: true, schema: { hide: true } }, async (socket, req) => {
    const token = (req.query as { token?: string }).token;
    let userId: string;
    try {
      userId = (await app.deps.tokens.verifyAccess(token ?? "")).userId;
    } catch {
      socket.close(4401, "unauthorized");
      return;
    }
    const mine = sockets.get(userId) ?? new Set<WebSocket>();
    sockets.set(userId, mine.add(socket));

    let alive = true;
    socket.on("pong", () => { alive = true; });
    const ping = setInterval(() => {
      if (!alive) return socket.terminate();
      alive = false;
      socket.ping();
    }, PING_EVERY_MS);

    socket.on("close", () => {
      clearInterval(ping);
      mine.delete(socket);
      if (!mine.size) sockets.delete(userId);
    });
    socket.send(JSON.stringify({ t: "hello" }));
  });
}
