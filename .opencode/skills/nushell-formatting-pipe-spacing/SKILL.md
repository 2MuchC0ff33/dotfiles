---
name: nushell-formatting-pipe-spacing
description: Description
compatibility: opencode
---

# Nushell Formatting: Pipe Spacing

## Description
Exactly one space before and after each pipe `|` operator. No consecutive spaces anywhere (except inside string literals).

## When to Load
Load this skill when writing any Nushell pipeline with `|`, reviewing pipeline formatting, or configuring automated formatting tools.

## Source
STANDARDS.adoc §11.5.2 (lines 4061–4123)

## Key Rules

- MANDATE: One space before each pipe operator: `|`.
- MANDATE: One space after each pipe operator: `| `.
- MANDATE: No consecutive spaces anywhere in source code (inside strings is the only exception).
- FORBIDDEN: Pipes without surrounding spaces: `$data|where size > 1mb|sort-by name`.
- FORBIDDEN: More than one space before or after a pipe: `$data  |  where size > 1mb`.
- FORBIDDEN: Tab characters before or after pipes (use spaces only).
- FORBIDDEN: Trailing pipe operators at the end of a line in multi-line pipelines (the pipe goes at the start of the continuation line).

## Rationale

1. Consistent spacing around pipes improves readability by visually separating pipeline stages.
2. The space-before convention is shared with Unix shell pipes (`|`) but Nushell mandates the space-after as well for uniformity.
3. No consecutive spaces ensures that indentation is predictable and that formatting diffs are minimal.
4. Nushell's grammar does not require spaces around `|`, but the standard mandates them for consistency and readability.

## Examples

### CORRECT

```nu
[1 2 3] | each {|x| $x * 2}
$data | where size > 1mb | sort-by name | select name path
open 'file.csv' | from csv | first 10
let result = $data | where active == true | get name
```

### INCORRECT

```nu
[1 2 3]|each {|x| $x * 2}             # no space before or after — FORBIDDEN
[1 2 3] |  each {|x| $x * 2}          # double space after — FORBIDDEN
$data  |  where size > 1mb  |  sort-by name  # multiple double spaces — FORBIDDEN
$data |where size > 1mb|sort-by name   # missing spaces after — FORBIDDEN
let result = $data| where active == true  # missing space before — FORBIDDEN
```

## Multi-Line Note

In multi-line pipelines (see `nushell-formatting-multiline-pipelines`), the pipe `|` goes at the beginning of each continuation line, indented by 4 spaces, with exactly one space after it:

```nu
let result = $data
    | where size > 1mb
    | sort-by name
```

## Related Skills

- [nushell-formatting-multiline-pipelines](file://.opencode/skills/nushell-formatting-multiline-pipelines.md)
- [nushell-formatting-no-trailing-whitespace](file://.opencode/skills/nushell-formatting-no-trailing-whitespace.md)
