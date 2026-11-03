#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

mkdir -p work
find tests/unit tests/property -type f -name '*.lua' | sort > work/test-files.txt
if [ -s work/test-files.txt ]; then
  xargs lua5.4 tests/run.lua < work/test-files.txt
fi

for f in tests/contract/*.sh tests/integration/*.sh; do
  [ -f "$f" ] || continue
  sh "$f"
done
