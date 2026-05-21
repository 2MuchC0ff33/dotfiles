---
name: standards-proof-tier-linted
description: Description
compatibility: opencode
---

# Skill Name: Linted Tier

## Description
`[LINTED]` — Standard clippy + rustc warnings as errors. This is the minimum bar for ALL code in the codebase. Used for top-level orchestration, main function, and glue code.

## When to Load
Load this skill when annotating functions with `[LINTED]`, adding top-level orchestration code, or determining the minimum proof tier for a function.

## Source
STANDARDS.adoc §0.3.3 (line 459), §12.2 (lines 4562–4564)

## Key Rules

- MANDATE: `[LINTED]` is the minimum bar for ALL code
- MANDATE: `-Dwarnings` enforces all lints as errors
- MANDATE: `-F unsafe_code` forbids unsafe code unless explicitly audited
- MANDATE: Used for: top-level orchestration, main function, glue code, CLI argument parsing
- SHOULD: Every function in the codebase must be at least `[LINTED]`
- FORBIDDEN: Functions without any proof tier annotation (they default to `[LINTED]` minimum)
- FORBIDDEN: Using `[LINTED]` on functions that could and should be `[PROVED]` or `[TESTED]`

## Example

```rust
/// Application entry point.
///
/// [LINTED] Standard clippy + rustc warnings as errors
/// Orchestrates startup, parses CLI args, delegates to subcommands.
pub fn main() -> Result<()> {
    let args = Cli::parse();
    match args.command {
        Command::Check => run_check()?,
        Command::Build => run_build()?,
        Command::Test => run_test()?,
    }
    Ok(())
}

/// Checks if a path exists and is readable.
///
/// [LINTED] Trivial wrapper around std::fs.
pub fn path_readable(path: &Path) -> bool {
    path.try_exists().unwrap_or(false) && std::fs::metadata(path).is_ok()
}
```

```rust
/// Core cryptographic hashing function.
///
/// [LINTED]  // INCORRECT: core crypto should be [PROVED]
pub fn hash(data: &[u8]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(data);
    hasher.finalize()
}
```

```rust
/// Parses configuration from disk.
///
/// [LINTED]  // INCORRECT: parsing should be [PROVED]
pub fn load_config(path: &Path) -> Result<Config, Error> {
    let bytes = std::fs::read(path)?;
    Config::from_der(&bytes)
}
```

## Related Skills
- [standards-proof-tier-annotations](file://.opencode/skills/standards-proof-tier-annotations.md)
- [standards-proof-tier-proved](file://.opencode/skills/standards-proof-tier-proved.md)
- [standards-proof-tier-tested](file://.opencode/skills/standards-proof-tier-tested.md)
