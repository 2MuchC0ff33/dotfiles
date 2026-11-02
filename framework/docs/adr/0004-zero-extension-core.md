# ADR 0004 — zero-extension core

Status: accepted.

## Context

The old core used `bc`, `mktemp`, `grep -r`, `timeout`, `local`, `jq`, and
`sha256sum`. Each required a waiver.

## Decision

Remove all of them from core. Use `awk`/Lua arithmetic, `mkdir -p`,
`find -exec grep`, `fw_timeout`, prefixed globals, Lua JSON checks, and
`cksum`.

## Consequences

- The core is POSIX.1-2017 plus external runtimes.
- The audit enforces the removals.
- Plugins are the only place for optional extensions.
