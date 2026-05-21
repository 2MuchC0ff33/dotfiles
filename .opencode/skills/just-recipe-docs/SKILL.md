---
name: just-recipe-docs
description: Description
compatibility: opencode
---

# just-recipe-docs

## Description
Documentation build recipes: Rust API docs, AsciiDoc docs, and xtask-driven doc generation.

## When to Load
Load this skill when implementing, modifying, or documenting the `docs`, `docs-open`, or `docs-adoc` recipes in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2782–2792)

## Key Rules

- MANDATE: `docs` MUST run `cargo xtask docs` (delegates to xtask for orchestrated doc building).
- MANDATE: `docs-open` MUST use `cargo doc --all-features --no-deps --open` (builds Rust API docs with all features, no dependencies, opens browser).
- MANDATE: `docs-adoc` MUST run `asciidoctor --failure-level=WARN docs/modules/ROOT/pages/index.adoc` (builds AsciiDoc docs, fails on warnings).
- MANDATE: `--failure-level=WARN` on asciidoctor builds means any warning is a build failure — no broken anchors, missing attributes, or malformed includes.
- SHOULD: Use `docs-open` during development to preview Rust API documentation locally.
- SHOULD: Use `docs-adoc` to validate AsciiDoc documentation structure before committing changes.
- SHOULD: The xtask `docs` subcommand may combine both Rust docs (`cargo doc`) and AsciiDoc validation.
- FORBIDDEN: Do NOT add `--open` to the default `docs` recipe — CI builds should not open browsers.
- FORBIDDEN: Do NOT use `asciidoctor` with `--failure-level=ERROR` — warnings must also fail the build.

## Examples

```just
# Build all documentation
docs:
    cargo xtask docs

# Build and open Rust API docs
docs-open:
    cargo doc --all-features --no-deps --open

# Build AsciiDoc documentation
docs-adoc:
    asciidoctor --failure-level=WARN docs/modules/ROOT/pages/index.adoc
```

Usage:
```sh
just docs          # Build all docs via xtask
just docs-open     # Build + open Rust API docs in browser
just docs-adoc     # Validate AsciiDoc docs build
```

## Related Skills
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
- [xtask-task-module-pattern](file://.opencode/skills/xtask-task-module-pattern.md)
