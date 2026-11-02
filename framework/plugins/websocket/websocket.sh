#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh
. sh/lib/timeout.sh

[ "$#" -ge 2 ] || fw_die 2 "usage: websocket.sh URL OUTPUT"

url=$1
output=$2

case $url in
  wss://*) ;;
  *) fw_die 3 "TOOL_CONTRACT: only wss:// is allowed" ;;
esac

allow=${FW_PLUGIN_WEBSOCKET_ALLOWLIST:-$(fw_config_get FW_PLUGIN_WEBSOCKET_ALLOWLIST etc/framework.conf)}
[ -n "$allow" ] || fw_die 3 "TOOL_CONTRACT: empty websocket allowlist"

found=0
old_ifs=$IFS
IFS=','
for host in $allow; do
  case $url in
    "$host"|"$host"/*) found=1 ;;
  esac
done
IFS=$old_ifs
[ "$found" -eq 1 ] || fw_die 3 "TOOL_CONTRACT: host not in allowlist"

fw_require_cmd websocat
mkdir -p "$(dirname "$output")"
tmp="$output.tmp"
rm -f "$tmp"

cleanup() {
  rm -f "$tmp"
}
trap cleanup 0 HUP INT TERM

fw_timeout 30 websocat -1 "$url" > "$tmp"
mv "$tmp" "$output"
