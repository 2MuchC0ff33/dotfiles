---
name: nushell-config-history-sync
description: Description
compatibility: opencode
---

# nushell-config-history-sync

## Description
Synchronize history to disk after every command, ensuring no entries are lost on crash.

## When to Load
Load this skill when configuring `$env.config.history.sync_on_each_command` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3664)

## Key Rules

- MANDATE: `$env.config.history.sync_on_each_command` MUST be `true`.
- SHOULD: Every command is immediately flushed to the SQLite history file, so even if the shell crashes, the last command is preserved.
- FORBIDDEN: `sync_on_each_command: false` — this risks losing the last N commands on crash or power loss.

## Rationale

With `sync_on_each_command: true`, Nushell calls `fsync` (or the SQLite
equivalent) after writing each history entry. This guarantees durability at
the cost of a small latency penalty (~1-5 ms per command on typical SSDs).

With `sync_on_each_command: false`, history writes are buffered and flushed
periodically. If the terminal is killed, the system crashes, or the power
drops, all unsynced entries since the last flush are lost. For a developer
running `cargo xtask check` with a 30-minute build, that could be dozens of
intervening commands gone forever.

The 1-5 ms per write is negligible compared to the cost of losing work.

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
- [nushell-config-history-max-size](file://.opencode/skills/nushell-config-history-max-size.md)
- [nushell-config-history-isolation](file://.opencode/skills/nushell-config-history-isolation.md)
