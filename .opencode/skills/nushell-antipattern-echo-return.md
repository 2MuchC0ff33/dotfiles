# Anti-Pattern #1: Echo for Return Values

## Description
Anti-pattern: Using `echo` for return values. Use implicit return (last expression) instead.

## When to Load
Load this skill when writing `def` commands that produce output values.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4367, 4165–4173)

## Key Rules

- FORBIDDEN: `echo` for returning values (use implicit return)
- MANDATE: Pipelines over imperative loops in ALL cases

## Rationale

`echo` prints to stdout. It is not a `return` statement. Using `echo` for return values is a legacy habit from other shells. The last expression in a `def` body is automatically returned. `echo` breaks pipeline semantics and can cause unexpected output interleaving.

## Example

```nu
# BAD — echo for return (anti-pattern #1)
def greet [name: string] {
    echo $'Hello, ($name)!'
}

# GOOD — implicit return
def greet [name: string] {
    $'Hello, ($name)!'
}

# BAD — echo for computed value
def double [x: int] {
    echo ($x * 2)
}

# GOOD — implicit return
def double [x: int]: nothing -> int {
    $x * 2
}

# BAD — echo in pipeline context
def get-name [user] {
    echo $user.name
}

# GOOD — implicit return
def get-name [user] {
    $user.name
}
```

## Related Skills
- nushell-pipeline-implicit-return
- nushell-antipattern-for-final-expression
- nushell-antipattern-missing-types
