-- Data retention (Privacy Policy §4) and video moderation.

-- When an admin last decided on a companion's KYC. Rejected applicants' files
-- are deleted 90 days after this.
ALTER TABLE companion_profiles ADD COLUMN kyc_reviewed_at timestamptz;
UPDATE companion_profiles SET kyc_reviewed_at = kyc_verified_at WHERE kyc_status = 'approved';

-- One still frame the app flagged as nudity during a video call. The frame is
-- encrypted in private storage and deleted 30 days after review.
CREATE TABLE moderation_flags (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  call_id         uuid NOT NULL REFERENCES calls(id),
  subject_id      uuid NOT NULL REFERENCES users(id),  -- whose video was flagged
  detected_by     uuid NOT NULL REFERENCES users(id),  -- whose phone flagged it
  score           real NOT NULL CHECK (score BETWEEN 0 AND 1),
  storage_key     text,                                -- NULL once the frame is deleted
  status          text NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'dismissed', 'actioned')),
  reviewed_by     uuid REFERENCES users(id),
  reviewed_at     timestamptz,
  note            text,
  frame_deleted_at timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  CHECK (subject_id <> detected_by)
);
CREATE INDEX moderation_flags_open ON moderation_flags (created_at) WHERE status = 'open';
CREATE INDEX moderation_flags_subject ON moderation_flags (subject_id, created_at DESC);
