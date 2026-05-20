# Anti-Pattern #10: Unnecessary String Interpolation

## Description
Anti-pattern: Unnecessary string interpolation. Use simplest format.

## When to Load
Load this skill when formatting strings in Nushell.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4434)

## Key Rules

- FORBIDDEN: Unnecessary string interpolation
- SHOULD: Use simplest format

## Rationale

String interpolation with `$"..."` is powerful but can be overkill for simple strings. Plain strings without interpolation are more readable, perform better, and avoid confusion with interpolation syntax. Choose the simplest format for the task.

## Example

```nu
# BAD — unnecessary interpolation (anti-pattern #10)
let greeting = $"hello"

# GOOD — plain string
let greeting = 'hello'

# BAD — unnecessary in concat contexts
let path = $"($base)/($filename)"       # fine if needed, but...

# GOOD — with path join or simpler
let path = $base + '/' + $filename
# or
let path = ([$base $filename] | path join)

# BAD — unnecessary for simple literals
let log_msg = $"info: starting..."

# GOOD — plain string
let log_msg = 'info: starting...'

# OK — interpolation justified
let msg = $"User ($name) logged in at ($timestamp)"

# OK — interpolation with expression
let report = $"Total: ($items | length)"

# INCORRECT — nesting interpolation unnecessarily
let x = $"outer: ($"inner: ($value)")"     # too complex

# GOOD — build in steps
let inner = $"inner: ($value)"
let outer = $"outer: ($inner)"
```
