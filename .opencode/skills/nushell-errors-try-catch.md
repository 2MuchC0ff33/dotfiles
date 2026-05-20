# Try/Catch for Fallible Operations

## Description
Fallible operations MUST be wrapped in `try`/`catch`. `catch` blocks MUST include meaningful error context.

## When to Load
Load this skill when performing operations that can fail (file I/O, network, external commands, parsing).

## Source
STANDARDS.adoc §11.5.7 (lines 4313–4330, 4346–4354)

## Key Rules

- MANDATE: Fallible operations MUST be wrapped in `try`/`catch`
- MANDATE: `catch` blocks MUST include meaningful error context (never empty)
- FORBIDDEN: Empty `catch {|| }` blocks

## Rationale

Unwrapped fallible operations cause unhandled crashes. Empty `catch` blocks silently swallow errors, making debugging impossible. Every `catch` must provide context (what failed, why, and with what input).

## Example

```nu
# CORRECT — try/catch with context
try {
    open $config_path
} catch {|err|
    error make {
        msg: $'Failed to open config at ($config_path): ($err)'
        label: {text: 'Config error'; span: (metadata $config_path).span}
    }
}

# INCORRECT — empty catch (silently swallows error)
try {
    open $config_path
} catch {|| }           # FORBIDDEN — error is lost!

# INCORRECT — no try/catch at all
let data = open $config_path    # crashes if file doesn't exist

# CORRECT — try with default value
let data = try { open $config_path } catch {|err|
    {host: 'localhost', port: 8080}   # fallback config
}

# CORRECT — try/catch in pipeline
try {
    http get $url | from json
} catch {|err|
    error make {
        msg: $'Failed to fetch ($url): ($err)'
    }
}
```

## Related Skills
- nushell-errors-error-make-label
- nushell-errors-complete-external
- nushell-errors-capture-stdin
- nushell-security-temp-files
