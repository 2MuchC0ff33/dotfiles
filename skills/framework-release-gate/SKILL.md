---
name: Framework Release Gate
description: Use before claiming the framework is done; runs the full verify and plugin gates plus the negative acceptance scenarios.
---

# Framework Release Gate

## Sequence

```sh
cd ~/.local/src/dotfiles/framework
make clean
make verify
make plugins
```

## Must pass

- `make verify` rc 0.
- `make plugins` rc 0.
- `git diff --check` clean.
- No generated files in `git status`.
- Negative scenarios in the handoff fail with the documented codes.

## Report

Attach the tail of `make verify` and the exit codes. Do not claim done
from a partial run.
