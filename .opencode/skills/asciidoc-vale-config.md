# Skill: asciidoc-vale-config

## Description

Vale prose lint configuration: `MinAlertLevel = warning`, `BasedOnStyles`, project-specific styles.

## When to Load

Load this skill when setting up or modifying Vale prose linting configuration for documentation.

## Source

STANDARDS.adoc §9.7 (lines 3272–3298)

## Key Rules

- MANDATE: `MinAlertLevel = warning` — no errors, no suggestions, only warnings and above.
- MANDATE: `StylesPath` MUST point to the project's Vale styles directory.
- MANDATE: `[*.adoc]` section MUST define `BasedOnStyles` with active style packages.
- MANDATE: Project-specific styles MUST be explicitly enabled or disabled.
- SHOULD: Use `Vale` and `write-good` as base style packages.
- SHOULD: Enable `Project.Terms`, `Project.Headings`, `Project.Abbreviations`, `Project.Punctuation`.
- SHOULD: Enable `Vale.Avoid`, `Vale.Spelling`, `Vale.Terms`.
- SHOULD: Enable `write-good.Passive`, `write-good.TooWordy`, `write-good.Weasel`, `write-good.ThereIs`.

## Example

### CORRECT — full Vale configuration

```ini
# docs/.vale.ini
StylesPath = vale/styles
MinAlertLevel = warning
Vocab = Project

[*.adoc]
BasedOnStyles = Vale, write-good

Project.Terms = YES
Project.Headings = YES
Project.Abbreviations = YES
Project.Punctuation = YES

Vale.Avoid = YES
Vale.Spelling = YES
Vale.Terms = YES

write-good.Passive = YES
write-good.TooWordy = YES
write-good.Weasel = YES
write-good.ThereIs = YES
```

### CORRECT — location within repository

```
docs/
├── .vale.ini                  # <-- this file
└── vale/
    └── styles/
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

### INCORRECT — wrong alert level

```ini
MinAlertLevel = error
// Too permissive — warnings are ignored
```

### INCORRECT — no MinAlertLevel set

```ini
// Defaults to suggestion level — too lax
```

### INCORRECT — missing BasedOnStyles

```ini
[*.adoc]
// No style packages enabled — no linting happens
```

## Rationale

Setting `MinAlertLevel = warning` ensures that all structural prose issues
are caught in CI without flooding output with low-value suggestions.
Explicitly enabling each style rule gives fine-grained control over what
passes and what fails. Without this configuration, Vale may silently skip
all checks or apply incorrect default rules.

## Related Skills

- [asciidoc-vale-styles](file://.opencode/skills/asciidoc-vale-styles.md)
- [asciidoc-build-failure-level](file://.opencode/skills/asciidoc-build-failure-level.md)
- [asciidoc-forbidden-language](file://.opencode/skills/asciidoc-forbidden-language.md)
