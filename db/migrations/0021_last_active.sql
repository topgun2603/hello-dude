-- When each person last had the app open (live connection), for admin "last seen".
-- Whether they have it open right now is disposable Redis state (presence.ts).
ALTER TABLE users ADD COLUMN last_active_at timestamptz;
