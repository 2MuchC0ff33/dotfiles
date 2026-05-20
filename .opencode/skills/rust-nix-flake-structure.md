# Nix Flake Structure (flake.nix)

## Description
Standard `flake.nix` structure for all Rust projects: hermetic development environment with nixpkgs, fenix (toolchain), crane (build), and flake-utils. Every project SHALL provide a `flake.nix` at repository root.

## When to Load
Load this skill when initializing a new project's Nix flake, setting up a hermetic build environment, or reviewing a flake.nix for correctness.

## Source
STANDARDS.adoc §1.2 (lines 649–655), §1.5 (lines 933–983), §1.5.1 (lines 941–983)

## Key Rules

- **MANDATE**: Every project SHALL provide a `flake.nix` at repository root.
- **MANDATE**: Every project SHALL pin ALL tool versions via Nix flakes.
- **MANDATE**: `flake.nix` SHALL use `fenix.fromToolchainFile` to read `rust-toolchain.toml`.
- **MANDATE**: `flake.nix` SHALL use `crane.mkLib` for Rust building.
- **MANDATE**: `flake.nix` SHALL provide a `devShells.default` for `nix develop .`.
- **MANDATE**: Inputs: `nixpkgs`, `fenix`, `crane`, `flake-utils`.
- **SHOULD**: Fenix and crane inputs SHALL follow nixpkgs (`inputs.fenix.inputs.nixpkgs.follows = "nixpkgs"`).

## flake.nix Template

```nix
{
  description = "project — hermetic dev environment";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-unstable";
    fenix.url         = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    crane.url         = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url   = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, fenix, crane, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fenix.overlays.default ];
        };

        rustToolchain = pkgs.fenix.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "0000000000000000000000000000000000000000000000000000";
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;
      in {
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
        };
      });
}
```

## Building with Crane

For production builds in CI, extend the outputs with `craneLib.buildPackage`:

```nix
packages.default = craneLib.buildPackage {
  src = craneLib.cleanCargoSource ./.;
  # crane automatically uses the Cargo.lock and rust-toolchain.toml
};
```

## Design Decisions

| Input | Purpose | Tracking |
|---|---|---|
| `nixpkgs` | System packages (zig, asciidoctor, etc.) | `nixos-unstable` branch |
| `fenix` | Rust toolchain from `rust-toolchain.toml` | Latest fenix revision |
| `crane` | Build Rust crates in Nix sandbox | Latest crane revision |
| `flake-utils` | `eachDefaultSystem` helper | Latest flake-utils revision |

All revisions are pinned in `flake.lock` — the merkle root of the environment.

## Related Skills
- [rust-nix-dev-shell](file://.opencode/skills/rust-nix-dev-shell.md)
- [rust-nix-flake-check](file://.opencode/skills/rust-nix-flake-check.md)
- [rust-toolchain-toml](file://.opencode/skills/rust-toolchain-toml.md)
- [rust-flake-lock-committed](file://.opencode/skills/rust-flake-lock-committed.md)
