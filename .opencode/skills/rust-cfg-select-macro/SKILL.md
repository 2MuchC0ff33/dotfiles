---
name: rust-cfg-select-macro
description: Description
compatibility: opencode
---

# cfg_select! Macro (Built-in Since Rust 1.95.0)

## Description
Use `cfg_select!` instead of the `cfg-if` crate for compile-time conditional branching. `cfg_select!` is built into `core` since Rust 1.95.0 and requires no dependencies.

## When to Load
Load this skill when writing compile-time conditional code, platform-specific implementations, or feature-gated logic.

## Source
STANDARDS.adoc §1.4.4.1 (lines 882–884) and §3.1 (lines 1482)

## Key Rules

- **MANDATE**: All compile-time cfg branching SHALL use `cfg_select!` (built-in) instead of the `cfg-if` crate.
- **MANDATE**: The `cfg-if` crate SHALL NOT be added as a dependency — `cfg_select!` replaces it completely.
- **SHOULD**: Use `core::cfg_select!` (no import needed) or `std::cfg_select!`.
- **MANDATE**: MSRV (1.95.0) guarantees `cfg_select!` availability.

## Rationale

The `cfg-if` crate has been a ubiquitous dependency for conditional compilation since 2016. Rust 1.95.0 stabilizes `cfg_select!` as a built-in macro in `core`, eliminating the need for a third-party dependency with the same semantics. This reduces dependency count, audit surface, and build time.

## Example

```rust
// ✅ CORRECT: Built-in cfg_select! — no dependency needed
use core::cfg_select;

cfg_select! {
    target_os = "linux" => {
        println!("Linux-specific implementation");
    }
    target_os = "macos" => {
        println!("macOS-specific implementation");
    }
    target_os = "windows" => {
        println!("Windows-specific implementation");
    }
    _ => {
        println!("Unsupported target");
    }
}

// ✅ CORRECT: Feature-based selection
cfg_select! {
    feature = "no_std" => {
        #![no_std]
    }
    feature = "std" => {
        extern crate std;
    }
    _ => {}
}
```

## Migration from cfg-if

```rust
// BEFORE: depends on cfg-if crate
cfg_if::cfg_if! {
    if #[cfg(target_os = "linux")] { /* ... */ }
    else if #[cfg(target_os = "macos")] { /* ... */ }
}

// AFTER: no dependency needed
core::cfg_select! {
    target_os = "linux" => { /* ... */ }
    target_os = "macos" => { /* ... */ }
}
```

## Cargo.toml Effect

Remove `cfg-if` from `[dependencies]`:
```toml
# ❌ REMOVE:
# cfg-if = "1.0"

# ✅ No addition needed — cfg_select! is built-in
```

## Related Skills
- [rust-edition-2024-features](file:///opencode/skills/rust-edition-2024-features.md)
- [rust-cargo-toml-template](file://.opencode/skills/rust-cargo-toml-template.md)
