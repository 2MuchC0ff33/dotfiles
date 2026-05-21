---
name: asciidoc-one-sentence-per-line
description: Description
compatibility: opencode
---

# Skill: asciidoc-one-sentence-per-line

## Description

One sentence per line in source for better diffs. Maximum 80 characters per line (except URLs).

## When to Load

Load this skill when writing or editing any `.adoc` file content.

## Source

STANDARDS.adoc §9.6 (lines 3293–3295)

## Key Rules

- MANDATE: One sentence per line in source.
- MANDATE: Maximum 80 characters per line.
- SHOULD: Exceed 80 characters only for URLs (which must not be broken).
- MANDATE: This rule applies to prose in paragraphs, list items, admonitions, and table cells.
- SHOULD: Use semantic line breaks — start each new sentence or logical clause on its own line.

## Example

### CORRECT — one sentence per line, within 80 chars

```asciidoc
The application requires a PostgreSQL database.
Connection details are configured in the `.env` file.
Default port is 5432.
```

### CORRECT — URL exception

```asciidoc
See the PostgreSQL documentation at
https://www.postgresql.org/docs/current/config-setting.html for details.
// URL may exceed 80 chars — do NOT break URLs across lines
```

### INCORRECT — multiple sentences on one line

```asciidoc
The application requires a PostgreSQL database. Connection details are configured in the `.env` file. Default port is 5432.
```

### INCORRECT — line exceeds 80 characters

```asciidoc
The application requires a PostgreSQL database, which must be version 14 or later, and connection details are configured in the `.env` file found in the project root.
```

## Rationale

One sentence per line produces clean, minimal diffs during code review.
A change to one sentence changes exactly one line, making PRs readable
at a glance. The 80-character limit ensures files render well in terminal
editors, side-by-side diffs, and code review interfaces without wrapping.

## Related Skills

- [asciidoc-forbidden-language](file://.opencode/skills/asciidoc-forbidden-language.md)
- [asciidoc-vale-styles](file://.opencode/skills/asciidoc-vale-styles.md)
