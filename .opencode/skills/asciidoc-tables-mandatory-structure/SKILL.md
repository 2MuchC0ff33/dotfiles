---
name: asciidoc-tables-mandatory-structure
description: Description
compatibility: opencode
---

# Skill: asciidoc-tables-mandatory-structure

## Description

ALL tables MUST have column specs, headers, and titles.

## When to Load

Load this skill when creating or editing any table in an `.adoc` file.

## Source

STANDARDS.adoc §9.6 (line 3299)

## Key Rules

- MANDATE: ALL tables MUST have explicit column specifications.
- MANDATE: ALL tables MUST have a header row.
- MANDATE: ALL tables MUST have a title (`.Title`).
- MANDATE: Column spec MUST precede the table block and define alignment, width, or both.
- SHOULD: Use `[cols="<spec>"]` syntax for column specs.
- FORBIDDEN: Tables without `.Title`, without `[cols]`, or without a header row.
- SHOULD: Use `|===` as the table delimiter (AsciiDoc table syntax).

## Example

### CORRECT — fully specified table

```asciidoc
.Configuration Options
[cols="2,3,1"]
|===
| Option | Description | Default

| `debug`
| Enable debug logging
| `false`

| `port`
| HTTP server port
| `8080`

| `host`
| Bind address
| `0.0.0.0`
|===
```

### CORRECT — with alignment specifiers

```asciidoc
.Package Versions
[cols="1,3,1,1"]
|===
| Package | Version | Status | EOL

| curl
| 8.2.1
| stable
| 2027-06

| openssl
| 3.1.0
| LTS
| 2028-12
|===
```

### INCORRECT — no title

```asciidoc
[cols="2,3,1"]
|===
| Option | Description | Default
| `debug` | Enable debug logging | `false`
|===
// No .Title — violates MANDATE
```

### INCORRECT — no column spec

```asciidoc
.Configuration Options
|===
| Option | Description | Default
| `debug` | Enable debug logging | `false`
|===
// No [cols] — column widths and alignment are undefined
```

### INCORRECT — no header row

```asciidoc
.Configuration Options
[cols="2,3,1"]
|===
| `debug` | Enable debug logging | `false`
| `port` | HTTP server port | `8080`
|===
// No header row — unreadable without context
```

## Rationale

Column specs ensure consistent rendering across output formats (HTML, PDF,
DocBook). Titles make tables referenceable and provide context for screen
readers. Header rows make data self-describing. Without all three, tables
are ambiguous, inaccessible, and prone to rendering breakage.

## Related Skills

- [asciidoc-section-ids-explicit](file://.opencode/skills/asciidoc-section-ids-explicit.md)
- [asciidoc-cross-references-explicit](file://.opencode/skills/asciidoc-cross-references-explicit.md)
