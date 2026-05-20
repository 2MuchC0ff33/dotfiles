# Unsafe Blocks in Unsafe Functions (Edition 2024)

## Description
Unsafe operations inside an `unsafe fn` MUST be wrapped in explicit `unsafe { }` blocks. The function's `unsafe` qualifier does NOT implicitly make all its body unsafe.

## When to Load
Load this skill when writing or reviewing `unsafe fn` definitions, auditing unsafe code, or migrating code from pre-2024 editions.

## Source
STANDARDS.adoc §1.4.4.1 (lines 872–877) and §3.1 (lines 1595–1596)

## Key Rules

- **MANDATE**: Every unsafe operation inside an `unsafe fn` SHALL be wrapped in `unsafe { }`.
- **MANDATE**: `unsafe_op_in_unsafe_fn` lint SHALL be set to `"warn"` (escalating to deny in CI).
- **SHOULD**: Keep `unsafe` blocks as small as possible — wrap individual operations, not entire function bodies.
- **FORBIDDEN**: Relying on the function's `unsafe` qualifier to implicitly permit unsafe operations in its body.

## Rationale

Before edition 2024, `unsafe fn` implicitly allowed unsafe operations in its body, making it hard to distinguish between the function's contract (caller must uphold preconditions) and the body's own unsafe implementations. Edition 2024 makes every unsafe operation explicit, so reviewers can see exactly which operations are unsafe within a function, regardless of the function's own unsafety.

## Example

```rust
/// Load a value from a raw pointer.
///
/// # Safety
/// `ptr` must be non-null, aligned, and point to initialized memory.
unsafe fn load_value(ptr: *const u32) -> u32 {
    // ✅ CORRECT: explicit unsafe block wraps the dereference
    unsafe { *ptr }
}

/// Decrement then store. SAFETY: caller guarantees non-zero.
unsafe fn decrement_and_store(ptr: *mut u32) {
    // ✅ CORRECT: each unsafe op is individually wrapped
    let val = unsafe { *ptr };
    let new_val = val.wrapping_sub(1);
    unsafe { *ptr = new_val };
}

/// ❌ ERROR: implicit unsafe — `unsafe_op_in_unsafe_fn` warns/denies
unsafe fn bad_load(ptr: *const u32) -> u32 {
    *ptr  // unsafe operation without block!
}
```

## Cargo.toml Enforcement

```toml
[lints.rust]
unsafe_op_in_unsafe_fn = "warn"
```

With RUSTFLAGS or xtask CI, escalate to deny:
```
RUSTFLAGS="-D unsafe_op_in_unsafe_fn" cargo check
```

## Related Skills
- [rust-unsafe-extern-blocks](file://.opencode/skills/rust-unsafe-extern-blocks.md)
- [rust-unsafe-attr-syntax](file://.opencode/skills/rust-unsafe-attr-syntax.md)
- [rust-edition-2024-lints](file://.opencode/skills/rust-edition-2024-lints.md)
