-- Refresh-token sessions. Only a SHA-256 of the token is stored. Tokens rotate
-- on every refresh; presenting an already-rotated token revokes the whole
-- family (someone copied it).
CREATE TABLE sessions (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash   bytea NOT NULL UNIQUE,
  family_id    uuid NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now(),
  expires_at   timestamptz NOT NULL,
  revoked_at   timestamptz
);
CREATE INDEX sessions_user ON sessions (user_id) WHERE revoked_at IS NULL;
CREATE INDEX sessions_family ON sessions (family_id);

-- FCM registration tokens, one row per installed app.
CREATE TABLE devices (
  fcm_token  text PRIMARY KEY,
  user_id    uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  platform   text NOT NULL DEFAULT 'android',
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX devices_user ON devices (user_id);

-- DPDP Act: record when the user confirmed 18+ and accepted the terms.
ALTER TABLE users ADD COLUMN terms_accepted_at timestamptz;

