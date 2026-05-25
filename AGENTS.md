# AGENTS.md — dotfiles (2MuchC0ff33)

## Repo State

- **Active**: dotfiles repo — Nix flake + Nushell config + opencode skills
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

All §1.4.2 tools are provided by the Nix flake (`flake.nix`) using
`pkgsCross.musl64` for static musl binaries. Enter the dev shell:

```
nix develop .
```

Quick install reference for host-only tools (used outside nix develop):

| Tool | Install |
|---|---|
| nu | `cargo install --locked nu` (0.112.2) |
| jj | `cargo install --locked --bin jj jj-cli` (0.41.0) |
| oc | `~/.cargo/bin/oc` (shim — launches opencode via nix develop) |

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

- Hermetic shell: `nix develop .` (uses `muslPkgs.bash` for Alpine compatibility)
- Verify: `nix flake check`
- Build: `nix build .`
- All `cargo install` MUST use `--locked`; `cargo install` is FORBIDDEN in CI
- Rust: 1.95.0, Edition 2024, pinned via fenix overlay in `flake.nix`

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
| 14 | AI Coding Agent Standard (opencode) | 4707 |
| 13 | Project Type Adaptation Guide | 4801 |

## Skills System: `.opencode/skills/`

This repo includes **249 atomic skill files** at
`.opencode/skills/` that opencode agents can load for granular
STANDARDS.adoc adherence. Each skill covers ONE rule/pattern.

## AI Coding Agent: opencode

opencode is the universal AI agent for coding and standards enforcement across all environments governed by this repository. All new agents, agents.json, and configuration must comply with the OpenCode config standard and skill system, as described in STANDARDS.adoc Part 14. See also the global skills in ~/.config/opencode/skills/ for best practices and reusable skill modules for any new project.

### Installation (Nix derivation)

opencode is provided as a local Nix derivation at `nix/opencode.nix`.
It downloads the official `opencode-linux-x64-musl.tar.gz` from GitHub releases
and generates a wrapper script that uses the musl dynamic linker with
`--preload /usr/lib/libucontext.so.1` to fix the `getcontext()` musl
compatibility issue on Alpine Linux.

The derivation produces `$out/bin/opencode` (wrapper script) and
`$out/bin/opencode-real` (the original binary).

The wrapper uses `/lib/ld-musl-x86_64.so.1 --preload` rather than the
`LD_PRELOAD` environment variable. This prevents the preload library
from leaking to child processes spawned by opencode.

### Launcher shim (`~/.cargo/bin/oc`)

The `oc` shim launches opencode via `nix develop --command opencode ...`
to ensure the full Nix devShell environment (PATH, LSP servers, MCP
runtimes) is available to opencode. The nix bash shadowing issue
(see STANDARDS.adoc §1.5.7.1) means the shim should eventually prepend
`/bin` to PATH to guarantee musl bash resolution.

### TUI compatibility (Alpine/musl)

The opencode TUI uses `libopentui.so` which calls `getcontext()` — a glibc function
absent in musl. The Nix wrapper invokes the musl dynamic linker with
`--preload /usr/lib/libucontext.so.1` to provide a compatible implementation.
Unlike `LD_PRELOAD`, this loader-level preload does not leak to child processes.
The wrapper is regenerated on every derivation rebuild and persists across
Nix-managed upgrades.

See `~/projects/personal/opencode/` for the upstream Alpine fix documentation
and test suite (`tests/verify-wrapper.sh`, `tests/verify-tui.sh`, etc.).

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
| **TOTAL** | **250** | | |

Load a skill via the skill tool:

```
skill name="nushell-config-completions-fuzzy"
```

See `.opencode/skills/README.md` for the full registry.

## MCP Servers

opencode integrates with MCP servers for extended capabilities.
All configured in `~/.config/opencode/opencode.json`.
Node.js 22 LTS (npx) is provided by the Nix devShell (`flake.nix`).

| Server | Type | Purpose | API Key Required |
|---|---|---|---|
| context7 | remote | Live library docs — add `use context7` to prompts | No |
| sequential-thinking | local | Structured reasoning chains | No |
| github | local | GitHub repo operations (issues, PRs, search) | Yes — `GITHUB_TOKEN` |
| filesystem | local | File access sandboxed to `~/projects` | No |
| memory | local | Persistent knowledge graph across sessions | No |

