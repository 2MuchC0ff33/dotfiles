# Anti-Pattern #23: Length Checks for Emptiness

## Description
Anti-pattern: Length checks for emptiness. Use `is-empty` / `is-not-empty`.

## When to Load
Load this skill when checking if a list, string, or table is empty.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4389)

## Key Rules

- FORBIDDEN: Length checks for emptiness
- MANDATE: Use `is-empty` / `is-not-empty`

## Rationale

`length == 0` is imperative and verbose. `is-empty` is declarative, more readable, and can be more efficient (short-circuits on empty collections). It also works consistently across strings, lists, and tables.

## Example

```nu
# BAD — length check for emptiness (anti-pattern #23)
if ($items | length) == 0 {
    print 'No items'
}

# GOOD — is-empty
if ($items | is-empty) {
    print 'No items'
}

# BAD — negative length check
if ($items | length) > 0 {
    print 'Has items'
}

# GOOD — is-not-empty
if ($items | is-not-empty) {
    print 'Has items'
}

# BAD — string emptiness
if ($name | str length) == 0 {
    print 'Empty name'
}

# GOOD — is-empty on string
if ($name | is-empty) {
    print 'Empty name'
}

# BAD — table emptiness
if (ls | length) == 0 {
    print 'No files'
}

# GOOD — is-empty on table
if (ls | is-empty) {
    print 'No files'
}

# BAD — ternary-like pattern
let status = if ($errors | length) > 0 { 'failed' } else { 'ok' }

# GOOD — is-not-empty
let status = if ($errors | is-not-empty) { 'failed' } else { 'ok' }
```

## Related Skills
- nushell-antipattern-manual-null-check
- nushell-pipeline-where-over-if
- nushell-antipattern-mut-accumulator
