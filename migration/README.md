# Migration Plan: Current → Hermetic Dev Environment

Source: `STANDARDS.adoc v2.0.0`
Target: Nix-based hermetic dev environment with Nushell, Helix, jj
System: Ubuntu 26.04 (native, 2-core AMD, 3.1 GiB RAM)

## Boot Order

Execute prompts **strictly in sequence**. Each prompt lists its preconditions — do not skip ahead.

```
P01  System Prep — Swap + Nix Install
 │
P02  Bootstrap Nix Dev Shell
 │
P03  Repair Dotfiles Paths
 │
P04  Nushell Home Config
 │
P05  Helix Editor + LSP
 │
P06  Starship + Terminal/Multiplexer
 │
P07  jj (Jujutsu) Setup
 │
P08  Dotfiles Housekeeping
 │
P09  Switch Default Shell to Nushell
 │
P10  Full Verification
```

## State Tracking

Each prompt ends with a **verification step**. Do not proceed to the next prompt until all checks pass. If a prompt fails, revert using its rollback section, fix the root cause, and re-run.

## Key

- `$REPO` = `/home/twomuchcoffee/.local/src/dotfiles`
- `$USER` = `twomuchcoffee`
- `doas` is the privilege escalator (sudo is available but not preferred)
- The existing `flake.nix` at `$REPO/flake.nix` provides ALL tools via Nix — no individual `cargo install` steps needed
- 3.1 GiB RAM constraint: swap is mandatory before any compilation work
