---
name: nushell-antipattern-string-parse-external
description: Description
compatibility: opencode
---

# Anti-Pattern #6: String-Parsing External Output

## Description
Anti-pattern: String-parsing external command output. Use structured commands (`ls`, `http get`, `from json`).

## When to Load
Load this skill when processing output from external commands or files.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4430)

## Key Rules

- FORBIDDEN: String-parsing external output
- MANDATE: Use structured commands

## Rationale

Nushell has built-in structured commands for most common operations. Parsing external output with string manipulation is fragile (breaks on output format changes), slow (string operations + regex), and misses type information. Use native Nushell commands.

## Example

```nu
# BAD — string-parsing ls output (anti-pattern #6)
let output = (^ls -la | str trim)
let lines = ($output | split row "\n")
# fragile parsing of column positions...

# GOOD — native ls (structured)
ls -la

# BAD — parsing ps output with regex
let output = (^ps aux)
let matches = ($output | parse '{process}\t{cpu}\t{mem}')

# GOOD — native ps (structured)
ps

# BAD — curl + string parsing
let html = (^curl https://api.example.com/users)
let lines = ($html | lines)

# GOOD — http get (structured)
http get https://api.example.com/users

# BAD — parsing JSON from external
let raw = (^cat data.json)
let data = ($raw | from json)         # works but unnecessary

# GOOD — open with from json
open data.json | from json
# OR simply
open data.json                         # Nushell auto-detects

# BAD — grep + parse
let matches = (^grep 'error' log.txt | parse 'error: {msg}')

# GOOD — builtin where
open log.txt | where $it =~ 'error'
```

## Related Skills
- nushell-antipattern-manual-parse
- nushell-performance-builtins-vs-external
- nushell-antipattern-missing-types
