---
name: nushell-linting-nu-lint-toml
description: Description
compatibility: opencode
---

# Nu-Lint TOML Configuration

## Description
Project root SHALL contain a `.nu-lint.toml` configuration with all rule groups.

## When to Load
Load this skill when setting up a new Nushell project or configuring linter rules.

## Source
STANDARDS.adoc §11.5.11 (lines 4492–4536)

## Key Rules

- MANDATE: Project root SHALL contain a `.nu-lint.toml` configuration
- MANDATE: ALL `.nu` files SHALL pass `nu-lint` in CI

## Rationale

A `.nu-lint.toml` at the project root ensures consistent linting across all contributors and CI environments. Configuration groups and rules codify the project's Nushell coding standards.

## Example

```toml
# .nu-lint.toml — project root
max_pipeline_length = 80
pipeline_placement = "start"
explicit_optional_access = true

[groups]
security     = "error"
type-safety  = "error"
performance  = "warning"
naming       = "error"
formatting   = "error"
documentation = "warning"
idioms       = "error"
effects      = "error"

[rules]
kebab_case_commands          = "error"
snake_case_variables         = "error"
screaming_snake_constants    = "error"
missing_output_type          = "error"
add_type_hints_arguments     = "error"
add_doc_comment_exported_fn  = "warning"
unchecked_cell_path_index    = "error"
inconsistent_pipe_spacing    = "error"
for_instead_of_each          = "warning"
mut_instead_of_reduce        = "warning"
hat_external_commands        = "error"
dynamic_script_import        = "error"
```

## Related Skills
- nushell-linting-nu-lint-mandate
- nushell-linting-ci-integration
- nushell-linting-nu-lint-toml-reference
