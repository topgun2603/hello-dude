-- Illustrated avatars (owner, 2026-09-24): avatar ids 1-3 are pictures chosen by gender.
--   1 = female, 2 = male, 3 = transgender (gender 'other').
-- There is no avatar picker yet, so every existing account gets the picture for its gender.
-- Other ids (4-50) still render as a coloured letter circle in the apps.
UPDATE users
   SET avatar_id = CASE gender WHEN 'female' THEN 1 WHEN 'male' THEN 2 ELSE 3 END
 WHERE role <> 'admin';
