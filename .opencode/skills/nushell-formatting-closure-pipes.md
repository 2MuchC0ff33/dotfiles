# Nushell Formatting: Closure Pipes — No Space Before `|params|`

## Description
Closure parameters use `{|x| ...}` with NO space before the opening pipe and NO space after the closing pipe.

## When to Load
Load this skill when writing closures passed to `each`, `where`, `reduce`, `all`, `any`, `sort-by`, `filter`, `map`, or any higher-order function in Nushell.

## Source
STANDARDS.adoc §11.5.2 (lines 4061–4123)

## Key Rules

- MANDATE: No space between `{` and `|params|`: `{|x| $x * 2}`.
- MANDATE: No space between `|params|` and the closure body: `{|x| $x * 2}` NOT `{|x|  $x * 2}`.
- MANDATE: Single space after the opening brace's pipe section before the body expression begins, if a single expression follows.
- FORBIDDEN: Space before the opening pipe: `{ |x| $x * 2}`.
- FORBIDDEN: Space after the closing pipe before the body: `{|x|  $x * 2}`.
- FORBIDDEN: `{  |x| ... }` (double space before pipe).

## Rationale

1. The `{|...|` syntax is a unified token in Nushell's grammar — the brace and pipe together form the closure opening delimiter.
2. Inserting a space between `{` and `|` breaks the visual unity of this token and is considered non-idiomatic.
3. All built-in Nushell examples use `{|x| ...}` without the leading space.
4. This convention is unique to Nushell and distinguishes it from languages where `{ |x|` is used (e.g., Rust).

## Examples

### CORRECT

```nu
[1 2 3] | each {|x| $x * 2}
[1 2 3 4] | reduce {|elt acc| $elt + $acc}
[[status]; [UP] [DOWN]] | all {|el| $el.status == UP}
$data | where {|row| $row.size > 100}
```

### INCORRECT

```nu
[1 2 3] | each { |x| $x * 2}           # space before |x| — FORBIDDEN
[1 2 3 4] | reduce { |elt, acc| ... }   # space before + commas — FORBIDDEN
[[status]; [UP] [DOWN]] | all { |el| ... }  # space before |el| — FORBIDDEN
$data | where { |row| $row.size > 100 } # space before |row| — FORBIDDEN
[1 2 3] | each {|x| $x * 2 }           # trailing space before } — minor, but inconsistent
```

## Multi-Line Closures

Multi-line closures still follow the same rule: no space between `{` and `|`:

```nu
let result = $data
    | each {|row|
        $row
        | select name age
        | where age > 18
    }
```

## Related Skills

- [nushell-formatting-pipe-spacing](file://.opencode/skills/nushell-formatting-pipe-spacing.md)
- [nushell-formatting-multiline-pipelines](file://.opencode/skills/nushell-formatting-multiline-pipelines.md)
