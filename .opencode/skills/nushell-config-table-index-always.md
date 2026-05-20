# nushell-config-table-index-always

## Description
Always show row index numbers in table output for easier reference and navigation.

## When to Load
Load this skill when configuring `$env.config.table.index_mode` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3678)

## Key Rules

- MANDATE: `$env.config.table.index_mode` MUST be `"always"`.
- SHOULD: Every displayed table includes a leftmost `#` column with 1-based row numbers.
- FORBIDDEN: `index_mode: "never"` (hides indices entirely) or `index_mode: "auto"` (shows only when rows > 1 — inconsistent behavior).

## Rationale

Always-on row indices serve several practical purposes:
- **Referencing rows**: "Look at row 5" is unambiguous communication in
  code review, pair programming, or documentation
- **Pipeline debugging**: `save` with index helps trace which row produced
  which output
- **Consistent UI**: Some commands show one row and lack an index; others
  show multiple and have one. "Always" eliminates the surprise.
- **Data analysis**: `select`, `where`, `sort-by` results are easier to
  discuss when every row has a stable visual identifier

The `"auto"` mode (default) hides the index when there is exactly one row,
which is disorienting — the same command sometimes shows an index and
sometimes doesn't, depending on data volume.

## Example

```nushell
$env.config = {
    table: {
        mode:       "rounded"
        index_mode: "always"
        trim: {
            methodology:             "wrapping"
            wrapping_try_keep_words: true
        }
    }
}
```

## Related Skills
- [nushell-config-table-mode-rounded](file://.opencode/skills/nushell-config-table-mode-rounded.md)
- [nushell-config-table-trim-wrapping](file://.opencode/skills/nushell-config-table-trim-wrapping.md)
