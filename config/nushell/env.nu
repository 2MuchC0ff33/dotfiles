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
$env.GITHUB_TOKEN = "<your-github-pat-here>"

# Nix profile — added by M01 hermetic migration
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "/nix/var/nix/profiles/default/bin"
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

# MCP infrastructure — Node.js 22 LTS (npx) and uv
# Paths hardcoded per STANDARDS.adoc §1.5.7 (Alpine/musl constraint)
# Update hashes after running: nix flake update
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "/nix/store/ac9bklddx1klg92hj7r08xmpky1nwag2-nodejs-22.22.3/bin"
    | prepend "/nix/store/8k7nm8lgd3kyns018jlfr37b1h5dj9yl-uv-0.11.15/bin"
    | prepend "/nix/store/qrfgwbf7g30qdmnirwgywk02zcgzdgzv-helix-25.07.1/bin"
    | uniq
)
