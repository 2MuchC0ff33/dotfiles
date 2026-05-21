---
name: nushell-antipattern-closure-pipe-space
description: Description
compatibility: opencode
---

# Anti-Pattern #8: Space Before Pipe Params

## Description
Anti-pattern: Space before `|params|` in closure. Use `{|x| ...}` NOT `{ |x| ...}`.

## When to Load
Load this skill when writing closures (blocks with parameters) in any Nushell expression.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4432)

## Key Rules

- FORBIDDEN: Space before `|params|`
- MANDATE: `{|x| ...}` format for closure parameters

## Rationale

The `{|x| ...}` syntax is the idiomatic Nushell closure format. The space before pipes (`{ |x| ...}`) is non-standard and can cause parsing ambiguities. All closures in the codebase must use the compact form.

## Example

```nu
# BAD — space before pipe params (anti-pattern #8)
let doubled = [1 2 3] | each { |x| $x * 2 }     # incorrect spacing

# BAD — space after opening brace
[1 2 3] | each { |x| $x * 2 }                    # incorrect

# GOOD — no space before pipes
let doubled = [1 2 3] | each {|x| $x * 2 }

# BAD — space in multi-param closure
$pairs | each { |a, b| $a + $b }                 # incorrect

# GOOD — no space
$pairs | each {|a, b| $a + $b }

# BAD — space in reduce
$items | reduce { |acc, item| $acc + $item }     # incorrect

# GOOD — no space
$items | reduce {|acc, item| $acc + $item }

# BAD — space in where closure
ls | where { |it| $it.size > 1mb }               # incorrect

# GOOD — no space
ls | where {|it| $it.size > 1mb }
```
