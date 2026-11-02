# ADR 0006 — proofs are data

Status: accepted.

## Context

Executable proofs are a code-injection surface. The framework needs
machine-checkable obligations without executing them.

## Decision

Proofs are restricted Lua table literals parsed by `lib/literal.lua`.
`dofile`, `loadfile`, `loadstring`, and `load` are banned in `lib/`.
`lib/refine.lua` validates the schema and checks that referenced files
exist.

## Consequences

- A proof cannot call functions, concatenate strings, or use long strings.
- Parse failures exit 5.
- The proof format is portable and diff-friendly.
