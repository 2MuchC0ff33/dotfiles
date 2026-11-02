---
name: Lua Bytecode Build
description: Use when building or debugging stripped Lua 5.4 bytecode; covers build/bytecode, luac5.4 -s, header checks, and require paths.
---

# Lua Bytecode Build

## Build

```sh
cd ~/.local/src/dotfiles/framework
make build
```

`sh/build_bytecode.sh` writes `build/bytecode/lib/**/*.luac` with
`luac5.4 -s`.

## Verify

- Source count equals output count.
- Every header is `1b4c756154`.
- `LUA_PATH=build/bytecode/?.luac;; lua5.4 -e 'require(...)'` works.

```sh
sh/tests/bytecode.sh
```

## Rules

- Never commit `build/`.
- Never ship unstripped bytecode.
- Do not change the header check to a prefix check.
