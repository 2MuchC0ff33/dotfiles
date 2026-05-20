# Skill: asciidoc-build-failure-level

## Description

ALL builds fail on ANY warning (`--failure-level=WARN`). ALL cross-references validated at build time. ALL prose passes Vale linting at warning level.

## When to Load

Load this skill when configuring CI build pipelines, setting up asciidoctor build flags, or ensuring documentation quality gates.

## Source

STANDARDS.adoc §9.1 (lines 3190–3192)

## Key Rules

- MANDATE: ALL builds MUST fail on ANY warning (`--failure-level=WARN`).
- MANDATE: ALL cross-references MUST be validated at build time.
- MANDATE: ALL prose MUST pass Vale linting at warning level.
- MANDATE: Zero tolerance for ambiguous structure.
- MANDATE: Zero tolerance for inconsistent terminology.
- MANDATE: Zero tolerance for documentation that cannot build.
- SHOULD: Use `asciidoctor --failure-level=WARN` in CI.
- SHOULD: Validate cross-references with additional linting tools.
- SHOULD: Run Vale linting as part of the documentation build step.

## Example

### CORRECT — CI build command

```bash
asciidoctor --failure-level=WARN -o /dev/null docs/modules/ROOT/pages/*.adoc
```

### CORRECT — full documentation CI pipeline

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== Linting prose ==="
vale docs/

echo "=== Building documentation ==="
asciidoctor --failure-level=WARN -o /dev/null docs/modules/ROOT/pages/*.adoc

echo "=== Documentation checks passed ==="
```

### CORRECT — justfile recipe

```makefile
# docs check — validate all documentation builds cleanly
docs-check:
    vale docs/
    asciidoctor --failure-level=WARN -o /dev/null docs/modules/ROOT/pages/*.adoc
```

### INCORRECT — no failure-level flag

```bash
asciidoctor -o /dev/null docs/modules/ROOT/pages/*.adoc
// Warnings are printed but ignored — broken references pass CI
```

### INCORRECT — failure-level set too high

```bash
asciidoctor --failure-level=ERROR -o /dev/null docs/modules/ROOT/pages/*.adoc
// Warnings do not fail the build — allows broken cross-references
```

### INCORRECT — no Vale linting

```bash
asciidoctor --failure-level=WARN -o /dev/null docs/modules/ROOT/pages/*.adoc
// asciidoctor passes, but prose may contain forbidden language or style issues
```

## Rationale

A documentation build that emits warnings is silently broken. Auto-generated
IDs change, cross-references decay, and terminology drifts — warnings signal
these issues. By failing the build on ANY warning, the standard enforces
that documentation quality is maintained continuously, not just at release
time. Combined with Vale linting at warning level, every prose issue is
caught before it reaches readers.

## Related Skills

- [asciidoc-vale-config](file://.opencode/skills/asciidoc-vale-config.md)
- [asciidoc-cross-references-explicit](file://.opencode/skills/asciidoc-cross-references-explicit.md)
- [asciidoc-section-ids-explicit](file://.opencode/skills/asciidoc-section-ids-explicit.md)
- [asciidoc-readme-generation-pipeline](file://.opencode/skills/asciidoc-readme-generation-pipeline.md)
