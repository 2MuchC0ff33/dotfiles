# Skill Name: Proved Tier

## Description
`[PROVED]` — A Kani proof harness exists and passes in CI. This is the highest proof tier. Used for core logic, parsing, state machines, and data transformations. Worst-case CI time: 30-60 minutes.

## When to Load
Load this skill when annotating functions with `[PROVED]`, writing Kani proof harnesses, or deciding whether a function qualifies for proved status.

## Source
STANDARDS.adoc §0.3.3 (lines 459–480), §12.2 (lines 4554–4556)

## Key Rules

- MANDATE: `[PROVED]` requires a Kani proof harness that passes in CI
- MANDATE: Proof harnesses live in the `proofs/` crate under `proofs/src/`
- MANDATE: Proof harness functions are annotated with `#[kani::proof]`
- MANDATE: Proof harnesses verify: no panics, no arithmetic overflow, no bounds errors, and custom invariants via `kani::assert`
- MANDATE: Use for: core logic, parsing, state machines, data transformations
- SHOULD: Include detailed assertions in doc comments about what is proved
- SHOULD: Document worst-case verification time in harness
- FORBIDDEN: Using `[PROVED]` on functions with FFI, syscalls, or unbounded algorithms

## Example

```rust
/// Calculates the bounding box for a set of positions.
///
/// [PROVED] Kani harness in proofs/harnesses/spatial_proofs.rs
/// - Asserts: result.min[i] <= result.max[i] for all i
/// - Asserts: no panic on empty input (returns degenerate bbox)
/// - Coverage: empty, single, many, collinear inputs
pub fn bounding_box(positions: &[[f32; 3]]) -> BBox {
    let mut bbox = BBox {
        min: [f32::MAX; 3],
        max: [f32::MIN; 3],
    };
    for pos in positions {
        for i in 0..3 {
            bbox.min[i] = bbox.min[i].min(pos[i]);
            bbox.max[i] = bbox.max[i].max(pos[i]);
        }
    }
    bbox
}

// Corresponding proof harness (proofs/src/math_proofs.rs):
#[kani::proof]
pub fn bounding_box_invariant() {
    let positions: [[f32; 3]; 5] = kani::any();
    let result = bounding_box(&positions);
    for i in 0..3 {
        kani::assert(result.min[i] <= result.max[i],
            "bounding box invariant: min <= max");
    }
}
```

```rust
/// Parses a state machine transition from a byte slice.
///
/// [LINTED]  // INCORRECT: parsing is core logic — should be [PROVED]
pub fn parse_transition(bytes: &[u8]) -> Result<Transition, ParseError> {
    // Parsing logic that Kani could fully verify
}
```

## Related Skills
- [standards-proof-tier-annotations](file://.opencode/skills/standards-proof-tier-annotations.md)
- [standards-proof-kani-harness-patterns](file://.opencode/skills/standards-proof-kani-harness-patterns.md)
- [standards-proof-coding-for-kani](file://.opencode/skills/standards-proof-coding-for-kani.md)
