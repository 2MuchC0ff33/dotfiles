# Skill: asciidoc-file-naming-kebab

## Description

All `.adoc` files MUST use kebab-case naming. Forbidden: PascalCase, camelCase, spaces, or non-adoc extensions.

## When to Load

Load this skill when creating or renaming any `.adoc` documentation file.

## Source

STANDARDS.adoc §9.3 (lines 3196–3213)

## Key Rules

- MANDATE: File names MUST be kebab-case (lowercase letters, hyphens between words).
- MANDATE: File extension MUST be `.adoc`.
- FORBIDDEN: PascalCase (`Deployment_Procedure.adoc`).
- FORBIDDEN: camelCase (`deploymentProcedure.adoc`).
- FORBIDDEN: Spaces (`deployment procedure.adoc`).
- FORBIDDEN: Wrong extension (`deployment-procedure.txt`).
- MANDATE: Image files also follow kebab-case (`deployment-flow-diagram.png`).
- FORBIDDEN: Generic image names (`diagram1.png`).
- FORBIDDEN: PascalCase image names (`DeploymentFlow.png`).

## Example

### CORRECT file names

```
deployment-procedure.adoc
installation-guide.adoc
api-reference.adoc
configuration-options.adoc
troubleshooting-network-errors.adoc
```

### CORRECT image names

```
deployment-flow-diagram.png
architecture-overview.svg
network-topology-diagram.png
```

### INCORRECT file names

```
Deployment_Procedure.adoc       # PascalCase with underscores
deploymentProcedure.adoc        # camelCase
deployment procedure.adoc       # spaces
deployment-procedure.txt        # wrong extension
deployment-procedure.md         # wrong format entirely
```

### INCORRECT image names

```
diagram1.png                    # generic, not descriptive
DeploymentFlow.png              # PascalCase
deployment Flow.png             # space
```

## Rationale

Kebab-case is the Unix convention — it avoids confusion in URL slugs,
case-sensitive file systems, shell tab-completion, and cross-platform
git operations. Consistent naming means tooling (linters, search, build
scripts) can reliably discover and process files without special-casing.

## Related Skills

- [asciidoc-directory-naming](file://.opencode/skills/asciidoc-directory-naming.md)
- [asciidoc-section-ids-explicit](file://.opencode/skills/asciidoc-section-ids-explicit.md)
