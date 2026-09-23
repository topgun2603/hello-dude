-- =====================================================================
-- Companion calling app (Hima-style) — core schema, PostgreSQL 15+
-- Units: coins wallet = coins (integer), earnings wallet = paise (integer).
-- Never use floats for money.
-- =====================================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE user_role       AS ENUM ('caller', 'companion', 'admin');
CREATE TYPE gender          AS ENUM ('male', 'female', 'other');
CREATE TYPE account_status  AS ENUM ('active', 'suspended', 'banned', 'deleted');
CREATE TYPE kyc_status      AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE call_type       AS ENUM ('audio', 'video');
CREATE TYPE call_status     AS ENUM ('ringing', 'active', 'ended', 'missed', 'rejected', 'failed');
CREATE TYPE wallet_kind     AS ENUM ('coins', 'earnings');
CREATE TYPE ledger_type     AS ENUM ('purchase', 'call_debit', 'call_credit', 'refund', 'refund_reversal',
                                     'bonus', 'payout', 'payout_reversal', 'adjustment');
CREATE TYPE purchase_status AS ENUM ('pending', 'credited', 'refunded', 'failed');
CREATE TYPE payout_status   AS ENUM ('requested', 'processing', 'paid', 'failed', 'rejected');

-- ---------------------------------------------------------------------
-- Users & languages
-- ---------------------------------------------------------------------
CREATE TABLE languages (
  code       text PRIMARY KEY,              -- 'ta', 'te', 'kn', 'hi' ...
  name       text NOT NULL,
  is_active  boolean NOT NULL DEFAULT true
);

