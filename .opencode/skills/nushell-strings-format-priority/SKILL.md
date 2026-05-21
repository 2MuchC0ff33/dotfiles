---
name: nushell-strings-format-priority
description: Description
compatibility: opencode
---

# Nushell Strings: Format Selection Priority

## Description
String format selection MUST follow a strict priority order: bare words > single-quoted > single-quoted interpolation > double-quoted > double-quoted interpolation > raw strings. Use the first matching rule that satisfies the requirement.

## When to Load
Load this skill when writing any string literal in Nushell — command arguments, variable assignments, configuration values, error messages, or any text content.

## Source
STANDARDS.adoc §11.5.3 (lines 4125–4144)

## Key Rules

- MANDATE: Follow the priority table below. Use the FIRST format that meets your needs:

| Priority | Format | Example | When To Use |
|----------|--------|---------|-------------|
| 1 (best) | Bare word in arrays | `[foo bar baz]` | When string has no spaces/special chars and is in a list/array context |
| 2 | Single-quoted | `'hello world'` | When string contains spaces or special chars but NO variables or escape sequences |
| 3 | Single-quoted interpolation | `$'val: ($x)'` | When you need variable interpolation but NO escape sequences |
| 4 | Double-quoted | `"tab: \t newline: \n"` | When you need escape sequences but NO interpolation |
| 5 | Double-quoted interpolation | `$"val: ($x)"` | When you need BOTH escape sequences AND interpolation |
| 6 (last) | Raw string | `r#'\d+\.\d+#'` | When escaping is cumbersome (regex, Windows paths) |

- FORBIDDEN: Skipping to a lower-priority format when a higher-priority format would work.
- FORBIDDEN: Using bare words outside of list/array/flag-value contexts.
- FORBIDDEN: Using raw strings when any simpler quoting suffix.

## Rationale

1. Bare words are the most readable, no delimiter noise — but only valid in specific contexts.
2. Single-quoted strings are preferred over double-quoted because they have no escape-sequence processing, making them both faster and safer.
3. Single-quoted interpolation (`$'...'`) is preferred over double-quoted interpolation (`$"... "`) because it avoids accidental escape-sequence interpretation.
4. Raw strings are a last resort because they break visual flow and are unfamiliar to many readers.
5. Consistent string format selection makes code predictable and self-documenting about what the string contains.

## Examples

### Priority Selection Walkthrough

```nu
# Priority 1: Bare word (in array)
[apple banana cherry]

# Priority 1: Bare word (flag value)
my-command --mode fast

# Priority 2: Single-quoted (spaces, special chars, no vars)
'hello world'
'/path/to/some/file.txt'
'error: connection refused'

# Priority 3: Single-quoted interpolation (has vars, no escapes)
$'User: ($user_name), Role: ($role)'
$'Processed ($count) records in ($elapsed)ms'

# Priority 4: Double-quoted (escape sequences, no vars)
"line1\nline2\nline3"
"tab:\tseparated"

# Priority 5: Double-quoted interpolation (escapes + vars)
$"Name:\t($name)\nAge:\t($age)"

# Priority 6: Raw string (regex, Windows paths)
r#'\d{3}-\d{2}-\d{4}'#
r'C:\Users\Alice\Documents\'
```

### INCORRECT Priority Violations

```nu
# FORBIDDEN: Double quotes when single quotes suffice
"hello world"      → 'hello world'
"user name"        → 'user name'

# FORBIDDEN: Double-quoted interpolation when single-quoted interpolation works
$"User: ($name)"   → $'User: ($name)'   (no escapes needed)

# FORBIDDEN: Interpolation with no variables
$"hello"           → 'hello'
$'hello'           → 'hello'

# FORBIDDEN: Raw string for simple text
r#'hello'#         → 'hello'
```

## Related Skills

- [nushell-strings-no-unnecessary-double-quotes](file://.opencode/skills/nushell-strings-no-unnecessary-double-quotes.md)
- [nushell-strings-no-unnecessary-interpolation](file://.opencode/skills/nushell-strings-no-unnecessary-interpolation.md)
