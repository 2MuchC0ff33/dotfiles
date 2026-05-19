# Anti-Pattern #17: Forgetting Export in Modules

## Description
Anti-pattern: Forgetting `export` in modules. Use `export def` for public API.

## When to Load
Load this skill when defining commands intended for external use within a module.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4383)

## Key Rules

- FORBIDDEN: Forgetting `export` in modules
- MANDATE: ONLY necessary definitions are `export`-ed
- MANDATE: `export def main` when command name matches module filename

## Rationale

Commands defined without `export` inside a module file are private and invisible to consumers. Forgetting `export` on a public API command means it won't be available after `use module.nu`. Always explicitly declare which commands are part of the public API.

## Example

```nu
# my-tools.nu

# BAD — forgot export (anti-pattern #17)
def main [] {                  # invisible to consumers!
    do-work
}

def do-work [] {               # also invisible!
    # ...
}

# user code
use my-tools.nu
my-tools main                  # Error! main is not exported
my-tools do-work               # Error! do-work is not exported

# GOOD — explicit export for public API
export def main [] {
    do-work
}

export def do-work [] {
    # ...
}

def internal-helper [] {       # intentionally private
    # ...
}

# user code
use my-tools.nu
my-tools main                  # works
my-tools do-work               # works

# GOOD — selective export
export def public-fn [] { ... }
def private-fn [] { ... }      # intentional — not exported
```

## Related Skills
- nushell-module-export-minimal
- nushell-module-export-main
- nushell-module-private-helpers
- nushell-antipattern-pipeline-vs-params
