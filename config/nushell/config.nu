# config.nu — interactive config only
# MANDATE: no credentials, no hardcoded secrets

$env.config = {
    error_style: "fancy"
    shell_integration: { osc2: true, osc7: true, osc133: true }
    history: { max_size: 100_000, file_format: "sqlite", isolation: true }
    completions: { case_sensitive: false, quick: false, partial: false, algorithm: "fuzzy" }
    table: { mode: "rounded", index_mode: "always", trim: { methodology: "wrapping", wrapping_try_keep_words: true } }
}

# PROXY TOGGLE
def --env proxy-on [] {
    $env.http_proxy = "http://127.0.0.1:3128"
    $env.https_proxy = "http://127.0.0.1:3128"
    $env.HTTP_PROXY = "http://127.0.0.1:3128"
    $env.HTTPS_PROXY = "http://127.0.0.1:3128"
    print "proxy: ON"
}

def --env proxy-off [] {
    for var in ["http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY"] {
        if ($env | get -o $var) != null { hide-env $var }
    }
    print "proxy: OFF"
}

# NOTE: STANDARDS §11.1 mandates `alias cd = z` but this creates infinite
# recursion in nushell — zoxide internally calls `cd`, which would expand
# back to `z`. Use `z <dir>` for zoxide jumps, `cd <dir>` for built-in.

# RUST-NATIVE ALIASES (conditional on tool availability)
if (which bat   | is-not-empty) { alias cat  = bat --style=full }
if (which fd    | is-not-empty) { alias find = fd }
if (which rg    | is-not-empty) { alias grep = rg }
if (which dust  | is-not-empty) { alias du   = dust }
if (which procs | is-not-empty) { alias ps   = procs }
if (which btm   | is-not-empty) { alias top  = btm }
if (which sd    | is-not-empty) { alias sed  = sd }
if (which delta | is-not-empty) { alias diff = delta }
if (which eza   | is-not-empty) { alias ls   = eza --long --git --icons --group-directories-first }
if (which eza   | is-not-empty) { alias ll   = eza --long --git --icons --all --group-directories-first }
if (which eza   | is-not-empty) { alias lt   = eza --tree --git --icons --level=3 }
if (which xh    | is-not-empty) { alias curl = xh }
if (which ouch  | is-not-empty) { alias tar  = ouch }
if (which doggo | is-not-empty) { alias dig  = doggo }
if (which gping | is-not-empty) { alias ping = gping }
if (which bandwhich | is-not-empty) { alias net = bandwhich }

alias git = jj
alias c   = cargo
alias cxt = cargo xtask
alias j   = just
alias gui = jj log

# PROJECTS
def proj [name?: string] {
    let root = $env.PROJ_ROOT
    if $name == null {
        print "personal:"
        ls ($root | path join "personal") | get name | each {|p| $p | path basename } | print
        print "work:"
        ls ($root | path join "work") | get name | each {|p| $p | path basename } | print
        return
    }
    let candidates = [
        ($root | path join "personal" $name)
        ($root | path join "work" $name)
        $name
    ]
    let found = ($candidates | where {|p| $p | path exists})
    if ($found | is-empty) {
        error make {msg: $"not found: ($name)"}
    }
    cd ($found | first)
}

# SSH AGENT
def --env ensure-ssh-agent [] {
    let key     = ($env.HOME | path join ".ssh" "id_ed25519")
    let pid     = ($env | get -o SSH_AGENT_PID)
    let alive   = if $pid != null {
        (^kill -0 ($pid | into int) | complete).exit_code == 0
    } else { false }
    if not $alive {
        let result      = (^ssh-agent -s | complete)
        let agent_file  = ($env.HOME | path join ".ssh" "agent.env")
        $result.stdout | save --force $agent_file
        for _l in ($result.stdout | lines) {
            if ($_l | str starts-with "SSH_AGENT_PID=") {
                $env.SSH_AGENT_PID = (
                    $_l | str replace "SSH_AGENT_PID=" ""
                        | str replace -r ";.*" ""
                        | str trim
                )
            }
            if ($_l | str starts-with "SSH_AUTH_SOCK=") {
                $env.SSH_AUTH_SOCK = (
                    $_l | str replace "SSH_AUTH_SOCK=" ""
                        | str replace -r ";.*" ""
                        | str trim
                )
            }
        }
    }
    if ($key | path exists) {
        ^ssh-add $key e>| ignore
    }
}

# STARTUP
ensure-ssh-agent

source ~/.zoxide.nu
if ("~/.cache/starship/init.nu" | path expand | path exists) {
    source "~/.cache/starship/init.nu"
}

# oc — opencode launcher
def oc [...args: string]: nothing -> nothing {
    run-external ($env.HOME | path join ".cargo" "bin" "oc") ...$args
}
