# Nushell Naming: Constants MUST Be SCREAMING_SNAKE_CASE

## Description
All constants declared with `const` MUST use SCREAMING_SNAKE_CASE (all uppercase with underscore separators).

## When to Load
Load this skill when declaring new constants with `const`, defining configuration values, setting static lookup tables, or reviewing constant naming in `.nu` files.

## Source
STANDARDS.adoc §11.5.1 (lines 4027–4059)

## Key Rules

- MANDATE: All `const` declarations MUST be SCREAMING_SNAKE_CASE: `const API_VERSION = '1.0'`, `const MAX_RETRIES = 3`.
- MANDATE: All constants MUST include a type annotation (see `nushell-types-const-typed`).
- FORBIDDEN: snake_case for constants: `const api_version = '1.0'`, `const max_retries = 3`.
- FORBIDDEN: camelCase for constants: `const apiVersion = '1.0'`, `const maxRetries = 3`.
- FORBIDDEN: kebab-case for constants (not valid Nushell syntax anyway for `const`).
- FORBIDDEN: PascalCase for constants: `const ApiVersion = '1.0'`, `const MaxRetries = 3`.

## Rationale

1. SCREAMING_SNAKE_CASE for constants is the convention across virtually every programming language (C, Rust, Python, TypeScript), signaling immutability and compile-time known values.
2. It visually distinguishes constants from regular variables, which use snake_case.
3. Constants are typically domain-specific values (limits, versions, configuration keys) that benefit from the emphasis of uppercase naming.
4. The visual weight of SCREAMING_SNAKE_CASE serves as a cognitive reminder that the value is not just immutable (`let` is also immutable by default) but computed at parse-time, not runtime.

## Examples

### CORRECT

```nu
const API_VERSION: string = '1.0'
const MAX_RETRIES: int = 3
const DEFAULT_TIMEOUT_MS: int = 30_000
const LOG_LEVEL: string = 'info'
const SUPPORTED_FORMATS: list<string> = ['json', 'yaml', 'toml']
const DB_PATH: string = '/var/lib/app/data.sqlite'
```

### INCORRECT

```nu
const api_version = '1.0'           # snake_case — FORBIDDEN
const maxRetries = 3                # camelCase — FORBIDDEN
const DefaultTimeout = 30_000       # PascalCase — FORBIDDEN
const LOGLEVEL = 'info'             # no underscore separator — unreadable
const SUPPORTED_FORMATS = ['json']  # missing type annotation — FORBIDDEN
```

## Related Skills

- [nushell-types-const-typed](file://.opencode/skills/nushell-types-const-typed.md)
- [nushell-naming-env-vars-screaming-snake](file://.opencode/skills/nushell-naming-env-vars-screaming-snake.md)
- [nushell-naming-variables-snake](file://.opencode/skills/nushell-naming-variables-snake.md)
- [nushell-naming-forbidden-pascal-case](file://.opencode/skills/nushell-naming-forbidden-pascal-case.md)
