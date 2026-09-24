-- Lives are billed per minute like 1:1 calls (owner, 2026-09-24): after the free
-- preview a viewer opts in ("Keep watching · N coins/min") and is charged at the
-- start of every minute they're in the LiveKit room, checked by the server. Time
-- passes are no longer sold (live_passes stays for history).

ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'live_debit';
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'live_credit';

-- Which live a ledger row belongs to (for "Live with Priya · 12 min" in coin history).
ALTER TABLE ledger_entries ADD COLUMN live_id uuid REFERENCES lives(id);
CREATE INDEX ledger_entries_live ON ledger_entries (live_id) WHERE live_id IS NOT NULL;

ALTER TABLE live_viewers
  ADD COLUMN paying boolean NOT NULL DEFAULT false,      -- opted in after the preview
  ADD COLUMN minutes_charged int NOT NULL DEFAULT 0,
  ADD COLUMN last_charged_at timestamptz,
  ADD COLUMN low_balance_sent_at timestamptz;

-- One row per charged minute; the primary key makes a double charge impossible.
CREATE TABLE live_ticks (
  live_id    uuid NOT NULL REFERENCES lives(id),
  viewer_id  uuid NOT NULL REFERENCES users(id),
  minute_no  int NOT NULL CHECK (minute_no >= 1),
  coins      int NOT NULL CHECK (coins > 0),
  paise      int NOT NULL CHECK (paise >= 0),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (live_id, viewer_id, minute_no)
);
CREATE INDEX live_ticks_created ON live_ticks (created_at);

-- Empty-live auto end: when the live last had nobody watching.
ALTER TABLE lives
  ADD COLUMN empty_since timestamptz,
  ADD COLUMN empty_warned_at timestamptz,
  ADD COLUMN limit_warned_at timestamptz;

-- Placeholder rules (admin-editable). The companion share stays at 25% of
-- coin.value_paise, which is already the net value per coin (the 75% margin target).
DELETE FROM app_settings WHERE key IN ('live.pass15_coins', 'live.pass60_coins');
INSERT INTO app_settings (key, value) VALUES
  ('live.coins_per_min', '3'),
  ('live.empty_end_minutes', '10'),
  ('live.max_minutes', '180'),
  ('live.max_per_day', '4'),
  ('live.previews_per_day', '20'),
  ('analytics.livekit_paise_per_viewer_minute', '9')
ON CONFLICT (key) DO NOTHING;
