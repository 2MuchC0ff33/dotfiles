---
name: nushell-alias-ping-gping
description: Description
compatibility: opencode
---

# nushell-alias-ping-gping

## Description
Replace `ping` with `gping`, a Rust-native ping tool with real-time graphing and multi-host support.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3705)

## Key Rules

- MANDATE: `alias ping = gping` MUST be present in `config.nu`.
- SHOULD: Use `gping` for network latency testing instead of traditional `ping`.
- FORBIDDEN: Omitting this alias, leaving the traditional `ping` (text-only, no graphing).

## Rationale

`gping` adds a graphical dimension to ping:

- **Real-time graph**: Displays latency over time as a scrolling chart
- **Multi-host**: Ping multiple hosts simultaneously, each with its own colored line
- **Histogram**: `--histogram` for latency distribution
- **Clear labels**: Shows min/max/avg/Jitter in the legend
- **Cross-platform**: Linux, macOS, Windows
- **Responsive**: Adjusts the time window as you resize the terminal

The latency graph makes it immediately obvious when you have packet loss,
intermittent high latency, or jitter — things that are hard to spot in
traditional ping's scrolling text output.

## Example

```nushell
alias ping = gping
```

Usage:
- `ping google.com` → real-time latency graph
- `ping google.com cloudflare.com 1.1.1.1` → compare multiple hosts
