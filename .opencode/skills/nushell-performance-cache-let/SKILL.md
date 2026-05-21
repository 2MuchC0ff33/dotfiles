---
name: nushell-performance-cache-let
description: Description
compatibility: opencode
---

# Cache Expensive Results in Let Bindings

## Description
Expensive results cached in `let` bindings, never recomputed.

## When to Load
Load this skill when using the same computed value multiple times.

## Source
STANDARDS.adoc §11.5.10 (lines 4450–4457, 4480–4489)

## Key Rules

- MANDATE: Expensive results cached in `let` bindings, never recomputed

## Rationale

Recomputing expensive operations (file system I/O, parsing, complex calculations) wastes CPU and I/O. Bind the result once and reuse it. This also ensures consistency — the same value is used for all checks.

## Example

```nu
# BAD — recompute expensive result
if (ls | length) > 100 {
    print $'Many files: (ls | length)'   # ls called twice!
}

# GOOD — bind once
let files = (ls)
if ($files | length) > 100 {
    print $'Many files: ($files | length)'
}

# BAD — repeatedly parse config
def get-config [] {
    let raw = (open 'config.toml')
    $raw.host                         # parses every call!
}

# GOOD — parse once
const CONFIG = (open 'config.toml')
def get-config [] { $CONFIG.host }

# BAD — recompute in each iteration
ls | each {|f|
    let config = (open 'config.json')   # opens and parses every iteration!
    process $f $config
}

# GOOD — bind before loop
let config = (open 'config.json')
ls | each {|f| process $f $config }

# BAD — recompute glob
if (glob '**/*.log' | length) > 10 {
    print 'Many log files'
    glob '**/*.log' | each {|f| analyze $f }   # glob computed twice!
}
```
