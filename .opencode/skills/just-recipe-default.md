# just-recipe-default

## Description
Default just recipe that lists all available recipes in display order.

## When to Load
Load this skill when implementing, modifying, or documenting the `default` recipe in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2685–2687)

## Key Rules

- MANDATE: The `default` recipe MUST use `@just --list --unsorted` to show available recipes.
- MANDATE: The `@` prefix suppresses printing of the command itself (only output is shown).
- MANDATE: The `--unsorted` flag MUST be used to preserve definition order (most important recipes first).
- MANDATE: Every justfile MUST have a `default` recipe as the first recipe after the help section comment.
- SHOULD: Place the `default` recipe first in the justfile so `just` (with no arguments) shows the user what's available.
- FORBIDDEN: Do NOT rename the `default` recipe — it is a special target in just that runs when no recipe is specified.
- FORBIDDEN: Do NOT add `@just --list --unsorted` to any recipe other than `default`.

## Example

```just
# Show available recipes.
default:
    @just --list --unsorted
```

## Rationale
The `default` recipe serves as the primary user-facing entry point. Running `just` with no arguments immediately shows all available recipes, making the build system self-documenting. The `@` prefix keeps output clean, and `--unsorted` preserves the intentional ordering (development, verification, quality, documentation, security, release, environment).

## Related Skills
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [just-recipe-lint](file://.opencode/skills/just-recipe-lint.md)
- [just-recipe-test](file://.opencode/skills/just-recipe-test.md)
