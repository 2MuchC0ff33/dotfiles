# Example Attribute for Doc-Tests

## Description
Provide `@example` attributes on non-trivial commands for doc-tests.

## When to Load
Load this skill when defining commands that would benefit from usage examples.

## Source
STANDARDS.adoc §11.5.12 (lines 4490–4501, 4504–4511)

## Key Rules

- SHOULD: Provide `@example` attributes on non-trivial commands (used as doc-tests)
- MANDATE: ALL exported commands in shared modules SHALL have tests

## Rationale

`@example` attributes serve dual purpose: as documentation (shown in `help` output) and as test cases (doc-tests). They demonstrate correct usage alongside the implementation, keeping docs and code in sync.

## Example

```nu
# CORRECT — @example with description and invocation
# Adds two integers and returns the result.
#
# @example 'Add 2 and 3' { add 2 3 }  # returns 5
export def add [a: int, b: int]: nothing -> int {
    $a + $b
}

# CORRECT — multiple @example variants
# Finds files matching a pattern.
#
# @example 'Find .nu files' { find-files '*.nu' }
# @example 'Find with depth limit' { find-files '*.toml' --depth 2 }
export def find-files [pattern: string, --depth: int = 3] {
    glob $pattern --depth $depth
}

# CORRECT — @example showing error cases
# Parses a version string.
#
# @example 'Parse semver' { parse-version '1.2.3' }  # returns {major: 1, minor: 2, patch: 3}
export def parse-version [version: string]: string -> record {
    let parts = ($version | split row '.')
    {major: ($parts | get 0 | into int), minor: ($parts | get 1 | into int), patch: ($parts | get 2 | into int)}
}

# INCORRECT — no @example on non-trivial command
export def complex-process [input: string] {
    # hard to figure out usage without example
}

# GOOD — @example format:
# # description of example case
# #
# # @example 'Short description' { command-name arg1 arg2 }  # expected output
```
