---
name: Man Page Gate
description: Use when editing man/framework.1; runs mandoc lint and render plus the pure-Lua structural fallback.
---

# Man Page Gate

## Rules

- Use mdoc/man macros only.
- `.TH` requires title and section.
- `.SH NAME` must not be empty.
- `.SH SYNOPSIS` or `.SH DESCRIPTION` is required.
- Unknown macros fail the Lua fallback.

## Check

```sh
cd ~/.local/src/dotfiles/framework
mandoc -T lint man/framework.1
mandoc -T ascii man/framework.1 | head
sh/tests/man_gate.sh
```

`man_gate.sh` fails on mandoc rc 2 (warnings or errors) and on an empty
render. It then runs `tests/run.lua tests/unit/manlint_spec.lua`.
