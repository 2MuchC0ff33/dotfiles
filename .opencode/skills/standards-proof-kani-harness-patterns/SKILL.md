---
name: standards-proof-kani-harness-patterns
description: Description
compatibility: opencode
---

# Skill Name: Kani Proof Harness Patterns

## Description
Three standard Kani proof harness patterns: unwrap-safety proof (function never panics), invariant proof (data structure invariant preserved), and bounded loop proof (loop with `#[kani::unwind]` bound).

## When to Load
Load this skill when writing Kani proof harnesses, setting up the proofs crate, or verifying function correctness with model checking.

## Source
STANDARDS.adoc §6.2 (lines 2371–2483)

## Key Rules

- MANDATE: Every Kani proof harness is a function annotated with `#[kani::proof]`
- MANDATE: Harness functions live in the `proofs/` crate, one module per domain
- MANDATE: Kani proof harnesses verify: no panics, no arithmetic overflow, no bounds errors, custom invariants
- MANDATE: Use `#[kani::unwind(N)]` for loops to bound the proof
- MANDATE: Use `kani::assume()` to constrain symbolic inputs to valid ranges
- MANDATE: Use `kani::assert()` inside code to assert invariants are preserved
- SHOULD: Use `kani::any()` for symbolic input generation

## Pattern 1: Unwrap-Safety Proof

```rust
/// [PROVED] ConfigParser::parse never panics on any valid DER input.
#[kani::proof]
pub fn config_parser_never_panics() {
    // Kani symbolically generates ALL possible valid DER byte sequences
    // that conform to the NetworkConfig schema.
    let bytes: [u8; 128] = kani::any();  // symbolic input up to 128 bytes
    let len: usize = kani::any();
    kani::assume(len <= bytes.len());

    let result = ConfigParser::parse(&bytes[..len]);

    // The parser MUST return Ok or Err — never panic.
    // Kani verifies this for ALL symbolic inputs within bounds.
    // If the parser panics on ANY input, this proof FAILS.
}
```

## Pattern 2: Invariant Proof

```rust
/// [PROVED] Health component invariant: current <= maximum always.
#[kani::proof]
pub fn health_invariant() {
    let current: u32 = kani::any();
    let maximum: u32 = kani::any();
    kani::assume(current <= maximum);  // only valid health values

    let health = Health { current, maximum };

    // After construction, the invariant holds by type construction.
    // But what about modification? Prove that death_system preserves it.
    let mut world = hecs::World::new();
    let entity = world.spawn((health,));
    death_system(&mut world);

    // After death_system:
    // - If entity still exists, its health invariant holds.
    // - If entity was despawned, that's correct behavior (health == 0).
    let query = world.query::<&Health>();
    for (_e, h) in query.iter() {
        kani::assert(h.current <= h.maximum,
            "health invariant preserved");
    }
}
```

## Pattern 3: Bounded Loop Proof

```rust
/// [PROVED] Physics system processes exactly N entities for bounded N.
#[kani::proof]
#[kani::unwind(100)]  // Kani needs loop bound hint
pub fn physics_system_bounded() {
    let mut world = hecs::World::new();
    let count: u32 = kani::any();
    kani::assume(count > 0);
    kani::assume(count <= 100);  // bounded for proof

    for i in 0..count {
        world.spawn((
            Position([0.0, 0.0, 0.0]),
            Velocity([1.0, 0.0, 0.0]),
        ));
    }

    physics_system(&mut world, 1.0 / 60.0);

    // Every entity's position changed by exactly velocity * dt
    let query = world.query::<(&Position, &Velocity)>();
    for (_e, (pos, vel)) in query.iter() {
        kani::assert(pos.0[0] == vel.0[0] / 60.0,
            "physics invariant");
    }
}
```

## Related Skills
- [standards-proof-coding-for-kani](file://.opencode/skills/standards-proof-coding-for-kani.md)
- [standards-proof-pyramid](file://.opencode/skills/standards-proof-pyramid.md)
- [standards-proof-tier-proved](file://.opencode/skills/standards-proof-tier-proved.md)
