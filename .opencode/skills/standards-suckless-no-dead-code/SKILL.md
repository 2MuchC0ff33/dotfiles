---
name: standards-suckless-no-dead-code
description: Description
compatibility: opencode
---

# Skill Name: No Dead Code

## Description
No dead code, no commented-out code, no `todo!()` or `unimplemented!()` in committed code. If it compiles but is never called, remove it.

## When to Load
Load this skill when reviewing PRs for dead code detection, cleaning up unused functions/variables, or before committing changes.

## Source
STANDARDS.adoc §0.1.3 (lines 105–106)

## Key Rules

- MANDATE: No dead code — if it compiles but is never called, remove it
- MANDATE: No commented-out code — use VCS history (`jj log` / `pijul log`) instead
- MANDATE: No `todo!()` or `unimplemented!()` in committed code
- MANDATE: Every function, type, constant, and module MUST be used or marked with intended future use
- SHOULD: Use `#[allow(dead_code)]` only with a documented reason and a tracking issue
- FORBIDDEN: `todo!()` — use `unreachable!()` only if Kani-proved unreachable
- FORBIDDEN: `unimplemented!()` — implement the function or remove it
- FORBIDDEN: Large blocks of commented-out code as "reference" — that is what VCS is for

## Example

```rust
// CORRECT — Clean file, no dead code, no commented-out code
/// Computes the SHA-256 hash of a byte slice.
pub fn hash(data: &[u8]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(data);
    hasher.finalize()
}

/// Verifies a signature against a public key.
pub fn verify(pub_key: &PublicKey, data: &[u8], signature: &[u8]) -> bool {
    pub_key.verify(data, signature).is_ok()
}
```

```rust
// INCORRECT — Dead code present
/// Computes the SHA-256 hash of a byte slice.
pub fn hash(data: &[u8]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(data);
    hasher.finalize()
}

// FORBIDDEN: Dead function — never called anywhere
fn legacy_hash(data: &[u8]) -> [u8; 20] {
    // Old SHA-1 implementation, kept for reference
    todo!()  // FORBIDDEN: todo!() in committed code
}

// FORBIDDEN: Commented-out code
// fn old_parse(data: &[u8]) -> Result<Config, Error> {
//     // Old parser implementation — delete this, use VCS history
//     let header = data.get(0..4).ok_or(Error::TooShort)?;
//     ...
// }

// FORBIDDEN: unimplemented!()
pub fn verify_v2(pub_key: &PublicKey, data: &[u8]) -> bool {
    unimplemented!()  // Either implement or remove
}
```

## Related Skills
- [standards-suckless-max-file-size](file://.opencode/skills/standards-suckless-max-file-size.md)
- [standards-suckless-doc-comments](file://.opencode/skills/standards-suckless-doc-comments.md)
