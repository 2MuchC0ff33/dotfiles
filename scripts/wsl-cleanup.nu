#!/usr/bin/env nu
# scripts/wsl-cleanup.nu
# WSL2 housekeeping — Nix GC, cargo cache, rust target dirs, tmp.
# Run from ~/projects/personal/dotfiles via:
#   just wsl-status
#   just wsl-clean
#
# [LINTED] Standard nu-lint rules apply.

const RUST_TARGETS: list<string> = [
    "/home/galloa/projects/work/elvis-rust/rust/target"
]

const TMP_PATTERNS: list<string> = [
    "cargo-*"
    "kani-*"
    "cbmc-*"
    "miri-*"
    "mirai-*"
    "verus-*"
    "proptest-*"
    ".tmp*"
    ".xargo*"
]

def main [command: string = "status"]: nothing -> nothing {
    match $command {
        "status"       => cmd-status
        "clean"        => cmd-clean
        "compact-hint" => cmd-compact-hint
        _              => {
            print "Usage: nu scripts/wsl-cleanup.nu <status|clean|compact-hint>"
            error make {msg: $"Unknown command: ($command)"}
        }
    }
}

def cmd-status []: nothing -> nothing {
    print "=== WSL2 Disk Status ==="
    print ""

    print "── Filesystem ──"
    ^df -h / | lines | each {|l| print $l }
    print ""

    let nix_size = (^du -sh /nix/store 2>/dev/null | str trim | split column "\t" size path | get size | first | default "?")
    print $"Nix store:    ($nix_size)"

    let nix_count = (^ls /nix/store 2>/dev/null | lines | length)
    print $"Nix paths:    ($nix_count)"

    let cargo_size = (^du -sh /home/galloa/.cargo 2>/dev/null | str trim | split column "\t" size path | get size | first | default "?")
    print $"Cargo home:   ($cargo_size)"

    print ""
    print "── Rust target/ dirs ──"
    for dir in $RUST_TARGETS {
        if ($dir | path exists) {
            let sz = (^du -sh $dir 2>/dev/null | str trim | split column "\t" size path | get size | first | default "?")
            print $"  ($sz)  ($dir)"
        } else {
            print $"  (absent)  ($dir)"
        }
    }

    let tmp_size = (^du -sh /tmp 2>/dev/null | str trim | split column "\t" size path | get size | first | default "?")
    print ""
    print $"Tmp:          ($tmp_size)"

    print ""
    print "Run 'just wsl-clean' to free space."
}

def cmd-clean []: nothing -> nothing {
    print "=== WSL2 Cleanup ==="
    print ""

    let before = (df-avail-gb)
    print $"Disk available before: ($before) GB"
    print ""

    print "── Step 1/4: Nix store garbage collection ──"
    let nix_result = (^doas nix-collect-garbage -d o+e>| complete)
    if $nix_result.exit_code != 0 {
        print $"WARNING: nix-collect-garbage exited ($nix_result.exit_code)"
        print $nix_result.stderr
    } else {
        print "Nix GC: OK"
    }
    print ""

    print "── Step 2/4: Cargo cache autoclean ──"
    let cargo_result = (^cargo cache --autoclean o+e>| complete)
    if $cargo_result.exit_code != 0 {
        print "WARNING: cargo cache --autoclean failed or not installed"
        print "Falling back to manual cargo registry/git cleanup..."
        rm -rf /home/galloa/.cargo/registry/src
        rm -rf /home/galloa/.cargo/registry/cache
        rm -rf /home/galloa/.cargo/git
        print "Manual cargo cache cleanup: OK"
    } else {
        print "Cargo cache: OK"
    }
    print ""

    print "── Step 3/4: Rust target/ directories ──"
    for dir in $RUST_TARGETS {
        if ($dir | path exists) {
            let sz = (^du -sh $dir 2>/dev/null | str trim | split column "\t" size path | get size | first | default "?")
            print $"  Removing ($sz) at ($dir)..."
            ^doas rm -rf $dir
            print $"  ($dir): removed"
        } else {
            print $"  ($dir): already absent"
        }
    }
    print ""

    print "── Step 4/4: /tmp build artifacts ──"
    for pattern in $TMP_PATTERNS {
        ^doas find /tmp -maxdepth 1 -name $pattern -exec rm -rf {} + 2>/dev/null
    }
    print "/tmp build artifacts: OK"
    print ""

    let after = (df-avail-gb)
    let freed = ($after - $before | math round --precision 1)
    print $"Disk available after:  ($after) GB"
    print $"Freed:                 ($freed) GB"
    print ""
    print "=== Cleanup complete ==="
    print "Run 'just wsl-compact-hint' for instructions to shrink the .vhdx on Windows."
}

def cmd-compact-hint []: nothing -> nothing {
    print "=== Compact the WSL2 .vhdx (run from Windows PowerShell) ==="
    print ""
    print "Step 1 — Shut down WSL2:"
    print "  wsl --shutdown"
    print ""
    print "Step 2 — Find the vhdx path:"
    print '  Get-ChildItem "$env:LOCALAPPDATA\Packages" -Recurse -Filter "ext4.vhdx" |'
    print '    Select-Object FullName, @{N="GB";E={[math]::Round($_.Length/1GB,2)}}'
    print ""
    print "Step 3 — Open diskpart and compact:"
    print "  diskpart"
    print '    select vdisk file="<path from step 2>"'
    print "    attach vdisk readonly"
    print "    compact vdisk"
    print "    detach vdisk"
    print "    exit"
    print ""
    print "Step 4 — Restart Alpine:"
    print "  wsl -d Alpine"
    print ""
    print "Note: compaction only reclaims space AFTER files have been deleted inside WSL2."
    print "Run 'just wsl-clean' first, then shut down, then compact."
}

def df-avail-gb []: nothing -> float {
    let raw_bytes = (^df / 2>/dev/null
        | lines
        | skip 1
        | first
        | str trim
        | split row -r '\s+'
        | get 3
        | into int)
    ($raw_bytes * 1024 / 1_073_741_824) | math round --precision 2
}
