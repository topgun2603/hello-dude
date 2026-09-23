-- Stage 7: gifts, favourites, first-recharge offer, refund requests,
-- report recordings, companion academy, account deletion.

-- ---------------------------------------------------------------------------
-- Ledger types for gifts. (New enum values are usable after this migration commits.)
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'gift_debit';
ALTER TYPE ledger_type ADD VALUE IF NOT EXISTS 'gift_credit';

-- Gifts (Gifts design). PLACEHOLDER prices, editable in admin.
CREATE TABLE gifts (
  id         serial PRIMARY KEY,
  code       text NOT NULL UNIQUE,
  name       text NOT NULL,
  emoji      text NOT NULL,
  coins      int NOT NULL CHECK (coins > 0),
  is_active  boolean NOT NULL DEFAULT true,
  sort_order int NOT NULL DEFAULT 0
);
INSERT INTO gifts (code, name, emoji, coins, sort_order) VALUES
  ('rose', 'Rose', '🌹', 10, 1), ('chai', 'Chai', '☕', 20, 2), ('heart', 'Heart', '❤️', 30, 3),
  ('balloon', 'Balloon', '🎈', 50, 4), ('star', 'Star', '⭐', 100, 5), ('cake', 'Cake', '🎂', 200, 6),
  ('crown', 'Crown', '👑', 500, 7), ('diamond', 'Diamond', '💎', 1000, 8);

CREATE TABLE call_gifts (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  call_id        uuid NOT NULL REFERENCES calls(id),
  sender_id      uuid NOT NULL REFERENCES users(id),
  receiver_id    uuid NOT NULL REFERENCES users(id),
  gift_id        int NOT NULL REFERENCES gifts(id),
  coins          int NOT NULL,
  paise_credited int NOT NULL,
  client_ref     uuid NOT NULL UNIQUE,     -- app-generated; a retried tap can't send twice
  created_at     timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX call_gifts_call ON call_gifts (call_id);

INSERT INTO app_settings (key, value) VALUES
  ('gift.companion_share_bps', '4000'),  -- companion gets 40% of a gift's coin value
  ('coin.value_paise', '80'),            -- 1 coin ≈ ₹0.80 (popular pack), used to value gifts
  ('offer.first_recharge_hours', '24'),
  ('refund.window_days', '7')
ON CONFLICT (key) DO NOTHING;

-- ---------------------------------------------------------------------------
-- Favourites (+ "tell me when they're online").
CREATE TABLE favourites (
  user_id      uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  companion_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  notify       boolean NOT NULL DEFAULT true,
  created_at   timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, companion_id),
  CHECK (user_id <> companion_id)
);
CREATE INDEX favourites_companion ON favourites (companion_id) WHERE notify;
ALTER TABLE companion_profiles ADD COLUMN last_online_at timestamptz;

-- ---------------------------------------------------------------------------
-- First-recharge offer: a pack only new users see (FirstRecharge design).
ALTER TABLE coin_packages ADD COLUMN first_recharge_only boolean NOT NULL DEFAULT false;
INSERT INTO coin_packages (play_sku, coins, bonus_coins, price_paise, label, sort_order, first_recharge_only)
VALUES ('first_recharge_100', 100, 100, 4900, 'Welcome offer', 0, true);

-- ---------------------------------------------------------------------------
-- Refund requests from Call details.
CREATE TYPE refund_status AS ENUM ('requested', 'approved', 'rejected');
CREATE TABLE refund_requests (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  call_id         uuid NOT NULL UNIQUE REFERENCES calls(id),  -- one request per call
  user_id         uuid NOT NULL REFERENCES users(id),
  reason          text NOT NULL,       -- call_dropped, couldnt_hear, wrong_language, other
  details         text,
  coins_eligible  int NOT NULL,        -- charged minus already refunded, at request time
  status          refund_status NOT NULL DEFAULT 'requested',
  coins_refunded  int NOT NULL DEFAULT 0,
  decided_by      uuid REFERENCES users(id),
  decided_at      timestamptz,
  note            text,
  created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX refund_requests_open ON refund_requests (created_at) WHERE status = 'requested';

-- ---------------------------------------------------------------------------
-- Call audio kept for a report; deleted when the report is closed.
CREATE TABLE report_recordings (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id    uuid NOT NULL REFERENCES reports(id),
  call_id      uuid NOT NULL REFERENCES calls(id),
  egress_id    text,
  storage_key  text,
  status       text NOT NULL DEFAULT 'recording',  -- recording, ready, failed, deleted, disabled
  started_at   timestamptz NOT NULL DEFAULT now(),
  deleted_at   timestamptz
);
CREATE INDEX report_recordings_report ON report_recordings (report_id);

-- ---------------------------------------------------------------------------
-- Companion academy (Training design). Video unlock needs all lessons passed.
CREATE TABLE academy_lessons (
  id        serial PRIMARY KEY,
  position  int NOT NULL UNIQUE,
  title     text NOT NULL,
  minutes   int NOT NULL,
  body      text NOT NULL,          -- lesson text (video_url added when videos exist)
  video_url text,
  quiz      jsonb NOT NULL          -- [{ "q": "...", "options": ["..", ".."], "answer": 1 }]
);
CREATE TABLE academy_progress (
  user_id   uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  lesson_id int NOT NULL REFERENCES academy_lessons(id),
  passed_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, lesson_id)
);

