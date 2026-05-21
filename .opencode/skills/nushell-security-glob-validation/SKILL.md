---
name: nushell-security-glob-validation
description: Description
compatibility: opencode
---

# Glob Validation

## Description
Glob patterns from user input must be validated (no unintended expansion). `--depth` limits on `glob` to prevent DoS on large trees.

## When to Load
Load this skill when accepting glob patterns or using the `glob` command with user-controlled or unconstrained input.

## Source
STANDARDS.adoc §11.5.8 (lines 4365–4381)

## Key Rules

- HIGH — MANDATE: Glob patterns from user input validated (no unintended expansion)
- HIGH — MANDATE: `--depth` limits on `glob` to prevent DoS on large trees

## Rationale

Unvalidated glob patterns like `**/**/**` or `/*` can cause extreme filesystem scanning, consuming memory and I/O. User-provided patterns containing `*` wildcards can match unintended files. Always constrain glob depth and validate patterns.

## Example

```nu
# INCORRECT — unbounded glob (DoS risk)
let files = (glob $user_pattern)                # FORBIDDEN — no depth limit

# INCORRECT — user-provided glob opens everything
glob $user_input                                # could be '**' on massive tree

# CORRECT — --depth limits on glob
let files = (glob $user_pattern --depth 3)

# CORRECT — validate pattern before globbing
if ($user_pattern | str length) > 200 {
    error make {msg: 'Glob pattern too long'}
}
if ($user_pattern =~ '(\*\*){2,}') {
    error make {msg: 'Excessive recursion in glob'}
}
let files = (glob $user_pattern --depth 2)

# CORRECT — restrict to extension-only patterns
def safe-glob [ext: string] {
    # Only allow specific extensions
    glob $'**/*.($ext)' --depth 3
}

# CORRECT — allow glob only within specific directory
let base = '/allowed/dir'
let pattern = $'($base)/($user_relative_pattern)'
if not ($pattern | str starts-with $base) {
    error make {msg: 'Glob escaping detected'}
}
let files = (glob $pattern --depth 3)

# CORRECT — use hardcoded glob with depth for CI/tooling
glob 'src/**/*.nu' --depth 5
```
