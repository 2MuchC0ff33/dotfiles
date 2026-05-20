# Test File Location and Naming

## Description
Tests SHALL be placed in a `tests/` subdirectory relative to the module. Files named `<module>.test.nu`.

## When to Load
Load this skill when creating test files for Nushell modules.

## Source
STANDARDS.adoc §11.5.12 (lines 4548–4554)

## Key Rules

- Tests SHALL be placed in a `tests/` subdirectory relative to the module
- Test files SHALL be named `<module>.test.nu`
- MANDATE: ALL exported commands in shared modules SHALL have tests

## Rationale

Consistent test location and naming makes tests discoverable and enables automated test runners. Placing tests in a `tests/` directory keeps them separate from implementation code.

## Example

```
# Directory structure:
my-project/
├── modules/
│   ├── utils.nu               # module to test
│   ├── config.nu              # module to test
│   └── tests/                 # test directory
│       ├── utils.test.nu      # tests for utils.nu
│       └── config.test.nu     # tests for config.nu
├── scripts/
│   ├── build.nu
│   └── tests/
│       └── build.test.nu
└── src/
    ├── lib.nu
    └── tests/
        └── lib.test.nu
```

```nu
# modules/tests/utils.test.nu
use ../utils.nu *

#[test]
def test_format_date [] {
    let result = format_date '2024-01-15'
    assert equal $result '2024-01-15'
}

#[test]
def test_parse_csv [] {
    let result = (parse_csv 'a,b,c\n1,2,3')
    assert equal ($result | length) 1
}
```

## Related Skills
- nushell-testing-exported-commands
- nushell-testing-assert-patterns
- nushell-testing-nupm
