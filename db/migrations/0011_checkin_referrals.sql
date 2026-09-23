-- Daily check-in bonus and referrals (CLAUDE.md "v2 rules").

ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'daily_bonus';
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'referral_bonus';

-- One row per claimed IST day. streak_day is 1..7 (the cycle restarts after 7).
CREATE TABLE checkins (
  user_id    uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  day        date NOT NULL,
  streak_day smallint NOT NULL CHECK (streak_day BETWEEN 1 AND 7),
  coins      int NOT NULL CHECK (coins >= 0),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, day)
);

ALTER TABLE users ADD COLUMN referral_code text UNIQUE;

-- A friend who signed up with someone's code. Both get coins after the
-- friend's first credited recharge.
CREATE TABLE referrals (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id    uuid NOT NULL REFERENCES users(id),
  referee_id     uuid NOT NULL UNIQUE REFERENCES users(id),
  code           text NOT NULL,
  status         text NOT NULL DEFAULT 'joined' CHECK (status IN ('joined', 'rewarded', 'capped')),
  referrer_coins int NOT NULL DEFAULT 0,
  referee_coins  int NOT NULL DEFAULT 0,
  created_at     timestamptz NOT NULL DEFAULT now(),
  rewarded_at    timestamptz,
  CHECK (referrer_id <> referee_id)
);
CREATE INDEX referrals_referrer ON referrals (referrer_id, created_at DESC);

INSERT INTO app_settings (key, value) VALUES
  ('checkin.day1', '2'), ('checkin.day2', '2'), ('checkin.day3', '3'), ('checkin.day4', '3'),
  ('checkin.day5', '5'), ('checkin.day6', '5'), ('checkin.day7', '10'),
  ('referral.referrer_coins', '50'), ('referral.referee_coins', '50'), ('referral.max_rewarded', '50')
ON CONFLICT (key) DO NOTHING;
