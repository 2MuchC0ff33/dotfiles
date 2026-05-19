# Nushell Formatting: Multi-line Records

## Description
When a record literal contains multiple key-value pairs or spans ~80+ characters, format with each key-value pair on its own line, indented by 4 spaces.

## When to Load
Load this skill when defining record literals with more than 2–3 key-value pairs, writing configuration records, constructing return values from commands, or formatting nested data structures in `.nu` files.

## Source
STANDARDS.adoc §11.5.2 (lines 4003–4065)

## Key Rules

- MANDATE: Each key-value pair in a multi-line record MUST be on its own line.
- MANDATE: Continuation lines (key-value pairs) MUST be indented by 4 spaces relative to the opening `{`.
- MANDATE: Opening `{` on same line as the preceding expression (or after `=`/assignment).
- MANDATE: Closing `}` on its own line, aligned with the start of the line containing the opening `{`.
- MANDATE: Multi-line records MUST omit trailing commas after the last key-value pair.
- SHOULD: Align colons vertically by padding values with spaces (optional, for readability).
- FORBIDDEN: 2-space indent for record values (must be exactly 4 spaces).
- FORBIDDEN: Closing `}` on the same line as the last value.
- FORBIDDEN: Trailing comma after the last entry in a multi-line record.

## Rationale

1. Each key-value pair on its own line makes diffs cleaner — adding, removing, or reordering fields only affects one line.
2. 4-space indentation is consistent with pipeline and closure formatting throughout the codebase.
3. Vertical alignment of colons (optional) improves scanability when values have varying lengths.
4. Multi-line records make it easy to add comments per field or annotate specific values.

## Examples

### CORRECT

```nu
# Simple multi-line record
let config = {
    host: 'localhost'
    port: 8080
    tls: true
    timeout: 30_000
}

# Aligned colons for readability
let app_config = {
    host:        'localhost'
    port:        8080
    tls:         true
    timeout_ms:  30_000
    log_level:   'debug'
}

# Nested multi-line records
let server = {
    host: 'localhost'
    port: 8080
    database: {
        url:      'postgres://localhost/db'
        pool:     10
        timeout:  5_000
    }
    logging: {
        level:  'info'
        file:   '/var/log/app.log'
    }
}
```

### INCORRECT

```nu
# Everything on one line — hard to read
let config = {host: 'localhost', port: 8080, tls: true, timeout: 30_000}

# 2-space indent — FORBIDDEN
let config = {
  host: 'localhost'
  port: 8080
}

# Closing brace on same line — FORBIDDEN
let config = {
    host: 'localhost'
    port: 8080 }

# Trailing comma — FORBIDDEN
let config = {
    host: 'localhost',
    port: 8080,
}

# Inconsistent indentation — FORBIDDEN
let config = {
    host: 'localhost'
      port: 8080
  tls: true
}
```

## Interaction With Other Rules

- Multi-line records omit commas between entries (unlike single-line records where commas are allowed).
- Nested records follow the same rules recursively, with each nesting level receiving an additional 4-space indent.
- When a record is the return value of a command, the opening `{` goes on the same line as the `{` in the signature or the `{` of the function body.

## Related Skills

- [nushell-formatting-multiline-pipelines](file://.opencode/skills/nushell-formatting-multiline-pipelines.md)
- [nushell-formatting-record-colons](file://.opencode/skills/nushell-formatting-record-colons.md)
- [nushell-formatting-no-commas-lists](file://.opencode/skills/nushell-formatting-no-commas-lists.md)
