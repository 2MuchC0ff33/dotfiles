# Nu-Lint Mandate

## Description
ALL `.nu` files SHALL pass `nu-lint` in CI. CI SHALL fail on any `nu-lint` error.

## When to Load
Load this skill when setting up CI, writing Nushell scripts, or configuring linting.

## Source
STANDARDS.adoc §11.5.11 (lines 4434–4445)

## Key Rules

- MANDATE: ALL `.nu` files SHALL pass `nu-lint` in CI
- MANDATE: CI SHALL fail on any `nu-lint` error
- MANDATE: Project root SHALL contain a `.nu-lint.toml` configuration

## Rationale

`nu-lint` catches type errors, security issues, performance problems, and style violations at CI time. Enforcing a zero-error policy prevents problematic code from reaching the codebase.

## Example

```bash
# CI workflow step
- name: Lint Nushell scripts
  run: |
    nu-lint check scripts/ src/  # exit code != 0 → CI fails

# Pre-commit hook (recommended)
nu-lint check --staged           # only check staged .nu files

# Checking specific files
nu-lint check src/main.nu src/utils.nu

# Checking entire project
nu-lint check .
```

## Related Skills
- nushell-linting-nu-lint-toml
- nushell-linting-ci-integration
- nushell-linting-nu-lint-toml-reference
