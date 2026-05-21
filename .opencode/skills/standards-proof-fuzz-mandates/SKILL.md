---
name: standards-proof-fuzz-mandates
description: Description
compatibility: opencode
---

# Skill Name: Fuzz Mandates

## Description
Every function that accepts `&[u8]` from external sources MUST have a fuzz target. CI runs each fuzz target for a minimum of 5 minutes.

## When to Load
Load this skill when writing fuzz targets for I/O boundaries, adding parsing functions that accept raw byte slices, or reviewing fuzz coverage for external input handling.

## Source
STANDARDS.adoc §6.4 (lines 2628–2649)

## Key Rules

- MANDATE: Every function accepting `&[u8]` from external sources MUST have a fuzz target
- MANDATE: CI runs each fuzz target for minimum 5 minutes (300 seconds)
- MANDATE: Fuzz targets MUST NOT panic on ANY input (return errors gracefully)
- MANDATE: Fuzz targets live in `fuzz/fuzz_targets/`
- MANDATE: `cargo-fuzz` requires a nightly toolchain; `fuzz/rust-toolchain.toml` SHALL set `channel = "nightly"`
- SHOULD: Test both valid and invalid input patterns
- SHOULD: Use `libfuzzer_sys::fuzz_target!` macro
- FORBIDDEN: Public `&[u8]`-accepting functions without fuzz targets
- FORBIDDEN: Fuzz targets shorter than 5 minutes in CI

## Example

```rust
// CORRECT — Fuzz target for DER parser
// fuzz/fuzz_targets/der_parser.rs
#![no_main]

use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    // Fuzz the DER parser with arbitrary byte sequences.
    // The parser MUST NOT panic on ANY input — valid or invalid.
    let _ = NetworkConfig::parse_from_der(data);
    // ^^ Note: we ignore the Result — the parser must not panic
    //    whether the input is valid OR invalid.
});
```

```rust
// CORRECT — Fuzz target for configuration parser
// fuzz/fuzz_targets/config_parser.rs
#![no_main]

use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    // Fuzz the config parser. Accepts TOML-like configuration bytes.
    // MUST NOT panic on any byte sequence.
    let _ = ConfigParser::parse(data);
});
```

```yaml
# CORRECT — CI fuzz configuration
# In CI workflow:
- name: Run fuzz targets
  run: |
    cargo fuzz run der_parser -- -max_total_time=300
    cargo fuzz run config_parser -- -max_total_time=300
    cargo fuzz run state_machine -- -max_total_time=300
  timeout-minutes: 20
```

```rust
// INCORRECT — Fuzz target that panics
fuzz_target!(|data: &[u8]| {
    let result = NetworkConfig::parse_from_der(data);
    // FORBIDDEN: unwrap will panic on invalid input, crashing the fuzzer
    let config = result.unwrap();
    // The parser MUST handle any input gracefully — return Err, don't panic
});
```

```rust
// INCORRECT — Public &[u8] function without fuzz target
/// Parses a raw protocol message from bytes.
///
/// [TESTED]  // Wrong tier: should have fuzz target
pub fn parse_message(bytes: &[u8]) -> Result<Message, Error> {
    // Takes &[u8] from network — MUST have a fuzz target
    // Missing fuzz/fuzz_targets/message_parser.rs
}
```

## Related Skills
- [standards-proof-proptest-mandates](file://.opencode/skills/standards-proof-proptest-mandates.md)
- [standards-proof-pyramid](file://.opencode/skills/standards-proof-pyramid.md)
- [standards-proof-tier-tested](file://.opencode/skills/standards-proof-tier-tested.md)
