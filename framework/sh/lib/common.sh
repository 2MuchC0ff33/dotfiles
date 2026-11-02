#!/bin/sh
# Shared helpers. POSIX sh only. No eval. No local.

fw_die() {
  fw_die_code=$1
  shift
  printf '%s\n' "$*" >&2
  exit "$fw_die_code"
}

fw_require_file() {
  [ -f "$1" ] || fw_die 4 "ENV_MISSING: $1"
}

fw_require_dir() {
  [ -d "$1" ] || fw_die 4 "ENV_MISSING: $1"
}

fw_require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fw_die 4 "ENV_MISSING: $1"
}

fw_config_get() {
  fw_cfg_key=$1
  fw_cfg_file=$2
  fw_require_file "$fw_cfg_file"
  fw_cfg_value=
  while IFS='=' read -r fw_cfg_k fw_cfg_v; do
    case $fw_cfg_k in
      ''|'#'*) continue ;;
    esac
    if [ "$fw_cfg_k" = "$fw_cfg_key" ]; then
      fw_cfg_value=$fw_cfg_v
    fi
  done < "$fw_cfg_file"
  printf '%s\n' "$fw_cfg_value"
}

fw_config_db() {
  if [ -n "${FRAMEWORK_DB:-}" ]; then
    printf '%s\n' "$FRAMEWORK_DB"
    return 0
  fi
  if [ -n "${DB_PATH:-}" ]; then
    printf '%s\n' "$DB_PATH"
    return 0
  fi
  if [ -f etc/framework.local.conf ]; then
    fw_local_db=$(fw_config_get DB_PATH etc/framework.local.conf)
    if [ -n "$fw_local_db" ]; then
      printf '%s\n' "$fw_local_db"
      return 0
    fi
  fi
  fw_config_get DB_PATH etc/framework.conf
}

fw_log() {
  printf '%s\n' "$*"
}

fw_checksum() {
  cksum "$1"
}
