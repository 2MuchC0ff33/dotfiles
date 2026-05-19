# Skill Name: Proof Tier Annotations

## Description
Every public function MUST be annotated with exactly one of `[PROVED]`, `[TESTED]`, `[LINTED]`, or `[FFI_AUDITED]` in its doc comment. CI SHALL fail if a public function lacks this annotation.

## When to Load
Load this skill when writing new public functions, reviewing PRs for annotation completeness, or adding missing proof tier annotations to existing code.

## Source
STANDARDS.adoc §0.3.3 (lines 459–507), §12.2 (lines 4548–4569)

## Key Rules

- MANDATE: Every public function MUST have exactly one of `[PROVED]`, `[TESTED]`, `[LINTED]`, or `[FFI_AUDITED]` in its doc comment
- MANDATE: CI SHALL fail if a `pub fn` lacks a proof tier annotation
- MANDATE: The annotation MUST appear in the first paragraph of the doc comment
- SHOULD: Include details about what is proved, test coverage, and harness location
- FORBIDDEN: mixing multiple tier annotations on the same function (pick the highest applicable)
- FORBIDDEN: `[LINTED]` on functions that could and should be `[PROVED]`

## Example

```rust
// CORRECT — All four tier annotations

/// Parses a DER-encoded certificate.
///
/// [PROVED] Kani harness in proofs/harnesses/der_proofs.rs
/// - Asserts: no panic on any valid DER input
/// - Asserts: no panic on any invalid DER input (returns ParseError)
/// - Bounds: max input 16MB, max nesting 32
pub fn parse_certificate(bytes: &[u8]) -> Result<Certificate, ParseError> { /* ... */ }

/// Sends a packet over the network.
///
/// [TESTED] proptest in tests/proptest/network.rs
/// - Properties: send + receive roundtrip, ordering preserved
/// - Coverage: 10_000 random payload sizes and distributions
/// Note: Kani cannot prove syscall behavior.
pub fn send_packet(conn: &mut Connection, payload: &[u8]) -> io::Result<()> { /* ... */ }

/// Main entry point.
///
/// [LINTED] Standard clippy + rustc warnings as errors
/// This is the minimum bar for ALL code.
pub fn main() -> Result<()> { /* ... */ }

/// FFI bridge to the C library.
///
/// [FFI_AUDITED] SAFETY reviewed by @alice and @bob on 2024-03-15
/// - Unsafe block #1: pointer dereference (line 127), validated non-null + aligned
/// - Unsafe block #2: FFI call (line 132), function pointer validated at init
pub unsafe fn blazing_fast_hash(input: &[u8]) -> u64 { /* ... */ }
```

```rust
// INCORRECT — Missing or wrong annotations

/// Parses config from bytes.
// Missing proof tier annotation — CI SHALL fail
pub fn parse_config(bytes: &[u8]) -> Result<Config, Error> { /* ... */ }

/// Sends data.
///
/// [LINTED] [TESTED]  // FORBIDDEN: mixing tiers, pick the highest
pub fn send(data: &[u8]) -> io::Result<()> { /* ... */ }

/// Core cryptographic operation.
///
/// [LINTED]  // INCORRECT: core crypto should be [PROVED]
pub fn encrypt(key: &Key, data: &[u8]) -> Vec<u8> { /* ... */ }
```

## Related Skills
- [standards-proof-tier-proved](file://.opencode/skills/standards-proof-tier-proved.md)
- [standards-proof-tier-tested](file://.opencode/skills/standards-proof-tier-tested.md)
- [standards-proof-tier-linted](file://.opencode/skills/standards-proof-tier-linted.md)
- [standards-proof-tier-ffi-audited](file://.opencode/skills/standards-proof-tier-ffi-audited.md)
