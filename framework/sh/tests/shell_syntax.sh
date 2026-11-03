#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

find sh tests plugins -type f -name '*.sh' -exec sh -n {} +
