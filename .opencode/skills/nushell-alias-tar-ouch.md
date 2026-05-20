# nushell-alias-tar-ouch

## Description
Replace `tar` with `ouch`, a Rust-native compression tool that handles multiple archive formats with a unified CLI.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3706)

## Key Rules

- MANDATE: `alias tar = ouch` MUST be present in `config.nu`.
- SHOULD: Use `ouch` for creating and extracting archives (`.tar.gz`, `.zip`, `.tar.xz`, `.7z`, etc.).
- FORBIDDEN: Omitting this alias, leaving the traditional `tar` (format-specific flags, no zip/7z support).

## Rationale

`ouch` simplifies archive operations with a unified interface:

- **Unified commands**: `ouch decompress file.tar.gz` not `tar -xzf file.tar.gz`
- **Multi-format**: tar, tar.gz, tar.xz, tar.bz2, zip, 7z, lz4, zstd, and more
- **Intuitive**: `ouch compress src/ archive.tar.gz` — you don't need to remember flag combinations
- **Listing**: `ouch list archive.tar.gz` shows contents
- **Cross-platform**: Same interface on Linux, macOS, Windows
- **Automatic format detection**: Extensions determine the format, no `-a` flag needed

The traditional `tar` requires memorizing cryptic flag combinations
(`-xzf` vs `-czf` vs `-xjf`) and doesn't handle `.zip` or `.7z` at all.

## Example

```nushell
alias tar = ouch
```

Usage:
- `tar decompress archive.tar.gz` → extract
- `tar compress src/ archive.tar.gz` → create
- `tar list archive.tar.gz` → list contents
