# Par-Each for Parallel Processing

## Description
MANDATE: Use `par-each` for I/O-bound work (file reads, HTTP, network). Use `par-each` for CPU-bound work.

## When to Load
Load this skill when processing collections in performance-sensitive code paths or when I/O operations are involved.

## Source
STANDARDS.adoc §11.5.10 (lines 4392–4411, 4414–4431)

## Key Rules

- MANDATE: Use `par-each` for I/O-bound work (file reads, HTTP requests, network)
- MANDATE: Use `par-each` for CPU-bound work (data processing, transforms)
- Use `each` ONLY when order must be preserved or list is very small

## Rationale

Sequential processing of I/O or CPU-bound operations wastes resources. `par-each` distributes work across available cores, dramatically reducing wall-clock time for batch operations.

## Example

```nu
# BAD — sequential file processing (slow)
ls **/*.json | each {|f| open $f.name | get version }

# GOOD — parallel file processing
ls **/*.json | par-each {|f| open $f.name | get version }

# BAD — sequential HTTP requests
$urls | each {|url| http get $url }

# GOOD — parallel HTTP requests
$urls | par-each {|url| http get $url }

# BAD — sequential image processing
$images | each {|img| process-image $img }

# GOOD — parallel image processing
$images | par-each {|img| process-image $img }

# OK — each when order must be preserved
$items | each {|item| print $item }      # sequential output order

# OK — each for very small lists
[1 2] | each {|x| expensive-op $x }      # parallel overhead not worth it
```
