# nushell-config-history-isolation

## Description
Isolate history per-session so concurrent shell instances don't interleave history entries.

## When to Load
Load this skill when configuring `$env.config.history.isolation` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3666)

## Key Rules

- MANDATE: `$env.config.history.isolation` MUST be `true`.
- SHOULD: With isolation enabled, each shell session's history is tracked separately. The `history` command shows entries from the current session by default, with options to view global history.
- FORBIDDEN: `isolation: false` — this causes interleaved history across sessions, making it hard to find commands from the current workflow.

## Rationale

History isolation addresses a common frustration: when you have multiple
terminal windows or tabs open, commands from all sessions get mixed together
in a single chronological stream. With `isolation: true`:

- **Per-session views**: `history` shows only the current session's commands
- **Global view**: Use `history --global` to search across all sessions
- **Session tagging**: Each entry is tagged with its session ID in SQLite
- **Focused search**: Fuzzy completion and `Ctrl+R` search scope is limited
  to the current session unless explicitly expanded

This is especially valuable when working on multiple tasks simultaneously
(e.g., one session for project A, another for project B). Without isolation,
`Ctrl+R` fuzzy search would show results from both projects mixed together.

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
- [nushell-config-history-sync](file://.opencode/skills/nushell-config-history-sync.md)
