#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

final=work/events.normalized.tsv
tmp=$final.tmp
result=work/normalize_events.result.json

mkdir -p work
rm -f "$final" "$final.cksum" "$tmp" "$result"

cleanup() {
  status=$?
  if [ "$status" -ne 0 ]; then
    rm -f "$tmp" "$final" "$final.cksum"
    printf '{"stage":"normalize_events","status":"error","code":%d}\n' "$status" > "$result"
  fi
}
trap cleanup 0
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

awk -f awk/normalize_events.awk spool/events.raw > "$tmp"

lua5.4 -e 'require("lib.stages.normalize_events").main("work/events.normalized.tsv.tmp")'

mv "$tmp" "$final"
cksum "$final" > "$final.cksum"
printf '{"stage":"normalize_events","status":"ok"}\n' > "$result"
