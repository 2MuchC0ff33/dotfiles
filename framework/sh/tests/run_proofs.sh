#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

mkdir -p work
find proofs -type f -name '*.refine' | sort > work/proof-files.txt
if [ -s work/proof-files.txt ]; then
  xargs lua5.4 tests/proofs.lua < work/proof-files.txt
fi
