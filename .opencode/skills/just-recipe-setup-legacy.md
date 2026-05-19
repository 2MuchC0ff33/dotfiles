# just-recipe-setup-legacy

## Description
Legacy setup recipes for non-Nix users: tool installation and environment verification via Nushell scripts.

## When to Load
Load this skill when implementing, modifying, or documenting the `setup-legacy` or `deps-legacy` recipes in the justfile, or when setting up the project without Nix.

## Source
STANDARDS.adoc §8.1 (lines 2857–2863)

## Key Rules

- MANDATE: `setup-legacy` MUST run `nu scripts/dev-setup.nu` — installs all required tools via Nushell script.
- MANDATE: `deps-legacy` MUST run `nu scripts/check-deps.nu` — verifies all required tools are present and correct versions.
- MANDATE: Both scripts MUST use Nushell (`.nu` extension), never bash/sh (`.sh`).
- SHOULD: Use the Nix-based `just shell` recipe instead of legacy setup when possible — Nix is the primary development environment.
- SHOULD: `scripts/dev-setup.nu` should install all tools listed in STANDARDS Part 1: `rg`, `fd`, `bat`, `sd`, `delta`, `eza`, `dust`, `procs`, `btm`, `zoxide`, `xh`, `dog`, `gping`, `ouch`, `bandwhich`, `just`, `zellij`, `hx`.
- SHOULD: `scripts/check-deps.nu` should verify each tool exists in `$PATH` and matches the minimum required version.
- FORBIDDEN: Do NOT use `cargo install` in legacy setup scripts without `--locked`.
- FORBIDDEN: Do NOT commit binaries or vendor directories — setup scripts download/build from source.
- FORBIDDEN: Do NOT require `sudo` for setup — all tools should install to user-local paths (`~/.cargo/bin`, `~/.local/bin`).

## Examples

```just
# Install all required tools (legacy)
setup-legacy:
    nu scripts/dev-setup.nu

# Verify all required tools present (legacy)
deps-legacy:
    nu scripts/check-deps.nu
```

Usage:
```sh
just setup-legacy    # First-time setup without Nix
just deps-legacy     # Verify environment after setup
```

## Legacy vs Nix
| Approach | Command | When to Use |
|---|---|---|
| Nix (primary) | `just shell` | Nix users; hermetic environment |
| Legacy | `just setup-legacy` | Non-Nix users; first-time setup |
| Legacy | `just deps-legacy` | Non-Nix users; integrity check |

## Related Skills
- [just-recipe-nix](file://.opencode/skills/just-recipe-nix.md)
