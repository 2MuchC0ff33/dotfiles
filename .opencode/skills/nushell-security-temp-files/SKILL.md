---
name: nushell-security-temp-files
description: Description
compatibility: opencode
---

# Temp File Security

## Description
Temp files created with `^mktemp`, not predictable paths. Temp files cleaned up in `try`/`catch`.

## When to Load
Load this skill when creating or using temporary files.

## Source
STANDARDS.adoc §11.5.8 (lines 4365–4383)

## Key Rules

- HIGH — MANDATE: Temp files created with `^mktemp`, not predictable paths
- HIGH — MANDATE: Temp files cleaned up in `try`/`catch` or equivalent

## Rationale

Predictable temp file paths are vulnerable to symlink attacks (TOCTOU) and information disclosure. `mktemp` creates files with randomized names in secure locations. Always clean up temp files with `try`/`finally` or `try`/`catch` to prevent disk pollution and information leaks.

## Example

```nu
# INCORRECT — predictable temp path (symlink attack)
let tmp = '/tmp/myapp-data.txt'          # FORBIDDEN — predictable
open $tmp | save $tmp

# INCORRECT — temp file not cleaned up
let tmp = (^mktemp)
open $data | save $tmp
# no cleanup — file remains on disk

# CORRECT — mktemp + try/catch cleanup
let tmp = (^mktemp)
try {
    open $data | save $tmp
    # process $tmp ...
} catch {|err|
    rm -f $tmp
    error make {msg: $'Failed: ($err)'}
}

# CORRECT — try/finally cleanup
let tmp = (^mktemp)
try {
    open $data | save $tmp
    # use $tmp ...
} finally {
    rm -f $tmp                         # always runs, even on error
}

# CORRECT — --suffix for file extension
let tmp = (^mktemp --suffix '.json')
try {
    open $data | save $tmp
    let parsed = (open $tmp | from json)
    # ...
} finally {
    rm -f $tmp
}

# CORRECT — temp directory with mktemp -d
let tmpdir = (^mktemp -d)
try {
    # use $tmpdir ...
} finally {
    rm -rf $tmpdir
}
```
