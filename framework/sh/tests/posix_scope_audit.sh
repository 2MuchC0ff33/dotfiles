#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

mkdir -p work
rm -f work/audit.*.patterns work/audit.findings
findings=0

for d in lib stages awk sed sh sql c proofs tests; do
  [ -d "$d" ] || fw_die 4 "ENV_MISSING: directory $d"
done

tab=$(printf '\t')
for scope in all lua lib sh awk sql make c; do
  : > "work/audit.$scope.patterns"
done

while IFS="$tab" read -r id scope pattern class reason; do
  case $id in
    ''|'#'*) continue ;;
  esac
  case $scope in
    all|lua|lib|sh|awk|sql|make|c) ;;
    *) fw_die 3 "TOOL_CONTRACT: banned_options.txt: unknown scope $scope" ;;
  esac
  printf '%s\n' "$pattern" >> "work/audit.$scope.patterns"
done < etc/banned_options.txt

report() {
  scope=$1
  status=$2
  case $status in
    0)
      printf 'TOOL_CONTRACT: forbidden pattern (scope %s)\n' "$scope" >&2
      cat work/audit.findings >&2
      findings=1
      ;;
    1) : ;;
    *)
      printf 'TOOL_CONTRACT: audit scan failed (scope %s, rc=%s)\n' "$scope" "$status" >&2
      findings=1
      ;;
  esac
}

scan_files() {
  scope=$1
  shift
  [ -s "work/audit.$scope.patterns" ] || return 0
  [ "$#" -gt 0 ] || return 0
  set +e
  grep -E -n -f "work/audit.$scope.patterns" "$@" > work/audit.findings
  status=$?
  set -e
  report "$scope" "$status"
}

semantic_check() {
  label=$1
  filter=$2
  shift 2
  [ "$#" -gt 0 ] || return 0
  set +e
  grep -E -n "(^|[[:space:];&|(])${label}([[:space:]]|$)" "$@" \
    | grep -v -e "$filter" \
    | grep -v -e '--version' \
    | grep -v -e 'probe_' \
    | grep -v -e ':[0-9]*:#' \
    | grep -v -E '(^|[[:space:]:])(find|mkdir|ls|rm|cp|mv|printf)([[:space:]]|$)' \
    > work/audit.findings
  status=$?
  set -e
  if [ "$status" -eq 0 ]; then
    printf 'TOOL_CONTRACT: %s requires %s\n' "$label" "$filter" >&2
    cat work/audit.findings >&2
    findings=1
  fi
}

if [ "$#" -gt 0 ]; then
  for scope in all lua lib sh awk sql make c; do
    scan_files "$scope" "$@"
  done
  semantic_check 'astyle' '--dry-run' "$@"
  semantic_check 'astyle' '--indent=spaces=2' "$@"
  semantic_check 'cppcheck' '--error-exitcode' "$@"
  semantic_check 'wget' '-T' "$@"
  semantic_check 'mandoc' '-T' "$@"
else
  lua_files=$(find lib stages tests -path 'tests/fixtures' -prune -o -type f -name '*.lua' -print)
  lib_files=$(find lib -type f -name '*.lua' -print)
  sh_files=$(find sh tests/integration -type f -name '*.sh' ! -name 'posix_scope_audit.sh' -print)
  awk_files=$(find awk -type f -name '*.awk' -print)
  sql_files=$(find sql -type f -name '*.sql' -print)
  c_files=$(find c -type f \( -name '*.c' -o -name '*.h' \) -print)

  if [ -n "$lua_files" ]; then scan_files lua $lua_files; fi
  if [ -n "$lib_files" ]; then scan_files lib $lib_files; fi
  if [ -n "$sh_files" ]; then scan_files sh $sh_files; fi
  if [ -n "$awk_files" ]; then scan_files awk $awk_files; fi
  if [ -n "$sql_files" ]; then scan_files sql $sql_files; fi
  if [ -f Makefile ]; then scan_files make Makefile; fi
  if [ -n "$c_files" ]; then scan_files c $c_files; fi

  all_files="$lua_files $sh_files $awk_files $sql_files $c_files"
  if [ -f Makefile ]; then all_files="$all_files Makefile"; fi
  if [ -n "$all_files" ]; then
    scan_files all $all_files
    semantic_check 'astyle' '--dry-run' $all_files
    semantic_check 'astyle' '--indent=spaces=2' $all_files
    semantic_check 'cppcheck' '--error-exitcode' $all_files
    semantic_check 'wget' '-T' $all_files
    semantic_check 'mandoc' '-T' $all_files
  fi
fi

[ "$findings" -eq 0 ] || exit 3
exit 0
