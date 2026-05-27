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

# Nix musl64 store tool paths — generated
# These are the Nix store "bin" directories for all §1.4.2 Rust-native
# CLI replacements plus related tools (node/npm/npx, uv, helix, opencode).
# Regenerate after changing flake.nix or running `nix flake update` by
# running (from the dotfiles repo):
#   just generate-paths
# which runs: nix develop . --command nu ./scripts/generate-env-paths.nu
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "/nix/store/ryfh6hspp28libl3mlw5sv64giq5iasi-bat-0.26.1/bin"
    | prepend "/nix/store/algax0xxwi6vdl6m63zpz9wz4p2hknqk-eza-0.23.4/bin"
    | prepend "/nix/store/ixsp81bia5w1fqd2d59vwbcfqk3n5231-ripgrep-15.1.0/bin"
    | prepend "/nix/store/wci2b3l9gs8nq3alx6czffsq55bg44cv-fd-10.4.2/bin"
    | prepend "/nix/store/vkmv0m1ll2cx8iaqhyfv8cj433hkz917-sd-1.1.0/bin"
    | prepend "/nix/store/hbxz2p9qsjq7hjmj41p40saanlih22bd-delta-0.19.2/bin"
    | prepend "/nix/store/83hq5hc61ila950250p5km1vwrc46vag-du-dust-1.2.4/bin"
    | prepend "/nix/store/86bx8s9km2isy2lyjcmhjlsa9zrk17in-procs-0.14.11/bin"
    | prepend "/nix/store/rg5d8iwnh23xixi4iss0pdvnrb1j5602-bottom-0.12.3/bin"
    | prepend "/nix/store/m1kv9z8w9l6i3wjgjmw9cnfraf8phqrs-xh-0.25.3/bin"
    | prepend "/nix/store/zbpzigma1995av8v7qsy4w6gg1alijya-zoxide-0.9.9/bin"
    | prepend "/nix/store/vrvh5n1sanmhgz8wc6vzy1idcyd0w456-hyperfine-1.20.0/bin"
    | prepend "/nix/store/lhfw5nxcch4m7qc2gzlk9ychi7d0d2gh-tokei-14.0.0/bin"
    | prepend "/nix/store/3j32zmchv9wd60qng1mm04yj07wf04i8-just-1.51.0/bin"
    | prepend "/nix/store/54vsx05sxbz5qcd03wbvkfi6y5dpnmvw-jujutsu-0.41.0/bin"
    | prepend "/nix/store/d9xiksw26z9rn4g8w4mz8r41rz0hmm3i-nushell-x86_64-unknown-linux-musl-0.112.2/bin"
    | prepend "/nix/store/2iyzhxjwbpir2n2xaqgq14v8455kbrri-starship-1.25.1/bin"
    | prepend "/nix/store/8pnw2sfmnprcxkx06l3xj3nmmddgdndd-helix-25.07.1/bin"
    | prepend "/nix/store/ac9bklddx1klg92hj7r08xmpky1nwag2-nodejs-22.22.3/bin"
    | prepend "/nix/store/8k7nm8lgd3kyns018jlfr37b1h5dj9yl-uv-0.11.15/bin"
    | prepend "/nix/store/2ipg5611qx7x6jlpps1kd0qvj83h50rd-opencode-1.15.10/bin"
    | uniq
)
