# Path Traversal Guard

## Description
MANDATE: User-provided paths validated with `path expand` + prefix check. FORBIDDEN: raw `open $user_input` without path traversal guard.

## When to Load
Load this skill when accepting file paths from user input, command-line arguments, or external sources.

## Source
STANDARDS.adoc §11.5.8 (lines 4307–4320)

## Key Rules

- HIGH — MANDATE: User-provided paths validated with `path expand` + prefix check
- HIGH — MANDATE: No raw `open $user_input` without path traversal guard
- HIGH — MANDATE: `..` sequences in user paths detected and rejected

## Rationale

Without validation, a user can provide `../../etc/passwd` to read arbitrary files. `path expand` resolves symlinks and relative paths to an absolute path. The prefix check ensures the resolved path stays within the allowed directory.

## Example

```nu
# INCORRECT — path traversal vulnerability
let path = $user_input
open $path                          # FORBIDDEN — user can read any file

# CORRECT — path traversal guard
let path = ($user_input | path expand)
if not ($path | str starts-with '/safe/directory') {
    error make {msg: $'Access denied: ($path) is outside allowed directory'}
}
open $path

# INCORRECT — allowing .. sequences
let path = ($user_input | path expand)
open $path                          # path could be /safe/dir/../../etc/passwd

# CORRECT — resolve and check prefix
let path = ($user_input | path expand)
if ($path | str starts-with '/safe/directory') {
    open $path
} else {
    error make {msg: 'Path traversal detected'}
}

# CORRECT — also validate that it's a file, not a directory
let path = ($user_input | path expand)
if ($path | path type) != 'file' {
    error make {msg: $'Not a file: ($path)'}
}

# CORRECT — function form
def safe-open [user_path: string]: nothing -> any {
    let resolved = ($user_path | path expand)
    if not ($resolved | str starts-with '/allowed/base') {
        error make {msg: 'Path traversal rejected'}
    }
    open $resolved
}
```
