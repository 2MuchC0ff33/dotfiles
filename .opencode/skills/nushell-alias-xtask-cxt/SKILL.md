---
name: nushell-alias-xtask-cxt
description: Description
compatibility: opencode
---

# nushell-alias-xtask-cxt

## Description
Short alias `cxt` for `cargo xtask`, the project's complex Rust automation framework.

## When to Load
Load this skill when reviewing or creating project-specific Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3720)

## Key Rules

- MANDATE: `alias cxt = cargo xtask` MUST be present in `config.nu` in the "PROJECT-SPECIFIC ALIASES" section.
- SHOULD: Use `cxt` for invoking xtask commands: `cxt check`, `cxt lint`, `cxt test`, `cxt docs`, `cxt audit`, `cxt cross`.
- FORBIDDEN: Omitting this alias — `cargo xtask` is the primary automation mechanism and its verbose name benefits from abbreviation.

## Rationale

`cargo xtask` is the project's build automation framework (see STANDARDS
Part 8). Xtask subcommands are the primary developer workflow:

- `cxt check` → lint + test + proof + docs + audit
- `cxt lint` → cargo clippy + nu-lint + vale
- `cxt test` → cargo test + nu test runner
- `cxt docs` → asciidoctor + cargo doc
- `cxt audit` → cargo audit + cargo deny
- `cxt cross` → cross-compilation via cargo-zigbuild

The `cxt` alias reduces `cargo xtask` (10 chars + space = 11) to 3
characters — a 73% reduction.

## Example

```nushell
alias cxt = cargo xtask
```

Usage:
- `cxt check` → runs full CI pipeline locally
- `cxt lint` → runs all linters
- `cxt test` → runs all tests

## Related Skills
- [nushell-alias-cargo-c](file://.opencode/skills/nushell-alias-cargo-c.md)
- [nushell-alias-just-j](file://.opencode/skills/nushell-alias-just-j.md)
