#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

DB=$(fw_config_db)
[ -n "$DB" ] || DB=srv/framework.db
fw_require_file sql/schema/001_init.sql

mkdir -p "$(dirname "$DB")"
sqlite3 -noheader "$DB" ".read sql/schema/001_init.sql"
printf 'OK db=%s\n' "$DB"
