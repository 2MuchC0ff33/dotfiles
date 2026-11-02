---
name: POSIX Shell Discipline
description: Use when writing or reviewing framework shell scripts; enforces set -eu, printf, prefixed globals, trap cleanup, and no bashisms.
---

# POSIX Shell Discipline

## Rules

- Start with `set -eu`.
- Use `printf`, never `echo`.
- No `local`; use prefixed globals such as `fw_cfg_key`.
- No `eval`, `[[ ]]`, arrays, or `function` keyword.
- Quote every expansion.
- Use `trap cleanup 0 HUP INT TERM`.
- Propagate nonzero status; do not assume `pipefail`.
- Use `fw_die` from `sh/lib/common.sh`.

## Pattern

```sh
#!/bin/sh
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
. sh/lib/common.sh
```

## Check

```sh
sh -n path/to/script.sh
make audit shell
```
