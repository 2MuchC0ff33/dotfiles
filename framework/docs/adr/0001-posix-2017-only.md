# ADR 0001 — POSIX.1-2017 only

Status: accepted.

## Context

musl 1.2.6 reports `_POSIX_VERSION=200809`. POSIX.1-2024 utilities such as
`timeout(1)` are not available in the 2017 surface. The old plan mixed 2024
utility claims with a 200809 libc.

## Decision

Target POSIX.1-2017 uniformly. Do not claim POSIX.1-2024. Do not use
`timeout(1)`. Use `sh/lib/timeout.sh` for wall-clock bounds.

## Consequences

- `getconf _POSIX_VERSION` returning 200809 is a pass.
- The C probe `_POSIX_VERSION == 200809L` is mandatory.
- Any 2024-only utility is out of scope.
