# just-recipe-audit

## Description
Security audit recipes: vulnerability scanning and dependency freshness checking.

## When to Load
Load this skill when implementing, modifying, or documenting the `audit` or `outdated` recipes in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2798–2804)

## Key Rules

- MANDATE: `audit` MUST run `cargo xtask audit` (delegates to xtask for full security audit with error context).
- MANDATE: `outdated` MUST run `cargo outdated --exit-code 1` (exits with code 1 if any dependency is outdated).
- MANDATE: `--exit-code 1` on `outdated` means CI fails if any dependencies are stale — not just a warning.
- SHOULD: Run `just audit` before every release and regularly during development.
- SHOULD: Run `just outdated` monthly to track dependency freshness.
- SHOULD: The xtask `audit` subcommand should use `cargo audit` (from `cargo-audit`) which checks the RustSec Advisory Database.
- SHOULD: Address `cargo audit` findings immediately — they indicate known CVEs in dependencies.
- FORBIDDEN: Do NOT use `cargo audit` without `--deny warnings` or equivalent strict mode in xtask.
- FORBIDDEN: Do NOT ignore `cargo outdated` results — plan upgrades within the current release cycle.
- FORBIDDEN: Do NOT add `cargo update` to the audit recipe — audits are read-only checks.

## Examples

```just
# Run security audit
audit:
    cargo xtask audit

# Check for outdated dependencies
outdated:
    cargo outdated --exit-code 1
```

## Integration with just check
The `check` recipe (via xtask) runs audit as the final phase. All CVEs must be addressed before `just check` passes.

## Related Skills
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [just-recipe-release](file://.opencode/skills/just-recipe-release.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
