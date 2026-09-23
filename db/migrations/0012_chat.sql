-- 1:1 text chat between a caller and a companion who have had at least one
-- connected call (CLAUDE.md "v2 rules"). Free. Calls between the pair are shown
-- in the thread from the calls table, so they are not copied here.
CREATE TABLE conversations (
  id                     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  caller_id              uuid NOT NULL REFERENCES users(id),
  companion_id           uuid NOT NULL REFERENCES users(id),
  created_at             timestamptz NOT NULL DEFAULT now(),
  last_message_at        timestamptz,
  caller_last_read_at    timestamptz,
  companion_last_read_at timestamptz,
  UNIQUE (caller_id, companion_id),
  CHECK (caller_id <> companion_id)
);
CREATE INDEX conversations_companion ON conversations (companion_id, last_message_at DESC);

CREATE TABLE messages (
  id              bigserial PRIMARY KEY,
  conversation_id uuid NOT NULL REFERENCES conversations(id),
  sender_id       uuid NOT NULL REFERENCES users(id),
  body            text NOT NULL CHECK (length(body) BETWEEN 1 AND 1000),
  client_ref      uuid NOT NULL UNIQUE,              -- app-generated; a retried send can't post twice
  created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX messages_conversation ON messages (conversation_id, id DESC);

-- Messages the safety filter refused (phone numbers, UPI IDs, payment requests).
-- Not delivered; kept for the fraud checks and the admin user page.
CREATE TABLE chat_violations (
  id              bigserial PRIMARY KEY,
  conversation_id uuid NOT NULL REFERENCES conversations(id),
  sender_id       uuid NOT NULL REFERENCES users(id),
  reason          text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX chat_violations_sender ON chat_violations (sender_id, created_at DESC);
