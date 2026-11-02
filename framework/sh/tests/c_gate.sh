#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

[ -f /usr/include/unistd.h ] || fw_die 4 "ENV_MISSING: musl-dev headers"
[ -f /usr/lib/crt1.o ] || fw_die 4 "ENV_MISSING: musl-dev crt"

mkdir -p build/c

tcc -std=c99 -D_POSIX_C_SOURCE=200809L -I c/include \
  c/src/fw_parse.c tests/unit/fw_parse_spec.c -o build/c/fw_parse_spec
./build/c/fw_parse_spec

tcc -std=c99 -D_POSIX_C_SOURCE=200809L c/tests/stdver.c -o build/c/stdver
stdver=$(./build/c/stdver)
[ "$stdver" = "199901" ] || fw_die 3 "C_STANDARD: expected 199901, got $stdver"

tcc -std=c99 -D_POSIX_C_SOURCE=200809L c/tests/posix_level.c -o build/c/posix_level
./build/c/posix_level

cppcheck --std=c99 --enable=warning,performance,portability --error-exitcode=3 --inline-suppr --suppress=missingIncludeSystem -I c/include c/src tests/unit

astyle --style=kr --indent=spaces=2 --dry-run --error-on-changes --suffix=none \
  --recursive "c/src/*.c" "c/include/*.h" "c/tests/*.c" "tests/unit/*.c"
