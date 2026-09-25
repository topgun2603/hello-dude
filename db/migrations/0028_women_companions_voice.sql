-- Owner, 2026-09-24:
-- 1. Women (and transgender sign-ups, treated as women) join as companions only, never callers.
--    Men can still be callers or apply to be companions. Existing women callers are converted.
-- 2. Women companions record a short voice intro (a random sentence) during verification; an
--    admin listens to it next to the selfie. The clip is deleted once the admin decides.
-- 3. A joining bonus (companion.joining_bonus_paise, ₹10) goes to their earnings when approved.

ALTER TABLE companion_profiles
  ADD COLUMN voice_sentence        text,
  ADD COLUMN voice_submitted_at    timestamptz,
  ADD COLUMN voice_verified_at     timestamptz,
  ADD COLUMN joining_bonus_paid_at timestamptz;

INSERT INTO app_settings (key, value) VALUES ('companion.joining_bonus_paise', '1000')
ON CONFLICT (key) DO NOTHING;

-- Convert women callers (not mid-call) to companions; they verify from their companion home.
WITH women AS (
  SELECT u.id FROM users u
   WHERE u.role = 'caller' AND u.gender IN ('female', 'other') AND u.status = 'active'
     AND NOT EXISTS (SELECT 1 FROM calls c WHERE c.caller_id = u.id AND c.status IN ('ringing', 'active'))
), converted AS (
  UPDATE users SET role = 'companion' WHERE id IN (SELECT id FROM women) RETURNING id
), profiles AS (
  INSERT INTO companion_profiles (user_id) SELECT id FROM converted ON CONFLICT (user_id) DO NOTHING
)
-- Their old tokens say "caller": sign them out so the app picks up the new role.
UPDATE sessions SET revoked_at = now() WHERE revoked_at IS NULL AND user_id IN (SELECT id FROM converted);
