---
name: nushell-alias-ps-procs
description: Description
compatibility: opencode
---

# nushell-alias-ps-procs

## Description
Replace Nushell's built-in `ps` with `procs`, a Rust-native process viewer with colorized, columnar output.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3697)

## Key Rules

- MANDATE: `alias ps = procs` MUST be present in `config.nu`.
- SHOULD: Use `procs` for inspecting running processes instead of Nushell's built-in `ps`.
- FORBIDDEN: Omitting this alias, leaving the less feature-rich built-in process listing.

## Rationale

`procs` is a modern `ps` replacement with significantly better output:

- **Colorized**: Processes color-coded by type (user, system, etc.)
- **Tree view**: `--tree` for hierarchical process display
- **Docker awareness**: Shows container names for containerized processes
- **TCP/UDP ports**: Shows which ports processes are listening on with `--tcp`/`--udp`
- **Watch mode**: `--watch` for live-updating process list (like `top`-lite)
- **Custom columns**: `--only` to specify exactly which columns to show
- **Search**: `procs <keyword>` to filter by process name
- **Cross-platform**: Linux, macOS, Windows

## Example

```nushell
alias ps = procs
```

Usage: `ps` → colorized process list. `ps rust` → show only rust-related processes. `ps --tree` → hierarchical view.
