---
name: Lua Stage Validation
description: Use when adding a stage validator; covers row/file validation, atomic temp files, result JSON, and exit-code mapping.
---

# Lua Stage Validation

## Pattern

- Shell writes `<output>.tmp`.
- Lua validates the temp file.
- Shell `mv`s to the final path.
- Shell writes `<output>.cksum` and a result JSON.
- A trap removes temp and final artifacts on failure.

## Validator API

```lua
local m = require("lib.stages.normalize_events")
local ok, count = m.validate_output("work/events.normalized.tsv.tmp")
```

`m.main(path)` exits 3 with `INPUT_INVALID` on failure.

## Check

```sh
cd ~/.local/src/dotfiles/framework
sh/tests/run_all.sh
sh tests/contract/normalize_events.sh
```
