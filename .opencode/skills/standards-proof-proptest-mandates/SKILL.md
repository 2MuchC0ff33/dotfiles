---
name: standards-proof-proptest-mandates
description: Description
compatibility: opencode
---

# Skill Name: Proptest Mandates

## Description
Every `parse` function MUST have a round-trip property test. Every `serialize` function MUST have a corpus of known-good DER vectors. 10,000+ random test cases per property in CI.

## When to Load
Load this skill when writing proptest harnesses for parse/serialize functions, adding property-based tests to the test suite, or reviewing test coverage for serialization boundaries.

## Source
STANDARDS.adoc §6.3 (lines 2592–2626)

## Key Rules

- MANDATE: Every `parse` function MUST have a round-trip property test: `parse(serialize(x)) == x`
- MANDATE: Every `serialize` function MUST have a corpus of known-good DER vectors
- MANDATE: 10,000+ random test cases per property in CI
- MANDATE: Tests live in `tests/proptest/` directory
- SHOULD: Use `proptest::prop_assume!` to filter valid inputs
- SHOULD: Test invariants beyond round-trip (idempotence, ordering, algebraic properties)
- FORBIDDEN: Parse/serialize functions without property tests
- FORBIDDEN: Running proptest with fewer than 10,000 cases in CI

## Example

```rust
// CORRECT — Round-trip proptest for parse/serialize
use proptest::prelude::*;
use crate::{NetworkConfig, Hostname};

proptest! {
    /// [TESTED] Config round-trip property: parse(serialize(c)) == c for all valid configs.
    #[test]
    fn config_roundtrip(config: NetworkConfig) {
        let bytes = config.serialize_to_der();
        let parsed = NetworkConfig::parse_from_der(&bytes).unwrap();
        assert_eq!(config, parsed);
    }

    /// [TESTED] Hostname length, charset, and dot-segment constraints.
    #[test]
    fn hostname_valid_chars(hostname: String) {
        prop_assume!(hostname.len() >= 1 && hostname.len() <= 253);
        prop_assume!(hostname.chars().all(|c|
            c.is_ascii_alphanumeric() || c == '-' || c == '.'));
        let config = NetworkConfig {
            hostname: Hostname::new(&hostname).unwrap(),
            ..Default::default()
        };
        let bytes = config.serialize_to_der();
        let parsed = NetworkConfig::parse_from_der(&bytes).unwrap();
        assert_eq!(config, parsed);
    }
}

// Run in CI with:
// #[ignore = "expensive"]
// And then: cargo test --test proptest -- --include-ignored
// Or configure proptest-cases = "10000" in .config/proptest-config.toml
```

```rust
// CORRECT — Known-good DER test vectors
// tests/conformance/vectors/mod.rs
/// Known-good DER-encoded NetworkConfig values.
/// These MUST all parse successfully.
pub const KNOWN_GOOD_VECTORS: &[&[u8]] = &[
    // Minimal config: default hostname, port 443
    &[0x30, 0x0A, 0x04, 0x04, 0x6C, 0x6F, 0x63, 0x61, 0x6C, 0x02, 0x02, 0x01, 0xBB],
    // Config with TLS enabled, custom timeout
    &[0x30, 0x12, 0x04, 0x09, 0x6C, 0x6F, 0x63, 0x61, 0x6C, 0x68, 0x6F, 0x73, 0x74,
      0x02, 0x02, 0x01, 0xBB, 0x01, 0x01, 0xFF, 0x02, 0x01, 0x3C],
];

#[test]
fn known_good_vectors() {
    for (i, bytes) in KNOWN_GOOD_VECTORS.iter().enumerate() {
        let result = NetworkConfig::parse_from_der(bytes);
        assert!(result.is_ok(), "Vector {i} should parse: {:?}", result.unwrap_err());
    }
}
```

```rust
// INCORRECT — Missing property test

/// Parses config from DER bytes.
pub fn parse_from_der(bytes: &[u8]) -> Result<Config, Error> { /* ... */ }
// FORBIDDEN: public parse function without round-trip property test

/// Serializes config to DER bytes.
pub fn serialize_to_der(&self) -> Vec<u8> { /* ... */ }
// FORBIDDEN: public serialize function without known-good vectors + round-trip test
```

## Related Skills
- [standards-proof-tier-tested](file://.opencode/skills/standards-proof-tier-tested.md)
- [standards-proof-fuzz-mandates](file://.opencode/skills/standards-proof-fuzz-mandates.md)
- [standards-proof-pyramid](file://.opencode/skills/standards-proof-pyramid.md)
