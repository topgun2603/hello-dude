-- App-open offers popup (admin "Offers popup" page): a bottom sheet with confetti
-- that the app shows when it opens. The highest-priority live promotion a user is
-- eligible for wins; how often it shows is enforced from promotion_views.

CREATE TABLE promotions (
  id          serial PRIMARY KEY,
  title       text NOT NULL CHECK (length(title) BETWEEN 3 AND 60),
  body        text NOT NULL DEFAULT '' CHECK (length(body) <= 200),
  highlight   text CHECK (length(highlight) <= 24),   -- the big line, e.g. "2× coins"
  badge       text CHECK (length(badge) <= 24),       -- small pill, e.g. "Today only"
  emoji       text CHECK (length(emoji) <= 8),
  cta_label   text NOT NULL CHECK (length(cta_label) BETWEEN 2 AND 24),
  -- Where the button goes inside the app. Never an external link (Play payments policy).
  cta_action  text NOT NULL CHECK (cta_action IN ('wallet', 'vip', 'checkin', 'referral', 'online', 'rooms', 'rewards', 'none')),
  theme       text NOT NULL DEFAULT 'brand' CHECK (theme IN ('brand', 'gold', 'green')),
  audience    text NOT NULL DEFAULT 'callers'
              CHECK (audience IN ('all', 'callers', 'companions', 'never_paid', 'paid')),
  frequency   text NOT NULL DEFAULT 'every_open' CHECK (frequency IN ('every_open', 'daily', 'once')),
  confetti    boolean NOT NULL DEFAULT true,
  priority    int NOT NULL DEFAULT 0,
  is_active   boolean NOT NULL DEFAULT true,
  starts_at   timestamptz NOT NULL DEFAULT now(),
  ends_at     timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  CHECK (ends_at IS NULL OR ends_at > starts_at)
);
CREATE INDEX promotions_live ON promotions (priority DESC, id DESC) WHERE is_active;

-- One row each time the sheet is shown or its button is tapped.
CREATE TABLE promotion_views (
  id           bigserial PRIMARY KEY,
  promotion_id int NOT NULL REFERENCES promotions(id) ON DELETE CASCADE,
  user_id      uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  action       text NOT NULL CHECK (action IN ('shown', 'clicked')),
  at           timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX promotion_views_user ON promotion_views (user_id, promotion_id, at DESC);
CREATE INDEX promotion_views_stats ON promotion_views (promotion_id, action, at);
