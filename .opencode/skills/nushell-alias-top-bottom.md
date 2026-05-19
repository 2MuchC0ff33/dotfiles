# nushell-alias-top-bottom

## Description
Replace Nushell's process monitor with `btm` (bottom), a cross-platform TUI system monitor.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3640)

## Key Rules

- MANDATE: `alias top = btm` MUST be present in `config.nu`.
- SHOULD: Use `btm` (bottom) for interactive system monitoring instead of any built-in process viewer.
- FORBIDDEN: Omitting this alias, or aliasing `top` to another TUI (htop, btop) — `btm` is the specified default.

## Rationale

`btm` (bottom) is a cross-platform graphical process/system monitor:

- **Multiple widgets**: CPU, memory, disk, network, processes, temperature
- **Mouse support**: Click to sort, select, expand
- **Customizable**: Show/hide widgets, change colors, adjust refresh rate
- **Cross-platform**: Linux, macOS, Windows (via Crossterm)
- **Process management**: Search, filter, kill processes interactively
- **Zoom**: Time-series zooming for resource graphs
- **Minimal dependencies**: Pure Rust, no system library dependencies

`btm` was chosen over `htop` (C/ncurses) and `btop` (C++/Bpftrace) for its
Rust-native toolchain, active maintenance, and consistent cross-platform UI.

## Example

```nushell
alias top = btm
```

Usage: `top` → launches the bottom TUI system monitor.
