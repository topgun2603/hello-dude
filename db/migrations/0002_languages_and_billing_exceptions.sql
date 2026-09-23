-- Launch languages (Tamil first). Rates are NOT seeded: prices are an open
-- decision for the owner and are set from the admin pricing screen.
INSERT INTO languages (code, name) VALUES
  ('ta', 'Tamil'),
  ('te', 'Telugu'),
  ('kn', 'Kannada'),
  ('ml', 'Malayalam'),
  ('hi', 'Hindi'),
  ('bn', 'Bengali'),
  ('mr', 'Marathi'),
  ('en', 'English')
ON CONFLICT (code) DO NOTHING;

-- Money movements the engine could not complete automatically (for example a
-- grace-period reversal when the companion's earnings were already withdrawn).
-- Finance resolves these by hand with 'adjustment' ledger rows.
CREATE TABLE billing_exceptions (
  id          bigserial PRIMARY KEY,
  call_id     uuid REFERENCES calls(id),
  user_id     uuid REFERENCES users(id),
  kind        text NOT NULL,              -- 'grace_reversal_failed', ...
  amount      bigint NOT NULL,
  resolved_at timestamptz,
  resolved_by uuid REFERENCES users(id),
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX billing_exceptions_open ON billing_exceptions (created_at) WHERE resolved_at IS NULL;
