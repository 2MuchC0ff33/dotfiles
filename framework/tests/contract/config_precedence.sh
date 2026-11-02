#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

local_conf=etc/framework.local.conf
rm -f "$local_conf"
trap 'rm -f "$local_conf"' 0 HUP INT TERM

unset FRAMEWORK_DB DB_PATH 2>/dev/null || true

db=$(fw_config_db)
[ "$db" = "srv/framework.db" ] || fw_die 1 "default: got $db"

db=$(DB_PATH=work/env.db fw_config_db)
[ "$db" = "work/env.db" ] || fw_die 1 "DB_PATH: got $db"

db=$(FRAMEWORK_DB=work/fw.db DB_PATH=work/env.db fw_config_db)
[ "$db" = "work/fw.db" ] || fw_die 1 "FRAMEWORK_DB: got $db"

printf 'DB_PATH=work/local.db\n' > "$local_conf"
db=$(fw_config_db)
[ "$db" = "work/local.db" ] || fw_die 1 "local conf: got $db"
