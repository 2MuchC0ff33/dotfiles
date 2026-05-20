# Anti-Pattern #12: Missing Command Docs

## Description
Anti-pattern: Missing command documentation. Always add `#` doc comments + `@example` attributes.

## When to Load
Load this skill when defining any `def` command, especially exported ones.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4436)

## Key Rules

- FORBIDDEN: Missing command docs
- MANDATE: Always add `#` doc comments + `@example`

## Rationale

Documented commands are discoverable, maintainable, and testable. Doc comments appear in `help` output. `@example` attributes serve as both documentation and test cases. Undocumented commands confuse users and maintainers.

## Example

```nu
# BAD — missing docs (anti-pattern #12)
export def add [a: int, b: int]: nothing -> int {
    $a + $b
}

# GOOD — documented command
# Adds two integers and returns the result.
#
# @example 'Add two positive numbers' { add 2 3 }  # returns 5
# @example 'Add with negative' { add (-1) 1 }      # returns 0
export def add [a: int, b: int]: nothing -> int {
    $a + $b
}

# BAD — exported command without docs
export def build-project [target: string] {
    # ...
}

# GOOD — full docs for exported commands
# Builds the project for the specified target.
# Supports debug and release configurations.
#
# @example 'Build debug' { build-project debug }
# @example 'Build release' { build-project release }
export def build-project [target: string] {
    # ...
}

# GOOD — private commands can have minimal docs
# Internal helper: normalizes path segments
def normalize [path: string]: string -> string {
    $path | path expand
}
```

## Related Skills
- nushell-testing-example-attribute
- nushell-module-export-minimal
- nushell-antipattern-missing-types
