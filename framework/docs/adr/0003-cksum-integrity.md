# ADR 0003 — cksum for integrity

Status: accepted.

## Context

`sha256sum` is not POSIX. `cksum` is POSIX and available in BusyBox. It
computes CRC32, not a cryptographic hash.

## Decision

Use `cksum` for manifests and sidecars. State explicitly that CRC32 is an
integrity check, not a security primitive.

## Consequences

- No `sha256sum` in core or plugins.
- Checksums are compared by recomputing and string-comparing.
- A future SHA-256 plugin would need its own contract and security claim.
