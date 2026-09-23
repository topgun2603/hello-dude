-- Every admin action (price change, suspension, report decision, ...) is
-- recorded here. Append-only, like the ledger.
CREATE TABLE audit_log (
  id          bigserial PRIMARY KEY,
  actor_id    uuid NOT NULL REFERENCES users(id),
  action      text NOT NULL,               -- 'rate.create', 'package.update', 'user.status', 'report.resolve'
  target_type text NOT NULL,               -- 'call_rate', 'coin_package', 'user', 'report'
  target_id   text NOT NULL,
  details     jsonb NOT NULL DEFAULT '{}', -- before/after values, reason
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX audit_log_time ON audit_log (created_at DESC);
CREATE INDEX audit_log_target ON audit_log (target_type, target_id);

CREATE FUNCTION audit_log_no_mutation() RETURNS trigger AS $$
BEGIN RAISE EXCEPTION 'audit_log is append-only'; END; $$ LANGUAGE plpgsql;
CREATE TRIGGER audit_log_immutable BEFORE UPDATE OR DELETE ON audit_log
  FOR EACH ROW EXECUTE FUNCTION audit_log_no_mutation();

-- Report decisions.
ALTER TABLE reports ADD COLUMN resolution_note text;
ALTER TABLE reports ADD COLUMN resolved_at timestamptz;
