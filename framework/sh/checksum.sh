#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

mkdir -p work
find lib stages awk sed sh sql c proofs man docs etc -type f \
  ! -name 'framework.local.conf' -exec cksum {} + \
  | LC_ALL=C sort -k 3 > work/checksums.cksum

find build/bytecode -type f -name '*.luac' -exec cksum {} + \
  | LC_ALL=C sort -k 3 >> work/checksums.cksum
