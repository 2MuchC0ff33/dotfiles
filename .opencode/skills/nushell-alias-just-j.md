# nushell-alias-just-j

## Description
Short alias `j` for `just`, the project's command runner (Makefile alternative).

## When to Load
Load this skill when reviewing or creating project-specific Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3721)

## Key Rules

- MANDATE: `alias j = just` MUST be present in `config.nu` in the "PROJECT-SPECIFIC ALIASES" section.
- SHOULD: Use `j` as shorthand for `just` to invoke justfile recipes.
- FORBIDDEN: Omitting this alias — `just` recipes are frequently used and the abbreviation saves time.

## Rationale

`just` is the project's command runner (see STANDARDS Part 8). It provides
discoverable recipes for common tasks. The `j` alias reduces typing by 67%
(4 characters → 1):

- `j check` → `just check`
- `j lint` → `just lint`
- `j test` → `just test`
- `j fmt` → `just fmt`
- `j clippy` → `just clippy`
- `j docs` → `just docs`

`just` recipes serve as a thin convenience layer over `cargo xtask`,
making the most common commands even easier to type and discover via
`just --list` / `j --list`.

## Example

```nushell
alias j   = just
```

Usage:
- `j check` → `just check` → runs full CI pipeline
- `j --list` → lists all available recipes
- `j fmt` → formats all code

## Related Skills
- [nushell-alias-cargo-c](file://.opencode/skills/nushell-alias-cargo-c.md)
- [nushell-alias-xtask-cxt](file://.opencode/skills/nushell-alias-xtask-cxt.md)
