#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

fw_require_file work/checksums.cksum

fail=0
while IFS=' ' read -r crc size path; do
  [ -n "$crc" ] || continue
  actual=$(cksum "$path" 2>/dev/null) || {
    printf 'CHECKSUM: cannot read %s\n' "$path" >&2
    fail=1
    continue
  }
  expected="$crc $size $path"
  if [ "$actual" != "$expected" ]; then
    printf 'CHECKSUM: mismatch for %s\n' "$path" >&2
    printf '  expected: %s\n' "$expected" >&2
    printf '  actual:   %s\n' "$actual" >&2
    fail=1
  fi
done < work/checksums.cksum

[ "$fail" -eq 0 ] || exit 3
exit 0
