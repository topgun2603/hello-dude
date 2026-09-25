-- Live tab (owner, 2026-09-24): each live card shows a fresh snapshot from the host's
-- camera. The host's phone uploads one already-safety-checked frame about once a
-- minute; the server re-encodes it. Snapshots are served only while the live is on and
-- deleted by the retention job once it ends.
ALTER TABLE lives
  ADD COLUMN snapshot_key text,
  ADD COLUMN snapshot_at  timestamptz;
