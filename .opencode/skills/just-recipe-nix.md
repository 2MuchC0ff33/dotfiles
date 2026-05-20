# just-recipe-nix

## Description
Nix environment recipes: hermetic development shell, environment verification, and builds.

## When to Load
Load this skill when implementing, modifying, or documenting the `shell`, `deps`, `build`, `cross-nix`, or `cross-nix-one` (Nix) recipes in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2862–2884)

## Key Rules

- MANDATE: `shell` MUST run `nix develop .` — enters the hermetic Nix development shell defined in `flake.nix`.
- MANDATE: `deps` MUST run `nix flake check` — verifies flake integrity (all outputs build successfully).
- MANDATE: `build` MUST run `nix build .` — builds the default package for the current platform.
- MANDATE: `cross-nix` (Nix section) MUST run `nix build .#all` — builds all configured targets via Nix.
- MANDATE: `cross-nix-one TARGET` (Nix section) MUST run `nix build .#{{TARGET}}` — builds a single named target.
- MANDATE: `ci` MUST run `nix build .#checks` — builds all CI check derivations (equivalent to the full pipeline).
- SHOULD: Use Nix recipes as the primary development workflow; legacy setup is only for non-Nix users.
- SHOULD: Run `just deps` (nix flake check) after any change to `flake.nix` or `flake.lock`.
- SHOULD: Run `just shell` before running any other commands to ensure the correct toolchain versions.
- FORBIDDEN: Do NOT use `nix-shell` (legacy) — always use `nix develop` (new CLI).
- FORBIDDEN: Do NOT use `nix build` without `.#` prefix for non-default attributes.
- FORBIDDEN: Do NOT run `cargo install` without `--locked` inside or outside the Nix shell.

## Examples

```just
# Enter hermetic development shell
shell:
    nix develop .

# Verify environment integrity
deps:
    nix flake check

# Build for current platform
build:
    nix build .

# Cross-compile for all targets
cross-nix:
    nix build .#all

# Cross-compile for one target
cross-nix-one TARGET:
    nix build .#{{TARGET}}

# CI check (equivalent to full pipeline)
ci:
    nix build .#checks
```

Usage:
```sh
just shell              # Enter Nix dev shell
just deps               # Verify flake integrity
just build              # Build for current platform
just cross-nix              # Cross-compile for all targets
just cross-nix-one x86_64-pc-windows-gnu  # Build for specific target
just ci                 # Run CI check derivations
```

## Related Skills
- [just-recipe-ci](file://.opencode/skills/just-recipe-ci.md)
- [just-recipe-setup-legacy](file://.opencode/skills/just-recipe-setup-legacy.md)
- [just-recipe-cross](file://.opencode/skills/just-recipe-cross.md)
