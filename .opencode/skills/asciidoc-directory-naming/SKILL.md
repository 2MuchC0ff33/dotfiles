---
name: asciidoc-directory-naming
description: Description
compatibility: opencode
---

# Skill: asciidoc-directory-naming

## Description

Documentation directories MUST be singular and kebab-case.

## When to Load

Load this skill when creating or restructuring documentation directories.

## Source

STANDARDS.adoc §9.3 (lines 3247–3250) and §9.2 (lines 3203–3223)

## Key Rules

- MANDATE: Directory names MUST be singular (not plural).
- MANDATE: Directory names MUST be kebab-case (lowercase, hyphens).
- FORBIDDEN: Abbreviated names (`inst/` instead of `installation/`).
- FORBIDDEN: PascalCase directory names (`Installation/`).
- FORBIDDEN: Plural directory names (`installations/`, `pages/`, `modules/` in Antora-convention directories should be reviewed).

## Example

### CORRECT directory structure

```
docs/
└── modules/
    └── ROOT/
        ├── page/              # singular
        ├── partial/           # singular (reusable fragments)
        ├── image/             # singular
        └── example/           # singular
```

### CORRECT content directories

```
installation/                   # singular, kebab-case
configuration/                  # singular, kebab-case
reference/                      # singular (already singular)
troubleshooting/                # singular (gerund acceptable)
```

### INCORRECT directory names

```
inst/                           # abbreviated, unclear
Installation/                   # PascalCase
installations/                  # plural
installation_guide/             # underscore instead of hyphen
installation-guide/             # actually CORRECT if "guide" is part of name
```

## Rationale

Singular directory names are consistent with Antora conventions and avoid
the English-grammar inconsistency of which words are pluralized. Kebab-case
ensures compatibility with URL routing, shell completion, and case-sensitive
filesystems. Abbreviations like `inst/` are ambiguous and harm
discoverability.

## Related Skills

- [asciidoc-file-naming-kebab](file://.opencode/skills/asciidoc-file-naming-kebab.md)
- [asciidoc-document-header](file://.opencode/skills/asciidoc-document-header.md)
