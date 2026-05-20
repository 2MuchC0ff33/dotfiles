# Nix Dev Shell (nix develop)

## Description
The `nix develop .` entry point provides a hermetic development shell with all required tools: Rust toolchain, just, zig, asciidoctor, pandoc, and vale. Every project SHALL define its development environment in `flake.nix`.

## When to Load
Load this skill when setting up a project's Nix development shell, adding tools to the dev shell, or onboarding new contributors.

## Source
STANDARDS.adoc §1.5 (lines 932–983), §1.5.1 (lines 941–983), §1.5.4 (lines 1031–1046)

## Key Rules

- **MANDATE**: `nix develop .` SHALL be the single entry point to the development environment.
- **MANDATE**: The dev shell SHALL include `rustToolchain` (from `fenix.fromToolchainFile`).
- **MANDATE**: The dev shell SHALL include `just` (command runner).
- **MANDATE**: The dev shell SHALL include `zig` (cross-compilation linker).
- **MANDATE**: The dev shell SHALL include `asciidoctor`, `pandoc`, and `vale` (documentation tools).
- **MANDATE**: The dev shell SHALL include `cargo-deny` (dependency auditing).
- **SHOULD**: Include additional tooling as needed (e.g., kani, wasm-pack, cargo-zigbuild).
- **FORBIDDEN**: Installing any of these tools outside the Nix sandbox in CI.

## Dev Shell Package Reference

| Package | Source (nixpkgs attribute) | Purpose |
|---|---|---|
| `rustToolchain` | `fenix.fromToolchainFile` | Rust compiler + cargo + clippy + rustfmt + rust-src |
| `just` | `pkgs.just` | Command runner (replaces make) |
| `zig` | `pkgs.zig` | Zig linker for cross-compilation with cargo-zigbuild |
| `asciidoctor` | `pkgs.asciidoctor` | AsciiDoc document build |
| `pandoc` | `pkgs.pandoc` | Document format conversion |
| `vale` | `pkgs.vale` | Prose linter for documentation |
| `cargo-deny` | `pkgs.cargo-deny` | Dependency license/audit checking |

## Dev Shell Definition

```nix
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    rustToolchain
    just
    zig
    asciidoctor
    pandoc
    vale
    cargo-deny
  ];

  # Additional environment variables for the dev shell
  RUSTFLAGS = "-Dwarnings";
  CARGO_NET_OFFLINE = false;  # allow network in dev, forbid in CI
};
```

## Usage

```bash
# Enter the hermetic development shell
nix develop .

# Now available inside the shell:
rustc --version    # 1.95.0 (or pinned version)
just --version
zig version
asciidoctor --version
pandoc --version
vale --version

# Build the project
just check
```

## Related Skills
- [rust-nix-flake-structure](file://.opencode/skills/rust-nix-flake-structure.md)
- [rust-nix-flake-check](file://.opencode/skills/rust-nix-flake-check.md)
- [rust-toolchain-toml](file://.opencode/skills/rust-toolchain-toml.md)
- [rust-flake-lock-committed](file://.opencode/skills/rust-flake-lock-committed.md)
