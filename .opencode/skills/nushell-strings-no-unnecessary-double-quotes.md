# Nushell Strings: No Unnecessary Double Quotes

## Description
Double quotes (`"..."`) are FORBIDDEN when single quotes (`'...'`) suffice. Double-quoted interpolation (`$"... "`) is FORBIDDEN when single-quoted interpolation (`$'...'`) works.

## When to Load
Load this skill when writing any string literal and considering quote style, reviewing existing code for unnecessary double quotes, or teaching Nushell quoting semantics.

## Source
STANDARDS.adoc §11.5.3 (lines 4125–4144)

## Key Rules

- FORBIDDEN: Double quotes (`"hello"`) when the string contains no escape sequences (`\n`, `\t`, etc.) and no interpolation — use single quotes: `'hello'`.
- FORBIDDEN: Double-quoted interpolation (`$"val: ($x)"`) when the string contains no escape sequences — use single-quoted interpolation: `$'val: ($x)'`.
- FORBIDDEN: `$"string"` (dollar-double-quotes with interpolation) when there are no variables to interpolate — use `'string'`.
- MANDATE: Inspect each string for the presence of escape characters (`\n`, `\t`, `\"`, `\\`, etc.) before choosing double quotes.
- MANDATE: Inspect each string for the presence of interpolation variables (`($var)`) before choosing interpolation syntax.

## Rationale

1. Single-quoted strings are safer — they interpret all characters literally with no escape processing, so there is no risk of accidentally including a real `\n` vs. an escape sequence.
2. Single-quoted strings are faster to parse (no escape scanning).
3. Single quotes signal to the reader: "this string is purely literal, no special processing."
4. Double quotes signal: "this string contains escape sequences" — using them unnecessarily dilutes this signal.
5. Consistency: the default should always be single quotes; double quotes are the exception, not the rule.

## Examples

### CORRECT

```nu
'hello world'                   # single-quoted — no escapes
'/path/to/file'                # single-quoted — no escapes
'error: connection refused'    # single-quoted — no escapes
$'User: ($name)'               # single-quoted interpolation — no escapes
$'Count: ($items | length)'    # single-quoted interpolation — expression, no escapes
"line1\nline2"                 # double-quoted — has escape sequences
$"Name:\t($name)"              # double-quoted interpolation — has escapes
```

### INCORRECT

```nu
"hello world"                   # double quotes — no escapes — FORBIDDEN → 'hello world'
"/path/to/file"                # double quotes — no escapes — FORBIDDEN → '/path/to/file'
$"User: ($name)"               # double-quoted interp — no escapes — FORBIDDEN → $'User: ($name)'
$"Count: ($items | length)"    # double-quoted interp — no escapes — FORBIDDEN → $'...'
"error: connection refused"    # double quotes — FORBIDDEN → 'error: connection refused'
"name"                         # double quotes — FORBIDDEN → 'name'
$"hello"                       # interpolation with no vars — FORBIDDEN → 'hello'
```

## Quick Reference

| Content | Correct Quote |
|---------|--------------|
| Literal text, no special chars | `'text'` |
| Literal text with spaces | `'text with spaces'` |
| Has `($var)` interpolation, no escapes | `$'text ($var)'` |
| Has `\n`, `\t` etc., no interpolation | `"text\nline2"` |
| Has both escapes and interpolation | `$"text\n($var)"` |
| Regex or Windows paths | `r'...'` |

## Related Skills

- [nushell-strings-format-priority](file://.opencode/skills/nushell-strings-format-priority.md)
- [nushell-strings-no-unnecessary-interpolation](file://.opencode/skills/nushell-strings-no-unnecessary-interpolation.md)
