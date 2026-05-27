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

        rustToolchain = fenix.packages.${system}.toolchainOf {
          channel = "1.95.0";
          
          sha256  = "sha256-gh/xTkxKHL4eiRXzWv8KP7vfjSk61Iq48x47BEDFgfk=";
        };

        toolchain = fenix.packages.${system}.combine [
          rustToolchain.rustc
          rustToolchain.cargo
          rustToolchain.clippy
          rustToolchain.rustfmt
          rustToolchain.rust-src
        ];

        opencode = pkgs.callPackage ./nix/opencode.nix {};

      in {
        packages.opencode = opencode;
        packages.default = opencode;
        devShells.default = pkgs.mkShell {
          name = "dotfiles-dev";
          packages = [
            # Rust toolchain — fenix 1.95.0, musl-targeted
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
            pkgs.zellij
            pkgs.helix

            # Documentation — Ruby interpreter, use pkgs (not static)
            pkgs.asciidoctor

            # AI coding agent — replaces ~/.opencode/bin shim
            opencode

            # MCP server runtime — Node.js 22 LTS (provides node + npx + npm)
            pkgs.nodejs_22
             pkgs.uv

             # LSP/Formatter/Linter tools (AI agent §14.9–14.10)
             pkgs.vale
             pkgs.nixd
             pkgs.nixfmt
             pkgs.topiary
           ];

          shellHook = ''
            unset LD_PRELOAD
            export SHELL=/bin/ash
            export http_proxy=http://127.0.0.1:3128
            export https_proxy=http://127.0.0.1:3128
            export HTTP_PROXY=http://127.0.0.1:3128
            export HTTPS_PROXY=http://127.0.0.1:3128
            export PATH=$PATH
            # opencode provided by Nix derivation (nix/opencode.nix) — see packages
            export EDITOR=hx
            export VISUAL=hx
            export RUSTFLAGS="-Dwarnings"
            export CARGO_TERM_COLOR=always
            export PROPTEST_CASES=100000
            echo "--- dotfiles hermetic dev environment ---"
           echo "nixpkgs rev: ${self.inputs.nixpkgs.rev or "unknown"}"
           echo "Nix: $(nix --version)"
           echo "Rust: $(rustc --version)  Cargo: $(cargo --version | head -1)"
           echo "Just: $(just --version 2>/dev/null || echo 'n/a')"
           echo "Nu: $(nu --version 2>/dev/null || echo 'n/a')"
           echo "Helix: $(hx --version 2>/dev/null | head -1 || echo 'n/a')"
           echo "Asciidoctor: $(asciidoctor --version 2>/dev/null | head -1 || echo 'n/a')"
           echo "------------------------------------------------"
          '';
        };
      });
}
