#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

. sh/lib/common.sh
LUAC=$(fw_config_get LUAC_BIN etc/framework.conf)
[ -n "$LUAC" ] || LUAC=luac5.4

mkdir -p build/bytecode
find lib -type f -name '*.lua' -exec sh -c '
  set -eu
  luac=$1
  shift
  for src do
    out="build/bytecode/${src%.lua}.luac"
    mkdir -p "$(dirname "$out")"
    "$luac" -s -o "$out" "$src"
  done
' sh "$LUAC" {} +
