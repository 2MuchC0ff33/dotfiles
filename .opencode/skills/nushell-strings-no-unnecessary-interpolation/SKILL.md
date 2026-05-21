---
name: nushell-strings-no-unnecessary-interpolation
description: Description
compatibility: opencode
---

# Nushell Strings: No Unnecessary Interpolation

## Description
String interpolation is FORBIDDEN when the string contains no interpolated variables or expressions.

## When to Load
Load this skill when writing string literals that do not contain `($variable)` or `($expression)` references, or when reviewing code for unnecessary `$"..."` or `$'...'` usage.

## Source
STANDARDS.adoc §11.5.3 (lines 4125–4144)

## Key Rules

- FORBIDDEN: `$"hello"` — double-quoted interpolation with no interpolated values. Use `'hello'`.
- FORBIDDEN: `$'hello'` — single-quoted interpolation with no interpolated values. Use `'hello'`.
- FORBIDDEN: `$"hello ($not_actually_a_var)"` — any string that appears to have interpolation but the `($...)` syntax does not contain a real variable or expression (e.g., if it's commented out or the variable doesn't exist).
- MANDATE: Check EVERY string with `$` prefix for actual `(...)` interpolation expressions before keeping the `$` prefix.
- MANDATE: Only use `$'...'` or `$"..."` when the string contains at least one `($var)` or `($expression)`.
- ACCEPTABLE during development: Temporary `$"..."` that will later gain interpolation — but MUST be cleaned up before commit.

## Rationale

1. The `$` prefix signals to the reader "this string has dynamic content" — using it on static strings is misleading.
2. Interpolation strings are parsed differently (they must scan for `(...)` expressions), making them fractionally slower and more complex.
3. Removing unnecessary `$` makes review easier — every `$`-prefixed string is a flag that the string has dynamic content.
4. Consistency: the default should always be plain strings; `$` is the exception.

## Examples

### CORRECT

```nu
'hello world'                   # no variables needed
'/path/to/file'                # no variables needed
'error: connection refused'    # no variables needed
$'User: ($name)'               # HAS interpolation — correct
$"Path: ($dir)/\nfile.txt"     # HAS interpolation + escapes — correct
$'Count: ($items | length)'    # HAS interpolation expression — correct
```

### INCORRECT

```nu
$"hello world"                  # no interpolation — FORBIDDEN → 'hello world'
$'hello world'                  # no interpolation — FORBIDDEN → 'hello world'
$"error: connection refused"    # no interpolation — FORBIDDEN → 'error: connection refused'
$'/path/to/file'               # no interpolation — FORBIDDEN → '/path/to/file'
$"static text"                  # no interpolation — FORBIDDEN → 'static text'
$'static text'                  # no interpolation — FORBIDDEN → 'static text'
```

## Detection Tip

If you can replace `$'...'` with `'...'` and the string still works the same (no `(var)` to interpolate), then the `$` is unnecessary.

Similarly, if you can replace `$"..."` with `'...'` (no escapes, no interpolation), both the `$` and the double quotes are unnecessary.

## Related Skills

- [nushell-strings-format-priority](file://.opencode/skills/nushell-strings-format-priority.md)
- [nushell-strings-no-unnecessary-double-quotes](file://.opencode/skills/nushell-strings-no-unnecessary-double-quotes.md)
