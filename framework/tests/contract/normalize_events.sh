#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

mkdir -p work spool

reset() {
  rm -f work/events.normalized.tsv \
    work/events.normalized.tsv.cksum \
    work/events.normalized.tsv.tmp \
    work/normalize_events.result.json
}

reset
cp tests/fixtures/events.raw spool/events.raw
sh/stages/normalize_events.sh
cmp work/events.normalized.tsv tests/fixtures/events.expected.tsv
grep -F -q '"status":"ok"' work/normalize_events.result.json
expected=$(cksum work/events.normalized.tsv)
actual=$(cat work/events.normalized.tsv.cksum)
[ "$expected" = "$actual" ] || fw_die 1 "checksum sidecar mismatch"

reset
cp tests/fixtures/events.bad.raw spool/events.raw
set +e
sh/stages/normalize_events.sh > work/contract.bad.stdout 2> work/contract.bad.stderr
rc=$?
set -e
[ "$rc" -eq 3 ] || fw_die 1 "bad field count: expected 3, got $rc"
[ ! -f work/events.normalized.tsv ] || fw_die 1 "final artifact survived failure"
[ ! -f work/events.normalized.tsv.tmp ] || fw_die 1 "temp artifact survived failure"
grep -F -q '"code":3' work/normalize_events.result.json
grep -F -q 'INPUT_INVALID' work/contract.bad.stderr

reset
cp tests/fixtures/events.bad_timestamp.raw spool/events.raw
set +e
sh/stages/normalize_events.sh > work/contract.ts.stdout 2> work/contract.ts.stderr
rc=$?
set -e
[ "$rc" -eq 3 ] || fw_die 1 "bad timestamp: expected 3, got $rc"
[ ! -f work/events.normalized.tsv ] || fw_die 1 "final artifact survived timestamp failure"
grep -F -q 'integer timestamp' work/contract.ts.stderr
