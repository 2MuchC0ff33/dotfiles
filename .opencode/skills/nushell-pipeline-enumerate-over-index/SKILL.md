---
name: nushell-pipeline-enumerate-over-index
description: Description
compatibility: opencode
---

# Enumerate Over Manual Index Counters

## Description
Use `enumerate` for indexed iteration instead of manual counter variables.

## When to Load
Load this skill when iterating with positional indices or counters.

## Source
STANDARDS.adoc §11.5.5 (lines 4185–4193)

## Key Rules

- MANDATE: `enumerate` over manual index counters
- FORBIDDEN: `mut` for accumulation when pipeline alternative exists

## Rationale

Manual index counters require `mut`, introduce state, and are error-prone (off-by-one, reset bugs). `enumerate` produces `{index: int, item: any}` records that compose naturally with `where`, `each`, and `reduce`.

## Example

```nu
# BAD — manual index counter with mut
mut i = 0
for item in $items {
    print $'($i): ($item)'
    $i += 1
}

# GOOD — enumerate
$items | enumerate | each {|row|
    print $'($row.index): ($row.item)'
}

# BAD — mut index for filtering by position
mut idx = 0
mut result = []
for item in $items {
    if $idx mod 2 == 1 {
        $result = ($result | append $item)
    }
    $idx += 1
}

# GOOD — enumerate + where
$items | enumerate | where ($it.index mod 2 == 1) | get item

# BAD — manual counter in each
let items = [a b c d]
mut i = 0
$items | each {|x|
    $i += 1
    {index: $i, value: $x}
}

# GOOD — enumerate
$items | enumerate | each {|row|
    {index: $row.index, value: $row.item}
}
```

## Related Skills
- nushell-pipeline-pipelines-over-imperative
- nushell-antipattern-mut-accumulator
- nushell-antipattern-for-final-expression
