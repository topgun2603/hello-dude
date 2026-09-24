-- Companion levels, online time, and time-window bonuses (design: Rewards.dc.html).

-- Levels by monthly talk hours + minimum rating; higher levels earn a bit more per
-- minute (frozen onto each call at start). Admin-editable.
CREATE TABLE companion_levels (
  level      smallint PRIMARY KEY CHECK (level >= 1),
  name       text NOT NULL,
  min_hours  int NOT NULL CHECK (min_hours >= 0),
  min_rating numeric(2, 1) NOT NULL DEFAULT 0 CHECK (min_rating BETWEEN 0 AND 5),
  boost_pct  smallint NOT NULL DEFAULT 0 CHECK (boost_pct BETWEEN 0 AND 50)
);
INSERT INTO companion_levels (level, name, min_hours, min_rating, boost_pct) VALUES
  (1, 'New voice', 0, 0, 0),
  (2, 'Friendly voice', 15, 4.0, 2),
  (3, 'Rising star', 30, 4.3, 3),
  (4, 'Star', 60, 4.5, 5),
  (5, 'Superstar', 100, 4.7, 8);

-- Minutes online per IST day (one per 60-second heartbeat).
CREATE TABLE companion_online_minutes (
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  day     date NOT NULL,
  minutes int NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, day)
);

-- "Stay online 3 hours between 8 and 11 PM tonight: +₹50".
CREATE TABLE bonus_campaigns (
  id               serial PRIMARY KEY,
  title            text NOT NULL,
  reward_paise     int NOT NULL CHECK (reward_paise > 0),
  required_minutes int NOT NULL CHECK (required_minutes > 0),
  window_start     smallint NOT NULL CHECK (window_start BETWEEN 0 AND 1439),  -- minutes after IST midnight
  window_end       smallint NOT NULL CHECK (window_end BETWEEN 1 AND 1440),
  weekdays         smallint[] NOT NULL DEFAULT '{1,2,3,4,5,6,7}',            -- ISO weekday, 1 = Monday
  starts_on        date NOT NULL DEFAULT CURRENT_DATE,
  ends_on          date,
  is_active        boolean NOT NULL DEFAULT true,
  created_at       timestamptz NOT NULL DEFAULT now(),
  CHECK (window_end > window_start),
  CHECK (required_minutes <= window_end - window_start)
);
INSERT INTO bonus_campaigns (title, reward_paise, required_minutes, window_start, window_end)
VALUES ('Evening bonus', 5000, 180, 1200, 1380);

CREATE TABLE bonus_progress (
  campaign_id int NOT NULL REFERENCES bonus_campaigns(id),
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  day         date NOT NULL,
  minutes     int NOT NULL DEFAULT 0,
  paid_at     timestamptz,
  PRIMARY KEY (campaign_id, user_id, day)
);

INSERT INTO app_settings (key, value) VALUES
  ('companion.daily_goal_paise', '30000'),
  ('companion.streak_min_minutes', '30')
ON CONFLICT (key) DO NOTHING;
