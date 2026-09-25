-- PK battles (owner, 2026-09-25): two live companions side by side for 5 minutes; the one
-- whose viewers send more gift coins (to her, from either live) wins a "PK winner" badge.
-- Viewers still pay only for the live they're in; both hosts keep their normal gift share.
CREATE TABLE pk_battles (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  live_a      uuid NOT NULL REFERENCES lives(id),
  live_b      uuid NOT NULL REFERENCES lives(id),
  host_a      uuid NOT NULL REFERENCES users(id),
  host_b      uuid NOT NULL REFERENCES users(id),
  status      text NOT NULL DEFAULT 'invited' CHECK (status IN ('invited', 'active', 'ended', 'declined', 'expired', 'cancelled')),
  seconds     int NOT NULL DEFAULT 300,
  started_at  timestamptz,
  ends_at     timestamptz,
  score_a     int NOT NULL DEFAULT 0,
  score_b     int NOT NULL DEFAULT 0,
  winner_host uuid REFERENCES users(id),
  created_at  timestamptz NOT NULL DEFAULT now(),
  CHECK (live_a <> live_b)
);
-- A live is in at most one open (invited/active) battle.
CREATE UNIQUE INDEX pk_one_open_a ON pk_battles (live_a) WHERE status IN ('invited', 'active');
CREATE UNIQUE INDEX pk_one_open_b ON pk_battles (live_b) WHERE status IN ('invited', 'active');

INSERT INTO app_settings (key, value) VALUES ('pk.seconds', '300') ON CONFLICT (key) DO NOTHING;
