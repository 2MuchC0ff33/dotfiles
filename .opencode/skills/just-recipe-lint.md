# just-recipe-lint

## Description
Lint recipe that runs clippy, format check, and no_std compliance check.

## When to Load
Load this skill when implementing, modifying, or documenting the `lint` recipe in the justfile, or when understanding code quality enforcement.

## Source
STANDARDS.adoc §8.1 (lines 2730–2732)

## Key Rules

- MANDATE: The `lint` recipe MUST run `cargo xtask lint` as a single command.
- MANDATE: The xtask `lint` subcommand MUST include clippy (with `-Dwarnings`), format check (`cargo fmt --all --check`), and no_std compliance check.
- SHOULD: Run `just lint` before opening a PR or creating a new jj change.
- SHOULD: `lint` should be the fastest quality gate (typically < 30 seconds for incremental runs).
- FORBIDDEN: Do NOT inline clippy/fmt/no_std commands in the just `lint` recipe — delegate to xtask.
- FORBIDDEN: Do NOT add `--fix` or auto-formatting flags to `lint` — format checking is separate from formatting.

## Example

```just
# Run lint only (clippy + fmt + no_std check)
lint:
    cargo xtask lint
```

## Difference from `just clippy` and `just fmt-check`
- `just clippy` runs only clippy (no format or no_std checking).
- `just fmt-check` runs only format checking.
- `just lint` runs all three: clippy + fmt-check + no_std, in that order (fastest first).

## Related Skills
- [just-recipe-clippy](file://.opencode/skills/just-recipe-clippy.md)
- [just-recipe-fmt](file://.opencode/skills/just-recipe-fmt.md)
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
