# Skill Name: Maximum File Size

## Description
No source file exceeds 500 lines. If a file exceeds 500 lines, a justification comment MUST be present at the top of the file explaining why.

## When to Load
Load this skill when creating new source files, reviewing PRs for file size compliance, or refactoring files that have grown too large.

## Source
STANDARDS.adoc §0.1.3 (line 104)

## Key Rules

- MANDATE: No source file exceeds 500 lines
- MANDATE: If a file exceeds 500 lines, a comment at the top MUST justify why the file cannot be split
- SHOULD: Target 200-400 lines per file for most modules
- FORBIDDEN: Files exceeding 500 lines without a justification comment
- FORBIDDEN: Justifications like "it's easier this way" — must be a technical rationale

## Example

```rust
// CORRECT — File under 500 lines, no justification needed
// File: src/parser/config.rs (312 lines)

/// Configuration file parser.
pub struct ConfigParser { /* ... */ }
// ... rest of file under 500 lines
```

```rust
// CORRECT — File over 500 lines WITH justification
// File: src/data/state_table.rs (847 lines)
//
// JUSTIFICATION: This file contains the exhaustive state transition table
// for the network protocol state machine. Every (state, event) pair is
// explicitly defined for verifiability. Splitting this table across
// multiple files would make it impossible to audit all transitions at once.

/// Protocol state transition table. Each row is a state, each column an event.
pub static STATE_TABLE: &[[Option<Transition>; 12]; 8] = &[
    // ... all 96 transitions defined explicitly ...
];
```

```rust
// INCORRECT — File over 500 lines WITHOUT justification
// File: src/util/helpers.rs (634 lines)
// No justification comment at top — FORBIDDEN

pub fn do_a_thing() { /* ... */ }
pub fn do_b_thing() { /* ... */ }
pub fn do_c_thing() { /* ... */ }
// ... 600+ lines of unrelated helper functions
```

## Related Skills
- [standards-suckless-max-function-size](file://.opencode/skills/standards-suckless-max-function-size.md)
- [standards-suckless-one-purpose](file://.opencode/skills/standards-suckless-one-purpose.md)
