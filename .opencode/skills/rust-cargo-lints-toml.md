# Lints in Cargo.toml (Single Source of Truth)

## Description
ALL lint configuration SHALL be declared in `[lints]` sections in `Cargo.toml` and NEVER in `lib.rs` or individual source files. This prevents lint suppression at the module level and provides a single audit point.

## When to Load
Load this skill when configuring lint levels for a new crate, reviewing lint configuration, or enforcing lint policy across a workspace.

## Source
STANDARDS.adoc §3.1 (lines 1556–1701)

## Key Rules

- **MANDATE**: All lints SHALL be declared in `[lints.rust]`, `[lints.clippy]`, and deny groups — never in `lib.rs`.
- **MANDATE**: `unsafe_code` SHALL be `"forbid"` (removed only with governance approval for FFI).
- **MANDATE**: No `#![allow(...)]`, `#![warn(...)]`, `#![deny(...)]`, `#![forbid(...)]` in any `.rs` file.
- **MANDATE**: Deny groups (`[lints.rust.deny]` and `[lints.clippy.deny]`) SHALL be defined separately.
- **MANDATE**: Clippy: `all`, `pedantic`, `nursery`, `cargo` SHALL be at `"warn"`.
- **MANDATE**: `unwrap_used`, `expect_used`, `panic` SHALL be at `"warn"` — no silent panics.
- **MANDATE**: `indexing_slicing` SHALL be `"warn"` — use `.get()` or prove bounds.

## Cargo.toml Lint Section

```toml
[lints.rust]
# Forbid unsafe code entirely.
unsafe_code                   = "forbid"

# Documentation: all public items documented.
missing_docs                  = "warn"

# Missing Debug impl = cannot assert type contents in tests.
missing_debug_implementations = "warn"

# Items visible outside current crate but not exported = likely bug.
unreachable_pub               = "warn"

# Every returned value MUST be explicitly handled.
unused_results                = "warn"
unused_must_use               = "warn"

# Private items do not need documentation tests.
private_doc_tests             = "allow"

# Dead code is only a warning during development.
dead_code                     = "warn"

# ─────────────────────────────────────────
# RUST 2024 EDITION COMPATIBILITY LINTS
# ─────────────────────────────────────────
missing_unsafe_on_extern       = "forbid"
unsafe_attr_outside_unsafe      = "forbid"
unsafe_op_in_unsafe_fn          = "warn"
impl_trait_overcaptures         = "warn"
if_let_rescope                  = "warn"
tail_expr_drop_order            = "warn"
rust_2024_incompatible_pat      = "warn"
keyword_idents_2024             = "error"
boxed_slice_into_iter           = "warn"
rust_2024_prelude_collisions    = "warn"
deprecated_safe_2024            = "warn"
ambiguous_glob_imported_traits  = "warn"
dependency_on_unit_never_type_fallback = "deny"
never_type_fallback_flowing_into_unsafe = "deny"

[lints.clippy]
all      = "warn"
pedantic = "warn"
nursery  = "warn"
cargo    = "warn"

# No silent panics
unwrap_used      = "warn"
expect_used      = "warn"
panic            = "warn"

# No unfinished code
todo             = "warn"
unimplemented    = "warn"

# No unchecked indexing
indexing_slicing = "warn"

# No unchecked arithmetic
arithmetic_side_effects = "warn"

# Forward-compatible public API design
exhaustive_structs = "warn"
exhaustive_enums   = "warn"

# Additional strict rules
missing_const_for_fn      = "warn"
missing_errors_doc        = "warn"
missing_panics_doc        = "warn"
must_use_candidate        = "warn"
mut_mut                   = "warn"
needless_pass_by_value    = "warn"
semicolon_if_nothing_returned = "warn"
same_name_method          = "warn"
significant_drop_tightening = "warn"

# ─────────────────────────────────────────
# DENY: Hard errors
# ─────────────────────────────────────────
[lints.rust.deny]
const_err                   = true
illegal_floating_point_literal_pattern = true
improper_ctypes             = true
invalid_macro_export_arguments = true
nonsensical_open_options    = true
pointer_structural_match    = true
private_bounds              = true
unconditional_recursion     = true
static_mut_refs             = true

[lints.clippy.deny]
cargo_common_metadata       = true
multiple_unsafe_ops_per_scope = true
panic_in_result_fn          = true
print_stderr                = true
print_stdout                = true
unnecessary_self_imports    = true
unused_async                = true
wildcard_dependencies       = true
```

## What NOT to Do

```rust
// ❌ NEVER in .rs files — all lints go in Cargo.toml only
#![warn(missing_docs)]
#![forbid(unsafe_code)]
#![allow(clippy::pedantic)]
```

## Related Skills
- [rust-cargo-config-toml](file://.opencode/skills/rust-cargo-config-toml.md)
- [rust-cargo-toml-template](file://.opencode/skills/rust-cargo-toml-template.md)
- [rust-cargo-profiles](file://.opencode/skills/rust-cargo-profiles.md)
- [rust-edition-2024-lints](file://.opencode/skills/rust-edition-2024-lints.md)
