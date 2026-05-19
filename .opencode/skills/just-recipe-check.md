# just-recipe-check

## Description
Complete check pipeline recipe that runs lint, test, proof, docs, and audit in sequence.

## When to Load
Load this skill when implementing, modifying, or documenting the `check` recipe in the justfile, or when understanding the full CI pipeline.

## Source
STANDARDS.adoc §8.1 (lines 2693–2695)

## Key Rules

- MANDATE: The `check` recipe MUST run `cargo xtask check` as a single command — all complex logic lives in xtask.
- MANDATE: `check` is the single entry point that guarantees all quality gates pass before merge.
- MANDATE: The xtask `check` subcommand MUST run lint → test → proof → docs → audit in that order (fastest/most likely to fail first).
- SHOULD: Use `check` as the primary CI pipeline stage and as a prerequisite for `release`.
- SHOULD: Run `just check` before any push or merge to catch all issues.
- FORBIDDEN: Do NOT inline individual tool commands inside the just `check` recipe — delegate entirely to `cargo xtask check`.
- FORBIDDEN: Do NOT add `--release` or other flags to `check` — keep it as a bare `cargo xtask check`.

## Example

```just
# Run complete check pipeline (lint + test + proof + docs + audit)
check:
    cargo xtask check
```

## Rationale
The `check` recipe is the single most important recipe in the project — it is the one-stop command that verifies everything before merging. By delegating all logic to xtask (Rust), the justfile stays thin and discoverable while xtask handles the complex orchestration with proper error handling, dependencies, and reporting.

## Related Skills
- [just-recipe-default](file://.opencode/skills/just-recipe-default.md)
- [just-recipe-lint](file://.opencode/skills/just-recipe-lint.md)
- [just-recipe-test](file://.opencode/skills/just-recipe-test.md)
- [just-recipe-proof](file://.opencode/skills/just-recipe-proof.md)
- [just-recipe-docs](file://.opencode/skills/just-recipe-docs.md)
- [just-recipe-audit](file://.opencode/skills/just-recipe-audit.md)
- [just-recipe-release](file://.opencode/skills/just-recipe-release.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
