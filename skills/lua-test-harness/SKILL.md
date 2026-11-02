---
name: Lua Test Harness
description: Use when adding unit or property tests; covers tests/run.lua, describe/it, eq/ok/fails, and the exit-status contract.
---

# Lua Test Harness

## Files

- `tests/lib/harness.lua`: `describe`, `it`, `eq`, `ok`, `fails`, `done`.
- `tests/run.lua`: loads spec files from `arg`.
- `tests/lib/lcg.lua`: deterministic generator.

## Pattern

```lua
local h = require("tests.lib.harness")

h.describe("thing", function()
  h.it("works", function()
    h.eq(1 + 1, 2)
  end)
end)
```

## Run

```sh
cd ~/.local/src/dotfiles/framework
mkdir -p work
find tests/unit tests/property -type f -name '*.lua' | sort | xargs lua5.4 tests/run.lua
```

`harness.done()` exits 1 when any test failed. Running a spec directly
without `tests/run.lua` skips the summary and the failure exit.
