# Cargo Profile Settings

## Description
Standard Cargo profile configuration across all Rust projects: debug, release, test, and bench profiles with mandatory overflow-checks, LTO, and panic settings.

## When to Load
Load this skill when configuring Cargo.toml profiles, optimizing for release size/speed, or ensuring Kani proof compatibility.

## Source
STANDARDS.adoc §3.1 (lines 1532–1554)

## Key Rules

- **MANDATE**: `overflow-checks = true` in ALL of dev, release, and test profiles.
- **MANDATE**: `debug-assertions = true` in release profile — Kani proof coverage requires them.
- **MANDATE**: `panic = "abort"` in release — smaller binary, no unwind tables.
- **MANDATE**: `lto = true` in release — link-time optimization.
- **MANDATE**: `codegen-units = 1` in release — single CGU for best optimization.
- **MANDATE**: `opt-level = "z"` in release — optimize for size by default.
- **SHOULD**: `strip = "debuginfo"` in release — strip debug but keep panic info.
- **SHOULD**: `overflow-checks = false` in bench profile — performance measurement.

## Profile Template

```toml
[profile.dev]
# Development: fast compilation, debug symbols, full safety checks.
overflow-checks  = true               # catch integer overflow in development
debug-assertions = true
debug            = true

[profile.release]
# MANDATE: overflow checks in release too — proof relies on defined behavior.
overflow-checks  = true
debug-assertions = true               # MANDATE: keep assertions for Kani proof coverage
strip            = "debuginfo"        # strip debug info but keep panic info
opt-level        = "z"                # optimize for size by default
lto              = true               # link-time optimization
codegen-units    = 1                  # single codegen unit for best optimization
panic            = "abort"            # abort on panic (smaller binary, no unwind tables)

[profile.test]
# Test: fastest iteration, full safety checks, no optimization.
overflow-checks  = true
debug-assertions = true

[profile.bench]
# Benchmark: performance measurement, disable safety overhead.
overflow-checks  = false              # benchmarks disable overflow checks for performance
debug-assertions = false
opt-level        = 3                  # optimize for speed in benchmarks
```

## Rationale

| Setting | Reason |
|---|---|
| `overflow-checks = true` everywhere except bench | Undefined behavior from overflow breaks Kani proofs. Kani assumes defined operations. This applies even in release builds. |
| `debug-assertions = true` in release | Kani proof harnesses often rely on debug assertions for contract enforcement. Removing them invalidates proof coverage. |
| `panic = "abort"` | Eliminates unwind tables (~30% binary size reduction). Abort-on-panic is deterministic; unwinding across FFI boundaries is UB. |
| `codegen-units = 1` | Single CGU enables cross-crate inlining and full-program optimization at the cost of compile time. Release builds are CI-only, so compile time is acceptable. |
| `opt-level = "z"` | Binary size over speed. Most projects benefit more from smaller binaries (CI artifact transfer, Docker images, WASM payloads). Override per-crate if benchmarks show regression. |
| `strip = "debuginfo"` | Removes DWARF sections (~50% binary size reduction) while keeping `.debug_policies` and `.eh_frame` for panic backtraces. |

## Related Skills
- [rust-cargo-toml-template](file://.opencode/skills/rust-cargo-toml-template.md)
- [rust-cargo-config-toml](file://.opencode/skills/rust-cargo-config-toml.md)
- [rust-cargo-lints-toml](file://.opencode/skills/rust-cargo-lints-toml.md)
