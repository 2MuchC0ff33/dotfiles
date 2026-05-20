# Complete Nu-Lint TOML Reference

## Description
Complete `.nu-lint.toml` reference with all groups and rules.

## When to Load
Load this skill when configuring or auditing `.nu-lint.toml` settings.

## Source
STANDARDS.adoc §11.5.11 (lines 4492–4536)

## Key Rules

- MANDATE: ALL `.nu` files SHALL pass `nu-lint` in CI
- MANDATE: Project root SHALL contain a `.nu-lint.toml` configuration

## Configuration Reference

### Top-Level Settings

| Setting | Description | Recommended |
|---|---|---|
| `max_pipeline_length` | Max pipeline stages | `80` |
| `pipeline_placement` | Pipe placement style | `"start"` |
| `explicit_optional_access` | Require `?` for optional fields | `true` |

### Rule Groups

| Group | Recommended | Purpose |
|---|---|---|
| `security` | `"error"` | Code injection, dynamic paths, shell injection |
| `type-safety` | `"error"` | Missing types, unchecked access |
| `performance` | `"warning"` | `for` instead of `each`, `mut` instead of `reduce` |
| `naming` | `"error"` | kebab-case commands, snake_case vars |
| `formatting` | `"error"` | Pipe spacing, bracket style |
| `documentation` | `"warning"` | Missing doc comments on exports |
| `idioms` | `"error"` | Nushell idiomatic patterns |
| `effects` | `"error"` | Side effects, env modifications |

### Individual Rules

| Rule | Recommended | Description |
|---|---|---|
| `kebab_case_commands` | `"error"` | Commands must be kebab-case |
| `snake_case_variables` | `"error"` | Variables must be snake_case |
| `screaming_snake_constants` | `"error"` | Constants must be SCREAMING_SNAKE |
| `missing_output_type` | `"error"` | Def must have output type |
| `add_type_hints_arguments` | `"error"` | All params must have type hints |
| `add_doc_comment_exported_fn` | `"warning"` | Exported functions should have docs |
| `unchecked_cell_path_index` | `"error"` | Prevent missing field panics |
| `inconsistent_pipe_spacing` | `"error"` | Consistent pipe spacing |
| `for_instead_of_each` | `"warning"` | Flag `for` when `each` works |
| `mut_instead_of_reduce` | `"warning"` | Flag `mut` when `reduce` works |
| `hat_external_commands` | `"error"` | Require `^` for shadowed commands |
| `dynamic_script_import` | `"error"` | Ban dynamic `source`/`use` paths |

## Example

```toml
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
- nushell-linting-nu-lint-toml
- nushell-linting-ci-integration
