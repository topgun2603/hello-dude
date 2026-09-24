-- VIP subscription (design: Vip.dc.html; CLAUDE.md "v2 rules").
-- Bought through Google Play once Play Billing is live; admins can grant it now.

CREATE TABLE vip_plans (
  id            serial PRIMARY KEY,
  play_sku      text NOT NULL UNIQUE,              -- Play subscription product id
  months        smallint NOT NULL CHECK (months > 0),
  price_paise   int NOT NULL CHECK (price_paise > 0),
  label         text,                              -- e.g. "Best value"
  is_active     boolean NOT NULL DEFAULT true,
  sort_order    int NOT NULL DEFAULT 0
);
INSERT INTO vip_plans (play_sku, months, price_paise, label, sort_order) VALUES
  ('vip_monthly', 1, 29900, NULL, 1),
  ('vip_quarterly', 3, 69900, 'Best value', 2);

CREATE TABLE vip_subscriptions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid NOT NULL REFERENCES users(id),
  plan_id        int REFERENCES vip_plans(id),
  source         text NOT NULL CHECK (source IN ('play', 'admin')),
  purchase_token text UNIQUE,                      -- Play purchase token (source = play)
  starts_at      timestamptz NOT NULL DEFAULT now(),
  expires_at     timestamptz NOT NULL,
  cancelled_at   timestamptz,
  granted_by     uuid REFERENCES users(id),
  note           text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  CHECK (expires_at > starts_at)
);
CREATE INDEX vip_subscriptions_user ON vip_subscriptions (user_id, expires_at DESC);

-- The weekly free gift (one per IST week while VIP). Used = spent on a call gift.
CREATE TABLE vip_gift_credits (
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  week_start  date NOT NULL,
  gift_id     int NOT NULL REFERENCES gifts(id),
  used_at     timestamptz,
  call_gift_id uuid REFERENCES call_gifts(id),
  PRIMARY KEY (user_id, week_start)
);

INSERT INTO app_settings (key, value) VALUES
  ('vip.discount_pct', '10')
ON CONFLICT (key) DO NOTHING;
