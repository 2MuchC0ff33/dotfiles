#!/usr/bin/env nu
# scripts/deploy-configs.nu
# Symlink dotfiles configs to ~/.config/
# Idempotent — safe to re-run.

let repo = ($env.FILE_PWD? | default (pwd) | path dirname)
let home = $env.HOME

let targets = [
    { src: $"($repo)/config/nushell/env.nu",    dst: $"($home)/.config/nushell/env.nu" }
    { src: $"($repo)/config/nushell/config.nu",  dst: $"($home)/.config/nushell/config.nu" }
    { src: $"($repo)/config/helix/config.toml",  dst: $"($home)/.config/helix/config.toml" }
    { src: $"($repo)/config/helix/languages.toml", dst: $"($home)/.config/helix/languages.toml" }
    { src: $"($repo)/config/starship.toml",      dst: $"($home)/.config/starship.toml" }
    { src: $"($repo)/config/zellij/config.kdl",  dst: $"($home)/.config/zellij/config.kdl" }
]

for t in $targets {
    let parent = ($t.dst | path dirname)
    if not ($parent | path exists) {
        mkdir $parent
        print $"Created directory: ($parent)"
    }

    if ($t.dst | path exists) {
        if (($t.dst | path expand) == ($t.src | path expand)) {
            print $"  SKIP  ($t.dst) — already symlinked"
            continue
        }
        let backup = $t.dst + ".bak"
        if not ($backup | path exists) {
            mv $t.dst $backup
            print $"  BACKUP  ($t.dst) -> ($backup)"
        } else {
            rm $t.dst
            print $"  REMOVED ($t.dst) — backup already exists at ($backup)"
        }
    }

    ln -s $t.src $t.dst
    print $"  LINK  ($t.src) -> ($t.dst)"
}

print ""
print "Deployment complete. Restart shell or source env.nu."
