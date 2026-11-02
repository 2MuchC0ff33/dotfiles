#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

mkdir -p work/luals-log work/luals-meta
rm -f work/luals.json

set +e
lua-language-server \
  --check="$ROOT" \
  --checklevel=Warning \
  --check_format=json \
  --check_out_path="$ROOT/work/luals.json" \
  --logpath="$ROOT/work/luals-log" \
  --metapath="$ROOT/work/luals-meta" \
  > work/luals.stdout 2>&1
rc=$?
set -e

if [ "$rc" -ne 0 ]; then
  printf 'LSP: diagnostics found (rc=%s)\n' "$rc" >&2
  cat work/luals.stdout >&2
  exit 3
fi

if [ ! -f work/luals.json ]; then
  printf 'LSP: missing diagnostics file\n' >&2
  exit 3
fi

if grep -E -q '"code"[[:space:]]*:' work/luals.json; then
  printf 'LSP: non-empty diagnostics\n' >&2
  cat work/luals.json >&2
  exit 3
fi

exit 0
