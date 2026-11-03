#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

mkdir -p work/man
rm -f work/man/lint.txt work/man/framework.1.txt

set +e
mandoc -T lint man/framework.1 > work/man/lint.txt 2>&1
rc=$?
set -e

cat work/man/lint.txt
[ "$rc" -eq 0 ] || fw_die 3 "MAN: mandoc -T lint failed"

mandoc -T ascii man/framework.1 > work/man/framework.1.txt
[ -s work/man/framework.1.txt ] || fw_die 3 "MAN: empty render"

lua5.4 tests/run.lua tests/unit/manlint_spec.lua
