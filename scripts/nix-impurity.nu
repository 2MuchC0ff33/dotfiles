#!/usr/bin/env nu
def main [] {
  let in_nix = ("IN_NIX_SHELL" in $env) or ("NIX_SHELL" in $env)

  if not $in_nix {
    print -e "ERROR: impurity-check must be run inside nix develop."
    exit 1
  }

  print "Running strict impurity check (nix flake check)..."
  nix flake check
  print "Impurity check complete."
}
