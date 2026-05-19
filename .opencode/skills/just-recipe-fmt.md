# just-recipe-fmt

## Description
Format recipes: apply formatting (`fmt`) or check formatting without modifying (`fmt-check`).

## When to Load
Load this skill when implementing, modifying, or documenting the `fmt` or `fmt-check` recipes in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2733–2739)

## Key Rules

- MANDATE: `fmt` MUST run `cargo fmt --all` (formats all code in the workspace in-place).
- MANDATE: `fmt-check` MUST run `cargo fmt --all --check` (exits non-zero if formatting is incorrect, but does NOT modify files).
- MANDATE: `--all` flag MUST be present in both recipes to format all packages in the workspace, not just the root crate.
- SHOULD: Run `just fmt` before creating any new jj change to avoid formatting diffs.
- SHOULD: Use `just fmt-check` in CI to enforce consistent formatting.
- SHOULD: Configure `hx` (Helix editor) with `cargo fmt` as the default formatter for Rust files so formatting is automatic on save.
- FORBIDDEN: Do NOT add `--check` to the `fmt` recipe — `fmt` is meant to auto-fix formatting.
- FORBIDDEN: Do NOT use nightly-only fmt options (`cargo +nightly fmt`) — stick with stable Rust formatter.
- FORBIDDEN: Do NOT add rustfmt.toml settings that conflict with Rust Edition 2024 defaults.

## Examples

```just
# Format all code
fmt:
    cargo fmt --all

# Format check without modifying
fmt-check:
    cargo fmt --all --check
```

Usage:
```sh
just fmt         # Auto-format all Rust code in workspace
just fmt-check   # CI check: fails if any file is not formatted
```

## Integration with just lint
The `lint` recipe (via xtask) runs `cargo fmt --all --check` as one of its phases. If `just fmt-check` fails, also run `just fmt` to fix formatting, then re-run `just lint`.

## Related Skills
- [just-recipe-lint](file://.opencode/skills/just-recipe-lint.md)
- [just-recipe-clippy](file://.opencode/skills/just-recipe-clippy.md)
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
