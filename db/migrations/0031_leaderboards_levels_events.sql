-- Growth features (owner, 2026-09-25): weekly leaderboards with badges, caller levels,
-- festival events, and the companion-invites-companion referral rule.

-- Every gift, wherever it was sent (calls, lives, groups, voice rooms).
CREATE VIEW all_gifts AS
  SELECT sender_id, receiver_id, coins, created_at FROM call_gifts
  UNION ALL SELECT sender_id, receiver_id, coins, created_at FROM live_gifts
  UNION ALL SELECT sender_id, receiver_id, coins, created_at FROM group_gifts
  UNION ALL SELECT sender_id, receiver_id, coins, created_at FROM voice_room_gifts;

-- Badges: weekly top companions / fans, event winners (PK wins later). Shown while not expired.
CREATE TABLE user_badges (
  id           bigserial PRIMARY KEY,
  user_id      uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  kind         text NOT NULL CHECK (kind IN ('top_companion', 'top_fan', 'event_companion', 'event_fan', 'pk_win')),
  rank         smallint,
  label        text NOT NULL,
  period_start timestamptz NOT NULL,
  event_id     uuid,
  expires_at   timestamptz NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX user_badges_once ON user_badges (user_id, kind, period_start, COALESCE(event_id, '00000000-0000-0000-0000-000000000000'));
CREATE INDEX user_badges_active ON user_badges (user_id, expires_at DESC);

-- Weeks whose badges were handed out (the worker runs hourly; this makes it once).
CREATE TABLE leaderboard_awards (week_start timestamptz PRIMARY KEY, awarded_at timestamptz NOT NULL DEFAULT now());

-- Caller levels by lifetime coins spent (calls, gifts, lives, groups; refunds taken back).
ALTER TABLE users ADD COLUMN coins_spent bigint NOT NULL DEFAULT 0;
UPDATE users u SET coins_spent = s.spent FROM (
  SELECT w.user_id, GREATEST(0, COALESCE(-sum(l.amount) FILTER (WHERE l.type IN ('call_debit', 'gift_debit', 'live_debit', 'live_pass_debit', 'group_debit')), 0)
                            - COALESCE(sum(l.amount) FILTER (WHERE l.type = 'refund'), 0)) AS spent
    FROM ledger_entries l JOIN wallets w ON w.id = l.wallet_id WHERE w.kind = 'coins' GROUP BY w.user_id) s
 WHERE s.user_id = u.id;

CREATE FUNCTION bump_coins_spent() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.type::text IN ('call_debit', 'gift_debit', 'live_debit', 'live_pass_debit', 'group_debit') THEN
    UPDATE users u SET coins_spent = u.coins_spent - NEW.amount
      FROM wallets w WHERE w.id = NEW.wallet_id AND w.kind = 'coins' AND u.id = w.user_id;
  ELSIF NEW.type::text = 'refund' THEN
    UPDATE users u SET coins_spent = GREATEST(0, u.coins_spent - NEW.amount)
      FROM wallets w WHERE w.id = NEW.wallet_id AND w.kind = 'coins' AND u.id = w.user_id;
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER ledger_bump_coins_spent AFTER INSERT ON ledger_entries FOR EACH ROW EXECUTE FUNCTION bump_coins_spent();

CREATE TABLE caller_levels (
  level     smallint PRIMARY KEY CHECK (level >= 1),
  name      text NOT NULL,
  min_coins int NOT NULL CHECK (min_coins >= 0),
  perk      text
);
-- Placeholder thresholds (admin-editable).
INSERT INTO caller_levels (level, name, min_coins, perk) VALUES
  (1, 'Newbie', 0, NULL),
  (2, 'Friendly', 200, 'Level badge on your profile'),
  (3, 'Regular', 1000, 'Level badge on your profile'),
  (4, 'Chatter', 3000, 'Companions see your level'),
  (5, 'Buddy', 8000, 'Companions see your level'),
  (6, 'Star fan', 20000, 'Gold level badge'),
  (7, 'Super fan', 50000, 'Gold level badge'),
  (8, 'Legend', 120000, 'Legend badge');
ALTER TABLE users ADD COLUMN caller_level smallint NOT NULL DEFAULT 1;

-- Festival events: dates, theme, featured gifts; their own leaderboards and winner badges.
CREATE TABLE events (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name              text NOT NULL CHECK (length(name) BETWEEN 3 AND 60),
  tagline           text,
  theme             text NOT NULL DEFAULT 'festive' CHECK (theme IN ('festive', 'pongal', 'diwali', 'onam', 'holi', 'love', 'cricket')),
  starts_at         timestamptz NOT NULL,
  ends_at           timestamptz NOT NULL CHECK (ends_at > starts_at),
  gift_ids          int[] NOT NULL DEFAULT '{}',
  active            boolean NOT NULL DEFAULT true,
  badges_awarded_at timestamptz,
  created_by        uuid REFERENCES users(id),
  created_at        timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX events_live ON events (starts_at, ends_at) WHERE active;
ALTER TABLE user_badges ADD CONSTRAINT user_badges_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE;

INSERT INTO app_settings (key, value) VALUES
  ('leaderboard.badge_top_n', '10'),
  ('referral.companion_invite_paise', '10000'),
  ('referral.companion_invite_hours', '10')
ON CONFLICT (key) DO NOTHING;
