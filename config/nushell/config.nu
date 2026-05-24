# config.nu — interactive config only
# MANDATE: no credentials, no hardcoded secrets

$env.config = {
    error_style: "fancy"
    shell_integration: { osc2: true, osc7: true, osc133: true }
    history: { max_size: 100_000, file_format: "plaintext", isolation: false }
    completions: { case_sensitive: false, quick: false, partial: false, algorithm: "fuzzy" }
    table: { mode: "rounded", index_mode: "always", trim: { methodology: "wrapping", wrapping_try_keep_words: true } }
}

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

if (which bat   | is-not-empty) { alias cat  = bat --style=full }
if (which fd    | is-not-empty) { alias find = fd }
if (which rg    | is-not-empty) { alias grep = rg }
if (which dust  | is-not-empty) { alias du   = dust }
if (which procs | is-not-empty) { alias ps   = procs }
if (which btm   | is-not-empty) { alias top  = btm }
if (which sd    | is-not-empty) { alias sed  = sd }
if (which delta | is-not-empty) { alias diff = delta }
if (which eza   | is-not-empty) { alias ls   = eza --long --git --group-directories-first }
if (which eza   | is-not-empty) { alias ll   = eza --long --git --all --group-directories-first }
if (which eza   | is-not-empty) { alias lt   = eza --tree --git --level=3 }
if (which xh    | is-not-empty) { alias curl = xh }

alias git = jj
alias c   = cargo
alias cxt = cargo xtask
alias j   = just

if (which zoxide | is-not-empty) { source ~/.zoxide.nu }

if ("~/.cache/starship/init.nu" | path expand | path exists) {
    source "~/.cache/starship/init.nu"
}
