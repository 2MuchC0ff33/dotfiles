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