---
name: nushell-config-table-trim-wrapping
description: Description
compatibility: opencode
---

# nushell-config-table-trim-wrapping

## Description
Wrap long table cell contents at word boundaries instead of truncating or clipping, with word-boundary-aware wrapping.

## When to Load
Load this skill when configuring `$env.config.table.trim` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (lines 3679–3682)

## Key Rules

- MANDATE: `$env.config.table.trim.methodology` MUST be `"wrapping"` AND `$env.config.table.trim.wrapping_try_keep_words` MUST be `true`.
- SHOULD: Long text in table cells wraps to the next line within the column, breaking at word boundaries rather than mid-word.
- FORBIDDEN: `methodology: "truncate"` (cuts off text with `…`), `methodology: "clip"` (abruptly cuts text at column edge), or `wrapping_try_keep_words: false` (wraps mid-word).

## Rationale

The trim methodology controls how Nushell handles content that's wider than
the terminal column width. Wrapping is superior because:

- **Readability**: All content is visible, just across multiple lines
- **Word integrity**: With `wrapping_try_keep_words: true`, breaks happen at
  spaces, not in the middle of words — critical for code paths, URLs,
  identifiers, and error messages
- **No information loss**: Unlike truncation (`...`) or clipping, wrapping
  preserves the full content

Alternative methodologies:
- `"truncate"`: Appends `…` to truncated text — loses data silently
- `"clip"`: Cuts off at column boundary — loses data silently, worse than truncate

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
- [nushell-config-table-index-always](file://.opencode/skills/nushell-config-table-index-always.md)