CREATE TABLE users (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  phone            text NOT NULL UNIQUE,     -- E.164, OTP-verified
  gender           gender NOT NULL,
  role             user_role NOT NULL DEFAULT 'caller',
  display_name     text NOT NULL,
  avatar_id        smallint NOT NULL DEFAULT 1,   -- avatar-based privacy, no photos
  primary_language text NOT NULL REFERENCES languages(code),
  status           account_status NOT NULL DEFAULT 'active',
  created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE user_languages (
  user_id       uuid REFERENCES users(id) ON DELETE CASCADE,
  language_code text REFERENCES languages(code),
  PRIMARY KEY (user_id, language_code)
);

CREATE TABLE companion_profiles (
  user_id            uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  kyc_status         kyc_status NOT NULL DEFAULT 'pending',
  kyc_verified_at    timestamptz,
  video_enabled      boolean NOT NULL DEFAULT false,
  bio                text,
  rating_sum         int NOT NULL DEFAULT 0,
  rating_count       int NOT NULL DEFAULT 0,
  total_call_seconds bigint NOT NULL DEFAULT 0,
  upi_id             text,
  created_at         timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE kyc_documents (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES users(id),
  doc_type    text NOT NULL,                -- 'aadhaar_offline', 'pan', 'selfie'
  storage_key text NOT NULL,                -- private bucket path; never public
  provider_ref text,                        -- id from KYC vendor
  status      kyc_status NOT NULL DEFAULT 'pending',
  reviewed_by uuid REFERENCES users(id),
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- Pricing (admin-controlled, versioned so old calls keep old rates)
-- ---------------------------------------------------------------------
CREATE TABLE call_rates (
  id                      serial PRIMARY KEY,
  language_code           text NOT NULL REFERENCES languages(code),
  call_type               call_type NOT NULL,
  coins_per_min           int NOT NULL CHECK (coins_per_min > 0),
  companion_paise_per_min int NOT NULL CHECK (companion_paise_per_min >= 0),
  effective_from          timestamptz NOT NULL DEFAULT now(),
  UNIQUE (language_code, call_type, effective_from)
);

CREATE TABLE coin_packages (
  id             serial PRIMARY KEY,
  play_sku       text NOT NULL UNIQUE,      -- Google Play product id
  coins          int NOT NULL CHECK (coins > 0),
  bonus_coins    int NOT NULL DEFAULT 0,
  price_paise    int NOT NULL,
  is_active      boolean NOT NULL DEFAULT true
);

-- ---------------------------------------------------------------------
-- Wallets & append-only ledger
-- ---------------------------------------------------------------------
CREATE TABLE wallets (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES users(id),
  kind       wallet_kind NOT NULL,
  balance    bigint NOT NULL DEFAULT 0 CHECK (balance >= 0),   -- DB refuses negatives
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, kind)
);

CREATE TABLE ledger_entries (
  id              bigserial PRIMARY KEY,
  wallet_id       uuid NOT NULL REFERENCES wallets(id),
  type            ledger_type NOT NULL,
  amount          bigint NOT NULL CHECK (amount <> 0),   -- signed: -debit / +credit
  balance_after   bigint NOT NULL,
  call_id         uuid,
  purchase_id     uuid,
  payout_id       uuid,
  idempotency_key text NOT NULL UNIQUE,                  -- retries can never double-post
  note            text,
  created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ledger_wallet_time ON ledger_entries (wallet_id, created_at DESC);
CREATE INDEX ledger_call        ON ledger_entries (call_id) WHERE call_id IS NOT NULL;

-- Ledger is append-only: corrections are new 'adjustment' rows, never edits.
CREATE FUNCTION ledger_no_mutation() RETURNS trigger AS $$
BEGIN RAISE EXCEPTION 'ledger_entries is append-only'; END; $$ LANGUAGE plpgsql;
CREATE TRIGGER ledger_immutable BEFORE UPDATE OR DELETE ON ledger_entries
  FOR EACH ROW EXECUTE FUNCTION ledger_no_mutation();

CREATE TABLE purchases (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid NOT NULL REFERENCES users(id),
  package_id     int NOT NULL REFERENCES coin_packages(id),
  play_order_id  text UNIQUE,
  purchase_token text NOT NULL UNIQUE,      -- verified server-side with Play Developer API
  coins_credited int NOT NULL DEFAULT 0,
  status         purchase_status NOT NULL DEFAULT 'pending',
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- Calls & per-minute billing audit trail
-- ---------------------------------------------------------------------
CREATE TABLE calls (
  id                     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  caller_id              uuid NOT NULL REFERENCES users(id),
  companion_id           uuid NOT NULL REFERENCES users(id),
  type                   call_type NOT NULL,
  language_code          text NOT NULL REFERENCES languages(code),
  rate_id                int NOT NULL REFERENCES call_rates(id),   -- rate frozen at call start
  coins_per_min          int NOT NULL,
  companion_paise_per_min int NOT NULL,
  room_name              text NOT NULL UNIQUE,                     -- LiveKit room
  status                 call_status NOT NULL DEFAULT 'ringing',
  created_at             timestamptz NOT NULL DEFAULT now(),
  started_at             timestamptz,       -- both participants joined
  ended_at               timestamptz,
  end_reason             text,              -- caller_hangup, companion_hangup, balance, network, timeout, admin
  minutes_charged        int NOT NULL DEFAULT 0,
  coins_charged          bigint NOT NULL DEFAULT 0,
  paise_credited         bigint NOT NULL DEFAULT 0,
  CHECK (caller_id <> companion_id)
);
CREATE INDEX calls_caller    ON calls (caller_id, created_at DESC);
CREATE INDEX calls_companion ON calls (companion_id, created_at DESC);
CREATE INDEX calls_open      ON calls (status) WHERE status IN ('ringing', 'active');

-- One row per billed minute. This is what the user sees in "call details",
-- so every coin deducted maps to a call + minute number.
CREATE TABLE call_ticks (
  call_id        uuid NOT NULL REFERENCES calls(id),
  minute_no      int NOT NULL CHECK (minute_no >= 1),
  coins_charged  int NOT NULL,
  paise_credited int NOT NULL,
  charged_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (call_id, minute_no)          -- a minute can only be billed once
);

CREATE TABLE call_ratings (
  call_id    uuid PRIMARY KEY REFERENCES calls(id),
  rater_id   uuid NOT NULL REFERENCES users(id),
  stars      smallint NOT NULL CHECK (stars BETWEEN 1 AND 5),
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- Payouts (companions withdraw earnings)
-- ---------------------------------------------------------------------
CREATE TABLE payouts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  companion_id  uuid NOT NULL REFERENCES users(id),
  gross_paise   bigint NOT NULL CHECK (gross_paise > 0),
  tds_paise     bigint NOT NULL DEFAULT 0,
  net_paise     bigint NOT NULL,
  upi_id        text NOT NULL,
  provider_ref  text,                       -- RazorpayX / Cashfree payout id
  status        payout_status NOT NULL DEFAULT 'requested',
  failure_reason text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  processed_at  timestamptz
);

-- ---------------------------------------------------------------------
-- Safety
-- ---------------------------------------------------------------------
CREATE TABLE blocks (
  blocker_id uuid REFERENCES users(id),
  blocked_id uuid REFERENCES users(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (blocker_id, blocked_id)
);

CREATE TABLE reports (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id uuid NOT NULL REFERENCES users(id),
  reported_id uuid NOT NULL REFERENCES users(id),
  call_id     uuid REFERENCES calls(id),
  reason      text NOT NULL,                -- abuse, sexual_content, spam, underage, fraud
  details     text,
  status      text NOT NULL DEFAULT 'open', -- open, actioned, dismissed
  handled_by  uuid REFERENCES users(id),
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX reports_open ON reports (created_at) WHERE status = 'open';
