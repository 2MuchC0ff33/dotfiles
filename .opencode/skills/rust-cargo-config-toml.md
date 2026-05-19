# Cargo Config (.cargo/config.toml)

## Description
Standard `.cargo/config.toml` configuration for all Rust projects: strict compiler flags, Zig linker for cross-compilation, registry configuration, and CI-specific settings.

## When to Load
Load this skill when initializing a new Rust project, configuring cross-compilation, or setting up CI build pipelines.

## Source
STANDARDS.adoc §1.1 (lines 588–593), §1.2 (lines 648–672), §1.3 (lines 674–714)

## Key Rules

- **MANDATE**: `-Dwarnings` SHALL be set in `[target.'cfg(all())'.rustflags]`.
- **MANDATE**: `-F unsafe_code` SHALL be set in CI rustflags (projects with FFI may override).
- **MANDATE**: Zig linker SHALL be configured for cross targets via `[target.TRIPLE]` sections.
- **MANDATE**: `cargo xtask` SHALL be aliased for discoverability.
- **SHOULD**: Sparse protocol (`sparse+https://`) SHALL be configured for crates.io.
- **MANDATE**: `--offline` SHALL be used in CI to prevent network access during builds.
- **FORBIDDEN**: Non-mirror registries without explicit project governance approval.

## Config Template

```toml
# .cargo/config.toml — project-wide cargo configuration

# ─────────────────────────────────────────
# COMPILER FLAGS
# ─────────────────────────────────────────
[target.'cfg(all())']
rustflags = [
    "-Dwarnings",              # deny all warnings in CI
    "-F unsafe_code",          # forbid unsafe (override per-project if FFI needed)

    # Edition 2024 compatibility enforcement
    "-D missing_unsafe_on_extern",
    "-D unsafe_attr_outside_unsafe",
    "-D unsafe_op_in_unsafe_fn",
]

# ─────────────────────────────────────────
# SPARSE PROTOCOL (faster registry access)
# ─────────────────────────────────────────
[registries.crates-io]
protocol = "sparse"

# ─────────────────────────────────────────
# CROSS TARGETS: Zig linker
# Each target uses Zig cc for static linking.
# ─────────────────────────────────────────
[target.x86_64-unknown-linux-musl]
linker = "zig"
rustflags = ["-C", "target-feature=+crt-static"]

[target.aarch64-unknown-linux-musl]
linker = "zig"
rustflags = ["-C", "target-feature=+crt-static"]

[target.x86_64-pc-windows-gnu]
linker = "zig"

[target.wasm32-wasi]
linker = "zig"

# ─────────────────────────────────────────
# ALIASES
# ─────────────────────────────────────────
[alias]
xtask    = "run --package xtask --"
check    = "run --package xtask -- check"
lint     = "run --package xtask -- lint"
test     = "run --package xtask -- test"
docs     = "run --package xtask -- docs"
audit    = "run --package xtask -- audit"
cross    = "run --package xtask -- cross"
ci       = "run --package xtask -- ci"
```

## CI-Only Overrides

In CI pipelines, use environment variables or a CI-specific config layer:

```bash
# CI enforces offline builds
CARGO_NET_OFFLINE=true cargo build --release

# CI escalates warnings to errors
RUSTFLAGS="-D warnings -F unsafe_code" cargo check
```

## Related Skills
- [rust-cargo-lints-toml](file://.opencode/skills/rust-cargo-lints-toml.md)
- [rust-cargo-toml-template](file://.opencode/skills/rust-cargo-toml-template.md)
- [rust-cargo-profiles](file://.opencode/skills/rust-cargo-profiles.md)
- [rust-toolchain-toml](file://.opencode/skills/rust-toolchain-toml.md)
