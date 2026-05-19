# Private Helpers Intentionally Unexported

## Description
Private helper commands should be left un-exported (intentionally private). Only the public API surface should be exported.

## When to Load
Load this skill when organizing code within a module and deciding what to export.

## Source
STANDARDS.adoc §11.5.6 (lines 4188–4198, 4215–4217)

## Key Rules

- SHOULD: Private helper commands left un-exported (intentionally private)
- MANDATE: ONLY necessary definitions are `export`-ed

## Rationale

Un-exported commands are internal implementation details. They can be refactored, renamed, or removed without breaking consumers. Keeping helpers private reduces API surface, documentation burden, and the cognitive load on users.

## Example

```nu
# CORRECT — private helpers un-exported
export def main [] {
    validate-env
    do-work
}

export def do-work [] {             # public API
    # ...
}

def validate-env [] {               # private — not exported
    if ($env.HOME | is-empty) {
        error make {msg: 'HOME not set'}
    }
}

def log [msg: string] {             # private — internal helper
    let timestamp = (date now | format date '%Y-%m-%d %H:%M:%S')
    print $'[($timestamp)] ($msg)'
}

# INCORRECT — exporting helpers that are implementation details
export def validate-env [] { ... }  # only used internally
export def log [msg] { ... }        # internal debug logging
export def normalize [] { ... }     # utility, not for external use

# CORRECT — if a helper becomes useful externally, export it intentionally
export def parse-config [path: string] { ... }  # now part of public API
```

## Related Skills
- nushell-module-export-minimal
- nushell-module-export-main
- nushell-module-re-exports
