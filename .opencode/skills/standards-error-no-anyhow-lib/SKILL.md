---
name: standards-error-no-anyhow-lib
description: Description
compatibility: opencode
---

# Skill Name: No anyhow in Library Code

## Description
`anyhow::Error` is FORBIDDEN in library code — it is only permitted in xtask/binaries. `unwrap()` is FORBIDDEN in library code unless Kani has proved it is impossible to panic.

## When to Load
Load this skill when writing library code, reviewing dependencies for anyhow usage, or determining correct error handling patterns for library vs binary code.

## Source
STANDARDS.adoc §3.3 (lines 4544–4545)

## Key Rules

- MANDATE: No `anyhow::Error` in library code (only in xtask/binaries)
- MANDATE: Library code MUST use custom error types or `Box<dyn Error>`
- MANDATE: No `unwrap()` in library code unless Kani-proved impossible
- MANDATE: No `expect()` in library code unless Kani-proved impossible
- SHOULD: Use `?` operator with custom error types and `From` impls for propagation
- SHOULD: Use `#[diagnostic::do_not_recommend]` on `From` impls to suppress unhelpful compiler diagnostics
- FORBIDDEN: `anyhow::Result<T>` in library function signatures
- FORBIDDEN: `unwrap()` in library code without a Kani proof comment

## Example

```rust
// CORRECT — Library code with custom error type
use std::error::Error;
use std::fmt;
use std::io;

/// Parse error with structured fields and source chain.
#[derive(Debug)]
pub struct ParseError {
    pub message: &'static str,
    pub offset: usize,
    pub file: &'static str,
    pub line: u32,
    pub source: Option<Box<dyn Error + Send + Sync>>,
}

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Parse error at {}:{} — {}", self.file, self.line, self.message)
    }
}

impl Error for ParseError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        self.source.as_ref().map(|e| e.as_ref() as _)
    }
}

impl From<io::Error> for ParseError {
    fn from(err: io::Error) -> Self {
        Self {
            message: "IO error during parsing",
            offset: 0,
            file: file!(),
            line: line!(),
            source: Some(Box::new(err)),
        }
    }
}

// CORRECT — No unwrap, no anyhow
pub fn parse_config(bytes: &[u8]) -> Result<Config, ParseError> {
    let reader = std::io::BufReader::new(bytes);
    // Uses ? operator with From<io::Error> for ParseError
    let header = read_header(&mut reader)?;
    Config::from_header(header)
}
```

```rust
// INCORRECT — Library code using anyhow
use anyhow::{Result, anyhow};

pub fn parse_config(bytes: &[u8]) -> Result<Config> {
    // FORBIDDEN: anyhow::Result in library code
    // Library users can't inspect the error type
}
```

```rust
// INCORRECT — Library code using unwrap without proof
pub fn parse_header(bytes: &[u8]) -> Result<Header, ParseError> {
    let first = bytes.get(0).unwrap();  // FORBIDDEN: no Kani proof this can't panic
    // Use bytes.first().ok_or(...) instead — safe, structured error
}
```

```rust
// CORRECT — Library code where unwrap IS provably safe
/// Reads a 4-byte length prefix.
///
/// [PROVED] Kani harness in proofs/parser_proofs.rs
/// Panics only if slice length < 4, which is proved impossible by the
/// caller's Kani harness.
pub fn read_len_prefix(bytes: &[u8; 8]) -> u32 {
    // unwrap SAFETY: [u8; 8] has at least 4 elements — proved by Kani
    u32::from_be_bytes(bytes[..4].try_into().unwrap())
}
```

## Related Skills
- [standards-error-struct-variants](file://.opencode/skills/standards-error-struct-variants.md)
- [standards-error-error-implementation](file://.opencode/skills/standards-error-error-implementation.md)
- [standards-error-invariant-violation](file://.opencode/skills/standards-error-invariant-violation.md)
