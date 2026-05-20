# nushell-config-completions-case-sensitive

## Description
Enforce case-sensitive matching in tab completions for precision.

## When to Load
Load this skill when configuring `$env.config.completions.case_sensitive` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3728)

## Key Rules

- MANDATE: `$env.config.completions.case_sensitive` MUST be `true`.
- SHOULD: Case-sensitive completions ensure that `File` and `file` are distinct matches, reducing ambiguity in command and path resolution.
- FORBIDDEN: `case_sensitive: false` — this introduces ambiguity where case distinguishes meaning (e.g., in Rust, type names are `PascalCase`, variables are `snake_case`).

## Rationale

Case-sensitive completions are preferred in this configuration for several
reasons:

- **Naming convention preservation**: Rust distinguishes `MyType` (PascalCase
  type) from `my_type` (snake_case variable). Case-insensitive matching blurs
  this distinction.
- **Filesystem accuracy**: On Linux (ext4, btrfs, etc.), filenames are
  case-sensitive. Case-insensitive completion can mislead you into thinking a
  file exists with wrong casing.
- **Precision over recall**: With fuzzy matching already providing wide recall,
  case-sensitivity narrows results to the most relevant ones.
- **Consistency**: Helix editor is case-sensitive in search; shell completions
  should behave the same way.

## Example

```nushell
$env.config = {
    completions: {
        case_sensitive: true
        quick:          false
        partial:        false
        algorithm:      "fuzzy"
    }
}
```

## Related Skills
- [nushell-config-completions-fuzzy](file://.opencode/skills/nushell-config-completions-fuzzy.md)
- [nushell-config-completions-quick](file://.opencode/skills/nushell-config-completions-quick.md)
- [nushell-config-completions-partial](file://.opencode/skills/nushell-config-completions-partial.md)
