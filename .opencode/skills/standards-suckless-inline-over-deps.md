# Skill Name: Inline Over Dependencies

## Description
If you can implement a helper in fewer than 20 lines without a dependency, do it rather than importing a crate. Every dependency is a liability.

## When to Load
Load this skill when considering adding a new crate dependency, reviewing PRs that add dependencies, or evaluating whether to inline a small utility function.

## Source
STANDARDS.adoc §0.1.3 (lines 120–121)

## Key Rules

- SHOULD: If you can implement a helper in <20 lines without a dependency, do it rather than importing a crate
- MANDATE: Every dependency MUST be justified — "why not inline this?" MUST be answered
- MANDATE: Dependencies that bring transitive deps for one small function are strongly discouraged
- FORBIDDEN: Adding a crate for a single function you could write in 20 lines
- FORBIDDEN: `cargo install` without `--locked` in CI

## Example

```rust
// CORRECT — Inline a small helper instead of importing a crate
/// Trims trailing whitespace from each line in a string.
/// Written inline (~12 lines) instead of importing a crate.
pub fn trim_lines(s: &str) -> String {
    s.lines()
        .map(|line| line.trim_end())
        .collect::<Vec<_>>()
        .join("\n")
}

// Compare: adding `trim_in_place` crate (3 transitive deps) for this
// is FORBIDDEN — 12 lines of Rust replaces a crate dependency.
```

```rust
// CORRECT — Small infallible conversion function inlined
/// Converts a hex string to bytes.
/// 6 lines, no error handling needed for known-valid input.
pub fn hex_to_bytes_unchecked(hex: &str) -> Vec<u8> {
    (0..hex.len())
        .step_by(2)
        .map(|i| u8::from_str_radix(&hex[i..i + 2], 16).unwrap())
        .collect()
}
// vs. importing `hex` crate — FORBIDDEN, this is 6 lines
```

```rust
// INCORRECT — Unnecessary dependency
use lazy_static::lazy_static;  // FORBIDDEN: std::sync::LazyLock exists in Rust 1.80+

lazy_static! {
    static ref CONFIG: Mutex<Config> = Mutex::new(Config::default());
}
// Rust 1.80+ has std::sync::LazyLock — no dependency needed.
```

```rust
// CORRECT — Complex dependency IS justified
// Using `ring` for cryptographic operations — JUSTIFIED
// Rationale: Implementing AES-GCM correctly is ~2000 lines and
// requires expert cryptographer review. ring is audited and well-maintained.
use ring::aead::{Aad, LessSafeKey, Nonce, UnboundKey};
// This dependency is justified — 20 lines of inline code would be UNSAFE.
```

## Related Skills
- [standards-suckless-no-builder-overuse](file://.opencode/skills/standards-suckless-one-purpose.md)
- [standards-proof-tier-ffi-audited](file://.opencode/skills/standards-proof-tier-ffi-audited.md)
