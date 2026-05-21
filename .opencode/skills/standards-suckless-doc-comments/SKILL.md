---
name: standards-suckless-doc-comments
description: Description
compatibility: opencode
---

# Skill Name: Doc Comments on Public Items

## Description
Every public item MUST have a doc comment explaining what it is, what it does, and (if applicable) when it panics.

## When to Load
Load this skill when writing new public API, reviewing PRs for documentation completeness, or adding missing doc comments.

## Source
STANDARDS.adoc §0.1.3 (lines 107–108)

## Key Rules

- MANDATE: Every `pub fn`, `pub struct`, `pub enum`, `pub trait`, `pub const`, `pub type` MUST have a doc comment (`///`)
- MANDATE: Doc comments MUST explain WHAT the item is, WHAT it does, and WHEN it panics
- MANDATE: If a function can panic, the doc comment MUST document the panic condition(s)
- SHOULD: Include example code in doc comments for non-trivial APIs
- SHOULD: Include `# Errors` section for functions that return `Result`
- SHOULD: Include `# Safety` section for `unsafe` functions
- FORBIDDEN: Public items without doc comments
- FORBIDDEN: Stub doc comments like `/// Does stuff.` or `/// A struct.` that add no value

## Example

```rust
// CORRECT — Comprehensive doc comment
/// Configuration for the network connection.
///
/// Controls timeouts, retry behavior, and TLS settings for outbound
/// connections to peer nodes. Created via [`ConfigBuilder`].
///
/// # Panics
///
/// Panics if the keepalive interval is set to 0.
#[derive(Debug, Clone)]
pub struct NetworkConfig {
    /// Connection timeout in seconds (default: 30).
    pub timeout_secs: u64,
    /// Maximum retry attempts (default: 3).
    pub max_retries: u32,
}

/// Opens a TCP connection to the given address.
///
/// Resolves the address, performs a TCP handshake, and returns a
/// connected stream wrapped in TLS if encryption is requested.
///
/// # Errors
///
/// Returns `io::Error` if DNS resolution fails, the connection is
/// refused, or the TLS handshake fails.
///
/// # Panics
///
/// Panics if `addr` is an invalid socket address format.
pub fn connect(addr: &str, tls: bool) -> io::Result<TcpStream> { /* ... */ }
```

```rust
// INCORRECT — Missing or poor doc comments
pub struct NetworkConfig {  // FORBIDDEN: no doc comment
    pub timeout_secs: u64,
    pub max_retries: u32,
}

/// Connect.
pub fn connect(addr: &str, tls: bool) -> io::Result<TcpStream> {
    // "Connect." tells the reader nothing about parameters, errors, or panics
    unimplemented!()
}

/// A helper function.
pub fn helper() {
    // "A helper function." is a stub comment — no useful information
}
```

## Related Skills
- [standards-suckless-no-dead-code](file://.opencode/skills/standards-suckless-no-dead-code.md)
- [standards-proof-tier-annotations](file://.opencode/skills/standards-proof-tier-annotations.md)
