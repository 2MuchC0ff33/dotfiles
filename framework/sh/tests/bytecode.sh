#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

[ -d build/bytecode ] || fw_die 4 "ENV_MISSING: build/bytecode"

src_count=$(find lib -type f -name '*.lua' | wc -l)
out_count=$(find build/bytecode -type f -name '*.luac' | wc -l)
if [ "$src_count" -ne "$out_count" ]; then
  printf 'BYTECODE: expected %s files, found %s\n' "$src_count" "$out_count" >&2
  exit 3
fi

for f in $(find build/bytecode -type f -name '*.luac' | sort); do
  header=$(od -An -tx1 -N5 "$f" | tr -d ' \n')
  if [ "$header" != "1b4c756154" ]; then
    printf 'BYTECODE: bad header for %s: %s\n' "$f" "$header" >&2
    exit 3
  fi
done

LUA_PATH="$ROOT/build/bytecode/?.luac;;" lua5.4 -e 'assert(type(require("lib.stages.normalize_events")) == "table")'