### Activating GitHub MCP

1. Generate a fine-grained GitHub personal access token
2. Store it:
   `echo "ghp_..." > ~/.config/secrets/github_token && chmod 600 ~/.config/secrets/github_token`
3. Add to `~/.config/nushell/env.nu`:
   ```nushell
   $env.GITHUB_TOKEN = (open --raw ~/.config/secrets/github_token | str trim)
   ```
4. Set `"enabled": true` for the github server in
   `~/.config/opencode/opencode.json`

### MCP on Alpine/musl

`npx` must be on PATH when opencode starts.
Enter `nix develop` or `just shell` first, OR hardcode the Node.js nix store
path in `env.nu` (see STANDARDS.adoc §14.8.3).

### Known Issues

#### bash tool resolves nix glibc bash instead of musl `/bin/bash`

opencode's built-in bash tool inherits PATH from its parent process.
On Alpine/musl, nix store paths appear early in PATH, so `which bash`
resolves to the nix glibc-linked bash (`/nix/store/.../bin/bash`)
instead of the musl-linked system `/bin/bash`. The nix bash requires
the glibc dynamic linker and fails when spawned outside the full nix
develop environment.

**Status:** Ongoing. The workaround is to ensure `/bin` is prepended
to PATH before launching opencode on Alpine/musl hosts.

See STANDARDS.adoc §1.5.7.1 and §14.12 for full documentation.

#### Subprocess environment hygiene

Environment variables inherited from the opencode process can cause
failures in child processes. The wrapper has been migrated from
`LD_PRELOAD` to musl ld `--preload` to prevent leakage, but other
variables (PATH, LD_LIBRARY_PATH) can still cause issues depending
on the execution context.

**Defense-in-depth measures** (retained from the earlier LD_PRELOAD fix):
- `flake.nix` shellHook: `unset LD_PRELOAD`
- `config/nushell/env.nu`: `hide-env LD_PRELOAD`
- `~/.profile`: `unset LD_PRELOAD`

If nix glibc binaries fail with `libc.musl-x86_64.so.1: not found`:
```sh
unset LD_PRELOAD
```

### Key STANDARDS.adoc References

| Part | Topic |
|---|---|---|
| §14.8 | MCP server configuration and activation |
| §14.9 | LSP Server configuration |
| §14.10 | Formatter configuration |
| §14.12 | Shell tool compatibility & subprocess environment sanitization |
| §1.5.7 | Alpine/musl nix store path hardcoding |
| §1.5.7.1 | bash PATH conflict on Alpine/musl |

## LSP Servers

opencode supports Language Server Protocol (LSP) servers for language-aware editing.
Configured in `~/.config/opencode/opencode.json` under the `"lsp"` key.

| Server | Command | File Types | Source |
|---|---|---|---|
| rust-analyzer | `["rust-analyzer"]` | `.rs` | rustup component |
| Nu LSP | `["nu", "--lsp"]` | `.nu` | Nushell binary (Nix devShell) |
| Taplo | `["taplo", "lsp", "stdio"]` | `.toml` | `cargo install taplo-cli --features lsp` |
| nixd | `["nixd"]` | `.nix` | `pkgs.nixd` in flake |

Canonical reference: STANDARDS.adoc §14.9.

## Formatters

opencode supports auto-formatting via configurable formatter commands.
Configured in `~/.config/opencode/opencode.json` under the `"formatter"` key.

| Formatter | Command | File Types | Source |
|---|---|---|---|
| rustfmt | `["rustfmt", "--edition", "2024"]` | `.rs` | rustup component |
| Taplo | `["taplo", "format"]` | `.toml` | `cargo install taplo-cli` |
| Topiary (Nushell) | `["topiary", "format", "--language", "nu"]` | `.nu` | `pkgs.topiary` in flake |
| nixfmt | `["nixfmt"]` | `.nix` | `pkgs.nixfmt` in flake |

Canonical reference: STANDARDS.adoc §14.10.

## Linters

| Linter | Target | Command | Source |
|---|---|---|---|
| Clippy | Rust | `cargo clippy --all-targets --all-features -- -Dwarnings` | rustup component |
| nu-lint | Nushell | `nu-lint` | `cargo install --locked nu-lint` |
| Vale | AsciiDoc | `vale` | `pkgs.vale` in flake |
