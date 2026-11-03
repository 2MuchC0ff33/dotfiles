#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

fail=0

probe_lua() { lua5.4 -v 2>&1; }
probe_luac() { luac5.4 -v 2>&1; }
probe_luacheck() { luacheck --version 2>&1 | head -n 1; }
probe_stylua() { stylua --version 2>&1 | head -n 1; }
probe_lls() { apk info -e -v lua-language-server 2>/dev/null | head -n 1; }
probe_busybox() { busybox 2>&1 | head -n 1; }
probe_make() { make --version 2>&1 | head -n 1; }
probe_sqlite() { sqlite3 --version 2>&1 | head -n 1; }
probe_getconf() { getconf _POSIX_VERSION 2>&1; }
probe_tcc() { tcc -v 2>&1 | head -n 1; }
probe_cppcheck() { cppcheck --version 2>&1 | head -n 1; }
probe_astyle() { astyle --version 2>&1 | head -n 1; }
probe_mandoc() { apk info -e -v mandoc 2>/dev/null | head -n 1; }
probe_websocat() { websocat --version 2>&1 | head -n 1; }
probe_musldev() {
  if [ -f /usr/include/unistd.h ] && [ -f /usr/lib/crt1.o ]; then
    printf 'musl-dev ok\n'
  else
    printf 'musl-dev absent\n'
  fi
}

tab=$(printf '\t')
while IFS="$tab" read -r tool expected tier probe; do
  case $tool in
    ''|'#'*) continue ;;
  esac
  actual=$(probe_"$probe" 2>/dev/null || true)
  if printf '%s\n' "$actual" | grep -E -q "$expected"; then
    printf 'OK %s %s\n' "$tool" "$actual"
  else
    case $tier in
      C_REQUIRED)
        if [ "${FW_REQUIRE_C:-0}" = 1 ]; then
          printf 'ENV_MISSING: %s expected /%s/ got %s\n' "$tool" "$expected" "$actual" >&2
          fail=1
        else
          printf 'WARN %s absent (C gates skipped; FW_REQUIRE_C=1 to require)\n' "$tool"
        fi
        ;;
      OPTIONAL)
        printf 'WARN %s optional, got %s\n' "$tool" "$actual"
        ;;
      *)
        printf 'ENV_MISSING: %s expected /%s/ got %s\n' "$tool" "$expected" "$actual" >&2
        fail=1
        ;;
    esac
  fi
done < etc/tool_versions.txt

posix=$(getconf _POSIX_VERSION 2>/dev/null || printf 'unknown')
printf 'POSIX_VERSION=%s\n' "$posix"
if [ "$posix" != 200809 ]; then
  printf 'WARN POSIX_VERSION=%s; target is POSIX.1-2017 (200809)\n' "$posix"
else
  printf 'OK POSIX_2017\n'
fi

[ "$fail" -eq 0 ] || exit 4
exit 0
