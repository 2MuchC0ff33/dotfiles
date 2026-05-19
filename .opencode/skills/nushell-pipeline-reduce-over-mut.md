# Reduce Over Mut Accumulator

## Description
Use `reduce` instead of `mut` accumulator + `for` loop patterns for aggregation operations.

## When to Load
Load this skill when aggregating, summing, or building collections from lists.

## Source
STANDARDS.adoc §11.5.5 (lines 4127–4138, 4143–4145)

## Key Rules

- MANDATE: `reduce` over `mut` accumulator patterns
- FORBIDDEN: `mut` for accumulation when pipeline alternative exists
- FORBIDDEN: `for` as the final expression in a command (returns null)

## Example

```nu
# BAD — mut accumulator + for
mut total = 0
for item in $items {
    $total += $item.price
}

# GOOD — reduce
$items | reduce {|item, acc| $acc + $item.price}

# BAD — mut + for to build a list
mut result = []
for f in (ls) {
    if ($f.size > 1mb) {
        $result = ($result | append $f.name)
    }
}

# GOOD — filter pipeline (where replaces the pattern entirely)
ls | where size > 1mb | get name

# GOOD — reduce for building (when filtering doesn't suffice)
$items | reduce -f [] {|item, acc|
    if $item.valid { $acc | append $item.name } else { $acc }
}
```

## Related Skills
- nushell-pipeline-pipelines-over-imperative
- nushell-antipattern-mut-accumulator
- nushell-performance-cache-let
