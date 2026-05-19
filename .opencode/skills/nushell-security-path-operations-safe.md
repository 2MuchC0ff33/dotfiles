# Safe Path Operations for Remove

## Description
`rm` operations validate target path (not `/`, not `$nu.home-path`). `..` sequences in user paths detected and rejected.

## When to Load
Load this skill when performing `rm` or destructive file operations with user-controllable paths.

## Source
STANDARDS.adoc §11.5.8 (lines 4307–4321)

## Key Rules

- HIGH — MANDATE: `rm` operations validate target path (not `/`, not `$nu.home-path`)
- HIGH — MANDATE: `..` sequences in user paths detected and rejected
- HIGH — MANDATE: User-provided paths validated with `path expand` + prefix check

## Rationale

Accidentally calling `rm /` would destroy the system. `rm $nu.home-path` would wipe user data. User paths containing `..` can escape allowed directories. Always validate before destruction.

## Example

```nu
# INCORRECT — no validation before rm
let path = $user_input
rm -rf $path                        # FORBIDDEN — could be / or ~

# INCORRECT — partial validation
let path = ($user_input | path expand)
if ($path | str starts-with '/allowed/dir') {
    rm -rf $path                    # path could still be /allowed/dir/../../
}

# CORRECT — full validation before rm
let path = ($user_input | path expand | path resolve)
if $path == '/' {
    error make {msg: 'Cannot remove root filesystem'}
}
if $path == $nu.home-path {
    error make {msg: 'Cannot remove home directory'}
}
if ($path | str starts-with '/allowed/dir') {
    rm -rf $path
} else {
    error make {msg: 'Path not in allowed directory'}
}

# CORRECT — reject path traversal
if ($user_input =~ '\.\.') {
    error make {msg: 'Path traversal detected'}
}

# CORRECT — safety-check function
def safe-rm [target: string] {
    let resolved = ($target | path expand | path resolve)
    if $resolved in ['/', $nu.home-path] {
        error make {msg: 'Refusing to remove protected path'}
    }
    rm -rf $resolved
}
```
