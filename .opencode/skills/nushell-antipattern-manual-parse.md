# Anti-Pattern #14: Manual Structured Data Parse

## Description
Anti-pattern: Manual structured data parsing. Use `from json` / `open` (native parser).

## When to Load
Load this skill when reading or parsing structured data files (JSON, YAML, TOML, CSV).

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4438)

## Key Rules

- FORBIDDEN: Manual structured data parsing
- MANDATE: Use `from json` / `open` (native parser)

## Rationale

Nushell has built-in parsers for JSON, YAML, TOML, CSV, and other formats. Manual parsing with string operations is fragile, slow, and error-prone. The built-in parsers handle encoding, edge cases, and type conversion properly.

## Example

```nu
# BAD — manual JSON parse (anti-pattern #14)
let raw = (open data.txt)
let lines = ($raw | lines)
# fragile string manipulation...

# GOOD — built-in parser
open data.json | from json

# BAD — parse CSV manually
let raw = (open data.csv)
let rows = ($raw | lines | skip 1 | each {|line|
    let cols = ($line | split row ',')
    {name: ($cols | get 0), age: ($cols | get 1)}
})

# GOOD — native CSV parser
open data.csv | from csv

# BAD — parse YAML manually
let raw = (open config.yaml)
# manual yaml parsing — don't!

# GOOD — native YAML parser
open config.yaml | from yaml

# BAD — parse TOML manually
# extremely complex string parsing...

# GOOD — native TOML parser
open Cargo.toml | from toml

# GOOD — auto-detect
open data.json  # Nushell auto-detects format and parses
open data.csv   # auto-detect
open data.yaml  # auto-detect
```
