#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

DB=$(fw_config_db)
[ -n "$DB" ] || DB=srv/framework.db
fw_require_file "$DB"

for f in sql/migrations/*.sql; do
  [ -f "$f" ] || continue
  version=$(basename "$f")
  checksum=$(cksum "$f" | awk '{print $1 "-" $2}')
  applied=$(sqlite3 -noheader "$DB" "SELECT checksum FROM schema_migration WHERE version='$version';")
  if [ "$applied" = "$checksum" ]; then
    continue
  fi
  sqlite3 -noheader "$DB" ".read $f"
  sqlite3 -noheader "$DB" \
    "INSERT OR REPLACE INTO schema_migration(version, checksum, applied_at) VALUES('$version', '$checksum', datetime('now'));"
done

printf 'OK migrations db=%s\n' "$DB"
