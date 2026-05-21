---
name: nushell-security-no-shell-injection
description: Description
compatibility: opencode
---

# No Shell Injection

## Description
FORBIDDEN: `^sh -c`, `^bash -c`, `^cmd.exe /C` with interpolated user input. FORBIDDEN: `run-external` with user-controlled command names.

## When to Load
Load this skill when invoking shell commands or using `run-external` with any user-controllable input.

## Source
STANDARDS.adoc §11.5.8 (lines 4365–4372, 4375–4386)

## Key Rules

- CRITICAL — FORBIDDEN: `^sh -c`, `^bash -c`, `^cmd.exe /C` with interpolated user input
- CRITICAL — FORBIDDEN: `run-external` with user-controlled command names
- HIGH — MANDATE: User-provided paths validated with `path expand` + prefix check

## Rationale

Passing interpolated user input to `sh -c` or `bash -c` opens shell injection vectors. Shell metacharacters (`;`, `` ` ``, `$()`, `|`) in user input can execute arbitrary commands. Even `run-external` with user-controlled command names is dangerous — an attacker could specify `/bin/malware` instead of `ls`.

## Example

```nu
# INCORRECT — shell injection via sh -c
let filename = $user_input
^sh -c $'cat ($filename)'           # FORBIDDEN — if filename is `; rm -rf /`

# INCORRECT — bash -c with interpolation
let query = $user_input
^bash -c $'grep "($query)" logs/'  # FORBIDDEN — shell injection

# INCORRECT — run-external with user-controlled command
let cmd = $user_input
^$cmd --flag                        # FORBIDDEN — user controls command name

# CORRECT — use built-in Nushell commands
open $safe_path

# CORRECT — use structured data processing
open logs | where $it.line =~ $query

# CORRECT — safe external with controlled command, validated args
let target = ($user_input | path expand)
if ($target | str starts-with '/safe/dir') {
    ^cat $target                    # safe — command is hardcoded, arg is safe
}

# CORRECT — use complete for safe externals
let result = (^git log -1 o+e>| complete)
```
