# Const Paths for Source/Use

## Description
`source`/`use` paths MUST be `const` (parse-time constant), NOT `let`. Dynamic paths will error at parse time.

## When to Load
Load this skill when using `source` or `use` with file paths.

## Source
STANDARDS.adoc §11.5.6 (lines 4188–4195, 4202–4204, 4223–4229)

## Key Rules

- MANDATE: `source`/`use` paths MUST be `const` (parse-time constant), NOT `let`
- FORBIDDEN: `source`/`use` with dynamic (runtime) paths — will error

## Rationale

Nushell resolves `source` and `use` paths at parse time, before any runtime evaluation. `let` bindings are not evaluated until runtime, so `source $let_path` produces a parse error. Only `const` (which is evaluated at parse time) works for these directives.

## Example

```nu
# INCORRECT — dynamic source path
let path = './utils.nu'
source $path                        # Error! Not parse-time constant

# CORRECT — const path
const PATH = './utils.nu'
source $PATH

# INCORRECT — dynamic use path
let module_path = './helpers.nu'
use $module_path                    # Error!

# CORRECT — const use path
const MODULE_PATH = './helpers.nu'
use $MODULE_PATH

# CORRECT — inline string literal (implicitly const)
source ./utils.nu

# CORRECT — const with string interpolation
const BASE = './modules'
const PATH = $"($BASE)/utils.nu"
source $PATH
```
