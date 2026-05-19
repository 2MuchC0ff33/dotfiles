# Skill: asciidoc-attributes-for-repeated-values

## Description

ALL repeated values MUST be AsciiDoc attributes (`:attr-name:`), never hardcoded.

## When to Load

Load this skill when writing documentation that references the same product name, version, URL, path, or any other value in multiple places.

## Source

STANDARDS.adoc §9.6 (line 3262)

## Key Rules

- MANDATE: ALL repeated values MUST be defined as AsciiDoc attributes.
- MANDATE: Reference attributes using `{attr-name}` syntax.
- MANDATE: Define attributes in the document header or in `antora.yml` for cross-page values.
- FORBIDDEN: Hardcoding the same value in multiple locations.
- SHOULD: Define version numbers, product names, URLs, file paths, and common commands as attributes.
- SHOULD: Use file-scoped attributes for page-specific values and component-level attributes in `antora.yml` for values shared across pages.

## Example

### CORRECT — attributes defined in header

```asciidoc
= Deployment Guide
:product-name: MyApp
:product-version: 3.2.1
:api-base-url: https://api.example.com/v3

Welcome to {product-name} v{product-version}.
The {product-name} API is available at {api-base-url}.
Refer to the {product-name} changelog for version history.
```

### CORRECT — using attributes for commands

```asciidoc
:install-cmd: cargo install --locked
:build-cmd: cargo build --release

To install, run {install-cmd} my-tool.
To build from source, run {build-cmd}.
```

### INCORRECT — hardcoded repeated values

```asciidoc
Welcome to MyApp v3.2.1.
The MyApp API is available at https://api.example.com/v3.
Refer to the MyApp changelog for version history.
// If MyApp or 3.2.1 changes, all three lines must be updated manually
```

### INCORRECT — mixed style

```asciidoc
:product-name: MyApp

Welcome to {product-name} v3.2.1.
// Version is hardcoded; product-name is an attribute — inconsistent
```

## Rationale

Hardcoded repeated values are a maintenance liability. Every version bump,
renaming, or URL change requires hunting through multiple files for all
occurrences. Attributes provide a single source of truth: change the
attribute definition, and every reference updates automatically. This is
especially critical in large documentation sets with dozens or hundreds of
pages.

## Related Skills

- [asciidoc-document-header](file://.opencode/skills/asciidoc-document-header.md)
- [asciidoc-readme-generation-pipeline](file://.opencode/skills/asciidoc-readme-generation-pipeline.md)
