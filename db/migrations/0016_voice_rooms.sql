-- Voice rooms (designs: Rooms.dc.html, RoomLive.dc.html; CLAUDE.md "v2 rules").
-- Hosted by approved companions; listening is free; gifts to the host/speakers
-- pay the same companion share as call gifts.

CREATE TABLE room_categories (
  code       text PRIMARY KEY,
  name       text NOT NULL,
  sort_order int NOT NULL DEFAULT 0,
  is_active  boolean NOT NULL DEFAULT true
);
INSERT INTO room_categories (code, name, sort_order) VALUES
  ('movies', 'Movies', 1), ('music', 'Music', 2), ('cricket', 'Cricket', 3), ('late_night', 'Late night', 4);

CREATE TABLE voice_rooms (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  host_id       uuid NOT NULL REFERENCES users(id),
  title         text NOT NULL CHECK (length(title) BETWEEN 3 AND 60),
  category      text NOT NULL REFERENCES room_categories(code),
  language_code text NOT NULL REFERENCES languages(code),
  livekit_room  text NOT NULL UNIQUE,
  status        text NOT NULL DEFAULT 'live' CHECK (status IN ('live', 'ended')),
  max_speakers  smallint NOT NULL DEFAULT 8,
  created_at    timestamptz NOT NULL DEFAULT now(),
  ended_at      timestamptz,
  end_reason    text
);
CREATE UNIQUE INDEX voice_rooms_one_live_per_host ON voice_rooms (host_id) WHERE status = 'live';
CREATE INDEX voice_rooms_live ON voice_rooms (language_code, created_at DESC) WHERE status = 'live';

CREATE TABLE voice_room_members (
  room_id        uuid NOT NULL REFERENCES voice_rooms(id),
  user_id        uuid NOT NULL REFERENCES users(id),
  role           text NOT NULL CHECK (role IN ('host', 'speaker', 'listener')),
  hand_raised_at timestamptz,
  joined_at      timestamptz NOT NULL DEFAULT now(),
  last_seen_at   timestamptz NOT NULL DEFAULT now(),
  left_at        timestamptz,
  PRIMARY KEY (room_id, user_id)
);
CREATE INDEX voice_room_members_live ON voice_room_members (room_id) WHERE left_at IS NULL;

CREATE TABLE voice_room_gifts (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id        uuid NOT NULL REFERENCES voice_rooms(id),
  sender_id      uuid NOT NULL REFERENCES users(id),
  receiver_id    uuid NOT NULL REFERENCES users(id),
  gift_id        int NOT NULL REFERENCES gifts(id),
  coins          int NOT NULL,
  paise_credited int NOT NULL,
  client_ref     uuid NOT NULL UNIQUE,
  created_at     timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX voice_room_gifts_room ON voice_room_gifts (room_id);
