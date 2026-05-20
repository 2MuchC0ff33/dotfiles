# Skill: asciidoc-admonitions-with-titles

## Description

Admonitions without titles are FORBIDDEN. Always use NOTE, WARNING, CAUTION, IMPORTANT, or TIP with proper formatting.

## When to Load

Load this skill when adding callouts, warnings, notes, tips, or cautions in any `.adoc` file.

## Source

STANDARDS.adoc §9.6 (line 3308)

## Key Rules

- FORBIDDEN: Admonitions without titles.
- MANDATE: Admonitions MUST use one of the five standard types: `NOTE`, `WARNING`, `CAUTION`, `IMPORTANT`, `TIP`.
- MANDATE: Admonition type label MUST be the first line after the opening delimiter.
- MANDATE: Use `[NOTE]`, `[WARNING]`, `[CAUTION]`, `[IMPORTANT]`, `[TIP]` block syntax.
- SHOULD: Use the admonition type that matches the severity of the content.
- FORBIDDEN: Using `NOTE` when `WARNING` or `CAUTION` is more appropriate.

## Example

### CORRECT — admonition with title

```asciidoc
[WARNING]
=====
Do not run this command in production.
Data loss may occur.
=====
```

### CORRECT — with custom title

```asciidoc
[TIP]
.Prerequisite Check
=====
Verify that PostgreSQL is running before starting the application.
=====
```

### CORRECT — all admonition types

```asciidoc
[NOTE]
=====
This feature is available in version 2.0 and later.
=====

[IMPORTANT]
=====
Back up your database before upgrading.
=====

[CAUTION]
=====
This operation is irreversible.
=====

[TIP]
=====
Use environment variables instead of hardcoded credentials.
=====
```

### INCORRECT — no title

```asciidoc
=====
This feature is available in version 2.0 and later.
=====
// No [NOTE] — what type of admonition is this?
```

### INCORRECT — wrong formatting

```asciidoc
NOTE: This feature is available in version 2.0 and later.
// Inline NOTE: — does not use proper block syntax
```

## Rationale

Untitled admonitions are visually ambiguous and fail accessibility checks.
Screen readers and structured output formats (DocBook, PDF) rely on the
admonition type label for correct rendering. Standardized types
communicate severity at a glance: NOTE informs, WARNING alerts,
CAUTION warns of damage, IMPORTANT signals critical information,
TIP offers helpful advice.

## Related Skills

- [asciidoc-forbidden-language](file://.opencode/skills/asciidoc-forbidden-language.md)
- [asciidoc-callouts-vs-inline-comments](file://.opencode/skills/asciidoc-callouts-vs-inline-comments.md)
