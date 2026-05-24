#!/usr/bin/env nu
# dev-setup.nu
# Sets up the hermetic development environment via Nix.
# Primary check: confirms Nix is installed and flake inputs are current.
# Note: On Alpine/musl, interactive 'nix develop' is blocked (glibc bash).
# Use 'nix develop --command <cmd>' or host tools directly.

def main []: nothing -> nothing {
    print "Setting up development environment via Nix..."

    let nix_check = (^which nix o+e>| complete)
    if $nix_check.exit_code != 0 {
        print $"(ansi red)Nix not found.(ansi reset)"
        print "Install Nix on Alpine:"
        print "  doas apk add nix"
        print "See: https://nixos.org/download"
        error make {msg: "Nix not installed — cannot proceed"}
    }

    let nix_version = (^nix --version | str trim)
    print $"Nix found: ($nix_version)"

    print "Verifying flake integrity..."
    let check_result = (^nix flake check --no-build o+e>| complete)
    if $check_result.exit_code != 0 {
        print $"(ansi yellow)Warning: nix flake check failed:(ansi reset)"
        print $check_result.stderr
        print "Environment may need attention — continuing anyway."
    } else {
        print $"(ansi green)nix flake check: PASS(ansi reset)"
    }

    print ""
    print $"(ansi green)Development environment ready.(ansi reset)"
    print ""
    print "Run commands via nix develop:"
    print "  nix develop --command <cmd>"
    print "  nix develop --command /bin/sh"
    print ""
    print "Or use host tools directly (cargo-installed, until P10 decommission)."
}
