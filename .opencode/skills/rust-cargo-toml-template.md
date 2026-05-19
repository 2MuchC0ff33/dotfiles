# Standard Cargo.toml Template

## Description
Mandatory Cargo.toml template for all Rust projects: edition 2024, rust-version 1.95.0, publish=false, standard features (std/no_std/alloc), dependency commenting rules, and profile defaults.

## When to Load
Load this skill when creating a new Rust crate, migrating an existing crate to edition 2024, or reviewing a Cargo.toml for compliance.

## Source
STANDARDS.adoc §3.1 (lines 1435–1554)

## Key Rules

- **MANDATE**: `edition = "2024"` — never 2021.
- **MANDATE**: `rust-version = "1.95.0"` — MSRV never omitted.
- **MANDATE**: `publish = false` — until explicitly ready for crates.io.
- **MANDATE**: `resolver = "3"` is implied by edition 2024.
- **MANDATE**: Every dependency SHALL have a comment justifying its use.
- **MANDATE**: Features: `default = ["std"]`, `std`, `no_std`, `alloc`.
- **SHOULD**: `readme = "README.md"` (generated from README.adoc at release).
- **SHOULD**: `exclude = [...]` lists docs/, scripts/, tests/, proofs/, fuzz/, cross/, xtask/.
- **FORBIDDEN**: Wildcard version requirements (`*`).

## Template

```toml
[package]
name          = "project-name"
version       = "0.1.0"
edition       = "2024"                      # MANDATE: 2024 edition
rust-version  = "1.95.0"                    # MANDATE: MSRV never omitted
authors       = ["Name <email@example.com>"]
description   = "One sentence description."
license       = "MIT OR Apache-2.0"
repository    = "https://github.com/org/project"
documentation = "https://docs.rs/project-name"
homepage      = "https://project.example.com"
readme        = "README.md"                 # generated from README.adoc at release

keywords      = ["keyword1", "keyword2"]
categories    = ["category1", "category2"]
exclude       = [
    "docs/",
    "scripts/",
    "tests/",
    "proofs/",
    "fuzz/",
    "cross/",
    "xtask/",
]

# MANDATE: publish = false until explicitly ready.
publish = false

# edition 2024 implies resolver = "3"

[lib]
name = "project_name"

[features]
default = ["std"]
std     = []                          # standard library (default)
no_std  = []                          # embedded / no_std mode
alloc   = []                          # alloc without full std (for no_std + alloc)

[dependencies]
# ─────────────────────────────────────────
# MANDATE: All dependencies use semver-compatible versions.
# MANDATE: Every dependency justified in a comment.
# ─────────────────────────────────────────

# ECS architecture (see Part 4 of STANDARDS)
hecs = "0.11"                         # minimal ECS, ~2000 LOC, no macros

# ASN.1/DER serialization
rasn = { version = "0.14", features = ["derive"], optional = true }
# DER is deterministic, provably unambiguous encoding.

# Error handling
thiserror = { version = "2", optional = true }  # std feature only

[dev-dependencies]
# Property-based testing for every project
proptest = "1.5"

# Test utilities
tempfile = "3"

[profile.dev]
overflow-checks  = true
debug-assertions = true
debug            = true

[profile.release]
overflow-checks  = true
debug-assertions = true
strip            = "debuginfo"
opt-level        = "z"
lto              = true
codegen-units    = 1
panic            = "abort"

[profile.test]
overflow-checks  = true
debug-assertions = true

[profile.bench]
overflow-checks  = false
debug-assertions = false
opt-level        = 3
```

## Dependency Commenting Rules

Every dependency entry MUST have an inline or top-level comment explaining WHY it is needed:

```toml
# ✅ GOOD: purpose is clear
# ECS architecture — entity-component-system for stateful apps
hecs = "0.11"

# ASN.1/DER serialization — deterministic encoding
rasn = { version = "0.14", features = ["derive"] }

# ❌ BAD: no justification
hecs = "0.11"
```

## Related Skills
- [rust-cargo-config-toml](file://.opencode/skills/rust-cargo-config-toml.md)
- [rust-cargo-lints-toml](file://.opencode/skills/rust-cargo-lints-toml.md)
- [rust-cargo-profiles](file://.opencode/skills/rust-cargo-profiles.md)
- [rust-edition-2024-features](file://.opencode/skills/rust-edition-2024-features.md)
