PRAGMA journal_mode=WAL;

CREATE TABLE IF NOT EXISTS schema_migration (
  version TEXT PRIMARY KEY,
  checksum TEXT NOT NULL,
  applied_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS stage_result (
  id INTEGER PRIMARY KEY,
  stage TEXT NOT NULL,
  status TEXT NOT NULL,
  checksum TEXT,
  payload TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS artifact (
  path TEXT PRIMARY KEY,
  checksum TEXT NOT NULL,
  schema_version TEXT NOT NULL
);
