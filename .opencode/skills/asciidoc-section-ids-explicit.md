# Skill: asciidoc-section-ids-explicit

## Description

Every section MUST have an explicit ID using `[#id-name]` syntax. Forbidden: auto-generated IDs.

## When to Load

Load this skill when writing or reviewing section headings in any `.adoc` file.

## Source

STANDARDS.adoc §9.5 (lines 3233–3249)

## Key Rules

- MANDATE: Every section MUST have an explicit ID.
- MANDATE: IDs use lowercase with hyphens (kebab-case).
- FORBIDDEN: Relying on auto-generated IDs.
- MANDATE: Place the `[#id-name]` block immediately before the `== Title` line.
- MANDATE: xref references MUST use the explicit ID, not an auto-generated one.

## Example

### CORRECT — explicit stable ID

```asciidoc
[#deployment-procedure]
== Deployment Procedure
// ID is explicit, stable, rename-proof
// xref:deployment-procedure[] always works
```

Usage in cross-reference:

```asciidoc
See <<deployment-procedure>> for details.
// OR
See xref:deployment-procedure[] for details.
```

### INCORRECT — auto-generated ID

```asciidoc
== Deployment Procedure
// Auto-generated: _deployment_procedure — breaks when title changes
```

### INCORRECT — using a non-kebab-case ID

```asciidoc
[#DeploymentProcedure]
== Deployment Procedure
// Violates: IDs use lowercase with hyphens
```

### INCORRECT — no ID at all

```asciidoc
== Deployment Procedure
// xrefs to this section are fragile — they depend on the auto-generated ID
```

## Rationale

Auto-generated IDs (e.g., `_deployment_procedure`) change when the heading
text changes, which silently breaks cross-references across the entire
documentation set. Explicit IDs survive title rewrites, refactoring, and
translation, making the documentation robust and maintainable at scale.

## Related Skills

- [asciidoc-cross-references-explicit](file://.opencode/skills/asciidoc-cross-references-explicit.md)
- [asciidoc-file-naming-kebab](file://.opencode/skills/asciidoc-file-naming-kebab.md)
