# Each Over For

## Description
Use `each` over `for` for list transformations. `each` returns a list (non-null), `for` returns null.

## When to Load
Load this skill when transforming every element of a list.

## Source
STANDARDS.adoc §11.5.5 (lines 4127–4133, 4175–4185)

## Key Rules

- MANDATE: `each` over `for` for list transformations
- FORBIDDEN: `for` as the final expression in a command (returns null)

## Rationale

`for` always returns null, making it useless as a final expression. `each` returns the transformed list and participates in pipelines. Every use of `for` that iterates over a list can and should be replaced with `each`.

## Example

```nu
# BAD — for returns null
def squares []: nothing -> list<int> {
    for x in [1 2 3 4] {
        $x ** 2
    }  # returns null! Function returns null.
}

# GOOD — each returns the list
def squares []: nothing -> list<int> {
    [1 2 3 4] | each {|x| $x ** 2 }
}

# BAD — for with side-effect accumulation
mut names = []
for file in (ls) {
    $names = ($names | append $file.name)
}
$names

# GOOD — pure each pipeline
ls | get name

# BAD — for each element
for url in $urls {
    http get $url
}

# GOOD — each pipeline (use par-each for I/O bound)
$urls | each {|url| http get $url }
```

## Related Skills
- nushell-pipeline-pipelines-over-imperative
- nushell-antipattern-for-final-expression
- nushell-performance-par-each
- nushell-performance-each-order
