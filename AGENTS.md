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
| Start work | `jj new [BOOKMARK]` | Creates change on top of `@` |
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

Canonical reference: **STANDARDS.adoc §1.4.2 and Appendix C**.

Install all tools with `--locked`. Quick install reference:

| Tool | Install |
|---|---|
| ripgrep | `cargo install --locked ripgrep` |
| fd | `cargo install --locked fd-find` |
| bat | `cargo install --locked bat` |
| sd | `cargo install --locked sd` |
| delta | `cargo install --locked git-delta` |
| eza | `cargo install --locked eza` |
| dust | `cargo install --locked du-dust` |
| procs | `cargo install --locked procs` |
| bottom | `cargo install --locked bottom` |
| zoxide | `cargo install --locked zoxide` |
| xh | `cargo install --locked xh` |
| just | `cargo install --locked just` |
| zellij | `cargo install --locked zellij` |
| helix | `cargo install --locked helix` |
| jj | `cargo install --locked --bin jj jj-cli` |

## Shell: Nushell (0.112.2)

> **Privilege escalation**: This system uses `doas` not `sudo`.
> Never use `sudo` on this system. Always use `doas <command>`.

Full alias list: **STANDARDS.adoc §11.1**.

Project-specific aliases (add to `config.nu`):

```nushell
alias c   = cargo
alias cxt = cargo xtask
alias j   = just
```

Key settings: fuzzy completions, sqlite history (100k), rounded tables,
OSC 2/7/133 shell integration. `$env.EDITOR = "hx"`,
`$env.PROPTEST_CASES = "100000"`, `$env.RUSTFLAGS = "-Dwarnings"`.
Prompt: Starship.

## Editor: Helix (25.07.1)

- Config: `config/helix/{config.toml,languages.toml}` → `~/.config/helix/`
- No plugin system (by design)

## Build System: just + cargo xtask

- `just` = thin wrapper for discoverability, `cargo xtask` = complex Rust automation
- Canonical source: **STANDARDS.adoc §8.1**. Agent quick-reference below.
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
| 14 | AI Coding Agent Standard (opencode) | 4629 |

## Skills System: `.opencode/skills/`

This repo includes **249 atomic skill files** at
`.opencode/skills/` that opencode agents can load for granular
STANDARDS.adoc adherence. Each skill covers ONE rule/pattern.

## AI Coding Agent: opencode

opencode is the universal AI agent for coding and standards enforcement across all environments governed by this repository. All new agents, agents.json, and configuration must comply with the OpenCode config standard and skill system, as described in STANDARDS.adoc Part 14. See also the global skills in ~/.config/opencode/skills/ for best practices and reusable skill modules for any new project.

| Category | Skills | Prefix | Use When... |
|---|---|---|---|
| Nushell Config | 43 | `nushell-config-*`, `nushell-alias-*`, `nushell-env-*`, `nushell-starship-*` | Writing/editing `config.nu`, setting aliases, env vars |
| Nushell Naming | 9 | `nushell-naming-*` | Naming commands, variables, files |
| Nushell Formatting | 7 | `nushell-formatting-*` | Formatting `.nu` files |
| Nushell Strings | 3 | `nushell-strings-*` | String literal formatting |
| Nushell Types | 6 | `nushell-types-*` | Type annotations, I/O sigs |
| Nushell Pipelines | 6 | `nushell-pipeline-*` | Pipeline patterns |
| Nushell Modules | 7 | `nushell-module-*` | Module exports, imports |
| Nushell Errors | 6 | `nushell-errors-*` | Error handling patterns |
| Nushell Security | 9 | `nushell-security-*` | Security best practices |
| Nushell Anti-patterns | 23 | `nushell-antipattern-*` | Avoiding forbidden patterns |
| Nushell Performance | 6 | `nushell-performance-*` | Performance patterns |
| Nushell Linting | 5 | `nushell-linting-*` | nu-lint configuration |
| Nushell Testing | 5 | `nushell-testing-*` | Test patterns |
| jj VCS | 25 | `jj-*` | Version control with jj |
| AsciiDoc Docs | 17 | `asciidoc-*` | Writing `.adoc` docs |
| justfile Recipes | 18 | `just-recipe-*` | Build system recipes |
| xtask | 5 | `xtask-*` | Rust build automation |
| Rust/2024 Edition | 6 | `rust-unsafe-*`, `rust-edition-*`, `rust-cfg-*` | Rust 2024 edition syntax |
| Cargo Config | 4 | `rust-cargo-*` | Cargo.toml, config.toml |
| Nix Flakes | 3 | `rust-nix-*` | Nix environment |
| Toolchain | 3 | `rust-toolchain-*`, `rust-cargo-install-*`, `rust-flake-*` | Tool version pinning |
| Rust Native Tools | 3 | `rust-native-tools-*` | Tool replacement mapping |
| Directory Layout | 5 | `standards-directory-*`, `standards-git*` | Repo structure |
| Suckless Code | 9 | `standards-suckless-*` | Code design rules |
| Proof Tiers | 5 | `standards-proof-tier-*` | Proof annotations |
| Error Taxonomy | 6 | `standards-error-*` | Error type design |
| Formal Verification | 5 | `standards-proof-*` | Kani/proptest/fuzz |
| **TOTAL** | **249** | | |

Load a skill via the skill tool:

```
skill name="nushell-config-completions-fuzzy"
```

See `.opencode/skills/README.md` for the full registry.
