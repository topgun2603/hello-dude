-- Chat safety + message requests (owner, 2026-09-24).
-- A. The filter is stronger (chat-filter.ts). B. Blocked attempts are strikes: 3 in 24 h pause
-- the sender's chat for 24 h; 5 in 30 days file an automatic report for admin review; companions
-- with strikes get a payout flag. C. New report reason "off_platform". D. A caller can send one
-- message request to a companion they haven't called yet; she accepts (chat opens) or declines.

CREATE TABLE chat_requests (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  caller_id    uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  companion_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body         text NOT NULL CHECK (length(body) BETWEEN 1 AND 300),
  status       text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined')),
  created_at   timestamptz NOT NULL DEFAULT now(),
  decided_at   timestamptz
);
-- One open request per pair.
CREATE UNIQUE INDEX chat_requests_one_pending ON chat_requests (caller_id, companion_id) WHERE status = 'pending';
CREATE INDEX chat_requests_companion ON chat_requests (companion_id, status, created_at DESC);
CREATE INDEX chat_requests_caller ON chat_requests (caller_id, created_at DESC);

ALTER TABLE users ADD COLUMN chat_paused_until timestamptz;

-- Strikes can come from a request message too (no conversation yet).
ALTER TABLE chat_violations ALTER COLUMN conversation_id DROP NOT NULL;
ALTER TABLE chat_violations ADD COLUMN request_id uuid REFERENCES chat_requests(id) ON DELETE SET NULL;

-- Automatic reports (repeated contact-sharing) have no human reporter.
ALTER TABLE reports ALTER COLUMN reporter_id DROP NOT NULL;
ALTER TABLE reports ADD COLUMN source text NOT NULL DEFAULT 'user' CHECK (source IN ('user', 'system'));

INSERT INTO app_settings (key, value) VALUES
  ('chat.strikes_to_pause', '3'),
  ('chat.pause_hours', '24'),
  ('chat.strikes_to_review', '5'),
  ('chat.requests_per_day', '5'),
  ('chat.request_retry_days', '7')
ON CONFLICT (key) DO NOTHING;
