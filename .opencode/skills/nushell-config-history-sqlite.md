# nushell-config-history-sqlite

## Description
Store Nushell command history in SQLite format for durability, performance, and queryability.

## When to Load
Load this skill when configuring `$env.config.history.file_format` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3665)

## Key Rules

- MANDATE: `$env.config.history.file_format` MUST be `"sqlite"`.
- SHOULD: SQLite history provides ACID guarantees, concurrent session safety, efficient timestamp-based queries, and avoids plaintext file corruption.
- FORBIDDEN: `file_format: "plaintext"` or `file_format: "mutex"`.

## Rationale

SQLite-backed history offers several critical advantages over plaintext files:
- **Crash safety**: Power loss or abrupt termination won't corrupt the history file (ACID via WAL mode).
- **Concurrent sessions**: Multiple Nushell instances can safely read/write history simultaneously without file corruption.
- **Queryability**: You can use `history` commands with rich filtering (by time, session, command text).
- **Performance**: SQLite indexes provide O(log n) lookups vs O(n) scans of plaintext.
- **No lock contention**: The `"mutex"` format serializes access across sessions, causing stalls.

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
- [nushell-config-history-max-size](file://.opencode/skills/nushell-config-history-max-size.md)
- [nushell-config-history-sync](file://.opencode/skills/nushell-config-history-sync.md)
- [nushell-config-history-isolation](file://.opencode/skills/nushell-config-history-isolation.md)
