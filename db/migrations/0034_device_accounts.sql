-- Fraud check "one phone with many accounts" (CLAUDE.md): which accounts have signed in on which
-- phone. device_hash = SHA-256 of Android's ANDROID_ID (the raw id is never stored). Unlike
-- devices (push tokens), rows stay when the phone signs into another account.
CREATE TABLE device_accounts (
  device_hash text NOT NULL,
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  first_seen  timestamptz NOT NULL DEFAULT now(),
  last_seen   timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (device_hash, user_id)
);
CREATE INDEX device_accounts_user ON device_accounts (user_id);

-- A withdrawal is flagged "shared_device" when one of the companion's phones has been used by
-- at least this many accounts (hers included).
INSERT INTO app_settings (key, value) VALUES ('fraud.device_max_accounts', '3') ON CONFLICT (key) DO NOTHING;
