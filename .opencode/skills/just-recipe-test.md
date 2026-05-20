# just-recipe-test

## Description
Test recipes: default test runner, verbose output, and single-test execution.

## When to Load
Load this skill when implementing, modifying, or documenting the `test`, `test-verbose`, or `test-one` recipes in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2734–2744)

## Key Rules

- MANDATE: `test` MUST run `cargo xtask test` (delegates to xtask for full test orchestration).
- MANDATE: `test-verbose` MUST use `cargo test --all-targets --all-features -- --nocapture` directly in just (not via xtask).
- MANDATE: `test-one NAME` MUST use `cargo test --all-targets --all-features -- {{NAME}} --nocapture` with the NAME positional argument.
- MANDATE: `test-verbose` and `test-one` use `--all-targets --all-features` for maximum coverage.
- MANDATE: `test-one` passes the test name filter via `{{NAME}}` (just syntax for positional arguments).
- SHOULD: Use `test-verbose` when debugging failing tests to see stdout/stderr output.
- SHOULD: Use `test-one NAME` during rapid iteration on a single test or integration test.
- SHOULD: Use plain `test` before `just check` (test is a subset of check).
- FORBIDDEN: Do NOT add `--nocapture` to the default `test` recipe — output should be concise for CI runs.
- FORBIDDEN: Do NOT use xtask for `test-verbose` or `test-one` — they are simple direct invocations that don't need the indirection.

## Examples

```just
# Run tests only
test:
    cargo xtask test

# Run tests with output shown
test-verbose:
    cargo test --all-targets --all-features -- --nocapture

# Run a single test by name
test-one NAME:
    cargo test --all-targets --all-features -- {{NAME}} --nocapture
```

Usage:
```sh
just test                        # Run all tests via xtask
just test-verbose                # Run all tests with stdout/stderr
just test-one my_test_name       # Run only tests matching "my_test_name"
```

## Related Skills
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [just-recipe-proptest](file://.opencode/skills/just-recipe-proptest.md)
- [just-recipe-fuzz](file://.opencode/skills/just-recipe-fuzz.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
