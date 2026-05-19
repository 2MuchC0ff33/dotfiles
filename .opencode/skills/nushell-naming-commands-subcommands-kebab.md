# Nushell Naming: Sub-commands MUST Be kebab-case With Space Separation

## Description
Sub-commands (nested commands dispatched by a parent) MUST use kebab-case for each segment, separated by a space.

## When to Load
Load this skill when defining sub-commands via `def "parent child"`, reviewing command hierarchies, or designing CLI command trees in Nushell.

## Source
STANDARDS.adoc §11.5.1 (lines 3969–4001)

## Key Rules

- MANDATE: Sub-commands MUST use kebab-case separated by a space inside double quotes: `def "db migrate" []`, `def "config validate" []`.
- MANDATE: Each hyphen-separated segment of the sub-command name must follow kebab-case rules individually.
- MANDATE: The parent command name and each sub-command word must be full, unabbreviated words.
- FORBIDDEN: snake_case or camelCase inside sub-command names: `def "db_migrate" []`, `def "configValidate" []`.
- FORBIDDEN: Using a hyphen where a space is intended for hierarchy: `def db-migrate []` is a flat command, not a sub-command.
- FORBIDDEN: Mixing delimiters (e.g., `def "db-migrate" []` with a hyphen when a space parent-child relationship is intended).

## Rationale

1. Nushell's string-quoted sub-command syntax (`def "parent child" []`) is the idiomatic way to create hierarchical command namespaces.
2. Space separation mirrors natural language command structures (e.g., `git commit`, `cargo build`), making the hierarchy intuitive.
3. Kebab-case within each segment maintains consistency with flat command naming while adding organizational structure.
4. This pattern enables command grouping without external module systems — the parent acts as a namespace.

## Examples

### CORRECT

```nu
def "db migrate" [direction: string] { }
def "db rollback" [steps: int] { }
def "config validate" [] { }
def "config show" [section: string] { }
def "image resize" [path: string, width: int, height: int] { }
def "image crop" [path: string, x: int, y: int] { }
def "user create" [name: string, email: string] { }
def "user delete" [user_id: int] { }
```

### INCORRECT

```nu
def "db_migrate" [direction] { }        # snake_case — FORBIDDEN
def "configValidate" [] { }             # camelCase — FORBIDDEN
def "db migrate" [dir] { }              # abbreviation — FORBIDDEN
def "image-resize" [path, w, h] { }     # hyphen instead of space — wrong hierarchy
def "User Create" [name, email] { }     # PascalCase segments — FORBIDDEN
def "config_show" [section] { }         # snake_case segment — FORBIDDEN
```

## Related Skills

- [nushell-naming-commands-kebab](file://.opencode/skills/nushell-naming-commands-kebab.md)
- [nushell-naming-forbidden-pascal-case](file://.opencode/skills/nushell-naming-forbidden-pascal-case.md)
- [nushell-naming-no-abbreviations](file://.opencode/skills/nushell-naming-no-abbreviations.md)
- [nushell-naming-files-kebab](file://.opencode/skills/nushell-naming-files-kebab.md)
