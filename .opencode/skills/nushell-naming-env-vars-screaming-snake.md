# Nushell Naming: Environment Variables MUST Be SCREAMING_SNAKE_CASE

## Description
All environment variables accessed via `$env.*` MUST use SCREAMING_SNAKE_CASE (all uppercase with underscore separators).

## When to Load
Load this skill when setting environment variables, accessing `$env.*` values, defining process environment overrides, or configuring shell environment in `env.nu` or `config.nu`.

## Source
STANDARDS.adoc §11.5.1 (lines 4027–4059)

## Key Rules

- MANDATE: All environment variables MUST be SCREAMING_SNAKE_CASE: `$env.APP_VERSION`, `$env.DATABASE_URL`, `$env.NODE_ENV`.
- MANDATE: Words MUST be separated by underscores (`_`) and be entirely uppercase.
- MANDATE: Prefix with project/organization identifier when defining custom env vars to avoid collisions: `$env.MYPROJ_LOG_LEVEL` not `$env.LOG_LEVEL`.
- FORBIDDEN: lowercase or mixed-case env var names: `$env.AppVersion`, `$env.app_version`, `$env.appVersion`.
- FORBIDDEN: kebab-case in env var names: `$env.app-version`.
- FORBIDDEN: Using `$env` for local configuration that should be a regular variable or constant.

## Rationale

1. SCREAMING_SNAKE_CASE is the universal convention for environment variables across all operating systems (POSIX, Windows) and languages (C, Python, Rust, Node.js).
2. Environment variables are global by nature — SCREAMING_SNAKE_CASE signals their special status and visually distinguishes them from local variables.
3. Nushell's `$env` scope already differentiates env vars; the naming convention provides a second visual cue.
4. Consistency with the broader ecosystem ensures that tools, CI systems, and container runtimes all interact predictably.

## Examples

### CORRECT

```nu
$env.APP_VERSION = '1.2.3'
$env.DATABASE_URL = 'postgres://localhost:5432/mydb'
$env.NODE_ENV = 'production'
$env.MYPROJ_LOG_LEVEL = 'debug'
$env.RUST_LOG = 'info'
$env.PATH = ($env.PATH | prepend '/usr/local/bin')
```

### INCORRECT

```nu
$env.app_version = '1.2.3'          # lowercase — FORBIDDEN
$env.AppVersion = '1.2.3'           # PascalCase — FORBIDDEN
$env.app-version = '1.2.3'          # kebab-case — FORBIDDEN
$env.DbUrl = 'postgres://...'       # camelCase — FORBIDDEN
$env.log_level = 'debug'            # snake_case not screaming — FORBIDDEN
$env.Version = '1.0'                # PascalCase — FORBIDDEN
```

## Related Skills

- [nushell-naming-constants-screaming-snake](file://.opencode/skills/nushell-naming-constants-screaming-snake.md)
- [nushell-naming-variables-snake](file://.opencode/skills/nushell-naming-variables-snake.md)
- [nushell-naming-forbidden-pascal-case](file://.opencode/skills/nushell-naming-forbidden-pascal-case.md)
