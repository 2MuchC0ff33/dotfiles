---
name: POSIX Framework Overview
description: Use when working in the POSIX.1-2017 Lua 5.4 framework in this dotfiles repo; covers layout, gates, and release flow.
---

# POSIX Framework Overview

## When to use

Use for any task that touches `~/.local/src/dotfiles/framework`, its gates,
its stages, or its release process.

## Rules

- POSIX.1-2017 only; `_POSIX_VERSION` must be `200809`.
- Lua 5.4.9 only; use `lua5.4` and `luac5.4`.
- C99 only; `__STDC_VERSION__` must be `199901L`.
- `make verify` is the definition of done.
- Plugins are excluded from `make verify`; use `make plugins`.

## Commands

```sh
cd ~/.local/src/dotfiles/framework
make verify
make plugins
```

## References

- `docs/conformance.md`
- `docs/architecture.md`
- `docs/decisions.md`
