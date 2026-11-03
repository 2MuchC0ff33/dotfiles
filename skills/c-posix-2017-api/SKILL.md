---
name: C POSIX 2017 API
description: Use when choosing libc calls for the C module; keeps the module inside the POSIX.1-2017 API surface and avoids 2024-only interfaces.
---

# C POSIX 2017 API

## Rule

Include `<unistd.h>` and define `_POSIX_C_SOURCE=200809L` before any
headers that depend on it. Do not use POSIX.1-2024 interfaces.

## Current module

`c/src/fw_parse.c` implements `fw_parse_i64` using `<limits.h>` only.

## Check

```sh
cd ~/.local/src/dotfiles/framework
tcc -std=c99 -D_POSIX_C_SOURCE=200809L c/tests/posix_level.c -o /tmp/pv && /tmp/pv
```

## References

- `docs/conformance.txt`
- `etc/contracts/c.contract`
