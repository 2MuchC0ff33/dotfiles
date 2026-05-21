---
name: nushell-performance-builtins-vs-external
description: Description
compatibility: opencode
---

# Builtins vs External Commands

## Description
Built-in commands preferred over external for small data (<1000 items). External tools for large-scale operations.

## When to Load
Load this skill when choosing between Nushell builtins and external commands for data processing.

## Source
STANDARDS.adoc §11.5.10 (lines 4450–4464)

## Key Rules

- SHOULD: Built-in commands preferred over external for small data (<1000 items)
- SHOULD: External tools (`^rg`, `^jq`, `^awk`) for large-scale operations
- FORBIDDEN: Loading entire large files into memory when streaming suffices

## Rationale

Nushell builtins are convenient and type-safe but can be slower for large datasets. For small data (<1000 items), builtins provide better integration and error messages. For large-scale operations, specialized tools like `rg`, `jq`, and `awk` are orders of magnitude faster.

## Example

```nu
# GOOD — builtin for small data
ls | where size > 1mb | get name     # fine for typical directory

# GOOD — external for large-scale search
^rg 'pattern' /very/large/dir        # ripgrep is 10-100x faster

# GOOD — builtin for config parsing
open config.json | from json         # native types, auto-detect

# GOOD — external for massive JSON
^jq '.data[] | {id, name}' huge.json # jq is optimized for streaming

# BAD — builtin grep on huge dataset
open 10gb-log.txt | lines | where $it =~ 'pattern'   # slow

# GOOD — external for huge logs
^rg 'pattern' 10gb-log.txt          # much faster

# BAD — builtin sort on large file
open huge.txt | lines | sort        # loads all into memory

# GOOD — external sort
^sort huge.txt                      # disk-backed, memory-efficient

# GOOD — builtin for transformation (small)
ls | get name | str upcase | each {|n| $'file: ($n)' }

# GOOD — external for transformation (large)
^awk '{print toupper($0)}' large.txt
```
