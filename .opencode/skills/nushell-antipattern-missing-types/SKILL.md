---
name: nushell-antipattern-missing-types
description: Description
compatibility: opencode
---

# Anti-Pattern #7: Missing Type Annotations

## Description
Anti-pattern: Missing type annotations. Always annotate parameters + I/O signature.

## When to Load
Load this skill when defining any `def` command.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4431)

## Key Rules

- FORBIDDEN: Missing type annotations
- MANDATE: Always annotate params + I/O signature

## Rationale

Type annotations serve as documentation, enable the type-checker to catch errors, and help the Nushell parser provide better error messages. Commands without type annotations are harder to understand and maintain.

## Example

```nu
# BAD — missing type annotations (anti-pattern #7)
def add [a, b] {
    $a + $b
}

# GOOD — annotated params
def add [a: int, b: int]: nothing -> int {
    $a + $b
}

# BAD — no I/O signature
def process [items: list] {
    $items | each {|x| $x * 2}
}

# GOOD — full I/O signature
def process [items: list<int>]: nothing -> list<int> {
    $items | each {|x| $x * 2}
}

# BAD — missing output type
def greet [name: string] {
    $'Hello, ($name)!'
}

# GOOD — annotated
def greet [name: string]: string -> string {
    $'Hello, ($name)!'
}

# WARNING — partial annotation
def fetch [url: string] {               # param typed, but:
    http get $url                       # no I/O signature!
}
```
