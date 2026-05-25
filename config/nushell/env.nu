<<<<<<< conflict 1 of 2
%%%%%%% diff from: kulvnuyz bd32f56b "feat(mcp): add Node.js + uv to Nix devShell, configure MCP servers" (rebased revision)
\\\\\\\        to: xrsoxtns 32b05cb1 (rebased revision)
 # Remove global LD_PRELOAD — it leaks from the opencode nix wrapper
 # and breaks nix glibc binaries (jj, git, asciidoctor, etc.)
 # The opencode wrapper at /nix/store/*-opencode-*/bin/opencode sets
 # LD_PRELOAD internally for TUI compatibility, so this is safe to clear.
-hide-env LD_PRELOAD
+if ("LD_PRELOAD" in $env) { hide-env LD_PRELOAD }
 
+++++++ nwpwoxut 00cc16a7 "fix(p14): complete migration cleanup" (parents of rebased revision)
>>>>>>> conflict 1 of 2 ends
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
<<<<<<< conflict 2 of 2
+++++++ xrsoxtns 32b05cb1 (rebased revision)
    | prepend $"($nix_link)/bin"
    | prepend ($env.HOME | path join ".opencode" "bin")
    | uniq
)

# ──────────────────────────────────────────────
# SECRETS — local-only, never committed to repo
# ──────────────────────────────────────────────
source ~/.config/nushell/secrets.nu

%%%%%%% diff from: kulvnuyz bd32f56b "feat(mcp): add Node.js + uv to Nix devShell, configure MCP servers" (rebased revision) (no terminating newline)
\\\\\\\        to: nwpwoxut 00cc16a7 "fix(p14): complete migration cleanup" (parents of rebased revision) (no terminating newline)
     | prepend ($env.HOME + "/.nix-profile/bin")
     | uniq
 )
 
 # Nix musl64 store tool paths — added by P10 decommission
 # These tools were removed from cargo and are now provided by the nix store.
 # Paths are hardcoded to avoid nix eval overhead on every shell startup.
 $env.PATH = (
     $env.PATH
     | split row (char esep)
     | uniq
 )
-
-# MCP infrastructure — Node.js 22 LTS (npx) and uv
-# Paths hardcoded per STANDARDS.adoc §1.5.7 (Alpine/musl constraint)
-# Update hashes after running: nix flake update
-$env.PATH = (
-    $env.PATH
-    | split row (char esep)
-    | prepend "/nix/store/ac9bklddx1klg92hj7r08xmpky1nwag2-nodejs-22.22.3/bin"
-    | prepend "/nix/store/8k7nm8lgd3kyns018jlfr37b1h5dj9yl-uv-0.11.15/bin"
-    | uniq
-)
>>>>>>> conflict 2 of 2 ends