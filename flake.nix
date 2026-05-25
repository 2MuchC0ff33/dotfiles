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
        muslPkgs    = pkgs.pkgsCross.musl64;

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
            toolchain
            muslPkgs.bash
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
            muslPkgs.just
            muslPkgs.jujutsu
            (muslPkgs.nushell.override { withDefaultFeatures = false; })
            muslPkgs.starship
            pkgs.zellij
            pkgs.helix
            pkgs.asciidoctor
            opencode
<<<<<<< conflict 1 of 1
+++++++ xrsoxtns 32b05cb1 (rebased revision)
            pkgs.nodejs_22
            pkgs.uv
            pkgs.vale
            pkgs.nixd
            pkgs.nixfmt
            pkgs.topiary
            pkgs.ouch
            pkgs.hyperfine
            pkgs.tokei
            pkgs.doggo
            pkgs.gping
            pkgs.bandwhich
%%%%%%% diff from: kulvnuyz bd32f56b "feat(mcp): add Node.js + uv to Nix devShell, configure MCP servers" (rebased revision)
\\\\\\\        to: nwpwoxut 00cc16a7 "fix(p14): complete migration cleanup" (parents of rebased revision)
-
-            # MCP server runtime — Node.js 22 LTS (provides node + npx + npm)
-            pkgs.nodejs_22
-            pkgs.uv
>>>>>>> conflict 1 of 1 ends
          ];

          shellHook = ''
            export SHELL=/bin/ash
            export EDITOR=hx
            export VISUAL=hx
            export CARGO_BUILD_JOBS=1
            export RUSTFLAGS="-Dwarnings"
            export CARGO_TERM_COLOR=always
            export PROPTEST_CASES=100000
            echo "Dev environment ready — $(nix --version)"
          '';
        };
      });
}
