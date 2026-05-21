---
name: rust-cargo-install-locked
description: Description
compatibility: opencode
---

# cargo install --locked

## Description
ALL `cargo install` invocations SHALL use `--locked` to prevent dependency resolution drift. `cargo install` is FORBIDDEN in CI — CI builds happen inside the Nix sandbox.

## When to Load
Load this skill when installing Rust tooling locally, writing CI configuration, or auditing dependency management.

## Source
STANDARDS.adoc §1.2 (lines 670–672)

## Key Rules

- **MANDATE**: ALL `cargo install` SHALL use `--locked`.
- **MANDATE**: `cargo install` is FORBIDDEN in CI — CI builds happen inside Nix sandbox.
- **SHOULD**: Use `cargo install --locked <tool>` for local development tool installation.
- **FORBIDDEN**: `cargo install` without `--locked` — this silently upgrades dependencies to latest semver-compatible versions, breaking reproducibility.

## Rationale

Without `--locked`, `cargo install` fetches the latest semver-compatible versions of all transitive dependencies at install time. Two developers installing the same tool on different days may get different binaries. `--locked` forces Cargo to use the lockfile from the published crate, ensuring bit-for-bit identical installs.

In CI, Nix sandbox replaces `cargo install` entirely. The Nix derivation pins every transitive dependency in `flake.lock`, `Cargo.lock`, and `rust-toolchain.toml`. This is more hermetic than `--locked` alone because it also pins system dependencies (glibc, openssl, etc.).

## Example

```bash
# ✅ CORRECT: Always use --locked
cargo install --locked ripgrep
cargo install --locked fd-find
cargo install --locked bat
cargo install --locked sd
cargo install --locked eza
cargo install --locked jujutsu
cargo install --locked helix

# ❌ WRONG: No --locked
cargo install ripgrep
```

## CI: Use Nix, Not cargo install

```nix
# ✅ CORRECT: Tools come from nixpkgs in the Nix sandbox
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    rustToolchain    # from fenix + rust-toolchain.toml
    just
    zig
    asciidoctor
  ];
};
```

```yaml
# ❌ WRONG: CI using cargo install
- run: cargo install --locked just
- run: cargo install --locked asciidoctor
```

```yaml
# ✅ CORRECT: CI using Nix
- run: nix develop . -c just check
```

## Related Skills
- [rust-nix-flake-structure](file://.opencode/skills/rust-nix-flake-structure.md)
- [rust-nix-dev-shell](file://.opencode/skills/rust-nix-dev-shell.md)
- [rust-nix-flake-check](file://.opencode/skills/rust-nix-flake-check.md)
- [rust-flake-lock-committed](file://.opencode/skills/rust-flake-lock-committed.md)
