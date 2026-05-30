# Remove global LD_PRELOAD — it leaks from the opencode nix wrapper
# and breaks nix glibc binaries (jj, git, asciidoctor, etc.)
# The opencode wrapper at /nix/store/*-opencode-*/bin/opencode sets
# LD_PRELOAD internally for TUI compatibility, so this is safe to clear.
if (("LD_PRELOAD" in $env)) { hide-env LD_PRELOAD }

$env.BAT_PAGER = "more"
# Ensure ~/.cargo/bin is in PATH (required for nu batch mode)
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "/home/galloa/.cargo/bin"
    | uniq
)
$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.RUSTFLAGS = "-Dwarnings"
$env.PROPTEST_CASES = "100000"
$env.GITHUB_TOKEN = (open --raw ~/.config/secrets/github_token | str trim)

$env.LC_ALL = "C.UTF-8"
$env.LANG = "C.UTF-8"

# Nix profile — added by M01 hermetic migration
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "/nix/var/nix/profiles/default/bin"
    | prepend ($env.HOME + "/.nix-profile/bin")
    | uniq
)

# oxillama — pure-Rust local LLM inference server (built from source, v0.1.2)
# Nix derivation deferred: upstream lacks Cargo.lock; binary built via cargo build --release
$env.PATH = ($env.PATH | split row (char esep) | prepend ([$env.HOME ".local" "bin"] | path join) | uniq)

# Nix musl64 store tool paths — generated
# The cache is a newline-delimited list of /nix/store/.../bin directories.
# Regenerate with:
#   nix develop . --command nu ./scripts/generate-env-paths.nu > ~/.cache/nix-tool-paths.list
let list_file = "~/.cache/nix-tool-paths.list"

if ($list_file | path expand | path exists) {
    let dirs = (open ($list_file | path expand) | lines)
    for d in $dirs {
        if ($d != '') {
            # Ensure the directory exists before prepending (avoid dead Nix store entries)
            if ($d | path exists) {
                $env.PATH = (
                    $env.PATH
                    | split row (char esep)
                    | prepend $d
                    | uniq
                )
            }
        }
    }
}

# Bypass HTTP proxy for loopback addresses — always active regardless of proxy-on/proxy-off.
# Required for opencode's Node.js AI SDK to reach local OxiLLaMa server on 127.0.0.1:8080.
# Safe on company network: only bypasses 127.0.0.1/localhost, never external hosts.
$env.NO_PROXY = "127.0.0.1,localhost,::1"
$env.no_proxy = "127.0.0.1,localhost,::1"
