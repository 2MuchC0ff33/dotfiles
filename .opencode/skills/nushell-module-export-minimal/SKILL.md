---
name: nushell-module-export-minimal
description: Description
compatibility: opencode
---

# Module Export Minimal

## Description
ONLY necessary definitions are `export`-ed. Keep the public API surface minimal.

## When to Load
Load this skill when defining a Nushell module.

## Source
STANDARDS.adoc §11.5.6 (lines 4246–4262)

## Key Rules

- MANDATE: ONLY necessary definitions are `export`-ed
- FORBIDDEN: Wildcard re-exports that pull in unexpected names

## Rationale

Every `export` is a commitment to maintain that API surface. Internal helpers, implementation details, and intermediate commands should remain private. Wildcard re-exports (`export use module.nu *`) can silently pull in unintended names, making the API unpredictable.

## Example

```nu
# my-tools.nu — CORRECT: only public API exported
export def main [] {
    validate-env
    do-work
}

export def do-work [] {      # intentionally public
    # ...
}

def validate-env [] {         # private — not exported
    # ...
}

def log [msg: string] {       # private — internal helper
    print $'[log] ($msg)'
}

# INCORRECT — exporting implementation details
export def validate-env [] { ... }
export def log [msg] { ... }           # internal, should be private
export def normalize-path [] { ... }   # implementation detail
export def parse-config [] { ... }     # only used internally

# INCORRECT — wildcard re-exports
export use utils.nu *           # pulls in EVERYTHING from utils

# CORRECT — selective re-export
export use utils.nu [format_date, parse_csv]
```

## Related Skills
- nushell-module-export-main
- nushell-module-private-helpers
- nushell-module-re-exports
- nushell-antipattern-forgot-export
