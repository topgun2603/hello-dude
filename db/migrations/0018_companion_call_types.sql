-- Companions choose which calls they take: voice, video or both. Video still needs
-- to be unlocked (video_enabled: KYC + academy + clean record); takes_video is the
-- companion's own switch on top of that.
ALTER TABLE companion_profiles
  ADD COLUMN takes_audio boolean NOT NULL DEFAULT true,
  ADD COLUMN takes_video boolean NOT NULL DEFAULT true,
  ADD CONSTRAINT companion_takes_some_calls CHECK (takes_audio OR takes_video);
