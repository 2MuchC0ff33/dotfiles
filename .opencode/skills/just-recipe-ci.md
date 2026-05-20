# just-recipe-ci

## Description
CI check recipe that builds all Nix check derivations.

## When to Load
Load this skill when implementing, modifying, or documenting the `ci` recipe in the justfile, or when understanding the CI configuration.

## Source
STANDARDS.adoc §8.1 (lines 2882–2884)

## Key Rules

- MANDATE: `ci` MUST run `nix build .#checks` — builds all check derivations defined in the Nix flake.
- MANDATE: The `.#checks` attribute is a Nix flake output that aggregates all CI checks (lint, test, build, audit, etc.).
- SHOULD: Run `just ci` locally before pushing to verify the full CI pipeline will pass.
- SHOULD: The `checks` output in `flake.nix` should mirror the `just check` pipeline (lint → test → proof → docs → audit).
- SHOULD: Configure CI (GitHub Actions) to run `nix build .#checks` as the primary CI job, not individual `just` recipes.
- FORBIDDEN: Do NOT use `nix flake check` as a replacement for `nix build .#checks` — they check different things (flake check verifies flake structure, build .#checks runs CI derivations).
- FORBIDDEN: Do NOT add `just ci` as a dependency of `just check` — CI builds are Nix-specific and not needed for local Rust development.

## Example

```just
# CI check (equivalent to full pipeline)
ci:
    nix build .#checks
```

## Nix Flake Check vs. nix build .#checks
| Command | Purpose |
|---|---|
| `nix flake check` | Verifies flake schema, all outputs evaluate |
| `nix build .#checks` | Builds and runs all CI check derivations |

Both should pass before merging to main.

## Related Skills
- [just-recipe-nix](file://.opencode/skills/just-recipe-nix.md)
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [just-recipe-build](file://.opencode/skills/just-recipe-nix.md)
