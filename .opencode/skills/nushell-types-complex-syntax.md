# Nushell Types: Complex Type Syntax Reference

## Description
Reference for Nushell's complex type annotation syntax including records, lists, tables, optionals, and nesting.

## When to Load
Load this skill when defining type annotations for records, lists, tables, optional values, nested structures, or any type more complex than a primitive (`int`, `string`, `bool`, etc.).

## Source
STANDARDS.adoc §11.5.4 (lines 4088–4125)

## Key Rules

- MANDATE: Use `record<...>` for record types with named fields and their types.
- MANDATE: Use `list<...>` for list types with element type.
- MANDATE: Use `table<...>` for table types (list of records with named columns).
- MANDATE: Use `?` suffix on field names for optional fields: `field?: string`.
- MANDATE: Nest angle brackets for complex nesting: `record<metadata: record<version: string>>`.
- MANDATE: Separate fields with commas inside `<>` type parameters.
- MANDATE: Use `nothing` for absence of value (both as input and output type).
- FORBIDDEN: Using `any` when a specific type is known.
- FORBIDDEN: Omitting the type parameter on `list`, `record`, or `table` (write `list<string>` not `list`).

## Type Syntax Reference

| Syntax | Meaning | Example |
|--------|---------|---------|
| `int` | Integer | `42` |
| `float` | Floating-point | `3.14` |
| `string` | Text string | `'hello'` |
| `bool` | Boolean | `true` |
| `datetime` | Date/time | `'2024-01-01'` |
| `filesize` | File size | `1mb` |
| `nothing` | Absence of value | `null` |
| `any` | Any type (avoid if possible) | — |
| `list<type>` | Homogeneous list | `list<string>` |
| `record<fields>` | Record with named fields | `record<name: string, age: int>` |
| `table<columns>` | Table with named columns | `table<id: int, name: string>` |
| `field?: type` | Optional field in record | `record<name: string, email?: string>` |

## Examples

### Simple Types

```nu
def greet [name: string]: string -> string { 'hello' }
def add [a: int, b: int]: int -> int { $a + $b }
def is-active [id: int]: int -> bool { $id > 0 }
def get-size [path: string]: string -> filesize { ls $path | get size | first }
```

### List Types

```nu
def process-names [names: list<string>]: list<string> -> list<string> {
    $names | each {|n| $n | str upcase }
}

def sum-all [nums: list<int>]: list<int> -> int {
    $nums | math sum
}

def first-three [items: list<any>]: list<any> -> list<any> {
    $items | first 3
}
```

### Record Types

```nu
def get-config []: nothing -> record<host: string, port: int, tls: bool> {
    {host: 'localhost', port: 8080, tls: true}
}

def display-user [user: record<name: string, age: int, email?: string>]: record<...> -> string {
    $'Name: ($user.name), Age: ($user.age)'
}
```

### Table Types

```nu
def get-users []: nothing -> table<id: int, name: string, email: string> {
    [[id name email]; [1 'Alice' 'a@x.com'] [2 'Bob' 'b@x.com']]
}

def active-users [users: table<id: int, active: bool>]: table<...> -> table<id: int> {
    $users | where active == true | select id
}
```

### Optional Fields

```nu
def create-user [
    name: string
    age: int
    --email: string
    --nickname: string
]: record<name: string, age: int, email?: string, nickname?: string> -> record<id: int, ...> {
    # ...
}
```

### Nested Types

```nu
def get-full-config []: nothing -> record<
    app: record<name: string, version: string>,
    database: record<host: string, port: int, pool: int>,
    logging: record<level: string, file: string, format?: string>
> {
    # ...
}

def process-metadata [data: record<
    items: list<record<id: int, tags: list<string>>>,
    config: record<debug: bool, timeout: int>
>]: record<...> -> int {
    # ...
}
```

### In I/O Signatures

```nu
# Takes int, returns record with nested record and list
def lookup-user [id: int]: int -> record<
    id: int,
    name: string,
    roles: list<string>,
    metadata: record<created: datetime, updated: datetime>
> {
    {id: $id, name: 'Alice', roles: ['admin'], metadata: {created: '2024-01-01', updated: '2024-06-15'}}
}
```

## Common Mistakes

| Mistake | Correct |
|---------|---------|
| `list` (no type param) | `list<string>` |
| `record` (no fields) | `record<name: string>` |
| `table` (no columns) | `table<id: int, name: string>` |
| `{name: string}` in type | `record<name: string>` |
| `[string]` in type | `list<string>` |
| `nullable string` | `record<field?: string>` or just `string` if not in a record |
| `str` | `string` |

## Related Skills

- [nushell-types-param-annotations](file://.opencode/skills/nushell-types-param-annotations.md)
- [nushell-types-io-signatures](file://.opencode/skills/nushell-types-io-signatures.md)
- [nushell-types-const-typed](file://.opencode/skills/nushell-types-const-typed.md)
- [nushell-types-return-type-documented](file://.opencode/skills/nushell-types-return-type-documented.md)
