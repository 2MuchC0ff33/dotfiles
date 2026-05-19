# Skill Name: Error Struct Variants

## Description
Every error variant is a struct with named fields (no stringly-typed errors). Catch-all variants like `Error::Other(String)` are FORBIDDEN.

## When to Load
Load this skill when defining new error types, reviewing error enum definitions, or refactoring stringly-typed error handling.

## Source
STANDARDS.adoc §12.1 (lines 4536–4546)

## Key Rules

- MANDATE: Every error variant is a struct with named fields
- MANDATE: Every variant provides structured data, not human-readable strings
- FORBIDDEN: `Error::Other(String)` catch-all variants
- FORBIDDEN: `Error::Custom(Box<dyn Error>)` opaque variants
- FORBIDDEN: Tuple variants like `Error::Io(i32)` without field names
- SHOULD: Use `#[error]` derive or manual Display that formats the structured fields
- SHOULD: Include context fields like `expected`, `found`, `offset` that help debugging

## Example

```rust
// CORRECT — Error variants with named struct fields
#[derive(Debug)]
#[non_exhaustive]
pub enum ParseError {
    InvalidHeader {
        found: u8,
        expected: u8,
        offset: usize,
    },
    Truncated {
        expected_bytes: usize,
        actual_bytes: usize,
        offset: usize,
    },
    UnknownTag {
        tag: u8,
        offset: usize,
        context: &'static str,
    },
}
```

```rust
// INCORRECT — Stringly-typed and catch-all variants
#[derive(Debug)]
pub enum ParseError {
    // FORBIDDEN: Catch-all variant with String
    Other(String),

    // FORBIDDEN: Tuple variant without named fields
    Io(i32),

    // FORBIDDEN: Variable data as string
    InvalidFormat(String),

    // FORBIDDEN: Opaque boxed error
    Custom(Box<dyn std::error::Error>),
}
```

```rust
// INCORRECT — Using string for structured error
pub fn parse_header(bytes: &[u8]) -> Result<Header, ParseError> {
    if bytes.is_empty() {
        return Err(ParseError::Other(
            "empty bytes".to_string()  // FORBIDDEN: stringly-typed
        ));
    }
    // No structured data — caller can't handle this error programmatically
}
```

## Related Skills
- [standards-error-source-location](file://.opencode/skills/standards-error-source-location.md)
- [standards-error-non-exhaustive](file://.opencode/skills/standards-error-non-exhaustive.md)
- [standards-error-error-implementation](file://.opencode/skills/standards-error-error-implementation.md)
