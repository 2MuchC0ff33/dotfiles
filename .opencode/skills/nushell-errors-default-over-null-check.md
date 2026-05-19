# Default Over Manual Null Check

## Description
Use `default` for optional/fallback values instead of manual null checks with `if`/`else`.

## When to Load
Load this skill when handling potentially null values or providing fallback defaults.

## Source
STANDARDS.adoc §11.5.7 (lines 4255–4265, 4298–4304)

## Key Rules

- SHOULD: Use `default` for optional/fallback values instead of manual null checks
- MANDATE: Fallible operations MUST be wrapped in `try`/`catch`

## Rationale

Manual null checks with `if`/`else` are verbose, easy to get wrong, and break pipeline flow. `default` is declarative and composable within pipelines.

## Example

```nu
# BAD — manual null check
let name = if $input == null { 'anonymous' } else { $input }

# GOOD — default
let name = $input | default 'anonymous'

# BAD — manual null check in pipeline
let config = if $optional_config == null {
    {host: 'localhost', port: 8080}
} else {
    $optional_config
}

# GOOD — default in pipeline
let config = $optional_config | default {host: 'localhost', port: 8080}

# BAD — manual check for optional field
let version = if ($record.version? == null) { '0.0.0' } else { $record.version? }

# GOOD — default with optional field access
let version = $record.version? | default '0.0.0'

# BAD — nested manual null handling
let greeting = if $user.name == null {
    'Hello, guest!'
} else {
    $'Hello, ($user.name)!'
}

# GOOD — chain default with string interpolation
let name = $user.name? | default 'guest'
let greeting = $'Hello, ($name)!'
```
