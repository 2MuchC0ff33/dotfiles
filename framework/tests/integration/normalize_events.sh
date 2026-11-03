#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

DB=work/integration.db
rm -f "$DB" "$DB-wal" "$DB-shm"

FRAMEWORK_DB="$DB" sh/db_bootstrap.sh
FRAMEWORK_DB="$DB" sh/db_migrate.sh

cp tests/fixtures/events.raw spool/events.raw
sh/stages/normalize_events.sh

sum=$(cksum work/events.normalized.tsv | awk '{print $1 "-" $2}')
sqlite3 -noheader "$DB" \
  "INSERT INTO stage_result(stage,status,checksum,payload) VALUES('normalize_events','ok','$sum','{}');"

count=$(sqlite3 -noheader "$DB" "SELECT COUNT(*) FROM stage_result WHERE stage='normalize_events';")
[ "$count" = 1 ] || fw_die 1 "stage_result row missing"

out=$(sqlite3 -noheader "$DB" < sql/queries/stage_status.sql)
printf '%s\n' "$out" | grep -F -q 'normalize_events|ok|'
