---
name: standards-proof-pyramid
description: Description
compatibility: opencode
---

# Skill Name: Proof Pyramid

## Description
The 5-layer Proof Pyramid: Kani model checking → Property-based testing (proptest) → Fuzzing (cargo-fuzz) → Static analysis (clippy + rustc) → Type system (Rust borrow checker). CI SHALL fail if ANY layer reports a violation.

## When to Load
Load this skill when setting up CI pipeline, designing verification strategy for a module, evaluating proof coverage, or debugging a CI failure across proof layers.

## Source
STANDARDS.adoc §0.3.2 (lines 421–456), §6.1 (lines 2367–2368)

## Key Rules

- MANDATE: Every codebase SHALL have all five layers of the proof pyramid
- MANDATE: CI SHALL fail if ANY layer reports a violation
- MANDATE: Lower layers are non-negotiable (type system + static analysis)
- MANDATE: Higher layers are applied based on code criticality

## Five Layers (bottom to top)

1. **Type System** (Rust borrow checker + trait system):
   - Proves: memory safety, thread safety, type correctness
   - Scope: every compilation
   - Enforced: compiler, non-negotiable

2. **Static Analysis** (clippy + rustc):
   - Proves: lint rules, coding standards, pattern correctness
   - Scope: every compilation
   - Enforced: `-Dwarnings`, `-F unsafe_code`

3. **Fuzzing** (cargo-fuzz):
   - Proves: no crashes on arbitrary inputs
   - Scope: all I/O boundaries, parsing, deserialization
   - Duration: CI runs for 5 min per target

4. **Property-Based Testing** (proptest):
   - Proves: algebraic properties, idempotence, round-trips
   - Scope: any function Kani cannot handle (FFI, unbounded loops)
   - Coverage: 10,000+ random cases per property

5. **Kani Model Checking** (cargo kani):
   - Proves: no panics, no overflow, no bounds errors, invariants
   - Scope: ALL public functions in library code
   - Cost: 15-30 min CI per 1000 LOC

```rust
// CI pipeline ordering (from bottom to top):
// 1. Type system: cargo check (compiler enforces)
// 2. Static analysis: cargo clippy --all-targets --all-features -- -Dwarnings
// 3. Fuzzing: cargo fuzz run <target> -- -max_total_time=300  (5 min)
// 4. Proptest: cargo test --test proptest  (10,000+ cases per property)
// 5. Kani: cargo kani --default-unwind 100 --output-format terse
```

## Example

```yaml
# CORRECT — CI pipeline with all five layers
name: CI
on: [push, pull_request]
jobs:
  check:
    steps:
      # Layer 1: Type system (compiler enforces)
      - run: cargo check --all-targets --all-features

      # Layer 2: Static analysis
      - run: cargo clippy --all-targets --all-features -- -Dwarnings
      - run: cargo fmt --check
      - run: cargo doc --no-deps --all-features

      # Layer 3: Fuzzing
      - run: cargo fuzz run der_parser -- -max_total_time=300
      - run: cargo fuzz run config_parser -- -max_total_time=300

      # Layer 4: Property-based testing
      - run: cargo test --test proptest -- --include-ignored

      # Layer 5: Kani model checking
      - run: cd proofs && cargo kani --default-unwind 100 --output-format terse
        timeout-minutes: 60
```

## Related Skills
- [standards-proof-kani-harness-patterns](file://.opencode/skills/standards-proof-kani-harness-patterns.md)
- [standards-proof-coding-for-kani](file://.opencode/skills/standards-proof-coding-for-kani.md)
- [standards-proof-proptest-mandates](file://.opencode/skills/standards-proof-proptest-mandates.md)
- [standards-proof-fuzz-mandates](file://.opencode/skills/standards-proof-fuzz-mandates.md)
