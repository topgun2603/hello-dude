-- Companion profile photos (owner, 2026-09-24). A companion may upload their own photo; it
-- shows only after an admin approves it (compared with the KYC selfie). Callers stay
-- avatar-only. The server strips metadata and re-encodes every upload; files live in the
-- encrypted object store and are served only through short-lived signed URLs.

ALTER TABLE users
  ADD COLUMN photo_key           text,      -- approved photo, shown to others
  ADD COLUMN photo_version       int NOT NULL DEFAULT 0,  -- bumps on every change (cache busting)
  ADD COLUMN photo_pending_key   text,      -- waiting for review
  ADD COLUMN photo_status        text NOT NULL DEFAULT 'none'
    CHECK (photo_status IN ('none', 'pending', 'approved', 'rejected')),
  ADD COLUMN photo_reject_reason text,
  ADD COLUMN photo_submitted_at  timestamptz;

CREATE INDEX users_photo_pending ON users (photo_submitted_at) WHERE photo_status = 'pending';

COMMENT ON COLUMN users.avatar_id IS
  'Illustrated avatar (1-3 by gender). Callers are avatar-only; companions may add an admin-approved photo (photo_key), with the avatar as fallback.';
