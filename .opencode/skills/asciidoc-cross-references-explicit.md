# Skill: asciidoc-cross-references-explicit

## Description

ALL cross-references use explicit IDs, never auto-generated. Use `xref:` syntax for cross-page references.

## When to Load

Load this skill when linking between sections within a page or between pages in the documentation.

## Source

STANDARDS.adoc §9.6 (line 3300)

## Key Rules

- MANDATE: ALL cross-references MUST use explicit IDs.
- MANDATE: NEVER reference auto-generated IDs.
- MANDATE: Use `xref:<page>#<section-id>[]` for cross-page references.
- MANDATE: Use `<<section-id>>` for intra-page references (or `xref:#section-id[]`).
- MANDATE: Explicit IDs MUST use lowercase with hyphens (kebab-case).
- FORBIDDEN: References to auto-generated IDs like `<<_deployment_procedure>>`.

## Example

### CORRECT — intra-page reference

```asciidoc
[#prerequisites]
== Prerequisites

Before proceeding, complete the <<installation>> steps.

[#installation]
== Installation

// Both sections have explicit IDs; the xref survives title changes
```

### CORRECT — cross-page reference with xref

```asciidoc
See xref:installation#prerequisites[] for system requirements.
// References page "installation.adoc", section with ID "prerequisites"
```

### CORRECT — xref with custom link text

```asciidoc
For more details, see xref:reference:configuration.adoc#logging[Logging Configuration].
```

### INCORRECT — auto-generated ID reference

```asciidoc
See <<_deployment_procedure>> for details.
// The ID is auto-generated — breaks if the heading text changes
```

### INCORRECT — referencing page without explicit section ID

```asciidoc
See xref:installation.adoc#_getting_started[].
// Auto-generated ID — fragile and non-explicit
```

## Rationale

Auto-generated IDs (e.g., `_deployment_procedure`) are derived from heading
text and change silently when a heading is rewritten. Every changed heading
can potentially break dozens of cross-references across the documentation
set. Explicit IDs decouple the reference from the display text, making the
entire documentation graph resilient to content edits.

## Related Skills

- [asciidoc-section-ids-explicit](file://.opencode/skills/asciidoc-section-ids-explicit.md)
- [asciidoc-external-links-descriptive](file://.opencode/skills/asciidoc-external-links-descriptive.md)
- [asciidoc-build-failure-level](file://.opencode/skills/asciidoc-build-failure-level.md)
