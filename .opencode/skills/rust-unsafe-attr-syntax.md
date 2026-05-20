# Unsafe Attribute Syntax (Edition 2024)

## Description
All unsafe attributes (`no_mangle`, `export_name`, `link_section`) MUST use the `#[unsafe(...)]` wrapper syntax in edition 2024. Bare attributes are a hard error.

## When to Load
Load this skill when writing or reviewing any attribute that controls linkage, symbol names, or section placement.

## Source
STANDARDS.adoc §1.4.4.1 (lines 872–877) and §3.1 (lines 1592–1593)

## Key Rules

- **MANDATE**: `#[unsafe(no_mangle)]` — never `#[no_mangle]`.
- **MANDATE**: `#[unsafe(export_name = "...")]` — never `#[export_name = "..."]`.
- **MANDATE**: `#[unsafe(link_section = "...")]` — never `#[link_section = "..."]`.
- **MANDATE**: `unsafe_attr_outside_unsafe` lint SHALL be set to `"forbid"` in `[lints.rust]`.
- **FORBIDDEN**: Bare `#[no_mangle]`, `#[export_name]`, `#[link_section]` — all MUST be wrapped in `#[unsafe(...)]`.

## Rationale

In edition 2024, the `unsafe_attr_outside_unsafe` lint (previously `unsafe_attr_outside_unsafe`) is elevated to a hard error. These attributes affect the ABI, symbol visibility, and memory layout — operations that can cause undefined behavior if incorrect. The `unsafe` wrapper makes the risk explicit at the attribute site.

## Example

```rust
// ✅ CORRECT: Edition 2024 syntax
#[unsafe(no_mangle)]
pub fn my_function() -> i32 { 42 }

#[unsafe(export_name = "rust_alloc")]
pub fn my_alloc(size: usize) -> *mut core::ffi::c_void {
    core::ptr::null_mut()
}

#[unsafe(link_section = ".my_custom_section")]
pub static MY_DATA: u32 = 42;

// ❌ ERROR: bare attributes — will not compile in edition 2024
#[no_mangle]
pub fn old_way() {}

#[export_name = "bad"]
pub fn also_bad() {}
```

## Common Migration

For migration from pre-2024 editions, run:
```
cargo fix --edition
```
This automatically wraps qualifying attributes in `#[unsafe(...)]`.

## Related Skills
- [rust-unsafe-extern-blocks](file://.opencode/skills/rust-unsafe-extern-blocks.md)
- [rust-unsafe-blocks-in-unsafe-fn](file://.opencode/skills/rust-unsafe-blocks-in-unsafe-fn.md)
- [rust-edition-2024-lints](file://.opencode/skills/rust-edition-2024-lints.md)
