#!/bin/sh
#
# ~/.profile  -  BusyBox ash login-shell profile
# Target: POSIX.1-2024 (IEEE 1003.1-2024 / Open Group Issue 8) baseline.
# Read ONLY by login shells.  Interactive non-login shells are configured
# via $ENV (see ~/.ashrc).  Kept POSIX-strict; safe to source in any
# POSIX-conforming shell.
#
# Personal command symlinks live in ~/.local/bin and are prepended to PATH.

# --- Safety: errexit for non-interactive (script) use only --------------
# errexit (-e) is intentionally NOT enabled interactively (it would kill
# the shell on any failing command).  Interactive safety (noclobber,
# nounset, noglob) is applied in ~/.ashrc.
case $- in
    *i*) ;;
    *)   set -e ;;
esac

umask 022

# --- PATH: idempotent prepend helper ------------------------------------
# Prepends $1 to PATH only if the directory exists and is not already
# present.  Prevents duplicate entries when files are sourced repeatedly.
_path_prepend() {
    [ -d "$1" ] || return 0
    case ":${PATH}:" in
        *":$1:"*) return 0 ;;
    esac
    PATH="$1${PATH:+:$PATH}"
}

# Personal commands and repo-managed symlinks.
_path_prepend "$HOME/.local/bin"

# Core system PATH (POSIX.1-2024 standard locations).
_path_prepend /usr/local/bin
_path_prepend /usr/bin
_path_prepend /bin
_path_prepend /usr/local/sbin
_path_prepend /usr/sbin
_path_prepend /sbin

# opencode (guarded: only prepend if the directory exists).
_path_prepend /home/twomuchcoffee/.opencode/bin
unset -f _path_prepend

export PATH

# --- Interactive-shell hook (ENV) ---------------------------------------
# Non-login interactive shells source $ENV.  Point it at ~/.ashrc.
ENV=$HOME/.ashrc
export ENV

# --- Login-only actions -------------------------------------------------
# Start X on the first virtual console when no display is active.
# (Preserved from existing config; `startx` not `exec`ed to keep original
# semantics - the login shell continues after startx returns.)
if [ -z "${DISPLAY}" ] && [ "$(tty)" = /dev/tty1 ]; then
    startx
fi

# --- Alias -------------------------------------------------------------
alias clear_downloads='find /home/twomuchcoffee/Downloads -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +'

