-- Group video (phase 2, owner 2026-09-24): a companion hosts up to 10 paying members,
-- everyone on camera. Members pay per minute (prepaid, like 1:1 and lives), charged
-- only while LiveKit shows them in the room. A group starts when enough members are
-- waiting in the lobby (nobody pays while waiting) and ends when too few remain.
-- Instant (host opens a lobby now) or scheduled (members book seats in advance).

ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'group_debit';
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'group_credit';

CREATE TABLE group_sessions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  host_id        uuid NOT NULL REFERENCES users(id),
  title          text NOT NULL CHECK (length(title) BETWEEN 3 AND 60),
  language_code  text NOT NULL REFERENCES languages(code),
  -- scheduled: seats bookable; lobby: waiting for members (no billing); live: billing; ended.
  status         text NOT NULL CHECK (status IN ('scheduled', 'lobby', 'live', 'ended')),
  scheduled_at   timestamptz,            -- set for scheduled groups
  lobby_at       timestamptz,            -- when the lobby opened
  started_at     timestamptz,            -- when billing started (enough members)
  ended_at       timestamptz,
  end_reason     text,
  livekit_room   text NOT NULL UNIQUE,
  coins_per_min  int NOT NULL CHECK (coins_per_min > 0),   -- frozen when created
  paise_per_min  int NOT NULL CHECK (paise_per_min >= 0),  -- companion share, frozen
  min_members    int NOT NULL,
  max_members    int NOT NULL,
  host_seen_at   timestamptz NOT NULL DEFAULT now(),
  few_since      timestamptz,            -- when members first fell below the end threshold
  reminded_at    timestamptz,
  created_at     timestamptz NOT NULL DEFAULT now()
);
-- One open (lobby/live) group per host at a time.
CREATE UNIQUE INDEX group_sessions_one_open ON group_sessions (host_id) WHERE status IN ('lobby', 'live');
CREATE INDEX group_sessions_open ON group_sessions (status, scheduled_at) WHERE status <> 'ended';

CREATE TABLE group_members (
  session_id       uuid NOT NULL REFERENCES group_sessions(id),
  user_id          uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  booked_at        timestamptz,          -- a seat booked for a scheduled group
  joined_at        timestamptz,          -- in the lobby / room now (null = only booked, or left)
  left_at          timestamptz,
  last_seen_at     timestamptz,
  paying           boolean NOT NULL DEFAULT false,
  minutes_charged  int NOT NULL DEFAULT 0,
  last_charged_at  timestamptz,
  PRIMARY KEY (session_id, user_id)
);

CREATE TABLE group_ticks (
  session_id uuid NOT NULL REFERENCES group_sessions(id),
  member_id  uuid NOT NULL REFERENCES users(id),
  minute_no  int NOT NULL CHECK (minute_no >= 1),
  coins      int NOT NULL CHECK (coins > 0),
  paise      int NOT NULL CHECK (paise >= 0),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (session_id, member_id, minute_no)
);
CREATE INDEX group_ticks_created ON group_ticks (created_at);

ALTER TABLE ledger_entries ADD COLUMN group_id uuid REFERENCES group_sessions(id);
CREATE INDEX ledger_entries_group ON ledger_entries (group_id) WHERE group_id IS NOT NULL;

ALTER TABLE moderation_flags ADD COLUMN group_id uuid REFERENCES group_sessions(id);
ALTER TABLE moderation_flags DROP CONSTRAINT moderation_flags_source;
ALTER TABLE moderation_flags ADD CONSTRAINT moderation_flags_source
  CHECK (call_id IS NOT NULL OR live_id IS NOT NULL OR group_id IS NOT NULL);
-- In groups (and lives) each phone checks its own camera, so a flag can be about
-- the person whose phone raised it.
ALTER TABLE moderation_flags DROP CONSTRAINT IF EXISTS moderation_flags_check;

-- Reports raised inside a group.
ALTER TABLE reports ADD COLUMN group_id uuid REFERENCES group_sessions(id);

-- Gifts in a group (to the host); client_ref makes retries safe.
CREATE TABLE group_gifts (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id     uuid NOT NULL REFERENCES group_sessions(id),
  sender_id      uuid NOT NULL REFERENCES users(id),
  receiver_id    uuid NOT NULL REFERENCES users(id),
  gift_id        int NOT NULL REFERENCES gifts(id),
  coins          int NOT NULL CHECK (coins > 0),
  paise_credited int NOT NULL CHECK (paise_credited >= 0),
  client_ref     uuid NOT NULL UNIQUE,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- Placeholder rules (admin-editable).
INSERT INTO app_settings (key, value) VALUES
  ('group.coins_per_min', '12'),
  ('group.companion_share_bps', '2500'),
  ('group.min_members', '3'),
  ('group.max_members', '10'),
  ('group.end_below', '2'),
  ('group.lobby_timeout_minutes', '10'),
  ('group.max_minutes', '120'),
  ('group.no_show_minutes', '15')
ON CONFLICT (key) DO NOTHING;
