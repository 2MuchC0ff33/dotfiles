# nushell-config-history-max-size

## Description
Limit Nushell command history to 100,000 entries to balance recall capacity with storage/performance.

## When to Load
Load this skill when configuring `$env.config.history.max_size` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3663)

## Key Rules

- MANDATE: `$env.config.history.max_size` MUST be `100_000`.
- SHOULD: 100,000 entries provides approximately 6-12 months of command history for an active developer, depending on session volume.
- FORBIDDEN: Values below `10_000` (too restrictive), values above `1_000_000` (performance regression at startup and on query), or omitting the field entirely.

## Rationale

The 100,000 entry cap strikes a balance between:
- **Recall**: Enough history to find commands from months ago via fuzzy search
- **Startup time**: SQLite loads only the index at startup, not all entries
- **Storage**: At ~200 bytes per entry (compressed SQLite), ~20 MB total
- **Query performance**: `history | where cmd =~ "pattern"` stays snappy

Nushell's SQLite backend handles pruning automatically — when the limit is
reached, old entries are evicted to make room for new ones.

## Example

```nushell
$env.config = {
    history: {
        max_size:             100_000
        sync_on_each_command: true
        file_format:          "sqlite"
        isolation:            true
    }
}
```

## Related Skills
- [nushell-config-history-sqlite](file://.opencode/skills/nushell-config-history-sqlite.md)
- [nushell-config-history-sync](file://.opencode/skills/nushell-config-history-sync.md)
- [nushell-config-history-isolation](file://.opencode/skills/nushell-config-history-isolation.md)
