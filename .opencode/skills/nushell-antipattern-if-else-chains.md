# Anti-Pattern #15: If-Else Chains for Branching

## Description
Anti-pattern: `if-else` chains for branching. Use `match` for multi-branch.

## When to Load
Load this skill when branching on multiple conditions or values.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4381)

## Key Rules

- FORBIDDEN: `if-else` chains for branching
- MANDATE: Use `match` for multi-branch

## Rationale

`if-else` chains are verbose, repetitive, and error-prone. `match` provides declarative pattern matching that is more readable, maintainable, and performs better. It also enforces exhaustive checking.

## Example

```nu
# BAD — if-else chain (anti-pattern #15)
def describe-status [code: int] {
    if $code == 200 {
        'OK'
    } else if $code == 404 {
        'Not Found'
    } else if $code == 500 {
        'Server Error'
    } else {
        'Unknown'
    }
}

# GOOD — match
def describe-status [code: int] {
    match $code {
        200 => 'OK'
        404 => 'Not Found'
        500 => 'Server Error'
        _   => 'Unknown'
    }
}

# BAD — multi-value if chain
def classify [x: int] {
    if $x < 0 { 'negative' }
    else if $x == 0 { 'zero' }
    else { 'positive' }
}

# GOOD — match
def classify [x: int] {
    match $x {
        $n if $n < 0 => 'negative'
        0 => 'zero'
        _ => 'positive'
    }
}

# BAD — string if-else chain
let ext = ($filename | path parse | get extension)
if $ext == 'json' {
    from json
} else if $ext == 'yaml' {
    from yaml
} else if $ext == 'toml' {
    from toml
} else {
    $filename
}

# GOOD — match
match $ext {
    'json' => (open $filename | from json)
    'yaml' => (open $filename | from yaml)
    'toml' => (open $filename | from toml)
    _      => (open $filename)
}
```
