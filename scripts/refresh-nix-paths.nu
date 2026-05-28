#!/usr/bin/env nu
# scripts/refresh-nix-paths.nu
# Idempotent Nushell implementation of the lazy cache path generator.

let repo = '~/projects/personal/dotfiles' | path expand
let cache_dir = '~/.cache' | path expand
let cache_file = ($cache_dir | path join 'nix-tool-paths.nu')
let meta_file = ($cache_dir | path join 'nix-tool-paths.meta')
let list_file = ($cache_dir | path join 'nix-tool-paths.list')

# Tools we expect (executable names)
# NOTE: keep this list consistent with scripts/generate-env-paths.nu
let tools = [ 'bat' 'eza' 'rg' 'fd' 'sd' 'delta' 'dust' 'procs' 'btm' 'xh' 'zoxide' 'hyperfine' 'tokei' 'just' 'jj' 'nu' 'starship' 'zellij' 'npm' 'npx' 'uv' 'hx' ]

def compute-hash [repo: string] {
    let lock = ($repo | path join 'flake.lock')
    let gen  = ($repo | path join 'scripts' 'generate-env-paths.nu')
    let lock_hash = if ($lock | path exists) {
        md5sum $lock | str trim | split row ' ' | first
    } else { '' }
    let gen_hash = if ($gen | path exists) {
        md5sum $gen | str trim | split row ' ' | first
    } else { '' }
    $lock_hash + ':' + $gen_hash
}

let current_hash = compute-hash $repo

if ($cache_file | path exists) and ($list_file | path exists) {
    if ($meta_file | path exists) {
        let prev = (open --raw $meta_file | str trim)
        if $prev == $current_hash {
            open --raw $cache_file
            exit 0
        }
    }
}

if not ($cache_dir | path exists) { mkdir $cache_dir }

# Run the Nushell generator inside the flake devShell to get a fresh snippet.
# This keeps all logic in Nushell and ensures we use the flake-provided binaries.
let gen_script = ($repo | path join 'scripts' 'generate-env-paths.nu')
# Capture output lines and filter out Nix's "Git tree is dirty" warning which
# appears when evaluating a flake in a working copy with uncommitted changes.
# Uses str starts-with (not regex) for an unambiguous prefix check.
let out_lines = (nix develop $repo --command nu $gen_script | lines | where {|it| not ($it | str starts-with "warning: Git tree") })
let out = ($out_lines | str join "\n")
if $out == '' { error make {msg: "nix develop failed to produce PATH snippet; enter 'nix develop' and run ./scripts/generate-env-paths.nu to diagnose."} }

# Atomic write
let tmp = ($cache_dir | path join (('nix-tool-paths-' + (date now | into string) | str replace -a ' ' '-' | str replace -a ':' '-') + '.nu'))
$out | save $tmp
mv $tmp $cache_file

# Write meta
$current_hash | save ($cache_dir | path join 'nix-tool-paths.meta.tmp')
mv ($cache_dir | path join 'nix-tool-paths.meta.tmp') $meta_file

# Output the generated snippet
open --raw $cache_file

# Also extract the list of bin dirs into a simple newline-delimited file
let lines = (open --raw $cache_file | lines)
let dirs = (
    $lines
    | where {|it| $it =~ "prepend" }
    | each {|l| (
        ($l | str trim)
        | str replace '| prepend "' ""
        | str replace '"' ""
    ) }
    | uniq
)
let list_dir = ($list_file | path dirname)
if not ($list_dir | path exists) { mkdir $list_dir }
$dirs | str join "\n" | save -f $list_file
