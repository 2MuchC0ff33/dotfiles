---
name: just-recipe-proptest
description: Description
compatibility: opencode
---

# just-recipe-proptest

## Description
Property-based testing recipe with high iteration count for thorough randomized testing.

## When to Load
Load this skill when implementing, modifying, or documenting the `proptest` recipe in the justfile, or when running property-based tests.

## Source
STANDARDS.adoc §8.1 (lines 2754–2756)

## Key Rules

- MANDATE: `proptest` MUST set `PROPTEST_CASES=100000` (100,000 test cases per proptest test).
- MANDATE: `proptest` MUST run `PROPTEST_CASES=100000 cargo test proptest -- --nocapture`.
- MANDATE: The `--nocapture` flag MUST be present so shrinking output and counterexamples are visible in real time.
- MANDATE: The test filter `proptest` in `cargo test proptest` targets tests whose names contain "proptest".
- SHOULD: Name proptest tests with the prefix `proptest` (e.g., `proptest_arithmetic`, `proptest_serialization`).
- SHOULD: Use `just proptest` during development of functions that handle complex input validation or parsing.
- SHOULD: Use `PROPTEST_CASES=100000` as the CI value; developers may use lower values (e.g., `PROPTEST_CASES=10000`) for faster iteration.
- FORBIDDEN: Do NOT set `PROPTEST_CASES` in `.cargo/config.toml` — it must be environment-specific.
- FORBIDDEN: Do NOT add `proptest` tests to the default `cargo test` runner without adjustment — proptest tests are significantly slower than unit tests.

## Example

```just
# Run property tests (proptest) with high iteration count
proptest:
    PROPTEST_CASES=100000 cargo test proptest -- --nocapture
```

Usage:
```sh
just proptest                          # Run all proptests with 100k cases
PROPTEST_CASES=10000 just proptest     # Override to 10k for faster feedback
```

## proptest Test Structure
```rust
#[test]
fn proptest_arithmetic() {
    // This test will run 100,000 times via `just proptest`
    proptest!(|(x: i32, y: i32)| {
        assert_eq!(x + y, y + x); // commutativity
    });
}
```

## Related Skills
- [just-recipe-test](file://.opencode/skills/just-recipe-test.md)
- [just-recipe-fuzz](file://.opencode/skills/just-recipe-fuzz.md)
