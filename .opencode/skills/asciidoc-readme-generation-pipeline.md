# Skill: asciidoc-readme-generation-pipeline

## Description

README generation pipeline: README.adoc → asciidoctor (DocBook) → pandoc (GFM) → README.md. README.md is in `.gitignore`, NEVER committed. Generation only at release time.

## When to Load

Load this skill when setting up the README build pipeline, generating README.md, or configuring .gitignore for documentation artifacts.

## Source

STANDARDS.adoc §9.8 (lines 3300–3314)

## Key Rules

- MANDATE: Only `README.adoc` is edited manually — it is the single source of truth.
- MANDATE: `README.md` MUST be in `.gitignore` and NEVER committed to the repository.
- MANDATE: README generation happens ONLY at release time (via xtask release).
- MANDATE: The pipeline is: `README.adoc` → asciidoctor (DocBook) → pandoc (GFM) → `README.md`.
- FORBIDDEN: Editing `README.md` directly.
- FORBIDDEN: Committing `README.md` to version control.
- FORBIDDEN: Regenerating `README.md` on every build (release only).

## Pipeline

```
README.adoc (source of truth)
    │
    ▼  asciidoctor --backend=docbook
README.xml (intermediate DocBook)
    │
    ▼  pandoc --from=docbook --to=gfm
README.md (generated for crates.io, in .gitignore)
```

## Example

### CORRECT — .gitignore entry

```gitignore
# README.md is generated from README.adoc at release time only
README.md
```

### CORRECT — release pipeline command

```bash
# Within xtask release or CI release job:
asciidoctor --backend=docbook -o README.xml README.adoc
pandoc --from=docbook --to=gfm -o README.md README.xml
rm README.xml
```

### INCORRECT — committing README.md

```
$ git add README.md   # FORBIDDEN — README.md is generated
```

### INCORRECT — editing README.md directly

```markdown
<!-- This file was hand-edited -- changes will be overwritten -->
# My Project
...
// FORBIDDEN — only README.adoc is the source of truth
```

### INCORRECT — regenerating on every build

```makefile
build:
	asciidoctor README.adoc   # Wrong — README.md should not be regenerated every build
```

## Rationale

Separating the source format (AsciiDoc, semantically rich) from the
generated format (GitHub Flavored Markdown, platform-specific) ensures
that the full power of AsciiDoc is available for authoring while
GitHub/crates.io gets the format they require. Generating only at release
prevents diff noise from automated regeneration and makes the release
commit the definitive record of what was published.

## Related Skills

- [asciidoc-document-header](file://.opencode/skills/asciidoc-document-header.md)
- [asciidoc-attributes-for-repeated-values](file://.opencode/skills/asciidoc-attributes-for-repeated-values.md)
- [asciidoc-build-failure-level](file://.opencode/skills/asciidoc-build-failure-level.md)
