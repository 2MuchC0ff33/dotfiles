---
name: nushell-linting-topiary
description: Description
compatibility: opencode
---

# Topiary Formatting

## Description
SHOULD: `topiary` (tree-sitter formatter) used for automated formatting of Nushell files.

## When to Load
Load this skill when setting up project formatting or CI formatting checks.

## Source
STANDARDS.adoc §11.5.11 (lines 4492–4502)

## Key Rules

- SHOULD: `topiary` (tree-sitter formatter) used for automated formatting
- MANDATE: ALL `.nu` files SHALL pass `nu-lint` in CI

## Rationale

Automated formatting eliminates style debates in code review and ensures consistent code layout across the entire codebase. `topiary` uses tree-sitter for language-aware formatting that respects Nushell syntax.

## Example

```bash
# Format all .nu files in the project
topiary format --language nu --glob '**/*.nu'

# Check formatting (for CI)
topiary format --language nu --check --glob '**/*.nu'

# Format specific file
topiary format --language nu --input src/main.nu --output src/main.nu

# Integrate with pre-commit or just
# justfile recipe:
format-nu:
    topiary format --language nu --glob 'config/**/*.nu'
    topiary format --language nu --glob 'scripts/**/*.nu'
    topiary format --language nu --glob 'src/**/*.nu'
```
