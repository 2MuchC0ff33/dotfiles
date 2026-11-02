---
name: C99 tcc Baseline
description: Use when compiling or reviewing C; enforces C99, -D_POSIX_C_SOURCE=200809L, tcc-only builds, and compile-time standard probes.
---

# C99 tcc Baseline

## Compile

```sh
tcc -std=c99 -D_POSIX_C_SOURCE=200809L -I c/include \
  c/src/fw_parse.c tests/unit/fw_parse_spec.c -o build/c/fw_parse_spec
```

## Probes

- `c/tests/stdver.c`: `__STDC_VERSION__ == 199901L`.
- `c/tests/posix_level.c`: `_POSIX_VERSION == 200809L`.

## Banned

- `-std=c17` (tcc silently reports C99).
- C11/C17 features.
- gcc/clang as the primary compiler.

## Check

```sh
cd ~/.local/src/dotfiles/framework
make c
```
