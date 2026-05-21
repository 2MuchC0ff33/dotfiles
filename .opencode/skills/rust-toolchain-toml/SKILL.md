---
name: rust-toolchain-toml
description: Description
compatibility: opencode
---

# Rust Toolchain Pinning (rust-toolchain.toml)

## Description
Every project SHALL lock `rust-toolchain.toml` to an exact Rust version (1.95.0) with required components and targets. This is the single source of truth for the Rust toolchain version across rustup, fenix, and crane.

## When to Load
Load this skill when initializing a new Rust project, updating the Rust toolchain version, or configuring cross-compilation targets.

## Source
STANDARDS.adoc §1.2 (lines 648–655), §1.5.2 (lines 985–1009)

## Key Rules

- **MANDATE**: `channel = "1.95.0"` — exact version pin, no `"stable"` or `"nightly"`.
- **MANDATE**: `components` SHALL include `["clippy", "rustfmt", "rust-src", "llvm-tools-preview"]`.
- **MANDATE**: `targets` SHALL include all targets the project supports.
- **MANDATE**: `rust-version` in Cargo.toml SHALL match `rust-toolchain.toml`.
- **MANDATE**: Every tool that reads the version (rustup, fenix, crane) SHALL agree on the exact version.
- **FORBIDDEN**: `channel = "stable"` or `channel = "nightly"` — no version drift.

## rust-toolchain.toml Template

```toml
[toolchain]
channel = "1.95.0"
components = ["clippy", "rustfmt", "rust-src", "llvm-tools-preview"]
targets = [
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-musl",
    "aarch64-unknown-linux-musl",
    "x86_64-pc-windows-gnu",
    "x86_64-pc-windows-msvc",
    "x86_64-unknown-freebsd14",
    "x86_64-apple-darwin",
    "aarch64-apple-darwin",
    "powerpc64-unknown-linux-musl",
    "aarch64-pc-windows-msvc",
]
```

## Component Reference

| Component | Purpose |
|---|---|
| `clippy` | Lint checking (enforced in CI) |
| `rustfmt` | Code formatting (enforced in CI) |
| `rust-src` | Source code for rust-analyzer, proc macros |
| `llvm-tools-preview` | LLVM tools (code coverage, profiling) |

## Target Selection Guidelines

Per-project: include only targets that are tested in CI. The full list above is the organizational maximum.

For minimal projects, start with:
```toml
targets = [
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
]
```

## Rationale

`rust-toolchain.toml` is the single source of truth for Rust version. Every tool that reads it agrees on the exact version:

```
rustup  → reads it to install the correct toolchain
fenix   → reads it (via fromToolchainFile) to provide rustc in Nix
crane   → reads it (via fenix override) to build in Nix sandbox
```

No more "latest stable" drift. No more CI failing because a new nightly broke something.

## Related Skills
- [rust-nix-flake-structure](file://.opencode/skills/rust-nix-flake-structure.md)
- [rust-nix-dev-shell](file://.opencode/skills/rust-nix-dev-shell.md)
- [rust-flake-lock-committed](file://.opencode/skills/rust-flake-lock-committed.md)
- [rust-cargo-toml-template](file://.opencode/skills/rust-cargo-toml-template.md)
