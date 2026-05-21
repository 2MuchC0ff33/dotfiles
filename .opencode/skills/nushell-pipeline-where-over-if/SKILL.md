---
name: nushell-pipeline-where-over-if
description: Description
compatibility: opencode
---

# Where Over Manual If

## Description
Use `where` for filtering lists instead of manual `if` checks inside `each` or `for` loops.

## When to Load
Load this skill when filtering a list, table, or record collection.

## Source
STANDARDS.adoc §11.5.5 (lines 4185–4192, 4212–4221)

## Key Rules

- MANDATE: `where` over manual filtering with `if`
- FORBIDDEN: `mut` for accumulation when pipeline alternative exists

## Rationale

`where` is declarative, composable, and automatically handles the plumbing. Manual `if`-inside-`each`/`for` patterns are imperative, verbose, and error-prone.

## Example

```nu
# BAD — mut + for + if to filter
mut result = []
for f in (ls) {
    if ($f.size > 1mb) {
        $result = ($result | append $f.name)
    }
}

# GOOD — where filter pipeline
ls | where size > 1mb | get name

# BAD — each + if
ls | each {|f| if $f.size > 1mb { $f.name } } | compact

# GOOD — where
ls | where size > 1mb | get name

# BAD — nested if for multiple conditions
ls | each {|f|
    if $f.size > 1mb {
        if ($f.name | str ends-with '.log') {
            $f.name
        }
    }
} | compact

# GOOD — compound where
ls | where size > 1mb and name =~ '\.log$' | get name
```

## Related Skills
- nushell-pipeline-pipelines-over-imperative
- nushell-antipattern-mut-accumulator
- nushell-performance-cache-let
