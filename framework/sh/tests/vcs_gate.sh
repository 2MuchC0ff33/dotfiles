#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
fail=0
require_contract() {
  rel=$1
  if [ -f "$root/$rel" ]; then printf 'ok: %s\n' "$rel"; else printf 'missing: %s\n' "$rel" >&2; fail=$((fail + 1)); fi
}
require_contract etc/contracts/cvs.contract
require_contract etc/contracts/git.contract
require_contract etc/contracts/dropbear.contract
require_contract etc/contracts/gpg.contract
grep -q '^cvs[[:space:]]*EXT[[:space:]]' "$root/etc/posix_allowlist.txt" || fail=$((fail + 1))
grep -q '^git[[:space:]]*EXT[[:space:]]' "$root/etc/posix_allowlist.txt" || fail=$((fail + 1))
grep -q '^dbclient[[:space:]]*EXT[[:space:]]' "$root/etc/posix_allowlist.txt" || fail=$((fail + 1))
grep -q '^gpg[[:space:]]*EXT[[:space:]]' "$root/etc/posix_allowlist.txt" || fail=$((fail + 1))
[ "$fail" -eq 0 ] || exit 1
printf 'vcs gate: ok\n'
