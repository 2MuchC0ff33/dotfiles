---
name: nushell-alias-ls-eza
description: Description
compatibility: opencode
---

# nushell-alias-ls-eza

## Description
Replace Nushell's built-in `ls` with `eza`, a modern Rust-native `ls` replacement using `alias ls = eza --long --git --icons --group-directories-first`.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3690)

## Key Rules

- MANDATE: `alias ls = eza --long --git --icons --group-directories-first` MUST be present in `config.nu`.
- SHOULD: Use `eza` instead of the built-in `ls` for richer output (permissions, sizes, git status, icons, directory-first sorting).
- FORBIDDEN: Omitting this alias (uses Nushell's built-in `ls` which lacks git integration, icons, and many formatting options).

## Rationale

`eza` is an actively maintained fork of `exa` (which is archived). It provides:
- **Columnar output**: Permissions, link count, owner, group, size, modified date
- **Git integration**: Shows staged/unstaged/modified status per file (`--git`)
- **Icons**: File-type icons via Nerd Fonts (`--icons`)
- **Directory-first sorting**: `--group-directories-first` puts directories at the top
- **Colors**: Syntax-highlighted output by file type
- **Symlink targets**: Shows where symlinks point

The flags used:
- `--long`: Detailed columnar listing
- `--git`: Show git status indicators per file
- `--icons`: Show file-type icons (requires Nerd Font)
- `--group-directories-first`: Sort directories before files

## Example

```nushell
alias ls = eza --long --git --icons --group-directories-first
```

Once defined, `ls` produces rich output with file permissions, sizes, dates,
icons, and git status indicators.

## Related Skills
- [nushell-alias-ll-eza](file://.opencode/skills/nushell-alias-ll-eza.md)
- [nushell-alias-lt-eza](file://.opencode/skills/nushell-alias-lt-eza.md)
- [nushell-alias-cat-bat](file://.opencode/skills/nushell-alias-cat-bat.md)
