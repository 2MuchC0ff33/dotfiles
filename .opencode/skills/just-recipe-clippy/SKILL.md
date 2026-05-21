---
name: just-recipe-clippy
description: Description
compatibility: opencode
---

# just-recipe-clippy

## Description
Clippy lint recipe with strict settings — all warnings are errors.

## When to Load
Load this skill when implementing, modifying, or documenting the `clippy` recipe in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2774–2776)

## Key Rules

- MANDATE: The `clippy` recipe MUST run `cargo clippy --all-targets --all-features -- -Dwarnings`.
- MANDATE: `--all-targets` MUST be present (checks lib, bins, tests, examples, benches).
- MANDATE: `--all-features` MUST be present (checks code under all feature flag combinations).
- MANDATE: `-- -Dwarnings` MUST be present (elevates all clippy warnings to errors — zero clippy warnings permitted).
- SHOULD: Run `just clippy` before `just lint` during development (fastest gate, under 10 seconds incremental).
- SHOULD: Add `#![allow(clippy::some_lint)]` attributes sparingly and only with a documented rationale.
- FORBIDDEN: Do NOT set `clippy.toml` to disable lints project-wide — use allow attributes on specific items only.
- FORBIDDEN: Do NOT skip clippy because "it's just a warning" — `-Dwarnings` means warnings are errors.
- FORBIDDEN: Do NOT use `cargo clippy` without `--all-targets` or `--all-features` — coverage must be complete.

## Example

```just
# Run clippy strict
clippy:
    cargo clippy --all-targets --all-features -- -Dwarnings
```

## Common Quick Fixes
```sh
just clippy                          # Run strict clippy
cargo clippy --fix --all-features    # Auto-fix what clippy can (then re-run clippy)
```

## Related Skills
- [just-recipe-lint](file://.opencode/skills/just-recipe-lint.md)
- [just-recipe-fmt](file://.opencode/skills/just-recipe-fmt.md)
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
