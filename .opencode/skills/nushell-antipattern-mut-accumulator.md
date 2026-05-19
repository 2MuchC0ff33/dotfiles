# Anti-Pattern #3: Mut Accumulator + For

## Description
Anti-pattern: `mut` accumulator + `for`. Use pipeline (`reduce`, `math sum`, `where`).

## When to Load
Load this skill when accumulating values or building collections across iterations.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4369, 4145–4163)

## Key Rules

- FORBIDDEN: `mut` for accumulation when pipeline alternative exists
- MANDATE: `reduce` over `mut` accumulator patterns
- MANDATE: `where` over manual filtering with `if`

## Rationale

`mut` + `for` is imperative, verbose, and error-prone. Functional pipelines (`reduce`, `math sum`, `where`) are declarative, composable, and automatically handle edge cases (empty lists, etc.).

## Example

```nu
# BAD — mut accumulator + for (anti-pattern #3)
mut total = 0
for item in $items {
    $total += $item.price
}

# GOOD — functional pipeline
$items | get price | math sum

# BAD — mut + for to build a filtered list
mut result = []
for f in (ls) {
    if ($f.size > 1mb) {
        $result = ($result | append $f.name)
    }
}

# GOOD — filter pipeline
ls | where size > 1mb | get name

# BAD — mut for building transformed list
mut names = []
for f in (ls) {
    $names = ($names | append ($f.name | str upcase))
}

# GOOD — pipeline with each
ls | get name | each {|n| $n | str upcase}

# BAD — reduce with mut
mut longest = ''
for word in $words {
    if ($word | str length) > ($longest | str length) {
        $longest = $word
    }
}

# GOOD — reduce
$words | reduce {|word, acc|
    if ($word | str length) > ($acc | str length) { $word } else { $acc }
}
```

## Related Skills
- nushell-pipeline-reduce-over-mut
- nushell-pipeline-pipelines-over-imperative
- nushell-antipattern-for-final-expression
