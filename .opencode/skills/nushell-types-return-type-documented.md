# Nushell Types: Public Commands MUST Document Return Type

## Description
ALL public (exported) commands MUST have a documented return type in their I/O signature. The return type of the command must be explicitly declared and documented.

## When to Load
Load this skill when defining exported commands, writing library/module code, reviewing public API surfaces of `.nu` files, or ensuring command signatures are fully documented.

## Source
STANDARDS.adoc §11.5.4 (lines 4146–4183)

## Key Rules

- MANDATE: The I/O signature MUST include a non-`nothing` return type when the command produces pipeline output (see `nushell-types-io-signatures` for the complete syntax).
- MANDATE: The return type MUST be documented via the I/O signature output type: `]: input_type -> output_type`.
- MANDATE: The documented return type MUST accurately reflect what the command actually returns.
- SHOULD: Use specific types rather than `any` — prefer `record<id: int, name: string>` over `any`.
- FORBIDDEN: Omitting the return type in the I/O signature for commands that return values.
- FORBIDDEN: Using `any` as the return type as a shortcut — be specific.
- FORBIDDEN: Claiming a return type that does not match the actual return value.

## Rationale

1. Documented return types allow consumers of the command to know exactly what data shape to expect.
2. Nushell's pipeline type checking can verify that the return type matches downstream expectations.
3. Return type documentation is essential for commands exported from modules — consumers may not have access to the source.
4. Self-documenting return types reduce the need for separate documentation and comments.
5. Explicit return types catch errors during refactoring when a command's return shape changes.

## Examples

### CORRECT

```nu
# Returns a record with id and status
def process-item [
    id: int
    --verbose (-v)
]: int -> record<id: int, status: string> {
    {id: $id, status: 'ok'}
}

# Returns a list of records
def list-users []: nothing -> table<id: int, name: string, email: string> {
    [
        [id name email];
        [1 'Alice' 'alice@example.com']
        [2 'Bob' 'bob@example.com']
    ]
}

# Returns nothing (side-effect only)
def log-message [msg: string]: string -> nothing {
    print $'[LOG] ($msg)'
}

# Returns a simple int
def count-active []: nothing -> int {
    $data | where active == true | length
}
```

### INCORRECT

```nu
def process-item [id] {              # no return type documented — FORBIDDEN
    {id: $id, status: 'ok'}
}

def list-users [] {                  # no return type — FORBIDDEN
    [[id name]; [1 'Alice']]
}

def count-active []: nothing -> any {  # any as return type — FORBIDDEN
    42
}

def get-version []: nothing -> nothing {  # incorrectly claims nothing — actually returns
    '1.0'
}
```

## Documenting Complex Return Types

For commands returning complex nested types, use the full type syntax:

```nu
def get-full-config []: nothing -> record<
    app: record<name: string, version: string>,
    database: record<host: string, port: int, pool: int>,
    logging: record<level: string, file: string>
> {
    # ...
}
```

## Related Skills

- [nushell-types-io-signatures](file://.opencode/skills/nushell-types-io-signatures.md)
- [nushell-types-param-annotations](file://.opencode/skills/nushell-types-param-annotations.md)
- [nushell-types-complex-syntax](file://.opencode/skills/nushell-types-complex-syntax.md)
