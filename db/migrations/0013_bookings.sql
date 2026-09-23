-- Scheduled calls (design: Schedule.dc.html; CLAUDE.md "v2 rules").
-- Coins are held when a caller books. The hold goes back to the wallet when the
-- booking is declined / cancelled / expires, or when the caller starts the booked
-- call — which is then billed per minute like any other call.

ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'booking_hold';
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'booking_release';

CREATE TABLE bookings (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  caller_id        uuid NOT NULL REFERENCES users(id),
  companion_id     uuid NOT NULL REFERENCES users(id),
  call_type        call_type NOT NULL DEFAULT 'audio',
  start_at         timestamptz NOT NULL,
  minutes          smallint NOT NULL CHECK (minutes IN (10, 20, 30)),
  coins_per_min    int NOT NULL CHECK (coins_per_min > 0),
  held_coins       int NOT NULL CHECK (held_coins > 0),
  -- requested → confirmed → started → completed | missed
  -- requested → declined | expired;  requested/confirmed → cancelled
  status           text NOT NULL DEFAULT 'requested'
                   CHECK (status IN ('requested', 'confirmed', 'declined', 'expired', 'cancelled', 'started', 'completed', 'missed')),
  hold_released    boolean NOT NULL DEFAULT false,
  note             text,
  reminder_sent_at timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  decided_at       timestamptz,
  CHECK (caller_id <> companion_id)
);
CREATE INDEX bookings_companion ON bookings (companion_id, start_at) WHERE status IN ('requested', 'confirmed', 'started');
CREATE INDEX bookings_caller ON bookings (caller_id, start_at DESC);

INSERT INTO app_settings (key, value) VALUES
  ('booking.window_days', '5'),
  ('booking.first_slot_minute', '1140'),  -- 19:00 IST
  ('booking.last_slot_minute', '1380'),   -- 23:00 IST (last start)
  ('booking.confirm_hours', '12')
ON CONFLICT (key) DO NOTHING;
