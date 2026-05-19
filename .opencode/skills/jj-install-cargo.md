# jj-install-cargo

## Description
Install Jujutsu (jj) via `cargo install --locked jujutsu` at version 0.41.0 (May 2026).

## When to Load
Load this skill when setting up a new development environment, adding jj to CI, or verifying the installed jj version matches the pinned standard.

## Source
STANDARDS.adoc §10.2.1 (lines 3353–3358)

## Key Rules

- MANDATE: Install jj via `cargo install --locked jujutsu` — the `--locked` flag ensures the `Cargo.lock` from the jujutsu repository is used, producing deterministic, reproducible builds.
- MANDATE: Pinned version is 0.41.0 (May 2026). If a newer version is desired, update the pin in STANDARDS.adoc Part 10 first.
- MANDATE: In CI environments, `cargo install` is FORBIDDEN — use a pinned Nix derivation or pre-built binary instead.
- SHOULD: Use `cargo install --locked --version 0.41.0 jujutsu` to explicitly request the pinned version.
- SHOULD: Verify installation with `jj --version` after install.

## Example

```bash
# Install pinned version
cargo install --locked jujutsu

# Verify
jj --version
# Output: jujutsu 0.41.0

# Install explicit version pin (alternative)
cargo install --locked --version 0.41.0 jujutsu
```

## Rationale

`cargo install --locked` is the standard's approved installation method for all Rust tools (see STANDARDS.adoc §1.4 Rust-native). The `--locked` flag is non-negotiable — it prevents upstream dependency changes from producing a different binary than what was tested. In Nix-based environments, use `nix build .#jj` instead, which pulls from the flake's pinned jujutsu derivation.

## Related Skills
- [jj-init-colocate](file://.opencode/skills/jj-init-colocate.md)
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
