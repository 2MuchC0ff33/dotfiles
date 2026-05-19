# Anti-Pattern #11: Each When Par-Each Works

## Description
Anti-pattern: Using `each` when `par-each` would work. Use `par-each` for I/O and CPU-bound work.

## When to Load
Load this skill when processing collections with I/O (file reads, HTTP, network) or CPU-bound operations.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4377)

## Key Rules

- FORBIDDEN: `each` when `par-each` works (for I/O/CPU-bound work)
- MANDATE: Use `par-each` for I/O-bound work (file reads, HTTP requests, network)

## Rationale

`each` processes items sequentially. For I/O-bound or CPU-bound work, this is significantly slower than parallel processing. `par-each` automatically distributes work across available cores. Use `each` only when order must be preserved or the list is very small.

## Example

```nu
# BAD — sequential file processing (slow) — anti-pattern #11
ls **/*.json | each {|f| open $f.name | get version }

# GOOD — parallel file processing
ls **/*.json | par-each {|f| open $f.name | get version }

# BAD — sequential HTTP requests
$urls | each {|url| http get $url }

# GOOD — parallel HTTP requests
$urls | par-each {|url| http get $url }

# BAD — sequential CPU-bound work
$data | each {|row| process-row $row }

# GOOD — parallel CPU-bound work
$data | par-each {|row| process-row $row }

# OK — each when order matters
$items | each {|item| $item | process-ordered }    # order preserved

# OK — each for very small lists (<= 5 items)
[1 2 3] | each {|x| expensive-op $x }              # overhead not worth it
```
