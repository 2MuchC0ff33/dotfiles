# Nushell Types: Constants MUST Be Typed

## Description
ALL constants declared with `const` MUST include an explicit type annotation.

## When to Load
Load this skill when declaring any new `const` binding, reviewing existing constant declarations, or enforcing type safety in module-level configuration.

## Source
STANDARDS.adoc §11.5.4 (lines 4088–4125)

## Key Rules

- MANDATE: Every `const` declaration MUST include a type annotation: `const FOO: string = 'bar'`.
- MANDATE: The type annotation MUST be placed between the constant name and the `=` sign, separated by `:`.
- MANDATE: The type annotation MUST accurately reflect the value's type.
- FORBIDDEN: `const FOO = 'bar'` — untyped constant declaration.
- FORBIDDEN: Using an incorrect type annotation that does not match the value.
- FORBIDDEN: Omitting the type annotation even when the value's type seems obvious.

## Rationale

1. Type annotations on constants make the expected data shape explicit and serve as documentation.
2. They enable parse-time type checking — improper use of a constant will be caught earlier.
3. Explicit types on constants improve IDE/editor support for autocomplete and type hints.
4. Constants are often defined separately from their usage; the type annotation ensures the reader knows the shape without scanning for the definition.
5. Consistency: if all parameters must be typed, constants should follow the same discipline.

## Examples

### CORRECT

```nu
const API_VERSION: string = '1.0'
const MAX_RETRIES: int = 3
const DEFAULT_TIMEOUT_MS: int = 30_000
const LOG_LEVEL: string = 'debug'
const SUPPORTED_FORMATS: list<string> = ['json', 'yaml', 'toml']
const DB_CONFIG: record<host: string, port: int> = {host: 'localhost', port: 5432}
const PI: float = 3.14159
const DEBUG_MODE: bool = true
const EMPTY_LIST: list<int> = []
```

### INCORRECT

```nu
const API_VERSION = '1.0'              # no type — FORBIDDEN
const MAX_RETRIES = 3                   # no type — FORBIDDEN
const LOG_LEVEL = 'debug'              # no type — FORBIDDEN
const PI = 3.14159                      # no type — FORBIDDEN
const SUPPORTED_FORMATS = ['json']      # no type — FORBIDDEN
const DB_CONFIG = {host: 'localhost'}   # no type — FORBIDDEN
```

## Common Constant Types

| Type Annotation | Example Value |
|----------------|---------------|
| `: string` | `'hello'` |
| `: int` | `42` |
| `: float` | `3.14` |
| `: bool` | `true` |
| `: list<string>` | `['a', 'b', 'c']` |
| `: list<int>` | `[1, 2, 3]` |
| `: record<host: string, port: int>` | `{host: 'localhost', port: 8080}` |
| `: table<name: string, age: int>` | `[[name age]; [Alice 30]]` |
| `: datetime` | `'2024-01-01'` |

## Related Skills

- [nushell-naming-constants-screaming-snake](file://.opencode/skills/nushell-naming-constants-screaming-snake.md)
- [nushell-types-param-annotations](file://.opencode/skills/nushell-types-param-annotations.md)
- [nushell-types-complex-syntax](file://.opencode/skills/nushell-types-complex-syntax.md)
