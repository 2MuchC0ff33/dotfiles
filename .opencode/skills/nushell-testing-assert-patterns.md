# Assert Patterns in Tests

## Description
Use `assert` commands from standard library.

## When to Load
Load this skill when writing test assertions or adding examples to commands.

## Source
STANDARDS.adoc §11.5.12 (lines 4548–4558)

## Key Rules

- SHOULD: Use `assert` commands from the standard library
- MANDATE: ALL exported commands in shared modules SHALL have tests

## Rationale

The standard library `assert` commands (`assert equal`, `assert greater`, `assert error`, etc.) provide clear, consistent test assertions. They produce informative failure messages and integrate with test runners.

## Example

```nu
#[test]
def test_add [] {
    let result = add 2 3
    assert equal $result 5
}

#[test]
def test_string_length [] {
    assert equal ('hello' | str length) 5
}

#[test]
def test_list_is_empty [] {
    assert ([] | is-empty)
}

#[test]
def test_greater_than [] {
    let result = (compute 10)
    assert greater $result 0
}

#[test]
def test_less_than_or_equal [] {
    let result = (compute 5)
    assert less_or_equal $result 100
}

#[test]
def test_throws_on_invalid_input [] {
    assert error {|_| compute -1 }
}

#[test]
def test_not_equal [] {
    let result = (process 'input1')
    assert not equal $result (process 'input2')
}
```
