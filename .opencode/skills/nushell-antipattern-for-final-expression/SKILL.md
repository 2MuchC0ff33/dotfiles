---
name: nushell-antipattern-for-final-expression
description: Description
compatibility: opencode
---

# Anti-Pattern #2: For as Final Expression

## Description
Anti-pattern: Using `for` as the final expression in a command (returns null). Use `each` which returns a list.

## When to Load
Load this skill when iterating over a list to produce a transformed result.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4426, 4233–4243)

## Key Rules

- FORBIDDEN: `for` as the final expression in a command (returns null)
- MANDATE: `each` over `for` for list transformations

## Rationale

`for` always returns null. Using it as the last expression means your command returns null, not the transformed data. `each` returns the transformed list and composes naturally in pipelines.

## Example

```nu
# BAD — for as final expression (returns null) — anti-pattern #2
def squares []: nothing -> list<int> {
    for x in [1 2 3 4] {
        $x ** 2
    }  # returns null!
}

# GOOD — each returns the list
def squares []: nothing -> list<int> {
    [1 2 3 4] | each {|x| $x ** 2 }
}

# BAD — for loop as final expression
def collect-names [] {
    let files = (ls)
    for f in $files {
        $f.name
    }  # returns null
}

# GOOD — pipeline
def collect-names [] {
    ls | get name
}
```

## Related Skills
- nushell-pipeline-each-over-for
- nushell-antipattern-echo-return
- nushell-antipattern-mut-accumulator
