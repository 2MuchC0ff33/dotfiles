# No Code Injection

## Description
FORBIDDEN: `nu -c $variable` with untrusted input. FORBIDDEN: `source`/`use` with runtime paths.

## When to Load
Load this skill when evaluating code strings, sourcing files, or using dynamic paths.

## Source
STANDARDS.adoc §11.5.8 (lines 4365–4373, 4317–4328)

## Key Rules

- CRITICAL — FORBIDDEN: `nu -c $variable` with untrusted input (code injection)
- CRITICAL — FORBIDDEN: `source $variable`/`use $variable` with runtime paths
- HIGH — MANDATE: User-provided paths validated with `path expand` + prefix check

## Rationale

`nu -c $user_input` is equivalent to `eval()` in other languages — it executes arbitrary code. An attacker can inject commands, read files, or exfiltrate data. Similarly, `source $runtime_path` can load malicious modules. Use structured data processing instead.

## Example

```nu
# INCORRECT — code injection via nu -c
let user_input = '1 + 1'
let result = (^nu -c $user_input)   # FORBIDDEN — arbitrary code execution!

# INCORRECT — source with runtime path
let path = $user_provided_path
source $path                        # FORBIDDEN — can load malicious code

# INCORRECT — use with runtime path
let module_name = $user_input
use $module_name                    # FORBIDDEN

# CORRECT — parse structured input instead
let number = ($user_input | into int)
let result = $number + 1

# CORRECT — const path for source
const UTILS_PATH = './utils.nu'
source $UTILS_PATH

# CORRECT — validated, safe external invocation
let file_path = ($user_input | path expand)
if ($file_path | str starts-with '/safe/directory') {
    open $file_path
} else {
    error make {msg: 'Access denied'}
}
```
