-- Coin purchases through Razorpay (User Choice Billing, owner 2026-09-23). Play purchases keep
-- purchase_token; Razorpay ones are tracked by order + payment id. Coins are credited only after
-- the server has checked Razorpay's signature AND fetched the payment itself (never on the app's
-- word), once per payment (unique razorpay_payment_id + ledger idempotency key).
ALTER TABLE purchases ALTER COLUMN purchase_token DROP NOT NULL;
ALTER TABLE purchases
  ADD COLUMN provider            text NOT NULL DEFAULT 'play' CHECK (provider IN ('play', 'razorpay')),
  ADD COLUMN amount_paise        int CHECK (amount_paise > 0),
  ADD COLUMN razorpay_order_id   text UNIQUE,
  ADD COLUMN razorpay_payment_id text UNIQUE,
  ADD COLUMN failure_reason      text,
  ADD COLUMN credited_at         timestamptz,
  ADD COLUMN refunded_at         timestamptz,
  -- UCB: every Razorpay sale is reported to Google (Play external transactions API) within 24 h.
  ADD COLUMN play_reported_at    timestamptz;
ALTER TABLE purchases ADD CONSTRAINT purchases_provider_ref CHECK (
  (provider = 'play' AND purchase_token IS NOT NULL) OR
  (provider = 'razorpay' AND razorpay_order_id IS NOT NULL AND amount_paise IS NOT NULL));
CREATE INDEX purchases_user_idx ON purchases (user_id, created_at DESC);

-- Coins taken back when a paid purchase is refunded (as far as the balance allows).
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'purchase_reversal';
