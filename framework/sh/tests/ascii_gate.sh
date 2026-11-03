#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"
bad=$(find . -path ./work -prune -o -path ./build -prune -o -path ./.git -prune -o -path ./CVS -prune -o -type f -exec sh -c 'LC_ALL=C tr "\t" " " < "$1" | LC_ALL=C grep -Iq "[^ -~]" && printf "%s\n" "$1"' _ {} \;)
case "$bad" in
  '') ;;
  *) printf '%s\n' "$bad" >&2; exit 1 ;;
esac
printf 'ascii gate: ok\n'
