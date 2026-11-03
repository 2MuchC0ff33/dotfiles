# Skills

Canonical OpenCode skills for the POSIX.1-2017 / Lua 5.4 framework.

## Install

```sh
sh skills/install.sh --dry-run
sh skills/install.sh
```

The default target is `~/.config/opencode/skills`. Each skill is a symlink
to its directory in this repo, so edits here are live.

## Options

- `--link` (default): symlink.
- `--copy`: copy the directory.
- `--dry-run`: print actions.
- `--remove`: remove installed entries.

## Add a skill

1. Create `skills/<id>/SKILL.md`.
2. Use lowercase kebab-case for `<id>`.
3. Add `name` and `description` frontmatter.
4. Run `sh skills/install.sh --dry-run`.
5. Run `sh skills/install.sh`.

## Verify

```sh
find skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l
find ~/.config/opencode/skills -maxdepth 1 -type l | wc -l
```
