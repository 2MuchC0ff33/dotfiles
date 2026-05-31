#!/usr/bin/env nu
# local-ci.nu — complete local correctness pipeline
# Replaces GitHub Actions as the PRIMARY CI surface.
# STANDARDS.adoc §6.2.4 (local CI replacement)
#
# Usage:
#   just ci              # all 16 layers
#   just ci-fast         # layers 0–4 only (fast iteration)
#   just ci-layer 5      # single layer

def main [
    --fast (-f)        # Skip slow layers: Kani (5), Miri (6), fuzz (8)
    --layer (-l): int = -1  # Run one layer only; -1 = all
]: nothing -> nothing {
    let t0 = (date now)

    let layers = [
        [n  name               skip_fast];
        [0  "rustc"            false]
        [1  "rustfmt+clippy"   false]
        [2  "hygiene"          false]
        [3  "cargo-mirai"      false]
        [4  "rust-analyzer"    false]
        [5  "kani"             true]
        [6  "miri"             true]
        [7  "proptest"         false]
        [8  "cargo-fuzz"       true]
        [9  "verus"            false]
        [10 "creusot"          false]
        [11 "cargo-doc"        false]
        [12 "zig-musl"         false]
        [13 "upx"              false]
        [14 "asciidoc+vale"    false]
        [15 "nushell"          false]
    ]

    let results = ($layers | each {|row|
        if $layer != -1 and $row.n != $layer {
            return {n: $row.n, name: $row.name, status: "SKIPPED", detail: "not selected"}
        }
        if $fast and $row.skip_fast {
            return {n: $row.n, name: $row.name, status: "SKIPPED", detail: "--fast active"}
        }
        run-layer $row.n $row.name
    })

    let elapsed = ((date now) - $t0)
    let failed  = ($results | where status == "FAIL")
    let passed  = ($results | where status == "PASS")
    let skipped = ($results | where status == "SKIPPED")

    print ""
    print "══════════════════════════════════════════════"
    $results | select n name status | table
    print "══════════════════════════════════════════════"
    print $"Elapsed: ($elapsed)"
    print $"($passed | length) passed  ($failed | length) failed  ($skipped | length) skipped"

    if ($failed | length) > 0 {
        print $"\n(ansi red)FAIL — ($failed | length) layer(ansi reset)(ansi red)s(ansi reset)(ansi red) failed(ansi reset)"
        error make {msg: "local-ci pipeline failed"}
    }
    print $"\n(ansi green)PASS — all active layers clean(ansi reset)"
}

def run-layer [n: int, name: string]: nothing -> record<n: int, name: string, status: string, detail: string> {
    print $"  Layer ($n) ($name)..."
    let result = try {
        match $n {
            0  => { layer-0-rustc }
            1  => { layer-1-lint }
            2  => { layer-2-hygiene }
            3  => { layer-3-mirai }
            4  => { layer-4-lsp }
            5  => { layer-5-kani }
            6  => { layer-6-miri }
            7  => { layer-7-proptest }
            8  => { layer-8-fuzz }
            9  => { layer-9-verus }
            10 => { layer-10-creusot }
            11 => { layer-11-docs }
            12 => { layer-12-musl }
            13 => { layer-13-upx }
            14 => { layer-14-adoc }
            15 => { layer-15-nushell }
            _  => { error make {msg: $"unknown layer ($n)"} }
        }
        {n: $n, name: $name, status: "PASS", detail: ""}
    } catch {|err|
        {n: $n, name: $name, status: "FAIL", detail: ($err.msg)}
    }
    $result
}

def shell-ok [cmd: string, args: list<string>]: nothing -> nothing {
    let r = (^$cmd ...$args | complete)
    if $r.exit_code != 0 {
        error make {msg: $"($cmd) ($args | str join ' '):\n($r.stderr)"}
    }
}

def shell-ok-env [cmd: string, args: list<string>, extra_env: record]: nothing -> nothing {
    let r = (with-env $extra_env { ^$cmd ...$args | complete })
    if $r.exit_code != 0 {
        error make {msg: $"($cmd) failed:\n($r.stderr)"}
    }
}

def layer-0-rustc []: nothing -> nothing {
    shell-ok "cargo" ["build" "--all-targets" "--all-features"]
}

def layer-1-lint []: nothing -> nothing {
    shell-ok "cargo" ["fmt" "--all" "--check"]
    shell-ok "cargo" ["clippy" "--all-targets" "--all-features" "--" "-Dwarnings"]
}

def layer-2-hygiene []: nothing -> nothing {
    shell-ok "cargo" ["audit"]
    shell-ok "cargo" ["deny" "check"]
    shell-ok "cargo" ["sort" "--check" "--workspace"]
    shell-ok "cargo" ["machete"]
}

def layer-3-mirai []: nothing -> nothing {
    shell-ok "cargo" ["mirai"]
}

def layer-4-lsp []: nothing -> nothing {
    shell-ok "cargo" ["check" "--all-targets" "--all-features"]
}

def layer-5-kani []: nothing -> nothing {
    shell-ok "cargo" ["kani" "--default-unwind" "100" "--output-format" "terse"]
}

def layer-6-miri []: nothing -> nothing {
    shell-ok-env "cargo" ["miri" "test" "--all-features"] {MIRIFLAGS: "-Zmiri-strict-provenance"}
}

def layer-7-proptest []: nothing -> nothing {
    shell-ok-env "cargo" ["test" "--all-targets" "--all-features" "--" "proptest"] {PROPTEST_CASES: "100000"}
}

def layer-8-fuzz []: nothing -> nothing {
    shell-ok "cargo" ["fuzz" "run" "parsing" "--" "-max_total_time=300"]
}

def layer-9-verus []: nothing -> nothing {
    shell-ok "verus" ["proofs/verus/"]
}

def layer-10-creusot []: nothing -> nothing {
    shell-ok "cargo" ["creusot"]
}

def layer-11-docs []: nothing -> nothing {
    shell-ok-env "cargo" ["doc" "--no-deps" "--all-features"] {RUSTDOCFLAGS: "-Dwarnings"}
}

def layer-12-musl []: nothing -> nothing {
    shell-ok "cargo" ["zigbuild" "--release" "--target" "x86_64-unknown-linux-musl"]
}

def layer-13-upx []: nothing -> nothing {
    shell-ok "upx" ["--test" "target/x86_64-unknown-linux-musl/release/elvis-rust"]
}

def layer-14-adoc []: nothing -> nothing {
    shell-ok "asciidoctor" ["--failure-level=WARN" "README.adoc"]
    if (which vale | is-not-empty) {
        shell-ok "vale" ["--config=docs/.vale.ini" "docs/"]
    }
}

def layer-15-nushell []: nothing -> nothing {
    shell-ok "nu-lint" ["check" "scripts/"]
    shell-ok "nu-lint" ["check" "config/nushell/"]
}
