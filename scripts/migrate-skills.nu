#!/usr/bin/env nu
# migrate-skills.nu
# Migrates flat .opencode/skills/*.md files into the directory structure
# required by opencode native skills (v1.0.190+).
# Run from: ~/projects/personal/dotfiles/
# Usage: ~/.cargo/bin/nu scripts/migrate-skills.nu

def extract-description [content: string, name: string]: nothing -> string {
    let lines = ($content | lines)

    if ($content | str starts-with '---') {
        let rest = ($lines | skip 1)
        let end_idx = ($rest
            | enumerate
            | where {|r| $r.item == '---'}
            | first)
        if $end_idx != null {
            let fm = ($rest | first $end_idx.index)
            let desc = ($fm
                | where {|l| $l | str starts-with 'description:'}
                | first)
            if $desc != null {
                return ($desc
                    | str replace 'description:' ''
                    | str trim
                    | str substring 0..199)
            }
        }
    }

    let h2 = ($lines
        | where {|l| ($l | str starts-with '## ') and ($l | str length) > 3}
        | first)
    if $h2 != null {
        return ($h2 | str replace -r '^#+ *' '' | str trim | str substring 0..199)
    }

    let h1 = ($lines
        | where {|l| ($l | str starts-with '# ') and ($l | str length) > 2}
        | first)
    if $h1 != null {
        return ($h1 | str replace -r '^#+ *' '' | str trim | str substring 0..199)
    }

    let first_line = ($lines
        | where {|l|
            let t = ($l | str trim)
            ($t | str length) > 5 and not ($t | str starts-with '#')
        }
        | first)
    if $first_line != null {
        return ($first_line | str trim | str substring 0..199)
    }

    $"($name) skill"
}

def main [] {
    let skills_dir = '.opencode/skills'

    if not ($skills_dir | path exists) {
        error make {
            msg: $"Not found: ($skills_dir) — run from ~/projects/personal/dotfiles/"
        }
    }

    let flat_files = (ls $skills_dir
        | where type == file
        | where name =~ '\.md$'
        | where {|f| ($f.name | path basename) != 'README.md'})

    let total = ($flat_files | length)
    print $"Found ($total) flat skill files to migrate."

    if $total == 0 {
        print "Nothing to migrate."
        return
    }

    mut migrated = 0
    mut failed = []

    for file in $flat_files {
        let full_path = $file.name
        let name = ($full_path | path basename | str replace '.md' '')

        if not ($name =~ '^[a-z0-9]+(-[a-z0-9]+)*$') {
            print $"SKIP — invalid name: ($name)"
            $failed = ($failed | append $name)
            continue
        }

        let content = (open --raw $full_path)
        let description = (extract-description $content $name)
        let target_dir = $"($skills_dir)/($name)"
        let target_file = $"($target_dir)/SKILL.md"

        mkdir $target_dir

        let fm = $"---\nname: ($name)\ndescription: ($description)\ncompatibility: opencode\n---\n\n"

        let new_content = if ($content | str starts-with '---') {
            let lines = ($content | lines)
            let rest = ($lines | skip 1)
            let end_idx = ($rest
                | enumerate
                | where {|r| $r.item == '---'}
                | first)
            if $end_idx != null {
                let body = ($rest | skip ($end_idx.index + 1) | str join "\n")
                $fm + $body
            } else {
                $fm + $content
            }
        } else {
            $fm + $content
        }

        $new_content | save --force $target_file

        if not ($target_file | path exists) {
            print $"ERROR — failed to write: ($target_file)"
            $failed = ($failed | append $name)
            rm -rf $target_dir
            continue
        }

        rm $full_path
        $migrated = ($migrated + 1)
        print $"  ✓ ($name)"
    }

    print "\n── Verification ────"
    let dirs = (ls $skills_dir | where type == dir)
    mut verified = 0
    mut verify_fail = []

    for d in $dirs {
        let skill_md = $"($d.name)/SKILL.md"
        if ($skill_md | path exists) {
            $verified = ($verified + 1)
        } else {
            $verify_fail = ($verify_fail | append ($d.name | path basename))
        }
    }

    print $"Migrated: ($migrated) / ($total)"
    print $"Verified: ($verified)"

    if ($failed | length) > 0 {
        print $"\nMigration failures: ($failed | str join ', ')"
    }
    if ($verify_fail | length) > 0 {
        print $"\nMissing SKILL.md:   ($verify_fail | str join ', ')"
    }

    if ($failed | length) == 0 and ($verify_fail | length) == 0 {
        print "\n✓ Migration complete — all skills verified."
    } else {
        print "\n✗ Failures — review above before continuing."
    }
}

main
