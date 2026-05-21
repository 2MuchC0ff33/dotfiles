---
name: nushell-antipattern-dynamic-source
description: Description
compatibility: opencode
---

# Anti-Pattern #4: Dynamic Source/Use Paths

## Description
Anti-pattern: Dynamic `source`/`use` paths. Use `const`, never `let`.

## When to Load
Load this skill when using `source` or `use` with variable paths.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4428, 4281–4287)

## Key Rules

- FORBIDDEN: `source`/`use` with dynamic (runtime) paths — will error
- MANDATE: `source`/`use` paths MUST be `const` (parse-time constant), NOT `let`

## Rationale

Nushell resolves `source` and `use` at parse time. `let` bindings are runtime values and cannot be used for parse-time directives. This produces a parse error. Always use `const` for paths.

## Example

```nu
# BAD — dynamic source path (anti-pattern #4)
let path = './utils.nu'
source $path                        # Error! Not parse-time constant

# BAD — dynamic use path
let module_path = './helpers.nu'
use $module_path                    # Error!

# GOOD — inline string literal
source ./utils.nu

# GOOD — const path
const PATH = './utils.nu'
source $PATH

# GOOD — const with interpolation
const BASE = './modules'
const MODULE = $"($BASE)/utils.nu"
source $MODULE

# GOOD — const use
const HELPERS = './helpers.nu'
use $HELPERS
```

## Related Skills
- nushell-module-const-paths
- nushell-security-no-code-injection
- nushell-antipattern-forgot-export
