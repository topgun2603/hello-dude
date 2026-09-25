-- Owner, 2026-09-24:
-- 1. Companion verification without Aadhaar: the companion states a date of birth (18+),
--    takes the live selfie and an admin approves. PAN is optional; without a PAN on file,
--    TDS on withdrawals is 20% (payout.tds_no_pan_bps) instead of payout.tds_bps.
--    Existing Aadhaar data stays until retention/deletion removes it.
-- 2. Companion referrals: a caller who signs up with a companion's code earns that
--    companion referral.companion_bonus_paise (earnings) on the caller's first recharge.

ALTER TABLE companion_profiles
  ADD COLUMN birth_date       date,
  ADD COLUMN age_confirmed_at timestamptz;

ALTER TABLE referrals ADD COLUMN referrer_paise int NOT NULL DEFAULT 0;

INSERT INTO app_settings (key, value) VALUES
  ('payout.tds_no_pan_bps', '2000'),
  ('referral.companion_bonus_paise', '2500')
ON CONFLICT (key) DO NOTHING;
DELETE FROM app_settings WHERE key = 'kyc.aadhaar_max_age_hours';
