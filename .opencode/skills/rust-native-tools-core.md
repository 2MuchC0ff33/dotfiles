# Rust-Native Core Tool Replacements

## Description
Core development tool replacements: ripgrep→grep, fd→find, bat→cat, sd→sed, delta→diff, eza→ls, dust→du, procs→ps, bottom→top. All installed via `cargo install --locked`.

## When to Load
Load this skill when setting up a new development machine, configuring the developer environment, or evaluating tool choices.

## Source
STANDARDS.adoc §1.4.2 (lines 752–812), §1.4.4 (lines 849–867)

## Key Rules

- **MANDATE**: All development environment tools SHALL be Rust-native replacements wherever possible.
- **MANDATE**: ALL tools SHALL be installed via `cargo install --locked`.
- **SHOULD**: Prepend `~/.cargo/bin` to PATH before `/bin` or `/usr/bin`.
- **SHOULD**: Start with the essential short list (rg, fd, bat, eza, zoxide, btm, delta, sd).
- **FORBIDDEN**: System package managers (`apt`, `brew`) for these tools.

## Replacement Table

| Rust Tool | Replaces | Install | Drop-in? |
|---|---|---|---|
| **ripgrep** (`rg`) | `grep` / `ag` | `cargo install --locked ripgrep` | Full |
| **fd** (`fd`) | `find` | `cargo install --locked fd-find` | Full |
| **bat** (`bat`) | `cat` / `less` | `cargo install --locked bat` | Full |
| **sd** (`sd`) | `sed` | `cargo install --locked sd` | Full |
| **delta** (`delta`) | `diff` | `cargo install --locked git-delta` | Full |
| **eza** (`eza`) | `ls` | `cargo install --locked eza` | Full |
| **dust** (`dust`) | `du` | `cargo install --locked dust` | Full |
| **procs** (`procs`) | `ps` | `cargo install --locked procs` | Full |
| **bottom** (`btm`) | `top` / `htop` | `cargo install --locked bottom` | Full |

## Essential Short List

If setting up a new machine with minimal tools:

```
ripgrep   → grep     (single biggest quality-of-life improvement)
fd        → find     (faster, simpler, git-aware)
bat       → cat      (syntax highlighting alone is worth it)
eza       → ls       (color, icons, permissions readable)
zoxide    → cd       (never type a full path again)
bottom    → htop     (better graphs, mouse support)
delta     → diff     (git diff becomes beautiful)
sd        → sed      (simple find-and-replace, regex consistent)
```

## Rationale for Rust-Native Tools

| Reason | Explanation |
|---|---|
| No C toolchain needed | Every Rust tool installs via `cargo install --locked`. No `apt`/`brew`/`yum` for C libraries. |
| Cross-platform identical | Same tool, same behavior on Linux, macOS, Windows. No GNU vs BSD grep differences. |
| Memory safe | All tools written in safe Rust. No buffer overflows in your development pipeline. |
| Faster in practice | ripgrep beats grep by 5-10x on large codebases. fd beats find by 3-5x. |
| Single upgrade path | `cargo install --locked <tool>` updates everything. No mixing apt/homebrew/cargo/gem/pip. |
| Works offline after install | No runtime dependencies fetched from the internet. |

## Related Skills
- [rust-native-tools-utilities](file://.opencode/skills/rust-native-tools-utilities.md)
- [rust-native-tools-terminal](file://.opencode/skills/rust-native-tools-terminal.md)
- [rust-cargo-install-locked](file://.opencode/skills/rust-cargo-install-locked.md)
