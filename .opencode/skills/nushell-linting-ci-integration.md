# CI Integration for Nu-Lint

## Description
CI integration: `nu-lint check scripts/ src/` with exit code enforcement.

## When to Load
Load this skill when setting up CI pipelines for Nushell projects.

## Source
STANDARDS.adoc §11.5.11 (lines 4492–4546)

## Key Rules

- MANDATE: ALL `.nu` files SHALL pass `nu-lint` in CI
- MANDATE: CI SHALL fail on any `nu-lint` error
- MANDATE: Project root SHALL contain a `.nu-lint.toml` configuration

## Rationale

`nu-lint` with exit code enforcement ensures no lint errors (security, type-safety, etc.) reach production. CI must fail when `nu-lint` detects any error, preventing non-compliant code from being merged.

## Example

```yaml
# In CI workflow:
- name: Lint Nushell scripts
  run: |
    nu-lint check scripts/ src/  # exit code != 0 → CI fails

# Full CI job examples:

# GitHub Actions
- name: Lint Nu scripts
  run: nu-lint check scripts/ src/

# With multiple directories
- name: Lint all Nu files
  run: |
    nu-lint check config/nushell/
    nu-lint check scripts/
    nu-lint check src/

# Pre-commit hook
#!/usr/bin/env nu
# .git/hooks/pre-commit or .githooks/pre-commit/nu-lint
let staged = (^git diff --cached --name-only --diff-filter=ACM
    | lines | where ($it | str ends-with '.nu'))
nu-lint check ...$staged
```

## Related Skills
- nushell-linting-nu-lint-mandate
- nushell-linting-nu-lint-toml
- nushell-linting-nu-lint-toml-reference
