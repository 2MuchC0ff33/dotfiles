---
name: nushell-antipattern-no-hat-external
description: Description
compatibility: opencode
---

# Anti-Pattern #21: Not Prefixing Externals With Hat

## Description
Anti-pattern: Not prefixing external commands with `^`. Use `^cmd` when builtin shadows.

## When to Load
Load this skill when invoking external commands that share names with Nushell builtins.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4445)

## Key Rules

- FORBIDDEN: Not prefixing externals with `^`
- MANDATE: Use `^cmd` when builtin shadows external

## Rationale

Nushell has builtin commands (`find`, `sort`, `date`, `open`, `source`) that override system commands. Without the `^` prefix, Nushell calls its builtin instead of the system external. This leads to subtle and confusing bugs.

## Example

```nu
# BAD — calls Nushell's find, NOT Unix find (anti-pattern #21)
find . -name '*.rs'           # executes Nushell string search!

# BAD — calls Nushell sort
sort -n                       # table sort, not line sort

# BAD — calls Nushell date
date +%s                      # date commands, not Unix date

# GOOD — hat prefix for external
^find . -name '*.rs'          # Unix find (file search)
^sort -n                      # Unix sort (line sort)
^date +%s                     # Unix date

# BAD — builtin opens the file
open file.txt                 # Nushell open

# GOOD — external open (rare, but when needed)
^open file.txt                # system open

# BAD — ambiguous
source ./script.sh            # Nushell source (module loader)

# GOOD — use hat for shell
^source ./script.sh           # bash source

# Reference: common ambiguous names
# | Command | Nushell Builtin    | Unix External (^) |
# | find    | String search      | File search        |
# | sort    | Table sort         | Line sort          |
# | date    | Date commands      | Unix date          |
# | open    | File reader        | System open        |
# | source  | Module loader      | Shell source       |
```
