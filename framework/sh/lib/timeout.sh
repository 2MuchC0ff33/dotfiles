#!/bin/sh
# POSIX wall-clock watchdog. No timeout(1). Returns 124 when it fires.

fw_timeout() {
  fw_to_secs=$1
  shift
  [ "$#" -gt 0 ] || return 2

  "$@" &
  fw_to_pid=$!

  (
    sleep "$fw_to_secs"
    kill -TERM "$fw_to_pid" 2>/dev/null || exit 0
    sleep 1
    kill -KILL "$fw_to_pid" 2>/dev/null || exit 0
  ) &
  fw_to_wd=$!

  if wait "$fw_to_pid"; then
    fw_to_status=0
  else
    fw_to_status=$?
  fi

  kill -TERM "$fw_to_wd" 2>/dev/null || true
  wait "$fw_to_wd" 2>/dev/null || true

  case $fw_to_status in
    143|137) return 124 ;;
    *) return "$fw_to_status" ;;
  esac
}
