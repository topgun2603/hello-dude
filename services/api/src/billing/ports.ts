/**
 * Everything the billing engine needs from the outside world besides Postgres
 * and Redis. Production uses the LiveKit / Redis adapters below; tests pass fakes.
 */
import { AccessToken, RoomServiceClient, WebhookReceiver } from "livekit-server-sdk";
import type { Redis } from "ioredis";

export interface RoomControl {
  /** Number of participants currently in the room (0 if it doesn't exist). */
  participantCount(room: string): Promise<number>;
  /** Closes the room, which disconnects both clients. Must not throw if already gone. */
  closeRoom(room: string): Promise<void>;
  /** Short-lived token that lets `identity` join `room`. */
  joinToken(room: string, identity: string): Promise<string>;
}

/** Pushed to a user's open WebSocket connections (see realtime.ts). */
export type UserEvent =
  | { t: "incoming_call"; callId: string; callType: "audio" | "video"; caller: { id: string; displayName: string; avatarId: number } }
  | { t: "call_accepted"; callId: string }
  | { t: "call_connected"; callId: string; coinsPerMin: number; balanceAfterFirstMinute: number | null }
  | { t: "low_balance"; callId: string }
  | { t: "gift_received"; callId: string; gift: { name: string; emoji: string; coins: number }; paiseEarned: number }
  | { t: "favourite_online"; companion: { id: string; displayName: string; avatarId: number } }
  | { t: "call_ended"; callId: string; reason: string }
  /** A new inbox item (notifications.ts); the app bumps its bell badge. */
  | { t: "notification"; id: number; type: string; title: string }
  /** A chat message for an open chat screen (routes/chat.ts). */
  | { t: "chat_message"; conversationId: string; message: { id: number; senderId: string; body: string; createdAt: string } };

export interface UserEvents {
  publish(userId: string, event: UserEvent): Promise<void>;
}

/** The parts of a LiveKit webhook the API acts on. */
export interface RoomWebhookEvent {
  event: string;          // participant_joined, participant_left, room_finished, ...
  room: string | null;
  identity: string | null;
}

export interface WebhookVerifier {
  /** Checks the signature in the Authorization header; throws if it is wrong. */
  verify(rawBody: string, authHeader: string | undefined): Promise<RoomWebhookEvent>;
}

export function liveKitWebhooks(key: string, secret: string): WebhookVerifier {
  const receiver = new WebhookReceiver(key, secret);
  return {
    async verify(rawBody, authHeader) {
      const e = await receiver.receive(rawBody, authHeader);
      return { event: e.event, room: e.room?.name ?? null, identity: e.participant?.identity ?? null };
    },
  };
}

export function liveKitRooms(url: string, key: string, secret: string): RoomControl {
  const rooms = new RoomServiceClient(url, key, secret);
  return {
    async participantCount(room) {
      const list = await rooms.listParticipants(room).catch(() => []);
      return list.length;
    },
    async closeRoom(room) {
      await rooms.deleteRoom(room).catch(() => {});
    },
    async joinToken(room, identity) {
      const t = new AccessToken(key, secret, { identity, ttl: "2h" });
      t.addGrant({ room, roomJoin: true, canPublish: true, canSubscribe: true });
      return t.toJwt();
    },
  };
}

/** Publishes to `user:<id>`; the WebSocket server relays it to that user's sockets. */
export function redisUserEvents(redis: Redis): UserEvents {
  return {
    async publish(userId, event) {
      await redis.publish(`user:${userId}`, JSON.stringify(event));
    },
  };
}
