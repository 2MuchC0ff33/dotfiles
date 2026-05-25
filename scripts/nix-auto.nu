#!/usr/bin/env nu
def main [cmd: string] {
  let in_nix = ("IN_NIX_SHELL" in $env) or ("NIX_SHELL" in $env)

  if not $in_nix {
    print -e "Not inside nix develop. Auto-entering Nix environment."
    exec nix develop --command nu -c $cmd
  }
  exec nu -c $cmd
}
