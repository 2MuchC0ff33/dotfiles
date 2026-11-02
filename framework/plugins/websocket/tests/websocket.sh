#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

mkdir -p work

set +e
sh plugins/websocket/websocket.sh ws://example.test work/ws.out > work/ws.stdout 2> work/ws.stderr
rc=$?
set -e
[ "$rc" -eq 3 ] || fw_die 1 "ws:// expected 3, got $rc"
grep -F -q 'only wss://' work/ws.stderr

set +e
sh plugins/websocket/websocket.sh wss://evil.example work/ws.out > work/ws.stdout 2> work/ws.stderr
rc=$?
set -e
[ "$rc" -eq 3 ] || fw_die 1 "non-allowlisted host expected 3, got $rc"
grep -F -q 'not in allowlist' work/ws.stderr

if ! command -v websocat >/dev/null 2>&1; then
  set +e
  sh plugins/websocket/websocket.sh wss://echo.websocket.events work/ws.out > work/ws.stdout 2> work/ws.stderr
  rc=$?
  set -e
  [ "$rc" -eq 4 ] || fw_die 1 "missing websocat expected 4, got $rc"
fi
