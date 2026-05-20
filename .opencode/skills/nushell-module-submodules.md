# Submodules Use Export Module

## Description
Submodules use `export module` to preserve namespace and avoid name collisions.

## When to Load
Load this skill when organizing code across multiple module files.

## Source
STANDARDS.adoc §11.5.6 (lines 4246–4257, 4306)

## Key Rules

- SHOULD: Submodules use `export module` to preserve namespace
- MANDATE: ONLY necessary definitions are `export`-ed

## Rationale

`export module` wraps a submodule in its own namespace, accessed as `parent.submodule`. This prevents name collisions between identically named commands in different submodules and makes the module hierarchy explicit.

## Example

```nu
# main.nu — CORRECT: submodule in its own namespace
export module utils.nu            # accessed as `use main.nu utils`
export module network.nu          # accessed as `use main.nu network`

# utils.nu
export def format-date [] { ... }
export def parse-csv [] { ... }

# network.nu
export def fetch [] { ... }
export def post [] { ... }

# user code
use main.nu
main utils format-date            # unambiguous
main network fetch                # unambiguous

# INCORRECT — flattening submodules into parent
# main.nu
export use utils.nu *             # names collide if utils and network
export use network.nu *           # both define format-date!

# CORRECT — export module preserves namespaces
export module utils.nu
export module network.nu
```

## Related Skills
- nushell-module-re-exports
- nushell-module-export-minimal
- nushell-module-private-helpers
