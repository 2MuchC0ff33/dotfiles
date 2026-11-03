#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_dir=${OPENCODE_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/opencode}
mode=link
action=install
force=0

usage() {
  printf 'usage: %s [--link|--copy|--dry-run|--remove] [--force] [--help]\n' "$0"
  printf 'default: symlink agents, commands, and skills into %s\n' "$config_dir"
  printf 'options:\n'
  printf '  --link     symlink sources (default)\n'
  printf '  --copy     copy source directories\n'
  printf '  --dry-run  print actions without changing anything\n'
  printf '  --remove   remove known installs from the target\n'
  printf '  --force    replace real directories or foreign symlinks\n'
  printf '  --help     show this help\n'
}

while [ $# -gt 0 ]; do
  case "$1" in
    --link) mode=link ;;
    --copy) mode=copy ;;
    --dry-run) mode=dry ;;
    --remove) action=remove ;;
    --force) force=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

remove_item() {
  dst=$1

  if [ "$mode" = dry ]; then
    printf 'would remove %s\n' "$dst"
    return 0
  fi

  if [ -L "$dst" ]; then
    current=$(ls -l "$dst" | sed -n -f "$repo_dir/tools/sed/symlink_target.sed")
    case "$current" in
      "$repo_dir"/*)
        rm -f "$dst"
        printf 'removed symlink %s\n' "$dst"
        ;;
      *)
        printf 'kept foreign symlink %s\n' "$dst"
        ;;
    esac
    return 0
  fi

  if [ -d "$dst" ] && [ -f "$dst/.installed-from-dotfiles" ]; then
    rm -rf "$dst"
    printf 'removed copy %s\n' "$dst"
    return 0
  fi

  if [ -e "$dst" ]; then
    printf 'kept existing path %s\n' "$dst"
  else
    printf 'absent %s\n' "$dst"
  fi
}

install_item() {
  src=$1
  dst=$2
  label=$3

  if [ "$action" = remove ]; then
    remove_item "$dst"
    return 0
  fi

  if [ "$mode" = dry ]; then
    printf 'would install %s %s -> %s\n' "$label" "$src" "$dst"
    return 0
  fi

  mkdir -p "$(dirname -- "$dst")"

  if [ -L "$dst" ]; then
    current=$(ls -l "$dst" | sed -n -f "$repo_dir/tools/sed/symlink_target.sed")
    case "$current" in
      "$repo_dir"/*)
        if [ "$current" = "$src" ]; then
          printf 'ok %s -> %s\n' "$dst" "$src"
          return 0
        fi
        rm -f "$dst"
        ln -s "$src" "$dst"
        printf 'relinked %s -> %s\n' "$dst" "$src"
        return 0
        ;;
      *)
        if [ "$force" -eq 1 ]; then
          rm -f "$dst"
          ln -s "$src" "$dst"
          printf 'replaced %s -> %s\n' "$dst" "$src"
          return 0
        fi
        printf 'refusing to replace foreign symlink: %s\n' "$dst" >&2
        printf 're-run with --force to replace it\n' >&2
        exit 1
        ;;
    esac
  fi

  if [ -e "$dst" ]; then
    if [ "$force" -eq 1 ]; then
      rm -rf "$dst"
    else
      printf 'refusing to replace existing path: %s\n' "$dst" >&2
      printf 're-run with --force to replace it\n' >&2
      exit 1
    fi
  fi

  if [ "$mode" = copy ]; then
    cp -R "$src" "$dst"
    : > "$dst/.installed-from-dotfiles"
    printf 'copied %s -> %s\n' "$src" "$dst"
  else
    ln -s "$src" "$dst"
    printf 'linked %s -> %s\n' "$src" "$dst"
  fi
}

install_tree() {
  name=$1
  src=$2
  dst=$3

  if [ -d "$src" ]; then
    install_item "$src" "$dst" "$name"
  else
    printf 'skip missing %s\n' "$src"
  fi
}

install_tree agents "$repo_dir/agents" "$config_dir/agents"
install_tree commands "$repo_dir/commands" "$config_dir/commands"

for skill_dir in "$repo_dir"/skills/*; do
  [ -d "$skill_dir" ] || continue
  [ -f "$skill_dir/SKILL.md" ] || continue
  id=${skill_dir##*/}
  install_item "$skill_dir" "$config_dir/skills/$id" "skill/$id"
done

if [ "$action" = remove ]; then
  printf 'removed known plan-mode entries from %s\n' "$config_dir"
else
  printf 'installed into %s\n' "$config_dir"
fi
printf 'restart OpenCode or run: opencode reload\n'
