---
name: nushell-module-export-env
description: Description
compatibility: opencode
---

# Export Env for Environment Setup

## Description
Use `export-env` blocks for environment setup instead of modifying `$env` at the top level of a module.

## When to Load
Load this skill when defining environment variables, PATH modifications, or shell setup in modules.

## Source
STANDARDS.adoc §11.5.6 (lines 4246–4252, 4310)

## Key Rules

- MANDATE: `export-env` for environment setup blocks
- MANDATE: ONLY necessary definitions are `export`-ed

## Rationale

`export-env` creates a scoped block where environment modifications are explicitly declared as intentional exports. Top-level `$env.FOO = 'bar'` in a module is executed at parse time and can have unpredictable side effects. `export-env` makes the intent clear and groups all environment changes.

## Example

```nu
# CORRECT — export-env block
export-env {
    $env.FOO = 'bar'
    $env.PATH = ($env.PATH | prepend '/custom/bin')
    $env.MY_APP_CONFIG = '/etc/my-app/config.toml'
}

# INCORRECT — top-level env modifications
$env.FOO = 'bar'                    # runs at parse time, side effects
$env.PATH = ($env.PATH | prepend '/custom/bin')

# CORRECT — export-env with conditional logic
export-env {
    if (which my-app | is-not-empty) {
        $env.MY_APP_HOME = '/opt/my-app'
    }
}

# CORRECT — export-env in module with other exports
export def main [] { ... }
export def helper [] { ... }

export-env {
    $env.MY_VAR = 'value'
}
```
