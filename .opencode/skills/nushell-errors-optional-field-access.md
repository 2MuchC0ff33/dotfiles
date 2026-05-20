# Optional Field Access With Question Mark

## Description
Use `?` for optional field access (`$record.field?`) to safely access potentially missing fields without panicking.

## When to Load
Load this skill when accessing fields on records that may not have the field present.

## Source
STANDARDS.adoc §11.5.7 (lines 4313–4330, 4360–4362)

## Key Rules

- SHOULD: Use `?` for optional field access: `$record.field?`

## Rationale

Accessing a missing field without `?` causes a runtime panic. The `?` operator returns `null` for missing fields, which can then be handled with `default`, `compact`, or other pipeline commands. This is the idiomatic way to handle optional data in Nushell.

## Example

```nu
# INCORRECT — panics if field is missing
let version = $record.version       # Panic! if version doesn't exist

# CORRECT — optional field access
let version = $record.version?      # null if missing

# CORRECT — optional field with default
let version = $record.version? | default '0.0.0'
# NOT: let version = $record.version   (panics if missing)

# CORRECT — optional nested access
let city = $user.address?.city?     # null if address or city missing

# BAD — manual checking (but no panic)
let city = if ($user | has-attr address) {
    $user.address.city
}

# GOOD — optional chaining
let city = $user.address?.city? | default 'Unknown'

# CORRECT — optional access in pipeline
ls
| where $it.name? != null            # skip entries without names
| each {|f| $f.size? | default 0}   # default size if missing

# CORRECT — optional field with compact to remove nulls
$data | select name version?        # version column may be null
```

## Related Skills
- nushell-errors-default-over-null-check
- nushell-antipattern-missing-field-access
- nushell-antipattern-manual-null-check
