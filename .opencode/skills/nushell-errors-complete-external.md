# Complete for External Commands

## Description
External commands whose exit code matters MUST use `complete` to capture exit code, stdout, and stderr.

## When to Load
Load this skill when running external commands (`^cmd`) where the result must be validated.

## Source
STANDARDS.adoc §11.5.7 (lines 4255–4270, 4276–4286)

## Key Rules

- MANDATE: External commands whose exit code matters MUST use `complete`
- FORBIDDEN: Ignoring external command exit codes via bare `^cmd` when result matters

## Rationale

Bare external commands stream output to stdout/stderr and exit codes are silently lost. `complete` captures the full result (`exit_code`, `stdout`, `stderr`) so the caller can validate success and surface meaningful diagnostics.

## Example

```nu
# CORRECT — complete for external command
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

# INCORRECT — bare external, exit code lost
^cargo build                    # if this fails, we never know!

# INCORRECT — ignoring exit code
let output = (^cargo build | str trim)   # exit code captured but ignored
print $output                            # might show error, but no check

# CORRECT — complete with success check
let result = (^rustc $file o+e>| complete)
if $result.exit_code != 0 {
    print $'Compilation failed: ($result.stderr)'
    exit $result.exit_code
}
print $result.stdout

# CORRECT — complete for git operations
let result = (^git push o+e>| complete)
if $result.exit_code != 0 {
    error make {msg: $'Push failed: ($result.stderr)'}
}
```
