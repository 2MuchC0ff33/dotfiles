---
name: nushell-pipeline-pipelines-over-imperative
description: Description
compatibility: opencode
---

# Pipelines Over Imperative Loops

## Description
Prefer pipelines over imperative loops in ALL cases. Use functional composition instead of `for`/`mut` loops.

## When to Load
Load this skill when writing any Nushell command that transforms, filters, or aggregates data.

## Source
STANDARDS.adoc §11.5.5 (lines 4185–4244)

## Key Rules

- MANDATE: Pipelines over imperative loops in ALL cases
- FORBIDDEN: `for` as the final expression in a command (returns null)
- FORBIDDEN: `echo` for returning values (use implicit return)
- FORBIDDEN: `mut` for accumulation when pipeline alternative exists

## Example

```nu
# BAD — imperative accumulation
mut total = 0
for item in $items {
    $total += $item.price
}

# GOOD — functional pipeline
$items | get price | math sum

# BAD — mut + for to build a list
mut result = []
for f in (ls) {
    if ($f.size > 1mb) {
        $result = ($result | append $f.name)
    }
}

# GOOD — filter pipeline
ls | where size > 1mb | get name

# BAD — for as final expression (returns null)
def squares []: nothing -> list<int> {
    for x in [1 2 3 4] {
        $x ** 2
    }  # returns null!
}

# GOOD — each returns the list
def squares []: nothing -> list<int> {
    [1 2 3 4] | each {|x| $x ** 2 }
}
```

## Related Skills
- nushell-pipeline-reduce-over-mut
- nushell-pipeline-each-over-for
- nushell-pipeline-where-over-if
- nushell-pipeline-enumerate-over-index
- nushell-pipeline-implicit-return
- nushell-antipattern-for-final-expression
- nushell-antipattern-mut-accumulator
