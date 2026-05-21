---
name: standards-suckless-no-builder-overuse
description: Description
compatibility: opencode
---

# Skill Name: No Builder Pattern Overuse

## Description
Builder patterns are FORBIDDEN when a constructor with named fields suffices. The builder pattern is reserved exclusively for cases with more than 5 optional parameters.

## When to Load
Load this skill when designing a new type with construction logic, reviewing PRs that introduce builder patterns, or refactoring unnecessary builders.

## Source
STANDARDS.adoc §0.1.3 (lines 112–113)

## Key Rules

- FORBIDDEN: Builder patterns when a constructor with named fields suffices
- FORBIDDEN: Builders for types with ≤5 optional parameters
- MANDATE: Builder pattern reserved for cases with >5 optional parameters
- MANDATE: Types with few required parameters and ≤5 optional parameters MUST use a plain struct with public fields or a simple `new()` constructor
- SHOULD: Use `..Default::default()` for types with sensible defaults
- SHOULD: Consider using the "cascade pattern" or constructor functions instead of builder for small numbers of parameters

## Example

```rust
// CORRECT — Simple struct with public fields (≤5 optional params)
/// Configuration for a network connection.
#[derive(Debug, Clone)]
pub struct Config {
    pub host: String,
    pub port: u16,
    pub timeout_secs: u64,        // optional
    pub tls: bool,                // optional
    pub keepalive: Option<u64>,   // optional
}

impl Config {
    pub fn new(host: &str, port: u16) -> Self {
        Self {
            host: host.to_string(),
            port,
            timeout_secs: 30,
            tls: true,
            keepalive: None,
        }
    }
}

// Usage
let cfg = Config {
    timeout_secs: 60,
    ..Config::new("localhost", 8080)
};
```

```rust
// INCORRECT — Unnecessary builder (only 3 optional params)
pub struct ConfigBuilder {
    host: String,
    port: u16,
    timeout: Option<u64>,
    tls: Option<bool>,
}

impl ConfigBuilder {
    pub fn new(host: &str, port: u16) -> Self {
        Self { host: host.into(), port, timeout: None, tls: None }
    }
    pub fn timeout(mut self, t: u64) -> Self { self.timeout = Some(t); self }
    pub fn tls(mut self, t: bool) -> Self { self.tls = Some(t); self }
    pub fn build(self) -> Result<Config, Error> {
        Ok(Config {
            host: self.host,
            port: self.port,
            timeout_secs: self.timeout.unwrap_or(30),
            tls: self.tls.unwrap_or(true),
        })
    }
}
// This builder has only 3 optional params — FORBIDDEN
// A plain struct with named fields is simpler and clearer.
```

```rust
// CORRECT — Builder justified (>5 optional params)
pub struct ConnectionConfig {
    pub host: String,
    pub port: u16,
    pub timeout_secs: u64,
    pub tls: bool,
    pub keepalive_secs: Option<u64>,
    pub max_retries: u32,
    pub backoff_base_ms: u64,
    pub backoff_max_ms: u64,
    pub proxy: Option<String>,
}
// 9 optional params — builder is justified (>5)
```

## Related Skills
- [standards-suckless-one-purpose](file://.opencode/skills/standards-suckless-one-purpose.md)
- [standards-suckless-inline-over-deps](file://.opencode/skills/standards-suckless-inline-over-deps.md)
