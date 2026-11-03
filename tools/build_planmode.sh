#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
mkdir -p build/planmode
for source in lib/planmode/*.lua; do
  file=${source##*/}
  output=build/planmode/${file%.lua}.luac
  luac5.4 -s -o "$output" "$source"
done
