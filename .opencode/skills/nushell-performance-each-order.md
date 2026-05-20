# Each Order Preservation

## Description
Use `each` ONLY when order must be preserved or list is very small. Otherwise prefer `par-each`.

## When to Load
Load this skill when deciding between `each` and `par-each` for collection processing.

## Source
STANDARDS.adoc §11.5.10 (lines 4450–4456)

## Key Rules

- MANDATE: Use `each` ONLY when order must be preserved or list is very small
- MANDATE: Use `par-each` for I/O-bound and CPU-bound work

## Rationale

`each` guarantees sequential order but is slower for non-trivial workloads. `par-each` processes in parallel but does not guarantee processing order. Choose based on whether order matters.

## Example

```nu
# BAD — par-each when order matters
$steps | par-each {|step| execute-step $step }   # steps may run in wrong order!

# GOOD — each preserves order
$steps | each {|step| execute-step $step }        # guaranteed order

# GOOD — par-each when order doesn't matter
$files | par-each {|f| analyze-file $f }          # order irrelevant

# BAD — each for large I/O-bound batch (slow)
$urls | each {|url| http get $url }               # wait for each response

# GOOD — par-each for I/O
$urls | par-each {|url| http get $url }           # concurrent requests

# OK — each for very small lists
[1 2 3] | each {|x| expensive-op $x }             # overhead not worth parallel

# OK — each with --flatten for streaming nested results
$groups | each --flatten {|g| $g.items }
```
