-- Private notes admins keep about a caller or companion (admin panel detail page).
-- Append-only history: each save adds a note; nothing here is shown in the app.
CREATE TABLE admin_notes (
  id         bigserial PRIMARY KEY,
  user_id    uuid NOT NULL REFERENCES users(id),
  author_id  uuid NOT NULL REFERENCES users(id),
  body       text NOT NULL CHECK (length(body) BETWEEN 1 AND 2000),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX admin_notes_user ON admin_notes (user_id, created_at DESC);
