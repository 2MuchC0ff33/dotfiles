---
name: rust-edition-2024-lints
description: Description
compatibility: opencode
---

# Edition 2024 Compatibility Lints

## Description
Comprehensive lint matrix for Rust 2024 edition migration and enforcement. These lints catch edition-mismatch issues, syntax deprecations, and behavioral changes between 2021 and 2024 editions.

## When to Load
Load this skill when migrating a crate from edition 2021 to 2024, setting up a new crate's lint configuration, or debugging edition-related compilation issues.

## Source
STANDARDS.adoc §3.1 (lines 1585–1629)

## Key Rules

- **MANDATE**: `missing_unsafe_on_extern` = `"forbid"` — extern blocks MUST be `unsafe extern`.
- **MANDATE**: `unsafe_attr_outside_unsafe` = `"forbid"` — no bare `#[no_mangle]` etc.
- **MANDATE**: `unsafe_op_in_unsafe_fn` = `"warn"` — explicit unsafe blocks in unsafe fn.
- **MANDATE**: `keyword_idents_2024` = `"error"` — `gen` keyword reserved.
- **MANDATE**: `dependency_on_unit_never_type_fallback` = `"deny"` — never type fallback changes.
- **MANDATE**: `never_type_fallback_flowing_into_unsafe` = `"deny"`.
- **SHOULD**: All other 2024 compatibility lints at `"warn"`.
- **FORBIDDEN**: Suppressing 2024 lints without explicit governance approval.

## Complete Lint Matrix

### Hard Errors (forbid)

| Lint | Level | Purpose |
|---|---|---|
| `missing_unsafe_on_extern` | `forbid` | All extern blocks need `unsafe` |
| `unsafe_attr_outside_unsafe` | `forbid` | All unsafe attrs need `#[unsafe(...)]` |
| `keyword_idents_2024` | `error` | `gen` keyword reserved in 2024 |

### Deny Group

| Lint | Level | Purpose |
|---|---|---|
| `dependency_on_unit_never_type_fallback` | `deny` | Never type fallback to `()` |
| `never_type_fallback_flowing_into_unsafe` | `deny` | Never fallback + unsafe interaction |

### Warning Group

| Lint | Level | Purpose |
|---|---|---|
| `unsafe_op_in_unsafe_fn` | `warn` | Explicit unsafe blocks required |
| `impl_trait_overcaptures` | `warn` | RPIT lifetime capture changes |
| `if_let_rescope` | `warn` | `if let` temporary scope changes |
| `tail_expr_drop_order` | `warn` | Drop order changes for tail expressions |
| `rust_2024_incompatible_pat` | `warn` | Match ergonomics pattern changes |
| `boxed_slice_into_iter` | `warn` | `Box<[T]>` into_iter changes |
| `rust_2024_prelude_collisions` | `warn` | New prelude items cause collisions |
| `deprecated_safe_2024` | `warn` | Functions made unsafe in 2024 |
| `ambiguous_glob_imported_traits` | `warn` | Ambiguous glob-imported traits |

## Cargo.toml

```toml
[lints.rust]
missing_unsafe_on_extern          = "forbid"
unsafe_attr_outside_unsafe        = "forbid"
unsafe_op_in_unsafe_fn            = "warn"
impl_trait_overcaptures           = "warn"
if_let_rescope                    = "warn"
tail_expr_drop_order              = "warn"
rust_2024_incompatible_pat        = "warn"
keyword_idents_2024               = "error"
boxed_slice_into_iter             = "warn"
rust_2024_prelude_collisions      = "warn"
deprecated_safe_2024              = "warn"
ambiguous_glob_imported_traits    = "warn"
dependency_on_unit_never_type_fallback      = "deny"
never_type_fallback_flowing_into_unsafe     = "deny"
```

## Related Skills
- [rust-unsafe-extern-blocks](file://.opencode/skills/rust-unsafe-extern-blocks.md)
- [rust-unsafe-attr-syntax](file://.opencode/skills/rust-unsafe-attr-syntax.md)
- [rust-unsafe-blocks-in-unsafe-fn](file://.opencode/skills/rust-unsafe-blocks-in-unsafe-fn.md)
- [rust-edition-2024-features](file://.opencode/skills/rust-edition-2024-features.md)
