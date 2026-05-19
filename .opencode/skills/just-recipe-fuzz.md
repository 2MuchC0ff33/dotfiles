# just-recipe-fuzz

## Description
Fuzz testing recipe that runs all fuzz targets via xtask (5 minutes per target).

## When to Load
Load this skill when implementing, modifying, or documenting the `fuzz` recipe in the justfile, or when running fuzz testing.

## Source
STANDARDS.adoc §8.1 (lines 2725–2727)

## Key Rules

- MANDATE: `fuzz` MUST run `cargo xtask fuzz` (delegates to xtask for fuzz target orchestration).
- MANDATE: Each fuzz target MUST run for at least 5 minutes.
- MANDATE: The xtask `fuzz` subcommand MUST run ALL fuzz targets sequentially, not just one.
- SHOULD: Use `cargo fuzz` (via `cargo-fuzz`) as the fuzzing framework with libfuzzer.
- SHOULD: Run `just fuzz` before release or for any code that handles untrusted input (parsers, deserializers, network protocols).
- SHOULD: Design fuzz targets in `fuzz/` directory, one per entry point, with names matching the function under test.
- FORBIDDEN: Do NOT use nightly-only fuzzing features if stable alternatives exist.
- FORBIDDEN: Do NOT reduce the 5-minute-per-target duration — short fuzz runs miss edge cases.
- FORBIDDEN: Do NOT add fuzz targets to the default `cargo test` runner — fuzzing is a separate CI stage.

## Example

```just
# Run fuzz targets (5 min each)
fuzz:
    cargo xtask fuzz
```

## Fuzz Target Structure
```rust
// fuzz/fuzz_targets/fuzz_parser.rs
#![no_main]
use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    // This runs for 5 minutes via `just fuzz`
    if let Ok(input) = std::str::from_utf8(data) {
        let _ = my_parser::parse(input);
    }
});
```

## Related Skills
- [just-recipe-test](file://.opencode/skills/just-recipe-test.md)
- [just-recipe-proptest](file://.opencode/skills/just-recipe-proptest.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
