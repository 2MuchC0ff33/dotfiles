---
name: standards-error-non-exhaustive
description: Description
compatibility: opencode
---

# Skill Name: Non-Exhaustive Error Enums

## Description
Every error enum MUST be annotated with `#[non_exhaustive]` to allow adding new variants without breaking the public API.

## When to Load
Load this skill when defining new error enums, reviewing public error types for API stability, or extending an existing error enum with new variants.

## Source
STANDARDS.adoc §3.3 (line 4539)

## Key Rules

- MANDATE: Every public error enum MUST use `#[non_exhaustive]`
- MANDATE: Consumers MUST match with a wildcard arm (`_ =>`) to handle future variants
- SHOULD: Also apply `#[non_exhaustive]` to error structs if they may gain fields
- FORBIDDEN: Public error enums without `#[non_exhaustive]`
- FORBIDDEN: Releasing a library error enum as exhaustive (breaks semver on variant addition)

## Example

```rust
// CORRECT — Non-exhaustive error enum
/// Errors that can occur during configuration parsing.
#[derive(Debug)]
#[non_exhaustive]  // Allows adding variants without breaking API
pub enum ConfigError {
    Io(std::io::Error),
    Parse {
        message: &'static str,
        offset: usize,
        file: &'static str,
        line: u32,
    },
    Validation {
        field: &'static str,
        reason: &'static str,
    },
}

// Consumers MUST handle with wildcard:
match error {
    ConfigError::Io(e) => println!("IO error: {e}"),
    ConfigError::Parse { message, .. } => println!("Parse error: {message}"),
    ConfigError::Validation { field, reason } => println!("{field}: {reason}"),
    _ => println!("Unknown error (new variant added in future version)"),
    // ^^ Wildcard required because enum is #[non_exhaustive]
}
```

```rust
// INCORRECT — Exhaustive error enum
/// Errors during configuration parsing.
#[derive(Debug)]
pub enum ConfigError {  // FORBIDDEN: missing #[non_exhaustive]
    Io(std::io::Error),
    Parse(String),
    Unknown,
}
// Adding a variant later breaks every downstream match statement — semver violation
```

```rust
// CORRECT — #[non_exhaustive] on struct too
/// Error context for a failed operation.
#[derive(Debug)]
#[non_exhaustive]
pub struct OperationError {
    pub operation: &'static str,
    pub reason: &'static str,
    pub file: &'static str,
    pub line: u32,
}
// Fields can be added in future without breaking API
```

## Related Skills
- [standards-error-struct-variants](file://.opencode/skills/standards-error-struct-variants.md)
- [standards-error-error-implementation](file://.opencode/skills/standards-error-error-implementation.md)
