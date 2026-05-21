---
name: standards-error-source-location
description: Description
compatibility: opencode
---

# Skill Name: Error Source Location

## Description
Every error MUST include source location (file and line number) of where it was created, enabling precise debugging and crash attribution.

## When to Load
Load this skill when creating error types, adding error creation sites, or debugging errors that lack location context.

## Source
STANDARDS.adoc §3.3 (line 4538)

## Key Rules

- MANDATE: Every error includes source location (`file: &'static str`, `line: u32`)
- MANDATE: Source location MUST be populated automatically at the creation site
- SHOULD: Use a macro to automatically capture `file!()` and `line!()` at the call site
- FORBIDDEN: Errors without file and line information
- FORBIDDEN: Hardcoded file/line strings (use `file!()` and `line!()` macros)

## Example

```rust
// CORRECT — Error with source location
#[derive(Debug)]
pub struct ConfigError {
    pub message: &'static str,
    pub file: &'static str,
    pub line: u32,
    pub source: Option<Box<dyn std::error::Error + Send + Sync>>,
}

// Macro to capture source location automatically
#[macro_export]
macro_rules! config_err {
    ($msg:expr) => {
        ConfigError {
            message: $msg,
            file: file!(),
            line: line!(),
            source: None,
        }
    };
    ($msg:expr, $source:expr) => {
        ConfigError {
            message: $msg,
            file: file!(),
            line: line!(),
            source: Some(Box::new($source)),
        }
    };
}

// Usage — source location captured automatically
pub fn load_config(path: &Path) -> Result<Config, ConfigError> {
    let content = std::fs::read_to_string(path)
        .map_err(|e| config_err!("failed to read config file", e))?;
    // Error now has file: "src/config.rs", line: 42
    Ok(Config::parse(&content)?)
}
```

```rust
// INCORRECT — Error without source location
#[derive(Debug)]
pub enum ConfigError {
    Io(std::io::Error),              // No file/line — FORBIDDEN
    Parse { msg: String },           // No file/line — FORBIDDEN
}
```

```rust
// INCORRECT — Hardcoded location (will be wrong after refactoring)
return Err(ConfigError {
    message: "invalid config",
    file: "src/config.rs",    // FORBIDDEN: hardcoded, use file!()
    line: 42,                 // FORBIDDEN: hardcoded, use line!()
    source: None,
});
```

## Related Skills
- [standards-error-struct-variants](file://.opencode/skills/standards-error-struct-variants.md)
- [standards-error-invariant-violation](file://.opencode/skills/standards-error-invariant-violation.md)
