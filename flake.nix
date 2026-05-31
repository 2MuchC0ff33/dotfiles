{
  description = "dotfiles — hermetic dev environment";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-unstable";
    fenix.url         = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    crane.url         = "github:ipetkov/crane";
    flake-utils.url   = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, fenix, crane, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs        = nixpkgs.legacyPackages.${system};
        # pkgsCross.musl64 produces genuine musl-linked binaries that run on Alpine.
        # pkgsStatic on x86_64-linux produces glibc-static (unusable on musl hosts).
        muslPkgs  = pkgs.pkgsCross.musl64;

        # Rolling nightly — used for devShell, rust-analyzer, Verus, general Rust dev
        rustToolchain = fenix.packages.${system}.toolchainOf {
          channel = "nightly";
          sha256 = "3255a1de36261ef30644bae1034dae04d15410115a4c4ca45b11621b62965c27";
        };

        toolchain = fenix.packages.${system}.combine [
          rustToolchain.rustc
          rustToolchain.cargo
          rustToolchain.clippy
          rustToolchain.rustfmt
          rustToolchain.rust-src
          rustToolchain.miri
          rustToolchain.rust-analyzer
          rustToolchain.rustc-dev
          rustToolchain.llvm-tools
        ];

        rustPlatform' = pkgs.makeRustPlatform {
          rustc = toolchain;
          cargo = toolchain;
        };

        # MIRAI — endorlabs fork, pinned nightly-2025-01-10
        miraiToolchain = fenix.packages.${system}.toolchainOf {
          channel = "nightly";
          date = "2025-01-10";
          sha256 = "6Lr3C/vgpFDCbiWJA8f1T5ej34adrbYeEVW+mAx2qxM=";
        };

        miraiToolchainCombined = fenix.packages.${system}.combine [
          miraiToolchain.rustc
          miraiToolchain.cargo
          miraiToolchain.rust-src
          miraiToolchain.rustc-dev
        ];

        miraiRustPlatform = pkgs.makeRustPlatform {
          rustc = miraiToolchainCombined;
          cargo = miraiToolchainCombined;
        };

        # Verus — stable 1.95.0 (see nix/verus-rust-toolchain.toml)
        verusToolchain = fenix.packages.${system}.fromToolchainFile {
          file = ./nix/verus-rust-toolchain.toml;
          sha256 = "sha256-gh/xTkxKHL4eiRXzWv8KP7vfjSk61Iq48x47BEDFgfk=";
        };

        # Creusot — pinned nightly-2026-02-27
        creusotToolchain = fenix.packages.${system}.toolchainOf {
          channel = "nightly";
          date = "2026-02-27";
          sha256 = "sha256-5twI9QsrPl0ryOZ4POGYAivSeI08jgmWnv0wVvzbjcE=";
        };

        creusotToolchainCombined = fenix.packages.${system}.combine [
          creusotToolchain.rustc
          creusotToolchain.cargo
          creusotToolchain.rust-src
          creusotToolchain.rustc-dev
        ];

        creusotRustPlatform = pkgs.makeRustPlatform {
          rustc = creusotToolchainCombined;
          cargo = creusotToolchainCombined;
        };

        # Z3 4.12.5 — Verus pins this exact version for solver compatibility
        z3-4125 = pkgs.callPackage ./nix/z3-4125.nix {};

        opencode = pkgs.callPackage ./nix/opencode.nix {};
        zellij   = pkgs.callPackage ./nix/zellij.nix {};

        verus = pkgs.callPackage ./nix/verus.nix {
          toolchain = verusToolchain;
          z3 = z3-4125;
        };

        mirai = pkgs.callPackage ./nix/mirai.nix {
          rustPlatform = miraiRustPlatform;
          toolchain = miraiToolchainCombined;
        };

        creusot = pkgs.callPackage ./nix/creusot.nix {
          rustPlatform = creusotRustPlatform;
          toolchain = creusotToolchainCombined;
        };

        in {
        packages.opencode = opencode;
        packages.default = opencode;
        packages.z3-4125 = z3-4125;
        packages.verus = verus;
        packages.cargo-mirai = mirai;
        packages.creusot = creusot;
        packages.kani = pkgs.callPackage ./nix/kani.nix {
          inherit fenix system;
        };

        devShells.default = pkgs.mkShell {
          name = "dotfiles-dev";
          packages = [
            # Rust toolchain — fenix rolling nightly, musl-targeted
            toolchain

            # Static musl bash — enables nix shell entry on Alpine/musl
            muslPkgs.bash

            # CLI replacements — STANDARDS.adoc §1.4.2
            # All static (musl) — run natively on Alpine without glibc
            muslPkgs.ripgrep
            muslPkgs.fd
            muslPkgs.bat
            muslPkgs.sd
            muslPkgs.delta
            muslPkgs.eza
            muslPkgs.dust
            muslPkgs.procs
            muslPkgs.bottom
            muslPkgs.zoxide
            muslPkgs.xh
            muslPkgs.hyperfine
            muslPkgs.tokei
            muslPkgs.just
            muslPkgs.jujutsu
            (muslPkgs.nushell.override { withDefaultFeatures = false; })
            muslPkgs.starship
            zellij
            pkgs.helix

            # Documentation — use pkgs (not static musl)
            pkgs.asciidoctor
            pkgs.pandoc

            # AI coding agent — replaces ~/.opencode/bin shim
            opencode

            # MCP server runtime — Node.js 22 LTS (provides node + npx + npm)
            pkgs.nodejs_22
            pkgs.uv
            
            # Cargo helpers — dependency management, sorting, verification
            pkgs.cargo-deny
            pkgs.cargo-sort
            pkgs.z3
            verus
            mirai
            creusot
            pkgs.cargo-fuzz
            pkgs.cargo-audit
            pkgs.cargo-machete
            # kani from packages output — pre-built binary + autoPatchelfHook
            self.packages.${system}.kani
            # Layer 5: Kani model checking — mandatory STANDARDS.adoc §0.3.1
            pkgs.cargo-zigbuild
            pkgs.zig
            pkgs.upx

            # LSP/Formatter/Linter tools (AI agent §14.9–§14.10)
            pkgs.vale
            pkgs.nixd
            pkgs.nixfmt
            pkgs.topiary
            pkgs.taplo
          ];

          shellHook = ''
            unset LD_PRELOAD
            export SHELL=/bin/ash
            export PATH=$PATH
            # opencode provided by Nix derivation (nix/opencode.nix) — see packages
            export EDITOR=hx
            export VISUAL=hx
            export RUSTFLAGS="-Dwarnings"
            export CARGO_TERM_COLOR=always
            export PROPTEST_CASES=100000
            if [ -t 1 ]; then
                echo "--- dotfiles hermetic dev environment ---"
                echo "nixpkgs rev: ${self.inputs.nixpkgs.rev or "unknown"}"
                echo "Nix: $(nix --version)"
                echo "Rust: $(rustc --version)  Cargo: $(cargo --version | head -1)"
                echo "Just: $(just --version 2>/dev/null || echo 'n/a')"
                echo "Nu: $(nu --version 2>/dev/null || echo 'n/a')"
                echo "Helix: $(hx --version 2>/dev/null | head -1 || echo 'n/a')"
                echo "Asciidoctor: $(asciidoctor --version 2>/dev/null | head -1 || echo 'n/a')"
                echo "------------------------------------------------"
            fi
          '';
        };
      });
}
