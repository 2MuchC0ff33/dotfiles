# Rust-Native Shell & Terminal Replacements

## Description
Shell and terminal replacements: nushell→bash/zsh, starship→oh-my-zsh, zellij→tmux, alacritty→xterm, helix→vim, just→make, jj→git. These tools replace the entire terminal user experience with Rust-native alternatives.

## When to Load
Load this skill when setting up a new development environment, configuring shell, terminal multiplexer, editor, or VCS tooling.

## Source
STANDARDS.adoc §1.4.3 (lines 815–848), §1.4.5 (lines 908–929), §1.1 (lines 570–581)

## Key Rules

- **MANDATE**: Nushell SHALL be the primary shell (replaces bash/zsh).
- **MANDATE**: Starship SHALL be the prompt engine (works with any shell).
- **MANDATE**: Helix SHALL be the primary editor (replaces vim/neovim).
- **MANDATE**: jj (Jujutsu) SHALL be the primary VCS with git backend.
- **MANDATE**: just SHALL be the command runner (replaces make).
- **SHOULD**: Zellij SHALL be the terminal multiplexer (replaces tmux).
- **SHOULD**: Alacritty SHALL be the terminal emulator (GPU-accelerated).
- **CAVEAT**: Alacritty requires system packages (`cmake`, `freetype`, `fontconfig`).

## Replacement Table

| Rust Tool | Replaces | Install | Drop-in? |
|---|---|---|---|
| **nushell** (`nu`) | `bash` / `zsh` | `cargo install --locked nu` | Full |
| **starship** (`starship`) | shell prompts | `cargo install --locked starship` | Full |
| **zellij** (`zellij`) | `tmux` / `screen` | `cargo install --locked zellij` | Full |
| **alacritty** (`alacritty`) | xterm, gnome-terminal | `cargo install --locked alacritty` | Full |
| **helix** (`hx`) | `vim` / `neovim` | `cargo install --locked helix` | Full |
| **just** (`just`) | `make` | `cargo install --locked just` | Full |
| **jj** (`jj`) | `git` (full replacement) | `cargo install --locked jujutsu` | Full |
| **gg** (`gg`) | `gitui` (TUI for jj) | `cargo install --locked gg` | Full |

## Tool Details

### Nushell
- Structured data pipelines (lists, tables, records instead of strings)
- Typed variables — no string-whispering
- Consistent command syntax: `ls | where size > 1mb | sort-by name`
- Config: `~/.config/nushell/config.nu`, `~/.config/nushell/env.nu`

### Starship
- Works in any shell (bash, zsh, fish, nushell)
- Minimal, fast, customizable prompt
- Shows Rust version, git status, command duration, etc.
- Config: `~/.config/starship.toml`

### Helix
- Modal editor with built-in LSP, tree-sitter, file picker
- No plugin system (by design) — batteries included
- Config: `~/.config/helix/config.toml`, `~/.config/helix/languages.toml`

### jj (Jujutsu)
- Change-oriented VCS, 100% git-compatible
- Automatic rebase, undo, no staging area
- `jj` aliased to `git` in Nushell config
- Workflow: `jj new`, `jj describe`, `jj git push`, `jj rebase -d main`

### just
- Simpler syntax than Makefile — no tabs vs spaces issues
- Type-checked recipes with positional arguments
- Recipes defined as `check:` blocks with shell commands

## Alacritty System Dependencies

Alacritty requires system-level graphics libraries that cannot be installed via cargo:

```bash
# Linux (Debian/Ubuntu)
apt install cmake libfreetype6-dev libfontconfig1-dev

# macOS
brew install cmake freetype fontconfig
```

## Related Skills
- [rust-native-tools-core](file://.opencode/skills/rust-native-tools-core.md)
- [rust-native-tools-utilities](file://.opencode/skills/rust-native-tools-utilities.md)
- [rust-cargo-install-locked](file://.opencode/skills/rust-cargo-install-locked.md)
