---
name: OpenCode Skills Authoring
description: Use when adding, renaming, or installing skills in this dotfiles repo; covers SKILL.md frontmatter, ID rules, and the installer.
---

# OpenCode Skills Authoring

## Layout

```text
skills/
  <skill-id>/
    SKILL.md
    references/   (optional)
```

The directory name is the skill ID. Use lowercase kebab-case:
`^[a-z0-9]+(-[a-z0-9]+)*$`.

## Frontmatter

```markdown
---
name: Human Name
description: When the model should load this skill.
---
```

## Install

```sh
cd ~/.local/src/dotfiles
sh skills/install.sh --dry-run
sh skills/install.sh
```

Default target: `~/.config/opencode/skills`. The installer symlinks each
directory and refuses to replace a non-symlink.

## Repo config

`opencode.json` adds `./skills` as a source. Global skills are
auto-discovered from `~/.config/opencode/skills`.
