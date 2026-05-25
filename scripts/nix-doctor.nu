#!/usr/bin/env nu
def main [] {
  let in_nix = ("IN_NIX_SHELL" in $env) or ("NIX_SHELL" in $env)

  if not $in_nix {
    print -e "ERROR: doctor must be run inside nix develop. Run nix develop first."
    exit 1
  }

  print "Running hermetic environment checks..."
  print $"Nix info: (nix --version)"
  print $"Rust: (rustc --version)  Cargo: (cargo --version | lines | first)"

  print "Checking for non-nix install hints..."
  rg -n --hidden "cargo install|pip install|apt-get|curl .* | bash" -S . | ignore
  if $env.LAST_EXIT_CODE == 0 {
    print -e "WARNING: probable non-Nix install invocation found."
  }

  print "Running nix flake check..."
  nix flake check
  print "Doctor completed."
}
