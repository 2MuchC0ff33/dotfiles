---
name: nushell-antipattern-each-single-record
description: Description
compatibility: opencode
---

# Anti-Pattern #19: Each on Single Records

## Description
Anti-pattern: Using `each` on single records. Use `items {|key, val| ...}`.

## When to Load
Load this skill when iterating over record fields.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4443)

## Key Rules

- FORBIDDEN: `each` on single records
- MANDATE: Use `items {|key, val| ...}`

## Rationale

`each` is for lists. Using it on a single record treats the record as a single item, not its fields. `items` correctly iterates over each key-value pair in the record, providing both the key and value as separate parameters.

## Example

```nu
# BAD — each on single record (anti-pattern #19)
let config = {host: 'localhost', port: 8080, debug: true}
$config | each {|value|                   # treats entire record as one item!
    print $value
}

# GOOD — items for record iteration
$config | items {|key, value|
    print $'($key) = ($value)'
}

# BAD — trying to get keys with each
let user = {name: 'Alice', age: 30}
$user | each {|field|                     # wrong — iterates record as a single item
    print $field.name?
}

# GOOD — items for key-value pairs
$user | items {|key, val|
    print $'($key): ($val)'
}

# BAD — transforming record
$config | each {|_|                       # useless — single iteration
    {host: 'localhost', port: 9090}
}

# GOOD — columns/items for record transform
$config | items {|key, val|
    if $key == 'port' { 9090 } else { $val }
}

# BAD — filtering record
$config | where value != null              # where on record doesn't work as expected
```
