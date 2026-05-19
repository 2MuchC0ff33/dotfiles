# Anti-Pattern #22: Ignoring External Exit Codes

## Description
Anti-pattern: Ignoring external command exit codes. Use `complete` for fallible externals.

## When to Load
Load this skill when running external commands where success/failure matters.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4388)

## Key Rules

- FORBIDDEN: Ignoring external exit codes
- MANDATE: External commands whose exit code matters MUST use `complete`

## Rationale

Bare external commands stream output to stdout/stderr. Their exit codes are silently lost. If the external fails, the script continues running as if nothing happened, leading to corrupted state or cascading failures.

## Example

```nu
# BAD — ignoring exit code (anti-pattern #22)
^cargo build                    # if this fails, we never know!

# BAD — exit code ignored with output capture
let output = (^cargo build | str trim)   # exit code not checked
# proceeds even if build failed...

# BAD — git push without checking
^git push                       # if push fails, script continues

# GOOD — complete for external command
let result = (^cargo build o+e>| complete)
if $result.exit_code != 0 {
    error make {
        msg: $'Build failed: ($result.stderr)'
        label: {text: 'Build error'; span: (metadata $result).span}
    }
}

# GOOD — complete with graceful error handling
let result = (^git push o+e>| complete)
if $result.exit_code != 0 {
    print $'Warning: push failed: ($result.stderr)'
    # decide whether to continue or abort
}

# GOOD — complete in CI pipeline
let result = (^rustc $file o+e>| complete)
if $result.exit_code != 0 {
    print $'Compilation failed: ($result.stderr)'
    exit $result.exit_code
}
```
