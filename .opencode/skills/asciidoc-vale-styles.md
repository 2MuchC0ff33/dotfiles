# Skill: asciidoc-vale-styles

## Description

Vale styles structure: `Project/` directory with Terms.yml, Headings.yml, Abbreviations.yml, Punctuation.yml. Config vocabularies with accept.txt and reject.txt.

## When to Load

Load this skill when creating, modifying, or reviewing Vale style files for project-specific prose linting rules.

## Source

STANDARDS.adoc §9.2 (lines 3224–3232) and §9.7 (lines 3314–3340)

## Key Rules

- MANDATE: Project-specific styles MUST be in `vale/styles/Project/`.
- MANDATE: Four core style files: `Terms.yml`, `Headings.yml`, `Abbreviations.yml`, `Punctuation.yml`.
- MANDATE: Vocabulary configuration in `vale/styles/config/vocabularies/`.
- MANDATE: `accept.txt` lists approved technical terms that Vale should not flag.
- MANDATE: `reject.txt` lists forbidden terms that Vale MUST flag.
- SHOULD: `Terms.yml` enforces project-specific terminology (e.g., "repository" not "repo").
- SHOULD: `Headings.yml` enforces heading case and structure rules.
- SHOULD: `Abbreviations.yml` defines project-specific abbreviation rules.
- SHOULD: `Punctuation.yml` enforces punctuation style (e.g., Oxford comma, spacing).

## Example

### CORRECT directory layout

```
vale/styles/
├── Project/
│   ├── Terms.yml
│   ├── Headings.yml
│   ├── Abbreviations.yml
│   └── Punctuation.yml
└── config/
    └── vocabularies/
        ├── accept.txt
        └── reject.txt
```

### CORRECT — Terms.yml

```yaml
# Terms.yml — project-specific terminology
extends: substitution
message: "Use '%s' instead of '%s'."
level: warning
scope: text
swap:
  repo: repository
  binary: executable
  info: information
  docs: documentation
  config: configuration
```

### CORRECT — Headings.yml

```yaml
# Headings.yml — heading structure rules
extends: existence
message: "Use sentence case for headings."
level: warning
scope: heading
match: "^[A-Z]"
exceptions:
  - API
  - CLI
  - IDE
```

### CORRECT — Abbreviations.yml

```yaml
# Abbreviations.yml — abbreviation rules
extends: substitution
message: "Spell out '%s' on first use."
level: warning
scope: text
swap:
  e.g.: for example
  i.e.: that is
  etc.: and so on
```

### CORRECT — Punctuation.yml

```yaml
# Punctuation.yml — punctuation rules
extends: existence
message: "Use the Oxford comma."
level: warning
scope: text
match: "\\b(?:\\w+,\\s*\\w+)\\s+(?:and|or)\\b"
```

### CORRECT — accept.txt

```
# Approved technical terms
AsciiDoc
Antora
Helix
Nushell
Jujutsu
Zellij
cargo
rustc
kebab-case
```

### CORRECT — reject.txt

```
# Forbidden terms
click here
simply
just
obviously
of course
note that
will be
```

### INCORRECT — flat file structure

```
vale/
├── Terms.yml
├── Headings.yml
├── accept.txt
// Missing Project/ directory — styles not properly namespaced
```

### INCORRECT — missing vocabulary directory

```
vale/styles/Project/
├── Terms.yml
├── Headings.yml
├── Abbreviations.yml
└── Punctuation.yml
// No config/vocabularies/ — cannot define project-specific accepted/rejected terms
```

## Rationale

A well-structured Vale style directory ensures linting rules are scoped,
maintainable, and composable. The `Project/` namespace separates
project-specific rules from third-party styles (Vale, write-good).
Vocabulary files (`accept.txt`, `reject.txt`) are the single source of
truth for terminology — they prevent false positives on technical terms
and catch forbidden language project-wide.

## Related Skills

- [asciidoc-vale-config](file://.opencode/skills/asciidoc-vale-config.md)
- [asciidoc-forbidden-language](file://.opencode/skills/asciidoc-forbidden-language.md)
- [asciidoc-build-failure-level](file://.opencode/skills/asciidoc-build-failure-level.md)
