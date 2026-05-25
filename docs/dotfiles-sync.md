# Dotfiles Sync Checklist

This file is a reminder to keep this dotfiles repository in sync with
project-specific quirks and onboarding patterns in other repositories (e.g., elvis-rust).

## When adding or changing Nix/just workflows in a project repo

- Copy any new `doctor`, `impurity-check`, or `_auto` just recipes to this
  justfile if they are generally useful.
- Ensure `docs/platform-quirks/` exists and has relevant OS-specific notes
  mirrored from project repos.
- Update the Quick Start section in README.adoc to reflect the preferred
  hermetic workflow.

## When updating tool versions in dotfiles

- If a tool version changes in the dotfiles Nix flake, check whether any
  project repo relies on a specific version and update accordingly.
- If the Rust toolchain version changes, update `STANDARDS.adoc` and all
  `rust-toolchain.toml` files in project repos.

## Cross-references

- `elvis-rust/docs/platform-quirks/` — Alpine/WSL notes, contributing guide
- `elvis-rust/docs/dotfiles-sync.md` — counterpart to this file
