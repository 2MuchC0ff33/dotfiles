# Nupm Test Integration

## Description
SHOULD: Use `nupm test` when working within a nupm-managed project.

## When to Load
Load this skill when testing within a project that uses nupm (Nushell Package Manager).

## Source
STANDARDS.adoc §11.5.12 (lines 4548–4557)

## Key Rules

- SHOULD: Use `nupm test` when working within a nupm-managed project
- MANDATE: ALL exported commands in shared modules SHALL have tests
- Tests SHALL be placed in a `tests/` subdirectory relative to the module

## Rationale

`nupm test` integrates with Nushell's standard test runner conventions, discovers `#[test]` attributes, and provides structured test output. Using `nupm` ensures consistent test execution across contributors.

## Example

```bash
# Run all tests in nupm project
nupm test

# Run tests with verbose output
nupm test --verbose

# Run tests for specific module
nupm test --module utils

# Run tests in CI
nupm test --no-capture   # show stdout/stderr

# nupm-compatible test file structure:
# my-project/
# ├── nupm.nu              # package definition
# ├── src/
# │   └── lib.nu           # module with exported commands
# └── tests/
#     ├── lib.test.nu      # tests
#     └── integration.test.nu  # integration tests
```
