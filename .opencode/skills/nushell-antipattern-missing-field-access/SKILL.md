---
name: nushell-antipattern-missing-field-access
description: Description
compatibility: opencode
---

# Anti-Pattern #20: Missing Field Access Without Question Mark

## Description
Anti-pattern: Missing field access without `?`. Use `$rec.field?` for optional fields.

## When to Load
Load this skill when accessing record fields that may not exist.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4444)

## Key Rules

- FORBIDDEN: Missing field access without `?`
- MANDATE: Use `$rec.field?` for optional fields

## Rationale

Accessing a missing field without `?` causes a runtime panic. The `?` operator returns `null` for missing fields, which can be safely handled with `default`, `compact`, or other commands.

## Example

```nu
# BAD — panics if field missing (anti-pattern #20)
let version = $record.version          # Panic! if version doesn't exist
let city = $user.address.city          # Panic! if address or city missing

# GOOD — optional field access
let version = $record.version?         # null if missing
let city = $user.address?.city?        # null if address or city missing

# BAD — no ? for optional field access
$data | each {|row|
    print $row.name                    # Panics if any row lacks 'name'
}

# GOOD — optional access
$data | each {|row|
    print ($row.name? | default 'unnamed')
}

# BAD — nested optional without ?
let street = $user.address.street      # Double panic if address missing

# GOOD — nested optional with ?
let street = $user.address?.street? | default 'No address'

# BAD — assuming field exists in where
ls | where size > 1mb                  # size always exists for ls — OK
# but for custom data:
$records | where metadata.size > 1mb   # Panics if any record has no metadata

# GOOD — optional access in where
$records | where $it.metadata?.size? | default 0 > 1mb
```
