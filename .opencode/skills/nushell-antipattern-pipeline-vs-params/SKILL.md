---
name: nushell-antipattern-pipeline-vs-params
description: Description
compatibility: opencode
---

# Anti-Pattern #18: Confusing Pipeline vs Params

## Description
Anti-pattern: Confusing pipeline input vs parameters. Use `$in` for pipeline input signature.

## When to Load
Load this skill when defining commands that accept either pipeline input or positional arguments.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4442)

## Key Rules

- FORBIDDEN: Confusing pipeline vs params
- MANDATE: Use `$in` for pipeline input signature

## Rationale

Nushell commands can receive input via both pipeline (`$in`) and parameters. Commands that accept pipeline input must explicitly declare the input type in their I/O signature. Forgetting the pipeline input type causes confusion about whether data comes from `$in` or a parameter.

## Example

```nu
# BAD — pipeline input not declared (anti-pattern #18)
def process []: any -> any {
    let data = $in
    $data | each {|x| $x * 2}
}

# GOOD — pipeline input declared in I/O signature
def process []: list<int> -> list<int> {
    let data = $in
    $data | each {|x| $x * 2}
}

# BAD — confusing: accepts both but ambiguous
def transform [
    input?: list<int>
]: any -> any {
    let data = if $input != null { $input } else { $in }
    # ambiguous — which takes priority?
}

# GOOD — explicit either-or pattern
def transform [input: list<int>]: nothing -> list<int> {
    # only params
    $input | each {|x| $x * 2}
}

def transform-pipeline []: list<int> -> list<int> {
    # only pipeline
    $in | each {|x| $x * 2}
}

# CORRECT — pipeline input with default
def filter-large []: list<record> -> list<record> {
    $in | where size > 1mb
}

# CORRECT — mixed with clear semantics
def greet [name?: string]: string -> string {
    let target = $name | default $in | default 'world'
    $'Hello, ($target)!'
}
```
