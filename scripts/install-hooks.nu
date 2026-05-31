#!/usr/bin/env nu
# install-hooks.nu — installs pre-commit verification script
#
# jj does not use .git/hooks. This script creates a wrapper alias
# documented in AGENTS.md that developers run before jj describe.
# See STANDARDS.adoc §10.2 — Version Control.

def main []: nothing -> nothing {
    let hook_dir  = $"($env.HOME)/.config/jj"
    let hook_file = $"($hook_dir)/pre-commit.nu"

    mkdir $hook_dir

    let content = "#!/usr/bin/env nu
# jj pre-commit hook — run manually before jj describe
# Execute: nu ~/.config/jj/pre-commit.nu (from repo root)
def main []: nothing -> nothing {
    print '(ansi cyan)Pre-commit: fmt + lint + audit...(ansi reset)'
    let r = (^just pre-commit o+e>| complete)
    if $r.exit_code != 0 {
        print $r.stdout
        error make {msg: 'pre-commit failed — fix before describing change'}
    }
    print '(ansi green)Pre-commit passed.(ansi reset)'
}"

    $content | save --force $hook_file
    ^chmod +x $hook_file

    print $"(ansi green)Hook written: ($hook_file)(ansi reset)"
    print "Run before jj describe: nu ~/.config/jj/pre-commit.nu"
    print "Or add shell alias:     alias jjd='nu ~/.config/jj/pre-commit.nu && jj describe'"
}
