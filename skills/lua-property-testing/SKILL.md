---
name: Lua Property Testing
description: Use when adding deterministic property tests; covers the LCG, boundary values, mutation checks, and avoiding clock/random APIs.
---

# Lua Property Testing

## Rules

- Use `tests/lib/lcg.lua`, not `math.random`.
- Seed explicitly: `lcg.seed(20261101)`.
- Generate many valid cases and a few targeted invalid cases.
- Assert on the validator, not on the transform's internal state.
- Keep runtime under a second.

## Pattern

```lua
lcg.seed(20261101)
for n = 1, 250 do
  local ts = lcg.int(2000001) - 1000001
  -- build a row with ts
end
```

## Check

```sh
cd ~/.local/src/dotfiles/framework
lua5.4 tests/run.lua tests/property/normalize_events_prop.lua
```
