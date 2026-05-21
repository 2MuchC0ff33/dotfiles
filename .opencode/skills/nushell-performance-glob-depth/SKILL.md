---
name: nushell-performance-glob-depth
description: Description
compatibility: opencode
---

# Glob Depth Limits

## Description
`--depth` limits on `glob` to avoid scanning huge directory trees.

## When to Load
Load this skill when using the `glob` command to match files.

## Source
STANDARDS.adoc §11.5.10 (lines 4450–4458, 4468–4469)

## Key Rules

- MANDATE: `--depth` limits on `glob` to avoid scanning huge directory trees
- FORBIDDEN: Unbounded `glob` without `--depth`

## Rationale

Unbounded glob (`**`) on a large directory tree (node_modules, vendor bundles, git repos) can scan millions of files, consuming memory and I/O. The `--depth` flag limits recursion depth, providing predictable performance.

## Example

```nu
# BAD — unbounded glob (might scan entire filesystem)
let files = (glob '**/*.nu')

# BAD — recursion through node_modules
let files = (glob '**/*.json')       # could scan 100k+ files

# GOOD — limited depth
let files = (glob '**/*.nu' --depth 3)

# GOOD — per-subdirectory depth
let files = (glob 'src/**/*.nu' --depth 5)

# GOOD — shallow for known structures
let files = (glob 'config/**/*' --depth 2)

# BAD — no depth on massive tree
let all = (glob '**/*')              # FORBIDDEN — scans everything

# GOOD — depth limit prevents DoS
let configs = (glob '**/*.toml' --depth 4)

# GOOD — use specific pattern to limit scope (instead of **)
let files = (glob 'src/*.nu')                    # single directory
let files = (glob 'src/**/*.nu' --depth 3)       # bounded recursion
```
