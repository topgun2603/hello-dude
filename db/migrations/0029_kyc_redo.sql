-- KYC rejections name what to redo (owner report 2026-09-24: after a PAN rejection the
-- companion re-uploaded the PAN but nothing went back to review). The admin ticks the items
-- to redo; only those reset, and once every one is re-uploaded the case goes back to the
-- review queue by itself.
ALTER TABLE companion_profiles
  ADD COLUMN kyc_redo text[] NOT NULL DEFAULT '{}'
    CHECK (kyc_redo <@ ARRAY['age', 'selfie', 'voice', 'pan', 'upi']::text[]);

-- Voice-intro sentences are now in the companion's language: unrecorded English ones are
-- dropped so the next visit gets one in her language.
UPDATE companion_profiles SET voice_sentence = NULL WHERE voice_submitted_at IS NULL AND voice_sentence IS NOT NULL;
