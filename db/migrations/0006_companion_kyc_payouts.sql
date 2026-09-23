-- Companion onboarding: in-house offline KYC (Aadhaar offline e-KYC + selfie + PAN).
-- Never store the full Aadhaar number: the offline XML only carries the last 4 digits.
ALTER TABLE companion_profiles
  ADD COLUMN applied_at        timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN kyc_submitted_at  timestamptz,
  ADD COLUMN kyc_reviewed_by   uuid REFERENCES users(id),
  ADD COLUMN kyc_reject_reason text,
  ADD COLUMN aadhaar_last4     text CHECK (aadhaar_last4 ~ '^\d{4}$'),
  ADD COLUMN aadhaar_name      text,
  ADD COLUMN aadhaar_dob       date,
  ADD COLUMN aadhaar_gender    text,
  ADD COLUMN aadhaar_generated_at timestamptz,
  ADD COLUMN selfie_blinks     smallint,
  ADD COLUMN pan_last4         text,
  ADD COLUMN pan_encrypted     bytea,          -- AES-256-GCM, needed for TDS filing
  ADD COLUMN upi_updated_at    timestamptz;

-- The kit's kyc_documents table: one row per uploaded file (encrypted object in private storage).
CREATE UNIQUE INDEX kyc_documents_user_type ON kyc_documents (user_id, doc_type);
CREATE INDEX companion_kyc_queue ON companion_profiles (kyc_submitted_at) WHERE kyc_status = 'pending' AND kyc_submitted_at IS NOT NULL;

-- Payouts: risk flags computed at request time, and who approved.
ALTER TABLE payouts
  ADD COLUMN flags        text[] NOT NULL DEFAULT '{}',
  ADD COLUMN approved_by  uuid REFERENCES users(id),
  ADD COLUMN approved_at  timestamptz;
CREATE INDEX payouts_status ON payouts (status, created_at DESC);
-- One open withdrawal at a time per companion.
CREATE UNIQUE INDEX payouts_one_open ON payouts (companion_id) WHERE status IN ('requested', 'processing');

-- Operational settings the admin can change later. PLACEHOLDER values.
CREATE TABLE app_settings (
  key        text PRIMARY KEY,
  value      jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);
INSERT INTO app_settings (key, value) VALUES
  ('payout.tds_bps', '100'),           -- 1% TDS (basis points)
  ('payout.min_paise', '10000'),       -- ₹100 minimum withdrawal
  ('kyc.aadhaar_max_age_hours', '72');  -- offline e-KYC ZIP must be downloaded within 3 days
