# Skill: asciidoc-document-header

## Description

Mandatory document header template for every `.adoc` page file.

## When to Load

Load this skill when creating or reviewing any `.adoc` documentation page.

## Source

STANDARDS.adoc §9.4 (lines 3215–3231)

## Key Rules

- MANDATE: Every `.adoc` page file MUST have this exact header structure.
- MANDATE: No exceptions. No omissions.
- MANDATE: Order is mandatory — title, author, version, attributes in that order.
- MANDATE: Version line uses `{revnumber}` and `{revdate}` attribute references.
- MANDATE: `:description:` MUST be a single sentence describing the page.
- MANDATE: `:keywords:` MUST list comma-separated keywords for search.
- MANDATE: `:page-status:` MUST be set (e.g., `draft`, `review`, `published`).
- MANDATE: `:page-reviewed-by:` MUST be present (can be empty initially).
- MANDATE: `:page-reviewed-date:` MUST be present (can be empty initially).

## Template

```asciidoc
// RULE: Every .adoc page file MUST have this exact header structure.
// RULE: No exceptions. No omissions.
// RULE: Order is mandatory.

= Page Title in Title Case
Author Name <author@organization.com>
v{revnumber}, {revdate}
:description: One sentence description of this page.
:keywords: keyword1, keyword2, keyword3
:page-status: draft
:page-reviewed-by:
:page-reviewed-date:
```

## Example

### CORRECT

```asciidoc
= Installation Guide
Jane Doe <jane@example.com>
v{revnumber}, {revdate}
:description: Step-by-step instructions for installing the application.
:keywords: installation, setup, configuration, getting-started
:page-status: draft
:page-reviewed-by:
:page-reviewed-date:
```

### INCORRECT — missing header, missing fields, wrong order

```asciidoc
= Installation Guide
:description: Step-by-step instructions.
```

### INCORRECT — hardcoded version instead of attribute references

```asciidoc
= Installation Guide
Jane Doe <jane@example.com>
v1.0.0, March 2026
```

## Rationale

Every page needs a self-describing header so that:
- Build tools can extract metadata for navigation and search.
- Reviewers know the status, who reviewed it, and when.
- Automated tooling can validate completeness.
- Version information stays consistent across the entire documentation set.

## Related Skills

- [asciidoc-attributes-for-repeated-values](file://.opencode/skills/asciidoc-attributes-for-repeated-values.md)
- [asciidoc-vale-config](file://.opencode/skills/asciidoc-vale-config.md)
