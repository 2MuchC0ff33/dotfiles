# Skill Name: Config Directory Layout

## Description
Standard dotfiles directory layout mapping `config/` subdirectories to `~/.config/` locations for Nushell, Helix, Starship, Zellij, and Alacritty.

## When to Load
Load this skill when creating or modifying configuration files under `config/`, adding new tool configurations, or verifying the dotfiles directory structure conforms to the standard.

## Source
STANDARDS.adoc §2.1 (lines 1126–1255)

## Key Rules

- MANDATE: `config/nushell/` maps to `~/.config/nushell/` — contains `config.nu` and `env.nu`
- MANDATE: `config/helix/` maps to `~/.config/helix/` — contains `config.toml` and `languages.toml`
- MANDATE: `config/starship.toml` maps to `~/.config/starship.toml`
- MANDATE: `config/zellij/` maps to `~/.config/zellij/`
- MANDATE: `config/alacritty/` maps to `~/.config/alacritty/`
- SHOULD: Each config directory contains only the minimum files needed for that tool's configuration
- SHOULD: Config files are symlinked or copied to `~/.config/` by a bootstrap script
- FORBIDDEN: Putting configuration outside `config/` directory tree
- FORBIDDEN: Mixing multiple tools' configuration in a single file

## Example

```text
# CORRECT — Standard config directory layout
config/
├── nushell/
│   ├── config.nu          # → ~/.config/nushell/config.nu
│   └── env.nu             # → ~/.config/nushell/env.nu
├── helix/
│   ├── config.toml        # → ~/.config/helix/config.toml
│   └── languages.toml     # → ~/.config/helix/languages.toml
├── starship.toml          # → ~/.config/starship.toml
├── zellij/
│   └── config.kdl         # → ~/.config/zellij/config.kdl
└── alacritty/
    └── alacritty.toml     # → ~/.config/alacritty/alacritty.toml

# INCORRECT — Disorganized layout
config/
├── nushell-config.toml    # Wrong location, wrong name
├── helix-config.toml      # Flat file instead of directory
├── my-scripts/            # Scripts don't belong in config/
└── random-tool/           # Tool not in the approved list
```

## Related Skills
- [standards-directory-scripts](file://.opencode/skills/standards-directory-scripts.md)
- [standards-directory-root-files](file://.opencode/skills/standards-directory-root-files.md)
