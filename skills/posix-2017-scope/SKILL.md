---
name: POSIX 2017 Scope
description: Use when deciding whether a shell utility or libc API is allowed; enforces the POSIX.1-2017 boundary and rejects 2024-only features.
---

# POSIX 2017 Scope

## When to use

Use before adding a utility, option, or libc call to the framework.

## Allowed

- POSIX.1-2017 shell utilities in `etc/posix_allowlist.txt`.
- `cksum`, `find -exec`, `printf`, `test`, `trap`, `wait`, `kill`, `sleep`.
- `_POSIX_VERSION == 200809L`.

## Rejected

- `timeout(1)` (POSIX.1-2024).
- `local`, `mktemp`, `bc`, `sha256sum`, `grep -r`, `jq`.
- Any utility not in the allowlist.

## Check

```sh
cd ~/.local/src/dotfiles/framework
getconf _POSIX_VERSION
make audit
```

## References

- `docs/conformance.txt`
- `docs/decisions.txt`
- `etc/posix_allowlist.txt`
