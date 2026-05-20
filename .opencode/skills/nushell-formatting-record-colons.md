# Nushell Formatting: Record Colons — One Space After `:`

## Description
In record literals, exactly one space MUST follow each colon after a key name.

## When to Load
Load this skill when writing record literals (`{key: value}`), defining configuration records, creating data structures with key-value pairs, or formatting command return records.

## Source
STANDARDS.adoc §11.5.2 (lines 4061–4123)

## Key Rules

- MANDATE: One space after `:` in record key-value pairs: `{x: 1, y: 2}`.
- MANDATE: Commas MAY be used between record entries (unlike lists): `{x: 1, y: 2}`.
- FORBIDDEN: No space after `:`: `{x:1}`, `{name:Alice}`.
- FORBIDDEN: More than one space after `:`: `{x:  1, y:  2}`.
- FORBIDDEN: Space before `:` in records: `{x : 1}`.
- FORBIDDEN: Mixed spacing within the same record: `{x: 1, y:2}`.

## Rationale

1. The `key: value` convention with a space after the colon is standard across JSON, YAML, TOML, Rust, TypeScript, and virtually every modern language with record-like syntax.
2. The space visually separates the key from its value, improving scanability.
3. Omitting the space after the colon creates cramped syntax that is harder to read, especially with longer values.
4. The space-before-colon convention exists in some languages (Hugo, some YAML styles) but Nushell follows the JSON/Rust convention.

## Examples

### CORRECT

```nu
{x: 1, y: 2}
{name: 'Alice', age: 30, role: 'admin'}
{status: 'UP', response_time_ms: 45}
let config = {
    host: 'localhost'
    port: 8080
    tls: true
    timeout: 30_000
}
def process []: int -> record<id: int, status: string> {
    {id: 42, status: 'ok'}
}
```

### INCORRECT

```nu
{x:1, y:2}                       # no space after colon — FORBIDDEN
{name:'Alice', age:30}           # no space after colon — FORBIDDEN
{status:  'UP'}                  # double space after colon — FORBIDDEN
{x : 1, y : 2}                   # space before colon — FORBIDDEN
{x: 1, y:2}                      # inconsistent spacing — FORBIDDEN
{host: 'localhost', port:8080}   # inconsistent — FORBIDDEN
```

## Interaction With Other Rules

- Unlike list literals (which omit commas), record literals MAY use commas between entries.
- Multi-line records (see `nushell-formatting-multiline-records`) omit commas and use newline separation instead.

## Related Skills

- [nushell-formatting-no-commas-lists](file://.opencode/skills/nushell-formatting-no-commas-lists.md)
- [nushell-formatting-multiline-records](file://.opencode/skills/nushell-formatting-multiline-records.md)
