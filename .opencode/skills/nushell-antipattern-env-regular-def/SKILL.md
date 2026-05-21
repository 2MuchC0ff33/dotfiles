---
name: nushell-antipattern-env-regular-def
description: Description
compatibility: opencode
---

# Anti-Pattern #9: Env Changes in Regular Def

## Description
Anti-pattern: `env` changes in regular `def`. Use `def --env` to propagate environment changes.

## When to Load
Load this skill when defining commands that modify environment variables.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4433)

## Key Rules

- FORBIDDEN: `env` changes in regular `def`
- MANDATE: Use `def --env` to propagate environment modifications

## Rationale

Regular `def` commands operate in a scoped environment. Any changes to `$env` inside a regular `def` are discarded when the function returns. `def --env` preserves those changes in the caller's scope.

## Example

```nu
# BAD — env change in regular def (anti-pattern #9)
def set-path [] {
    $env.PATH = ($env.PATH | prepend '/custom/bin')
    # PATH change is discarded when this returns!
}

# GOOD — def --env propagates changes
def --env set-path [] {
    $env.PATH = ($env.PATH | prepend '/custom/bin')
}

# BAD — multiple env changes lost
def configure [] {
    $env.APP_MODE = 'production'
    $env.LOG_LEVEL = 'debug'
}

# GOOD — def --env works
def --env configure [] {
    $env.APP_MODE = 'production'
    $env.LOG_LEVEL = 'debug'
}

# BAD — env changes that need propagation
def use-python3 [] {
    $env.PYTHON = (which python3 | get path.0)
}

# GOOD — explicit --env
def --env use-python3 [] {
    $env.PYTHON = (which python3 | get path.0)
}
```
