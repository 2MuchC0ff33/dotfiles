# Nushell Types: Parameter Annotations on All Exported Commands

## Description
ALL exported (public) commands MUST have type annotations on ALL parameters. Every positional, flag, and optional parameter must declare its type.

## When to Load
Load this skill when defining any `def` command without `--warnings` or `--private`, when exporting commands from modules, when designing command signatures, or when reviewing existing command definitions for type safety.

## Source
STANDARDS.adoc §11.5.4 (lines 4146–4183)

## Key Rules

- MANDATE: EVERY parameter in EVERY exported command MUST have a type annotation.
- MANDATE: Positional parameters MUST be annotated: `name: string`, `count: int`, `items: list<string>`.
- MANDATE: Flag parameters with values MUST be annotated: `--output: string`, `--retries: int`.
- MANDATE: Boolean flags (present/absent) do not need `: bool` (the absence of a type annotation on a flag implies boolean), but it is acceptable to add it.
- MANDATE: Default values MUST still have the type annotation: `name: string = 'default'`.
- FORBIDDEN: Unannotated parameters in exported commands: `def fetch [id, name] { }`.

## Rationale

1. Type annotations enable Nushell's parse-time type checking, catching misuse before the command runs.
2. Annotations serve as inline documentation for parameter expectations.
3. Commands with typed parameters produce better error messages when called with wrong argument types.
4. Consumers of the command (including tab completion) use type annotations to provide better UX.
5. Untyped parameters are a common source of runtime errors that could be caught at parse time.

## Examples

### CORRECT

```nu
def fetch-user [
    user_id: int            # positional, annotated
    --format: string        # flag with value, annotated
    --verbose (-v)          # boolean flag — type implied
] { }

def process-items [
    items: list<string>     # typed as list
    --output-dir: string    # typed flag
    --dry-run               # boolean flag
    --batch-size: int = 100 # typed with default
] { }

def create-record [
    name: string
    age: int
    email: string
    --tags: list<string>
    --notify: bool = false   # explicit bool is acceptable
] { }
```

### INCORRECT

```nu
def fetch [id, name] { }            # no types — FORBIDDEN
def process [items, --verbose] { }  # no types on positionals — FORBIDDEN
def get [id, --format] { }          # untyped — FORBIDDEN
def run [cmd: string, args] { }     # mixed — only cmd is typed — FORBIDDEN
```

## Interaction With Other Rules

- I/O signatures are also mandatory for exported commands (see `nushell-types-io-signatures`).
- Private commands SHOULD (but are not required to) have type annotations (see `nushell-types-private-annotations`).

## Related Skills

- [nushell-types-io-signatures](file://.opencode/skills/nushell-types-io-signatures.md)
- [nushell-types-private-annotations](file://.opencode/skills/nushell-types-private-annotations.md)
- [nushell-types-return-type-documented](file://.opencode/skills/nushell-types-return-type-documented.md)
- [nushell-types-complex-syntax](file://.opencode/skills/nushell-types-complex-syntax.md)
