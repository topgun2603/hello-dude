-- Admin panel roles (RBAC). Every staff member (users.role = 'admin') has one
-- role; a role is a list of permission codes (services/api/src/auth/permissions.ts).
-- The built-in "admin" role always has every permission (checked in code), so new
-- permissions never lock the owner out. Custom roles can be added from the panel.

CREATE TABLE admin_roles (
  code        text PRIMARY KEY CHECK (code ~ '^[a-z][a-z0-9_]{1,31}$'),
  name        text NOT NULL CHECK (length(name) BETWEEN 2 AND 40),
  description text NOT NULL DEFAULT '' CHECK (length(description) <= 200),
  permissions text[] NOT NULL DEFAULT '{}',
  is_system   boolean NOT NULL DEFAULT false,   -- built-in: can't be renamed or deleted
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

INSERT INTO admin_roles (code, name, description, permissions, is_system) VALUES
  ('admin', 'Admin', 'Everything, including staff and roles.', '{}', true),
  ('moderator', 'Moderator', 'Keeps the community safe: KYC, reports, video frames, live rooms.',
   ARRAY['dashboard.view', 'users.view', 'users.manage', 'kyc.review', 'companions.video',
         'reports.review', 'moderation.review', 'rooms.manage'], true),
  ('finance', 'Finance', 'Money: payouts, refunds, coins and prices.',
   ARRAY['dashboard.view', 'users.view', 'users.coins', 'payouts.view', 'payouts.decide',
         'refunds.review', 'pricing.manage', 'audit.view'], true);

ALTER TABLE users ADD COLUMN admin_role text REFERENCES admin_roles(code);

-- Staff get a role; everyone else has none. A new or promoted admin with no role
-- given (the make-admin script: the owner) gets the full "admin" role.
CREATE FUNCTION users_admin_role() RETURNS trigger AS $$
BEGIN
  IF NEW.role = 'admin' AND NEW.admin_role IS NULL THEN
    NEW.admin_role := 'admin';
  ELSIF NEW.role <> 'admin' THEN
    NEW.admin_role := NULL;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER users_admin_role BEFORE INSERT OR UPDATE OF role, admin_role ON users
  FOR EACH ROW EXECUTE FUNCTION users_admin_role();

UPDATE users SET admin_role = 'admin' WHERE role = 'admin';
