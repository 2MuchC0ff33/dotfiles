---
name: nushell-errors-error-make-label
description: Description
compatibility: opencode
---

# Error Make With Label

## Description
Custom errors MUST include `label` with `span` when source metadata exists. Bare `error make {msg: '...'}` is FORBIDDEN when span is available.

## When to Load
Load this skill when raising custom errors via `error make`.

## Source
STANDARDS.adoc §11.5.7 (lines 4313–4327, 4334–4354)

## Key Rules

- MANDATE: Custom errors MUST include `label` with `span` when source metadata exists
- FORBIDDEN: Bare `error make {msg: '...'}` without `label` when span is available

## Rationale

The `label` with `span` tells the user exactly WHERE the error occurred (file, line, column). Without `span`, the user must guess which input caused the error. Span is obtained from `(metadata $value).span`.

## Example

```nu
# CORRECT — error with label and span
error make {
    msg: $'Invalid config value: ($value)'
    label: {
        text: 'Expected a positive integer'
        span: (metadata $value).span
    }
}

# INCORRECT — bare error make without label
error make {msg: 'Invalid config value'}    # FORBIDDEN when span is available

# INCORRECT — error without span when source context exists
error make {
    msg: $'File not found: ($path)'
    # missing label with span!
}

# CORRECT — error with span from source
error make {
    msg: $'File not found: ($path)'
    label: {
        text: 'Does not exist'
        span: (metadata $path).span
    }
}

# CORRECT — try/catch with error make + label
try {
    open $config_path
} catch {|err|
    error make {
        msg: $'Failed to open config at ($config_path): ($err)'
        label: {text: 'Config error'; span: (metadata $config_path).span}
    }
}

# CORRECT — complete + error make + label
let result = (^cargo build o+e>| complete)
if $result.exit_code != 0 {
    error make {
        msg: $'Build failed: ($result.stderr)'
        label: {
            text: 'Build error'
            span: (metadata $result).span
        }
    }
}
```

## Related Skills
- nushell-errors-try-catch
- nushell-errors-complete-external
- nushell-errors-capture-stdin