INSERT INTO academy_lessons (position, title, minutes, body, quiz) VALUES
(1, 'Welcome and app rules', 4,
 E'You are here to have kind, respectful conversations in your language.\n\n• Be yourself and be warm. Callers come for good company.\n• Calls are private and paid by the minute; the first minute starts only when you both join.\n• Never promise meetings, relationships or anything outside the app.\n• Adult or explicit talk is not allowed on voice or video. Accounts that break this are removed.',
 '[{"q":"When does the caller start paying?","options":["When they tap Call","When you both have joined","After 5 minutes"],"answer":1},
   {"q":"Can you plan to meet a caller in person?","options":["Yes, if they are polite","No, never"],"answer":1},
   {"q":"Is explicit or sexual talk allowed?","options":["No","Only on video","Only if the caller asks"],"answer":0}]'),
(2, 'Your privacy and safety', 5,
 E'Callers see only your first name and avatar. Your number is never shared.\n\n• Do not share your surname, address, workplace, social media or photos.\n• You can end any call at any time — you never owe anyone your time.\n• Report and block anyone who makes you uncomfortable. The safety team reviews every report.',
 '[{"q":"What do callers see about you?","options":["Your phone number","First name and avatar","Your Instagram"],"answer":1},
   {"q":"A caller asks where you live. You…","options":["Tell them your area","Politely change the topic","Send your location"],"answer":1},
   {"q":"Someone makes you uncomfortable. You…","options":["Stay on till the minute ends","End the call and report","Argue with them"],"answer":1}]'),
(3, 'Handling rude callers', 6,
 E'Most callers are kind. When someone is rude:\n\n• Stay calm, do not argue or insult back.\n• Give one clear warning: "Please talk respectfully or I will end the call."\n• If it continues, end the call and tap Report. Blocking stops them from reaching you again.\n• Rude calls never affect your rating unfairly — reports are reviewed by people.',
 '[{"q":"A caller insults you. First you…","options":["Insult them back","Give one calm warning","Stay silent for 10 minutes"],"answer":1},
   {"q":"They keep being rude after the warning. You…","options":["End the call and report","Keep talking for the earnings"],"answer":0},
   {"q":"What does blocking do?","options":["Nothing","They can''t call you again","Deletes their account"],"answer":1}]'),
(4, 'Never share contact details', 3,
 E'For everyone''s safety, all talk and payments stay inside the app.\n\n• Never share or ask for phone numbers, WhatsApp, Instagram or UPI IDs.\n• Never ask a caller for money, recharges or gifts outside the app.\n• Chat and calls are checked for numbers and payment requests; sharing them leads to suspension and lost earnings.',
 '[{"q":"A caller asks for your WhatsApp. You…","options":["Share it","Say you only talk here","Give a friend''s number"],"answer":1},
   {"q":"Can you ask a caller to send money to your UPI?","options":["Yes","No — earn only through the app"],"answer":1},
   {"q":"What happens if you share contact details?","options":["Nothing","Suspension and lost earnings"],"answer":1}]'),
(5, 'Getting great ratings', 5,
 E'Callers rate every call. Good ratings bring more calls.\n\n• Greet warmly and use their name.\n• Listen more than you talk; ask about their day.\n• Find a quiet place with good network.\n• End kindly: thank them for calling.',
 '[{"q":"What helps ratings most?","options":["Listening and being warm","Talking only about yourself","Rushing the call"],"answer":0},
   {"q":"Best place to take calls?","options":["A noisy bus","A quiet place with good network"],"answer":1},
   {"q":"How should you end a call?","options":["Hang up suddenly","Thank them for calling"],"answer":1}]');

-- ---------------------------------------------------------------------------
-- Account deletion (DPDP Act). Money records stay (tax law); personal data goes.
CREATE TABLE account_deletions (
  id            bigserial PRIMARY KEY,
  user_id       uuid NOT NULL REFERENCES users(id),
  role          user_role NOT NULL,
  requested_at  timestamptz NOT NULL DEFAULT now(),
  forfeited_coins bigint NOT NULL DEFAULT 0,
  kept          text[] NOT NULL DEFAULT '{}'    -- what was retained and why
);
