#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh
. sh/lib/timeout.sh

[ "$#" -ge 2 ] || fw_die 2 "usage: fetch.sh URL OUTPUT [TIMEOUT] [RETRIES]"

url=$1
output=$2
wget_timeout=${3:-$(fw_config_get FW_WGET_TIMEOUT etc/framework.conf)}
retries=${4:-$(fw_config_get FW_WGET_RETRIES etc/framework.conf)}
ua=$(fw_config_get FW_WGET_USER_AGENT etc/framework.conf)
[ -n "$wget_timeout" ] || wget_timeout=30
[ -n "$retries" ] || retries=3
[ -n "$ua" ] || ua=framework/0.1

mkdir -p "$(dirname "$output")"
tmp="$output.tmp"
rm -f "$tmp"

cleanup() {
  rm -f "$tmp"
}
trap cleanup 0 HUP INT TERM

attempt=1
while [ "$attempt" -le "$retries" ]; do
  if fw_timeout "$((wget_timeout + 5))" \
    wget -q -S -T "$wget_timeout" -O "$tmp" -U "$ua" "$url"; then
    mv "$tmp" "$output"
    exit 0
  fi
  rm -f "$tmp"
  attempt=$((attempt + 1))
  if [ "$attempt" -le "$retries" ]; then
    sleep 1
  fi
done

exit 1
