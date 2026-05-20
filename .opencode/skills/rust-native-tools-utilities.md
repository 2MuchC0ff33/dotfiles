# Rust-Native Utility Tool Replacements

## Description
Utility tool replacements: zoxide→cd, hyperfine→time, tokei→cloc, ouch→tar, xh→curl, dog→dig, gping→ping, bandwhich→nethogs. All installed via `cargo install --locked`.

## When to Load
Load this skill when setting up a development machine, replacing classic utilities with Rust-native alternatives, or evaluating tool compatibility.

## Source
STANDARDS.adoc §1.4.2 (lines 785–813), §1.4.5 (lines 908–929)

## Key Rules

- **MANDATE**: All utility tools SHALL be Rust-native replacements wherever possible.
- **MANDATE**: ALL tools SHALL be installed via `cargo install --locked`.
- **SHOULD**: Use `zoxide` (`z`) as the primary directory navigation tool.
- **SHOULD**: Use `hyperfine` for command timing and benchmarking.
- **CAVEAT**: `dog` is low maintenance (last release 2022) — keep `dig` for advanced DNS debugging.
- **CAVEAT**: `gping` on Linux requires `CAP_NET_RAW` or `sudo` for ICMP ping.

## Replacement Table

| Rust Tool | Replaces | Install | Drop-in? |
|---|---|---|---|
| **zoxide** (`z`) | `cd` | `cargo install --locked zoxide` | Full |
| **hyperfine** (`hyperfine`) | `time` | `cargo install --locked hyperfine` | Full |
| **tokei** (`tokei`) | `cloc` | `cargo install --locked tokei` | Full |
| **ouch** (`ouch`) | `tar` / `zip` / `gzip` | `cargo install --locked ouch` | Full |
| **xh** (`xh`) | `curl` / `httpie` | `cargo install --locked xh` | Full |
| **dog** (`dog`) | `dig` | `cargo install --locked dog` | Partial |
| **gping** (`gping`) | `ping` | `cargo install --locked gping` | Partial |
| **bandwhich** (`bandwhich`) | `nethogs` / `iftop` | `cargo install --locked bandwhich` | Full |

## Caveats and Compatibility

### dog (DNS lookup)
- Low maintenance (last release 2022)
- Basic DNS lookups (A, AAAA, MX, TXT) work fine
- For advanced DNS debugging (zone transfers, DNSSEC validation), keep `dig` installed

### gping (network latency)
- Linux: supports ICMP ping (requires `CAP_NET_RAW` capability or `sudo`)
- macOS and Windows: uses TCP ping by default (connect to a port, measure latency)
- Infrequent updates but stable

### ouch (archiving)
- Detects format from file extension
- Supports tar, zip, gzip, bzip2, xz, lz4, zstd, and more
- Simpler syntax than tar: `ouch decompress archive.tar.gz`

## Essential Usage

```bash
# zoxide — directory jumping
z projects/dotfiles   # fuzzy match, jumps to the right dir
z foo/bar/baz         # unique prefix matching

# hyperfine — benchmarking
hyperfine --warmup 3 'rg foo' 'grep -r foo'

# tokei — code statistics
tokei                 # count all code in current dir
tokei src/            # count code in src/

# ouch — archiving
ouch decompress archive.tar.gz   # auto-detects format
ouch compress myfile.txt         # compresses to myfile.txt.zip

# xh — HTTP requests
xh GET https://api.example.com/users
xh POST https://api.example.com/users name=John

# bandwhich — network monitoring
bandwhich              # TUI showing per-process bandwidth usage
```

## Related Skills
- [rust-native-tools-core](file://.opencode/skills/rust-native-tools-core.md)
- [rust-native-tools-terminal](file://.opencode/skills/rust-native-tools-terminal.md)
- [rust-cargo-install-locked](file://.opencode/skills/rust-cargo-install-locked.md)
