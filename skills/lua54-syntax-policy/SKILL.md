---
name: Lua 5.4 Syntax Policy
description: Use when writing or reviewing Lua; bans Lua 5.5-only global declarations, named varargs, prefix attributes, and table.create.
---

# Lua 5.4 Syntax Policy

## Banned

- `global x = 1`
- `local function f(... args)`
- `local x <const> = 1` (prefix attribute)
- `table.create(...)`

## Allowed

- `local x <const> = 1` (suffix attribute)
- bitwise operators
- `goto` and labels
- `utf8`, `coroutine`, `math`, `string`, `table`

## Gates

```sh
cd ~/.local/src/dotfiles/framework
find lib tests -type f -name '*.lua' -exec luac5.4 -p {} +
make audit lint format
```

`luac5.4 -p` is authoritative. `luacheck --std lua54` and
`stylua --syntax Lua54` must agree.
