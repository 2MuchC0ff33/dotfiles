# Skill: asciidoc-forbidden-language

## Description

Forbidden phrases and patterns in AsciiDoc prose: "Note that", future tense, condescending language, and skipped heading levels.

## When to Load

Load this skill when drafting or editing prose content in any `.adoc` file.

## Source

STANDARDS.adoc §9.6 (lines 3264–3269)

## Key Rules

- FORBIDDEN: "Click here" as link text.
- FORBIDDEN: "Note that" in prose — use a NOTE admonition block instead.
- FORBIDDEN: Future tense ("will be") — use present tense.
- FORBIDDEN: Condescending language — including "simply", "just", "obviously", "of course".
- FORBIDDEN: Admonitions without titles (see asciidoc-admonitions-with-titles).
- FORBIDDEN: Skipped heading levels (e.g., `===` directly after `=` without `==`).

## Example

### CORRECT — present tense, no condescension

```asciidoc
The application connects to the database at startup.
// Present tense — describes current behavior

Configure the timeout value in the settings file.
// Direct instruction — no "simply" or "just"
```

### CORRECT — "Note that" replaced with NOTE admonition

```asciidoc
[NOTE]
=====
The database connection uses TLS 1.3 by default.
=====
```

### INCORRECT — "Note that" in prose

```asciidoc
Note that the database connection uses TLS 1.3 by default.
// "Note that" is filler — use a NOTE admonition
```

### INCORRECT — future tense

```asciidoc
The application will connect to the database on startup.
// "will connect" → "connects"
```

### INCORRECT — condescending language

```asciidoc
Simply run the installer to get started.
// "Simply" is condescending — implies the reader found it difficult

Just edit the configuration file.
// "Just" minimizes the action — may not be trivial for all readers
```

### INCORRECT — skipped heading level

```asciidoc
= Document Title
=== Subsection
// Skipped == level — heading jumps from level 1 to level 3
```

### INCORRECT — "Click here"

```asciidoc
Click here for more information: url[Click here]
// See asciidoc-external-links-descriptive
```

## Rationale

Present tense is factual and timeless — documentation describes what the
system does, not what it will do. "Note that" is redundant prose when a
NOTE admonition is available. Condescending language alienates readers
with varying experience levels. Skipped heading levels break accessibility
(outline structure) and some tooling (table of contents generation).
Every forbidden pattern has a direct, better replacement.

## Related Skills

- [asciidoc-admonitions-with-titles](file://.opencode/skills/asciidoc-admonitions-with-titles.md)
- [asciidoc-external-links-descriptive](file://.opencode/skills/asciidoc-external-links-descriptive.md)
- [asciidoc-one-sentence-per-line](file://.opencode/skills/asciidoc-one-sentence-per-line.md)
- [asciidoc-vale-styles](file://.opencode/skills/asciidoc-vale-styles.md)
