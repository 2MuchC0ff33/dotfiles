# Edition 2024 Language Features

## Description
Comprehensive reference for all language features enabled by Rust Edition 2024 (and related 1.85+ stabilizations) that do not require feature gates — they are part of the edition.

## When to Load
Load this skill when writing new code that can leverage edition 2024 features, reviewing code for idiomatic edition-2024 patterns, or evaluating whether a feature is available.

## Source
STANDARDS.adoc §1.4.4.1 (lines 869–914) and §3.1 (lines 1476–1486)

## Key Rules

- **MANDATE**: edition = "2024" SHALL be set in every Cargo.toml.
- **MANDATE**: `cfg_select!` SHALL replace `cfg-if` crate usage.
- **SHOULD**: Prefer `if let` chains over nested `if let Some(x) = ... { if let ... }`.
- **SHOULD**: Prefer `if let` guards over `match` + nested conditions.
- **SHOULD**: Use `core::hint::cold_path` in error/unlikely branches.
- **SHOULD**: Use `core::range::RangeInclusive` for range operations.
- **FORBIDDEN**: Adding feature flags for features that are edition-gated.

## Stable Feature Reference

### Edition 2024 Native (no feature flags required)

| Feature | Since | Description |
|---|---|---|
| `let` chains | Edition 2024 | `if let A = x && let B = y { }` |
| `if let` guards | Edition 2024 | `match x { Some(v) if let Ok(y) = f(v) => { } }` |
| `cfg_select!` | 1.95.0 | Built-in cfg matching, replaces `cfg-if` crate |
| `let_chains` in `while` | Edition 2024 | `while let Some(x) = iter.next() && condition { }` |

### Stabilized Features (available regardless of edition)

| Feature | Since | Description |
|---|---|---|
| Async closures | 1.85.0 | `async \|\| { }`, `async move \|\| { }`, `AsyncFn*` traits |
| Precise capturing | 1.82.0+ (default 2024) | `impl Trait + use<'a, T>` for explicit lifetime capture |
| Trait upcasting | 1.86.0 | `dyn SubTrait` → `dyn SuperTrait` coercion |
| Naked functions | 1.88.0 | Full control over function assembly |
| `core::range` module | 1.95.0 | New range types e.g. `RangeInclusive` |
| `core::hint::cold_path` | 1.95.0 | Hint compiler that path is cold |
| `bool: TryFrom<integer>` | 1.95.0 | Safe integer-to-bool conversion |
| `Vec::push_mut`, `Vec::insert_mut` | 1.95.0 | In-place mutation of elements |
| Generic const arg inference | 1.89.0 | Infer const generic arguments |

## Example

```rust
// let chains (Edition 2024)
if let Some(x) = get_optional()
    && let Ok(y) = x.parse::<i32>()
    && y > 0
{
    println!("Positive number: {y}");
}

// if let guards (Edition 2024)
match result {
    Some(val) if let Ok(parsed) = val.parse::<i32>() => parsed,
    _ => 0,
}

// cold_path hint
if core::hint::cold_path() {
    // Error handling — unlikely branch
    handle_error();
}

// cfg_select! (built-in, no cfg-if crate)
core::cfg_select! {
    feature = "no_std" => { /* ... */ }
    _ => { /* std path */ }
}
```

## Related Skills
- [rust-cfg-select-macro](file://.opencode/skills/rust-cfg-select-macro.md)
- [rust-edition-2024-lints](file://.opencode/skills/rust-edition-2024-lints.md)
- [rust-cargo-toml-template](file://.opencode/skills/rust-cargo-toml-template.md)
