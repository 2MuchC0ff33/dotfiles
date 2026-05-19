# Anti-Pattern #13: Manual Null Checks

## Description
Anti-pattern: Manual null checks. Use `default 'fallback'`.

## When to Load
Load this skill when handling potentially null values or providing fallback defaults.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4379)

## Key Rules

- FORBIDDEN: Manual null checks
- SHOULD: Use `default` for optional/fallback values instead of manual null checks

## Rationale

Manual null checks with `if`/`else` are verbose, break pipeline flow, and are easy to get wrong. `default` is declarative, composable, and idiomatic.

## Example

```nu
# BAD — manual null check (anti-pattern #13)
let name = if $input == null { 'anonymous' } else { $input }

# GOOD — default
let name = $input | default 'anonymous'

# BAD — manual check in pipeline
let config = if $optional_config == null {
    {host: 'localhost', port: 8080}
} else {
    $optional_config
}

# GOOD — default in pipeline
let config = $optional_config | default {host: 'localhost', port: 8080}

# BAD — nested manual handling
let greeting = if $user.name == null {
    'Hello, guest!'
} else {
    $'Hello, ($user.name)!'
}

# GOOD — chain default
let name = $user.name? | default 'guest'
let greeting = $'Hello, ($name)!'

# BAD — manual fallback chain
let port = if $config.port == null {
    if $env.PORT == null {
        8080
    } else { $env.PORT }
} else { $config.port }

# GOOD — nested default
let port = $config.port? | default $env.PORT | default 8080
```
