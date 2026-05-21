---
name: nushell-pipeline-implicit-return
description: Description
compatibility: opencode
---

# Implicit Return Over Echo

## Description
Use implicit return (last expression evaluates as the return value) instead of `echo` for returning values from commands.

## When to Load
Load this skill when defining functions that produce output.

## Source
STANDARDS.adoc §11.5.5 (lines 4198, 4223–4231)

## Key Rules

- FORBIDDEN: `echo` for returning values (use implicit return)
- MANDATE: Pipelines over imperative loops in ALL cases

## Rationale

`echo` in Nushell prints to stdout. Using it for "return" values is a legacy habit from other shells. The last expression in a `def` body is automatically returned. Using `echo` breaks pipeline semantics and can cause unexpected output interleaving.

## Example

```nu
# BAD — echo for return
def greet [name: string] {
    echo $'Hello, ($name)!'
}

# GOOD — implicit return
def greet [name: string] {
    $'Hello, ($name)!'
}

# BAD — echo in pipeline context
def get-name [user] {
    echo $user.name
}

# GOOD — implicit return
def get-name [user] {
    $user.name
}

# BAD — echo for computed value
def double [x: int] {
    echo ($x * 2)
}

# GOOD — implicit return
def double [x: int]: nothing -> int {
    $x * 2
}
```

## Related Skills
- nushell-antipattern-echo-return
- nushell-pipeline-pipelines-over-imperative
- nushell-module-export-minimal
