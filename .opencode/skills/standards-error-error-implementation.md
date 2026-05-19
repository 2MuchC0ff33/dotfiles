# Skill Name: Error Implementation

## Description
Every error type MUST implement `std::error::Error` with a proper `source()` chain, enabling error propagation and introspection.

## When to Load
Load this skill when defining new error types, implementing `std::error::Error` trait, or setting up error source chains.

## Source
STANDARDS.adoc §12.1 (line 4542)

## Key Rules

- MANDATE: Every public error type MUST implement `std::error::Error`
- MANDATE: The `source()` method MUST return the underlying cause if one exists
- MANDATE: Error chains MUST preserve the full causal path (inner → outer)
- SHOULD: Implement `Display` to provide a human-readable description
- SHOULD: Implement `Error` with `source()` delegating to inner error
- FORBIDDEN: Error types that don't implement `std::error::Error`
- FORBIDDEN: Returning `None` from `source()` when there IS an underlying error

## Example

```rust
// CORRECT — Error with full source chain
use std::error::Error;
use std::fmt;

#[derive(Debug)]
#[non_exhaustive]
pub struct ConfigError {
    pub kind: ConfigErrorKind,
    pub file: &'static str,
    pub line: u32,
}

#[derive(Debug)]
#[non_exhaustive]
pub enum ConfigErrorKind {
    Io(std::io::Error),
    Parse { message: &'static str, offset: usize },
}

impl fmt::Display for ConfigError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Config error at {}:{} — {:?}", self.file, self.line, self.kind)
    }
}

impl Error for ConfigError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match &self.kind {
            ConfigErrorKind::Io(err) => Some(err),  // Source chain: ConfigError → io::Error
            ConfigErrorKind::Parse { .. } => None,   // Leaf error — no chain
        }
    }
}

// Usage — error chain is preserved:
// ConfigError → io::Error → OS error code
// Callers can inspect the full chain with .source()
```

```rust
// INCORRECT — Missing Error impl or source chain
#[derive(Debug)]
pub struct ConfigError {  // FORBIDDEN: no Error impl
    pub message: String,
}
// This type cannot be used with `?` operator in functions returning Result<T, impl Error>
```

```rust
// INCORRECT — Broken source chain
impl Error for ConfigError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        None  // FORBIDDEN: returns None even though Io variant has an inner error
    }
}
// Callers can't determine the root cause of Io errors
```

## Related Skills
- [standards-error-struct-variants](file://.opencode/skills/standards-error-struct-variants.md)
- [standards-error-source-location](file://.opencode/skills/standards-error-source-location.md)
- [standards-error-non-exhaustive](file://.opencode/skills/standards-error-non-exhaustive.md)
