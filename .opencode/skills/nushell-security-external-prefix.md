# External Command Prefix (Hat)

## Description
External commands prefixed with `^` when name conflicts with builtins to avoid ambiguity.

## When to Load
Load this skill when invoking external commands that share names with Nushell builtins.

## Source
STANDARDS.adoc §11.5.8 (lines 4307–4328, 4350–4360)

## Key Rules

- HIGH — MANDATE: External commands prefixed with `^` when name conflicts with builtins
- CRITICAL — FORBIDDEN: `run-external` with user-controlled command names

## Rationale

Nushell has builtin commands (`find`, `sort`, `date`, `open`, `source`) that shadow their Unix external counterparts. Without the `^` prefix, Nushell calls its builtin instead of the system command. This leads to subtle bugs where pipeline semantics differ.

## Example

```nu
# INCORRECT — builtin shadows external
find . -name '*.rs'           # Calls Nushell's find (string search), NOT Unix find!
grep -r 'pattern' src/        # Calls Nushell's grep, NOT Unix grep!

# CORRECT — explicit external via ^ prefix
^find . -name '*.rs'          # unambiguous external (file search)
^grep -r 'pattern' src/       # unambiguous external

# INCORRECT — ambiguous
sort -n                       # Nushell table sort, not line sort
date                          # Nushell date commands, not system date

# CORRECT — hat for expected external
^sort -n                      # Unix sort
^date +%s                     # Unix date

# Ambiguous names reference table
# | Command   | Nushell Builtin    | Unix External (use ^) |
# |-----------|--------------------|------------------------|
# | find      | String search      | File search            |
# | sort      | Table sort         | Line sort              |
# | date      | Date commands      | Date (if installed)    |
# | open      | File reader        | (rare)                 |
# | source    | Module loader      | (rare)                 |
```
