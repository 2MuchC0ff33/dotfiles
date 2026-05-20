# just-recipe-proof

## Description
Kani proof verification recipe for formal verification of Rust code.

## When to Load
Load this skill when implementing, modifying, or documenting the `proof` recipe in the justfile, or when running formal verification with Kani.

## Source
STANDARDS.adoc §8.1 (lines 2750–2752); xtask proof module (lines 3005–3035)

## Key Rules

- MANDATE: The `proof` recipe MUST run `cargo xtask proof`.
- MANDATE: All Kani proofs MUST pass before merge — this is a hard gate in the CI pipeline.
- MANDATE: The xtask proof module MUST invoke Kani with the following flags:
  - `--default-unwind 100` (unwind depth for loop unrolling)
  - `--output-format terse` (compact output)
- SHOULD: Expect 30–60 minutes for a full proof run across all harnesses.
- SHOULD: Use `--harness` flag (via xtask Verify subcommand) during development to target specific proof harnesses for faster iteration.
- FORBIDDEN: Do NOT pass `--release` to Kani — proofs run on the internal representation, not optimized builds.
- FORBIDDEN: Do NOT skip Kani proofs for "small changes" — any unsafe block or pointer arithmetic requires verification.

## Example

```just
# Run all Kani proofs
proof:
    cargo xtask proof
```

The xtask proof module (lines 3005–3035) implements:
```rust
pub fn run() -> Result<()> {
    println!("Running Kani verification...");
    println!("This will take 30-60 minutes for a full proof run.");
    run_command("cargo", &[
        "kani",
        "--default-unwind", "100",
        "--output-format", "terse",
    ], "Kani proof verification failed.")?;
    println!("All Kani proofs passed.");
    Ok(())
}
```

## Kani Coverage Guarantees
Kani verifies at minimum:
- No panics (index bounds, unwrap, expect, assert)
- No integer overflow/underflow
- No pointer dereference errors (null, dangling, misaligned)
- No bounds errors on slice/array access
- Function contract invariants (pre/post conditions via `#[kani::requires]` / `#[kani::ensures]`)

## Related Skills
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
- [xtask-task-module-pattern](file://.opencode/skills/xtask-task-module-pattern.md)
