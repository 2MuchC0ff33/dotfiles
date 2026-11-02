#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")" && pwd)
TARGET=${OPENCODE_SKILLS_DIR:-"$HOME/.config/opencode/skills"}
MODE=link

for arg in "$@"; do
  case $arg in
    --copy) MODE=copy ;;
    --link) MODE=link ;;
    --dry-run) MODE=dry ;;
    --remove) MODE=remove ;;
    -h|--help)
      printf 'usage: %s [--link|--copy|--dry-run|--remove]\n' "$0"
      exit 0
      ;;
    *)
      printf 'unknown option: %s\n' "$arg" >&2
      exit 2
      ;;
  esac
done

case $MODE in
  dry|remove) ;;
  *) mkdir -p "$TARGET" ;;
esac

count=0
for dir in "$ROOT"/*/; do
  [ -f "$dir/SKILL.md" ] || continue
  id=$(basename "$dir")
  dest="$TARGET/$id"
  count=$((count + 1))
  case $MODE in
    dry)
      printf 'would install %s -> %s\n' "$id" "$dest"
      ;;
    remove)
      rm -rf "$dest"
      printf 'removed %s\n' "$dest"
      ;;
    copy)
      rm -rf "$dest"
      cp -R "$dir" "$dest"
      printf 'copied %s -> %s\n' "$id" "$dest"
      ;;
    link)
      if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        printf 'refusing to replace non-symlink: %s\n' "$dest" >&2
        exit 1
      fi
      rm -f "$dest"
      ln -s "$dir" "$dest"
      printf 'linked %s -> %s\n' "$id" "$dest"
      ;;
  esac
done

printf 'skills=%d target=%s mode=%s\n' "$count" "$TARGET" "$MODE"
