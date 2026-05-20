# Nushell Formatting: Multi-line Pipelines

## Description
When a pipeline exceeds ~80 characters or contains nested records/lists, format with each pipeline step on its own line, indented by 4 spaces, with the pipe at the start of each continuation line.

## When to Load
Load this skill when formatting pipelines that are too long for a single line, when pipelines contain complex closures or nested structures, or when reviewing multi-line pipeline formatting.

## Source
STANDARDS.adoc §11.5.2 (lines 4061–4123)

## Key Rules

- MANDATE: Each pipeline step MUST be on its own line in multi-line pipelines.
- MANDATE: Continuation lines MUST be indented by 4 spaces relative to the start of the expression.
- MANDATE: The pipe `|` MUST appear at the BEGINNING of each continuation line, not at the end of the previous line.
- MANDATE: Opening `{`/`[`/`(` on same line as the preceding expression.
- MANDATE: Closing `}`/`]`/`)` on its own line.
- FORBIDDEN: 2-space indent for continuation lines (must be exactly 4 spaces).
- FORBIDDEN: Pipes at the end of lines (leading-pipe convention).
- FORBIDDEN: Mixed indentation levels within the same pipeline.

## Rationale

1. Leading-pipe alignment (pipe at start of line) makes it visually obvious where each pipeline stage begins.
2. 4-space indentation is the standard across the Nushell ecosystem and matches the indentation used in records and closures.
3. Each step on its own line makes git diffs cleaner — adding or removing a pipeline stage only affects one line.
4. Long single-line pipelines are harder to read, debug, and comment on.

## Examples

### CORRECT

```nu
# Simple multi-line pipeline
let result = $data
    | where size > 1mb
    | sort-by name
    | select name path size
    | first 10

# Pipeline with closure
let processed = $data
    | each {|row|
        $row
        | select id name
        | where active == true
    }
    | sort-by name
```

### INCORRECT

```nu
# Pipe at end of line — FORBIDDEN
let result = $data |
    where size > 1mb |
    sort-by name

# 2-space indent — FORBIDDEN
let result = $data
  | where size > 1mb
  | sort-by name

# All on one line when too long — unclear
let result = $data | where size > 1mb | sort-by name | select name path size | first 10

# Mixed indent — FORBIDDEN
let result = $data
    | where size > 1mb
  | sort-by name
```

## When To Use Multi-line

Use multi-line formatting when:
- The pipeline exceeds ~80 characters on a single line
- The pipeline contains 3 or more stages
- Any stage contains a closure with multiple lines
- Any stage contains nested records, lists, or tables
- The pipeline is part of a complex data transformation

## Related Skills

- [nushell-formatting-pipe-spacing](file://.opencode/skills/nushell-formatting-pipe-spacing.md)
- [nushell-formatting-multiline-records](file://.opencode/skills/nushell-formatting-multiline-records.md)
- [nushell-formatting-closure-pipes](file://.opencode/skills/nushell-formatting-closure-pipes.md)
