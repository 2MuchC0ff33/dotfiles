---
name: nushell-testing-exported-commands
description: Description
compatibility: opencode
---

# Testing Exported Commands

## Description
MANDATE: ALL exported commands in shared modules SHALL have tests.

## When to Load
Load this skill when adding new exported commands to modules or writing tests.

## Source
STANDARDS.adoc §11.5.12 (lines 4548–4559, 4562–4584)

## Key Rules

- MANDATE: ALL exported commands in shared modules SHALL have tests
- Tests SHALL be placed in a `tests/` subdirectory relative to the module
- Test files SHALL be named `<module>.test.nu`

## Rationale

Exported commands are the public API of a module. They must be tested to ensure correctness, prevent regressions, and serve as documentation. Internal (un-exported) commands may also benefit from tests but are not mandatory.

## Example

```nu
# my-module.nu
# Adds two numbers together.
# @example 'Add 2 and 3' { add 2 3 }  # returns 5
export def add [a: int, b: int]: nothing -> int {
    $a + $b
}

# tests/my-module.test.nu
use ../my-module.nu *

#[test]
def test_add [] {
    let result = add 2 3
    assert equal $result 5
}

#[test]
def test_add_negative [] {
    let result = add (-1) 1
    assert equal $result 0
}

#[test]
def test_add_zero [] {
    let result = add 0 0
    assert equal $result 0
}

#[test]
def test_add_large [] {
    let result = add 1000000 2000000
    assert equal $result 3000000
}
```

## Related Skills
- nushell-testing-test-location
- nushell-testing-assert-patterns
- nushell-testing-example-attribute
- nushell-testing-nupm
