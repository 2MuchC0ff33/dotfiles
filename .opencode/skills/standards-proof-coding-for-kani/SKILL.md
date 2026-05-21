---
name: standards-proof-coding-for-kani
description: Description
compatibility: opencode
---

# Skill Name: Coding for Kani Proof

## Description
Code must be written in a style amenable to Kani model-checking: statically known loop bounds, no recursion without proven termination, no trait objects, no interior mutability, all indexing provably in-bounds, all arithmetic provably overflow-free.

## When to Load
Load this skill when writing code that will be formally verified with Kani, reviewing code for Kani-proof compatibility, or refactoring existing code to be Kani-amenable.

## Source
STANDARDS.adoc §6.2.3 (lines 2517–2539)

## Key Rules

- MANDATE (for proved code):
  - Loop bounds MUST be statically known or symbolic-bounded
  - No recursion without proven termination
  - No trait objects (`dyn Trait`) — dynamic dispatch blocks proof
  - No interior mutability (`RefCell`, `Mutex`) in proved paths
  - No raw pointer dereference
  - All indexing MUST be provably in-bounds
  - All arithmetic MUST be provably overflow-free
  - No `gen` blocks (reserved keyword in 2024, use iterators)
  - Use `cfg_select!` over `cfg-if` crate for compile-time branching

- SHOULD (for proved code):
  - Use bounded integer types (u8, u16, u32) where possible
  - Use `.get()` and explicit bounds checks instead of `[]` where bounds cannot be statically proved
  - Factor out pure functions from side-effectful code
  - Keep functions small (Kani verification time scales super-linearly)

## Example

```rust
// CORRECT — Code written for Kani proof

/// Computes sum of u32 slice with proved bounds and overflow safety.
///
/// [PROVED] Kani harness in proofs/math_proofs.rs
/// - Asserts: no panic for any valid slice
/// - Asserts: no overflow (saturating arithmetic)
/// - Loop bound: len <= 1000 (bounded for proof)
pub fn bounded_sum(values: &[u32]) -> u32 {
    // All indexing is provably in-bounds (loop bound = slice length)
    // Arithmetic is overflow-free (saturating_add)
    let mut sum = 0u32;
    for i in 0..values.len() {
        sum = sum.saturating_add(values[i]);  // overflow-free
    }
    sum
}

/// State machine transition with Kani-provable exhaustiveness.
///
/// [PROVED] Uses enum (not trait objects) — Kani can explore all variants.
pub fn apply_transition(state: State, event: Event) -> State {
    // No trait objects, no dynamic dispatch — Kani explores all (state, event) pairs
    STATE_TABLE[state as usize][event as usize]
        .map(|t| t.next_state)
        .unwrap_or(state)  // illegal transition stays in current state
}
```

```rust
// INCORRECT — NOT amenable to Kani proof

/// Computes sum with unknown loop bound — FORBIDDEN for proved code.
pub fn unbounded_sum(values: &[u32]) -> u32 {
    let mut sum = 0u32;
    // Loop bound depends on values.len() which Kani cannot bound
    for &v in values.iter() {
        sum = sum.checked_add(v).unwrap();  // Unwrap unproved — FORBIDDEN
    }
    sum
}

/// Uses trait objects — FORBIDDEN for proved code.
pub fn process(handler: Box<dyn Handler>) {
    // dyn Handler — Kani cannot explore all possible implementations
    handler.handle();
}

/// Uses interior mutability — FORBIDDEN for proved code.
pub struct Cache {
    data: RefCell<HashMap<String, Value>>,  // RefCell blocks proof
}
```

## Related Skills
- [standards-proof-kani-harness-patterns](file://.opencode/skills/standards-proof-kani-harness-patterns.md)
- [standards-proof-pyramid](file://.opencode/skills/standards-proof-pyramid.md)
- [standards-suckless-no-trait-objects-hot](file://.opencode/skills/standards-suckless-no-trait-objects-hot.md)
