# AGENTS.md — dotfiles (2MuchC0ff33)

## Repo State

- **Early stage**: only `README.adoc` and `STANDARDS.adoc` committed
- **Active branch**: `dev`; `main` is protected (PR + 2 approvals + linear history + signed commits)
- **Org**: [2MuchC0ff33](https://github.com/2MuchC0ff33) on GitHub
- **License**: ISC

## VCS: `jj` (Jujutsu) primary, `git` fallback

Init a repo: `jj git init --colocate` (keeps `.git/` — GitHub works normally).

| Intent | `jj` command | Notes |
|---|---|---|
| Start work | `jj new [BRANCH]` | Creates change on top of `@` |
| Commit msg | `jj describe -m "msg"` | Idempotent — re-run to amend |
| Push | `jj git push` | Pushes real git commits |
| Rebase | `jj rebase -d main` | All descendants auto-rebase |
| Squash | `jj squash` | Into parent |
| Split | `jj split` | Interactive file-level split |
| Undo | `jj undo` | Full atomic operation undo |
| Log | `jj log` | Graph + change/commit IDs + bookmarks |
| Abandon | `jj abandon` | History preserved |
| Resolve | `jj resolve` | Conflicts stored in commits |

Known gaps vs git: no submodules (use `git` directly), no `jj gh submit` (use `gh` CLI).

## Toolchain: Rust-native replacements

| Classic → Rust | Install |
|---|---|
| `grep` → `rg` (ripgrep) | `cargo install --locked ripgrep` |
| `find` → `fd` | `cargo install --locked fd-find` |
| `cat` → `bat` | `cargo install --locked bat` |
| `sed` → `sd` | `cargo install --locked sd` |
| `diff` → `delta` | `cargo install --locked git-delta` |
| `ls` → `eza` | `cargo install --locked eza` |
| `du` → `dust` | `cargo install --locked dust` |
| `ps` → `procs` | `cargo install --locked procs` |
| `top` → `btm` (bottom) | `cargo install --locked bottom` |
| `cd` → `z` (zoxide) | `cargo install --locked zoxide` |
| `curl` → `xh` | `cargo install --locked xh` |
| `dig` → `dog` | `cargo install --locked dog` |
| `ping` → `gping` | `cargo install --locked gping` |
| `tar` → `ouch` | `cargo install --locked ouch` |
| `nethogs` → `bandwhich` | `cargo install --locked bandwhich` |
| `make` → `just` | `cargo install --locked just` |
| `tmux` → `zellij` | `cargo install --locked zellij` |
| `vim` → `hx` (helix) | `cargo install --locked helix` |

## Shell: Nushell (0.112.2)

- All scripts: `.nu` extension (never `.sh`)
- Config: `config/nushell/config.nu`, `config/nushell/env.nu` → `~/.config/nushell/`
- Key settings: fuzzy completions, sqlite history (100k), rounded tables, OSC 2/7/133 shell integration
- `$env.EDITOR = "hx"`, `$env.PROPTEST_CASES = "100000"`, `$env.RUSTFLAGS = "-Dwarnings"`
- `git` aliased to `jj`
- Prompt: Starship (init: `~/.cache/starship/init.nu`)

## Editor: Helix (25.07.1)

- Config: `config/helix/{config.toml,languages.toml}` → `~/.config/helix/`
- No plugin system (by design)

## Build System: just + cargo xtask

- `just` = thin wrapper for discoverability, `cargo xtask` = complex Rust automation
- Recipes (from STANDARDS Part 8):
  - `just check` → `cargo xtask check` (lint + test + proof + docs + audit)
  - `just lint` → `cargo xtask lint`
  - `just test` → `cargo xtask test`
  - `just fmt` / `just fmt-check` → `cargo fmt --all [--check]`
  - `just clippy` → `cargo clippy --all-targets --all-features -- -Dwarnings`
  - `just docs` → `cargo xtask docs`
  - `just audit` → `cargo xtask audit`
  - `just cross` → `cargo xtask cross` (via cargo-zigbuild + Zig linker)

## Dev Environment: Nix Flakes (26.05)

- Hermetic shell: `nix develop .`
- Verify: `nix flake check`
- Build: `nix build .`
- All `cargo install` MUST use `--locked`; `cargo install` is FORBIDDEN in CI
- Rust: 1.95.0, Edition 2024, pinned via `rust-toolchain.toml`

## Documentation: AsciiDoc (.adoc)

- One sentence per line in source, max 80 chars
- Explicit section IDs (kebab-case), never auto-generated
- All code blocks MUST declare their language
- `--failure-level=WARN` on asciidoctor builds
- Vale prose linting at warning level
- `README.md` is generated from `README.adoc` at release (never committed, in `.gitignore`)

## Planned Directory Layout

```
config/
├── nushell/          # ~/.config/nushell/
├── helix/            # ~/.config/helix/
├── starship.toml     # ~/.config/starship.toml
├── zellij/           # ~/.config/zellij/
└── alacritty/        # ~/.config/alacritty/
scripts/
├── dev-setup.nu      # Toolchain installation
└── check-deps.nu     # Env integrity verification
justfile              # Task runner
flake.nix             # Nix flake
```

## Key STANDARDS.adoc References (v2.0.0)

| Part | Topic | Lines |
|---|---|---|
| 0 | Guiding Philosophies | 70–560 |
| 1 | Full Stack Decision & Tool Versions | 561–1130 |
| 2 | Repository Structure | 1131–1432 |
| 3 | Rust Configuration | 1433–1854 |
| 8 | Build System (justfile recipes) | 2671–2850 |
| 9 | AsciiDoc Documentation Standard | 3146–3317 |
| 10 | Version Control (jj workflow) | 3318–3584 |
| 11 | Nushell Configuration & Scripts | 3585–4530 |
