# env.nu — environment variables, no credentials
# MANDATE: no credentials, no hardcoded secrets

# Remove global LD_PRELOAD — it leaks from the opencode nix wrapper
# and breaks nix glibc binaries (jj, git, asciidoctor, etc.)
# The opencode wrapper at /nix/store/*-opencode-*/bin/opencode sets
# LD_PRELOAD internally for TUI compatibility, so this is safe to clear.
if ("LD_PRELOAD" in $env) { hide-env LD_PRELOAD }

$env.BAT_PAGER = "more"
$env.PAGER = "less"
$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.RUSTFLAGS = "-Dwarnings"
$env.PROPTEST_CASES = "100000"
$env.CARGO_BUILD_JOBS = "1"
$env.PROJ_ROOT = ($env.HOME | path join ".local" "src")

# ──────────────────────────────────────────────
# NIX ENVIRONMENT — replicates ~/.nix-profile/etc/profile.d/nix.sh
# ──────────────────────────────────────────────
let nix_link = ($env.HOME | path join ".nix-profile")
$env.NIX_LINK = $nix_link
$env.NIX_PROFILES = $"/nix/var/nix/profiles/default ($nix_link)"
$env.NIX_SSL_CERT_FILE = (
    [/etc/ssl/certs/ca-certificates.crt /etc/ssl/ca-bundle.pem /etc/ssl/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt $"($nix_link)/etc/ssl/certs/ca-bundle.crt"]
    | each {|p| if ($p | path exists) {$p}}
    | first
)
$env.XDG_DATA_DIRS = (
    ($env | get -o XDG_DATA_DIRS)
    | default "/usr/local/share:/usr/share"
    | split row (char esep)
    | append $"($nix_link)/share"
    | append "/nix/var/nix/profiles/default/share"
    | append ($env.HOME | path join ".local" "share" "flatpak" "exports" "share")
    | append "/var/lib/flatpak/exports/share"
    | uniq
    | str join (char esep)
)

# ──────────────────────────────────────────────
# PATH — replicates .profile + nix.sh + .bashrc
# ──────────────────────────────────────────────
$env.PATH = (
    ($env | get -o PATH)
    | default "/usr/local/bin:/usr/bin:/bin"
    | split row (char esep)
    | prepend ($env.HOME | path join ".local" "bin")
    | prepend ($env.HOME | path join ".local" "share" "flatpak" "exports" "bin")
    | prepend "/var/lib/flatpak/exports/bin"
    | prepend ($env.HOME | path join ".cargo" "bin")
    | prepend "/nix/var/nix/profiles/default/bin"
    | prepend $"($nix_link)/bin"
    | prepend ($env.HOME | path join ".opencode" "bin")
    | uniq
)
