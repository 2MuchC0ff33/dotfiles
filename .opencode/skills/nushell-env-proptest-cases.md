# nushell-env-proptest-cases

## Description
Set `$env.PROPTEST_CASES = "100000"` to configure high default iteration count for property-based testing.

## When to Load
Load this skill when reviewing or creating environment variable settings in `config.nu` or `env.nu`.

## Source
STANDARDS.adoc §11.1 (line 3675)

## Key Rules

- MANDATE: `$env.PROPTEST_CASES = "100000"` MUST be present in the ENVIRONMENT section of `config.nu`.
- SHOULD: Proptest will generate 100,000 random test cases per property by default, providing high confidence in correctness.
- FORBIDDEN: Omitting this variable (defaults to 256 cases, which is far too low for meaningful property testing). Setting a value below `10_000`.

## Rationale

The `proptest` crate for Rust generates random test cases to verify
properties of functions. The `PROPTEST_CASES` environment variable controls
how many cases are generated per property:

- **Default (256)**: Suitable for smoke tests, not rigorous verification
- **10,000**: Minimum for CI-grade property testing (catches most edge cases)
- **100,000 (this setting)**: High-confidence verification that catches
  subtle edge cases, boundary conditions, and rare state combinations
- **1,000,000+**: Exhaustive-level, used for critical security properties

At 100,000 cases with typical property test complexity, a test run takes ~5-30
seconds per property. This is the organization's standard for non-proven
(see `[TESTED]` tier in STANDARDS §12.2) property-based tests.

## Example

```nushell
$env.PROPTEST_CASES    = "100000"  # High property test count
```

Usage:
```rust
// Any proptest test will now run 100,000 cases by default
proptest! {
    #[test]
    fn parse_roundtrip(s in ".*") {
        let parsed = parse(&s);
        let serialized = format(&parsed);
        assert_eq!(s, serialized);
    }
}
```
