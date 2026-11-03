---
name: Lua 5.4 Runtime
description: Use when running or debugging framework Lua code; covers lua5.4/luac5.4 binaries, package paths, bytecode, and toolchain versions.
---

# Lua 5.4 Runtime

## Rules

- Use `lua5.4` and `luac5.4`; never bare `lua` or `luac`.
- Runtime is Lua 5.4.9.
- Bytecode header is `1b4c756154`.
- `package.path` starts with `./?.lua;./?/init.lua`.
- Do not use `io.popen`, `os.execute`, or `package.loadlib`.

## Commands

```sh
cd ~/.local/src/dotfiles/framework
lua5.4 -v
luac5.4 -p lib/errors.lua
lua5.4 -e 'assert(require("lib.errors").exit_code("INPUT_INVALID") == 3)'
```

## References

- `lib/config.lua`
- `sh/build_bytecode.sh`
- `etc/contracts/lua.contract`
