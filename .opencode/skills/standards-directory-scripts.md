# Skill Name: Scripts Directory

## Description
The `scripts/` directory contains Nushell-only scripts (.nu extension, never .sh) for development setup, dependency checking, release workflows, and CI utilities.

## When to Load
Load this skill when creating new scripts, migrating shell scripts to Nushell, or verifying the scripts directory structure.

## Source
STANDARDS.adoc §2.1 (lines 1240–1244)

## Key Rules

- MANDATE: All scripts in `scripts/` use `.nu` extension (never `.sh`)
- MANDATE: `dev-setup.nu` installs all required tools for development
- MANDATE: `check-deps.nu` verifies all required tools are present and at correct versions
- SHOULD: `release.nu` contains the release workflow automation
- SHOULD: `ci-helper.nu` contains CI utility functions used across workflows
- FORBIDDEN: POSIX shell scripts (`.sh`, `.bash`, `.zsh`) in the repository
- FORBIDDEN: Mixing script languages — all automation scripts are Nushell

## Example

```nu
# CORRECT — Nushell script (dev-setup.nu)
#!/usr/bin/env nu

# Install all required tools for dotfiles development
def main [] {
    print "Setting up development environment..."

    # Install Rust toolchain
    ^rustup toolchain install stable

    # Install Rust-native replacements
    let tools = [
        "ripgrep", "fd-find", "bat", "git-delta",
        "eza", "dust", "procs", "bottom",
        "zoxide", "xh", "dog", "gping",
        "ouch", "bandwhich", "just", "zellij", "helix"
    ]

    for tool in $tools {
        cargo install --locked $tool
    }

    print "Development environment setup complete."
}
```

```sh
# INCORRECT — POSIX shell script (dev-setup.sh)
#!/bin/sh

# FORBIDDEN: No .sh scripts in the repository
set -e
echo "Setting up development environment..."
cargo install ripgrep fd-find bat
# MIXING languages violates the standard
```

## Related Skills
- [standards-directory-config-files](file://.opencode/skills/standards-directory-config-files.md)
- [standards-directory-root-files](file://.opencode/skills/standards-directory-root-files.md)
