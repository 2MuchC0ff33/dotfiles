---
name: nushell-naming-files-kebab
description: Description
compatibility: opencode
---

# Nushell Naming: Files/Modules MUST Be kebab-case

## Description
All `.nu` script files and module paths MUST use kebab-case naming.

## When to Load
Load this skill when creating new `.nu` files, organizing scripts into modules, importing files with `use` or `source`, or designing a file hierarchy for a Nushell project.

## Source
STANDARDS.adoc §11.5.1 (lines 4027–4059)

## Key Rules

- MANDATE: All `.nu` file names MUST be kebab-case: `utils.nu` → `util-helpers.nu`, `db-migrate.nu`, `config-validate.nu`.
- MANDATE: Module directories should also use kebab-case if they form part of the module path.
- MANDATE: File names should describe the primary export or purpose in 1–3 hyphen-separated words.
- FORBIDDEN: snake_case in file names: `util_helpers.nu`, `db_migrate.nu`, `config_validate.nu`.
- FORBIDDEN: camelCase in file names: `dbMigrate.nu`, `configValidate.nu`.
- FORBIDDEN: PascalCase in file names: `DbMigrate.nu`, `ConfigValidate.nu`.
- FORBIDDEN: File names with spaces or special characters beyond hyphens.

## Rationale

1. kebab-case file names are standard across the Nushell ecosystem and match the command naming convention.
2. Many operating systems are case-preserving but case-insensitive (macOS, Windows); kebab-case avoids ambiguity entirely since hyphens have no case.
3. kebab-case URLs and paths are URL-friendly and do not require encoding.
4. Consistency between file names and the commands they export makes the module system predictable: `use db-migrate.nu` exports commands consistent with the file name.

## Examples

### CORRECT

```nu
# File names:
#   utils.nu
#   db-migrate.nu
#   config-validate.nu
#   http-client.nu
#   file-watcher.nu
#   data-transform.nu

# Usage:
use utils.nu
use db-migrate.nu
source config-validate.nu
```

### INCORRECT

```nu
# File names:
#   utils.nu              # snake_case — FORBIDDEN
#   db_migrate.nu          # snake_case — FORBIDDEN
#   configValidate.nu      # camelCase — FORBIDDEN
#   DbMigrate.nu           # PascalCase — FORBIDDEN
#   http_client.nu         # snake_case — FORBIDDEN
#   dataTransform.nu       # camelCase — FORBIDDEN

# Usage:
use utils.nu               # references a file that doesn't exist
```

## Interaction With Other Rules

- File names for command modules should match the primary command they export (e.g., `fetch-user.nu` for `def fetch-user`).
- Module paths used with `use` reflect the file naming convention directly.

## Related Skills

- [nushell-naming-commands-kebab](file://.opencode/skills/nushell-naming-commands-kebab.md)
- [nushell-naming-commands-subcommands-kebab](file://.opencode/skills/nushell-naming-commands-subcommands-kebab.md)
- [nushell-naming-no-abbreviations](file://.opencode/skills/nushell-naming-no-abbreviations.md)
- [nushell-naming-forbidden-pascal-case](file://.opencode/skills/nushell-naming-forbidden-pascal-case.md)
