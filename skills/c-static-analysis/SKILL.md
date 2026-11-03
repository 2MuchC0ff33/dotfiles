---
name: C Static Analysis
description: Use when running cppcheck or astyle; covers c99 mode, error-exitcode, include paths, and the intentional #error probe exclusion.
---

# C Static Analysis

## cppcheck

```sh
cppcheck --std=c99 --enable=warning,performance,portability \
  --error-exitcode=3 --inline-suppr --suppress=missingIncludeSystem \
  -I c/include c/src tests/unit
```

Do **not** analyze `c/tests`; `stdver.c` and `posix_level.c` contain
intentional `#error` probes that cppcheck reports as errors.

## astyle

```sh
astyle --style=kr --indent=spaces=2 --dry-run --error-on-changes \
  --suffix=none --recursive "c/src/*.c" "c/include/*.h" \
  "c/tests/*.c" "tests/unit/*.c"
```

## Check

```sh
cd ~/.local/src/dotfiles/framework
make c
```
