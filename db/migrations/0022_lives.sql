-- Live mode (phase 1): a companion streams video to many viewers. Viewers get a
-- short free preview, then buy a time pass (15 min / 1 hour) with coins; gifts
-- work as in calls. Access is enforced by the server (worker removes viewers from
-- the LiveKit room when their preview or pass runs out).

ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'live_pass_debit';
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'live_pass_credit';

CREATE TABLE lives (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  host_id        uuid NOT NULL REFERENCES users(id),
  title          text NOT NULL CHECK (length(title) BETWEEN 3 AND 60),
  language_code  text NOT NULL REFERENCES languages(code),
  livekit_room   text NOT NULL UNIQUE,
  status         text NOT NULL DEFAULT 'live' CHECK (status IN ('live', 'ended')),
  host_seen_at   timestamptz NOT NULL DEFAULT now(),   -- host heartbeat
  peak_viewers   int NOT NULL DEFAULT 0,
  started_at     timestamptz NOT NULL DEFAULT now(),
  ended_at       timestamptz,
  end_reason     text
);
CREATE UNIQUE INDEX lives_one_per_host ON lives (host_id) WHERE status = 'live';
CREATE INDEX lives_live ON lives (started_at DESC) WHERE status = 'live';

-- One row per viewer per live: when their free preview started, when they were last here.
CREATE TABLE live_viewers (
  live_id          uuid NOT NULL REFERENCES lives(id),
  user_id          uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  preview_started_at timestamptz NOT NULL DEFAULT now(),
  joined_at        timestamptz NOT NULL DEFAULT now(),
  last_seen_at     timestamptz NOT NULL DEFAULT now(),
  left_at          timestamptz,
  PRIMARY KEY (live_id, user_id)
);

-- Each purchase; a new pass while one is running extends it (starts_at = old end).
CREATE TABLE live_passes (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  live_id        uuid NOT NULL REFERENCES lives(id),
  viewer_id      uuid NOT NULL REFERENCES users(id),
  minutes        int NOT NULL CHECK (minutes > 0),
  coins          int NOT NULL CHECK (coins > 0),
  paise_credited int NOT NULL CHECK (paise_credited >= 0),
  starts_at      timestamptz NOT NULL,
  ends_at        timestamptz NOT NULL,
  client_ref     uuid NOT NULL UNIQUE,     -- app-generated; a retried tap can't buy twice
  created_at     timestamptz NOT NULL DEFAULT now(),
  CHECK (ends_at > starts_at)
);
CREATE INDEX live_passes_access ON live_passes (live_id, viewer_id, ends_at DESC);

CREATE TABLE live_gifts (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  live_id        uuid NOT NULL REFERENCES lives(id),
  sender_id      uuid NOT NULL REFERENCES users(id),
  receiver_id    uuid NOT NULL REFERENCES users(id),
  gift_id        int NOT NULL REFERENCES gifts(id),
  coins          int NOT NULL,
  paise_credited int NOT NULL,
  client_ref     uuid NOT NULL UNIQUE,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- Frames flagged during a live (the host's own camera) go to the same moderation queue.
ALTER TABLE moderation_flags ALTER COLUMN call_id DROP NOT NULL;
ALTER TABLE moderation_flags ADD COLUMN live_id uuid REFERENCES lives(id);
ALTER TABLE moderation_flags ADD CONSTRAINT moderation_flags_source CHECK (call_id IS NOT NULL OR live_id IS NOT NULL);

-- Placeholder prices (admin-editable in Pricing → Settings).
INSERT INTO app_settings (key, value) VALUES
  ('live.preview_seconds', '10'),
  ('live.pass15_coins', '40'),
  ('live.pass60_coins', '120'),
  -- Companion share of pass coins, in basis points of coin.value_paise (2500 = 25%).
  ('live.companion_share_bps', '2500'),
  ('live.max_viewers', '200')
ON CONFLICT (key) DO NOTHING;
