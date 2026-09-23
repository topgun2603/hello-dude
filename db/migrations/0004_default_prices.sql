-- Starting prices. PLACEHOLDERS chosen by the developer, to be tuned by the
-- owner from the admin pricing screen. Rates are versioned (effective_from),
-- so changing them later never affects calls already in progress.
--
-- 1 coin ≈ ₹0.80 at the popular pack. Voice: 10 coins/min (≈ ₹8), companion
-- earns ₹3/min. Video: 25 coins/min (≈ ₹20), companion earns ₹7/min.
INSERT INTO call_rates (language_code, call_type, coins_per_min, companion_paise_per_min, effective_from)
SELECT code, t.call_type, t.coins, t.paise, '2026-01-01T00:00:00Z'
  FROM languages
 CROSS JOIN (VALUES ('audio'::call_type, 10, 300), ('video'::call_type, 25, 700)) AS t(call_type, coins, paise);

-- Coin packs shown on the Wallet screen. `label` is the badge text.
ALTER TABLE coin_packages ADD COLUMN label text;
ALTER TABLE coin_packages ADD COLUMN sort_order int NOT NULL DEFAULT 0;

INSERT INTO coin_packages (play_sku, coins, bonus_coins, price_paise, label, sort_order) VALUES
  ('coins_50',     50,   0,   4900, NULL,         1),
  ('coins_120',   120,   0,   9900, NULL,         2),
  ('coins_300',   300,   0,  23900, 'Popular',    3),
  ('coins_650',   650,  65,  49900, '+10% bonus', 4),
  ('coins_1400', 1400,   0,  99900, NULL,         5),
  ('coins_3000', 3000,   0, 199900, 'Best value', 6);
