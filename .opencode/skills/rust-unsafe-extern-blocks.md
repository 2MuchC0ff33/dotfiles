# Unsafe Extern Blocks (Edition 2024)

## Description
Rust 2024 edition requires `unsafe extern "C"` syntax for all extern blocks. The bare `extern "C" { }` form is a hard error unless wrapped in `unsafe`.

## When to Load
Load this skill when writing or reviewing FFI declarations, extern blocks, or C ABI bindings in any crate targeting edition 2024.

## Source
STANDARDS.adoc §1.4.4.1 (lines 871–876) and §3.1 (lines 1595–1597)

## Key Rules

- **MANDATE**: All extern blocks SHALL use `unsafe extern "C"` syntax.
- **MANDATE**: `missing_unsafe_on_extern` lint SHALL be set to `"forbid"` in `[lints.rust]`.
- **MANDATE**: Every `extern` block without `unsafe` is a compilation error in edition 2024.
- **FORBIDDEN**: Bare `extern "C" { ... }` without outer `unsafe`.

## Rationale

Rust 2024 edition (stabilized in Rust 1.85+) makes `unsafe` explicit on extern blocks because FFI declarations are inherently unsafe — the caller assumes the foreign function's signature matches the actual C ABI. Making `unsafe` visible at the declaration site ensures every FFI boundary is auditable.

## Example

```rust
// ✅ CORRECT: Edition 2024 syntax
unsafe extern "C" {
    fn malloc(size: usize) -> *mut core::ffi::c_void;
    fn free(ptr: *mut core::ffi::c_void);
    fn printf(fmt: *const core::ffi::c_char, ...) -> core::ffi::c_int;
}

// ❌ ERROR: missing `unsafe` — will not compile in edition 2024
extern "C" {
    fn bad();
}
```

## Cargo.toml Enforcement

```toml
[lints.rust]
missing_unsafe_on_extern = "forbid"
```

## Related Skills
- [rust-unsafe-attr-syntax](file://.opencode/skills/rust-unsafe-attr-syntax.md)
- [rust-unsafe-blocks-in-unsafe-fn](file://.opencode/skills/rust-unsafe-blocks-in-unsafe-fn.md)
- [rust-edition-2024-lints](file://.opencode/skills/rust-edition-2024-lints.md)
