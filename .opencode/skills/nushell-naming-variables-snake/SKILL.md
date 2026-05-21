---
name: nushell-naming-variables-snake
description: Description
compatibility: opencode
---

# Nushell Naming: Variables and Parameters MUST Be snake_case

## Description
All variables, parameters, `let` bindings, `mut` bindings, and function parameters MUST use snake_case naming.

## When to Load
Load this skill when declaring variables (`let`, `mut`), defining command parameters, binding loop variables, or reviewing any identifier that holds a value in `.nu` scripts.

## Source
STANDARDS.adoc §11.5.1 (lines 4027–4059)

## Key Rules

- MANDATE: All variable names and command parameters MUST be snake_case: `$user_id`, `$db_conn`, `$record_count`, `$file_path`.
- MANDATE: Use underscore (`_`) as the word separator between lowercase words.
- MANDATE: Single-letter variable names are acceptable only for generic loop counters (`$i`, `$n`) or mathematical conventions (`$x`, `$y`).
- FORBIDDEN: camelCase in variables: `$userId`, `$dbConn`, `$recordCount`.
- FORBIDDEN: PascalCase in variables: `$UserId`, `$DbConn`, `$RecordCount`.
- FORBIDDEN: kebab-case in variables: `$user-id`, `$db-conn`, `$record-count` (Nushell interprets hyphens in identifiers as subtraction).
- FORBIDDEN: Abbreviations where full words exist: `$usr_nm` → `$user_name`.

## Rationale

1. Snake_case visually distinguishes variables from commands (which are kebab-case), making pipeline code easier to scan.
2. Nushell's `$` sigil already marks variables; snake_case adds an additional visual cue about the semantic role.
3. Hyphens in Nushell identifiers can be ambiguous or interpreted as subtraction operators in certain contexts, making kebab-case dangerous for variables.
4. Snake_case is the dominant convention across most scripting languages (Python, Ruby, Rust) and reduces context-switching.

## Examples

### CORRECT

```nu
let user_id = 42
let db_conn = open --raw 'db.sqlite'
let record_count = ($data | length)
mut file_path = '/tmp/output.json'
def greet [user_name: string] {
    $'Hello ($user_name)'
}
for $item in $items {
    print $item
}
```

### INCORRECT

```nu
let userId = 42                     # camelCase — FORBIDDEN
let dbConn = open --raw 'db.sqlite' # camelCase — FORBIDDEN
let $record-count = 5               # hyphen — NOT valid identifier
mut filePath = '/tmp/output.json'   # camelCase — FORBIDDEN
def greet [userName: string] { }    # camelCase parameter — FORBIDDEN
let usr_nm = 'Alice'                # abbreviation — FORBIDDEN
let qry_result = ...                # abbreviation (qry → query) — FORBIDDEN
```

## Interaction With Other Rules

- Environment variables use SCREAMING_SNAKE_CASE (see `nushell-naming-env-vars-screaming-snake`).
- Constants use SCREAMING_SNAKE_CASE (see `nushell-naming-constants-screaming-snake`).
- Command names use kebab-case (see `nushell-naming-commands-kebab`), maintaining visual distinction.

## Related Skills

- [nushell-naming-env-vars-screaming-snake](file://.opencode/skills/nushell-naming-env-vars-screaming-snake.md)
- [nushell-naming-constants-screaming-snake](file://.opencode/skills/nushell-naming-constants-screaming-snake.md)
- [nushell-naming-commands-kebab](file://.opencode/skills/nushell-naming-commands-kebab.md)
- [nushell-naming-no-abbreviations](file://.opencode/skills/nushell-naming-no-abbreviations.md)
- [nushell-naming-forbidden-pascal-case](file://.opencode/skills/nushell-naming-forbidden-pascal-case.md)
