---
name: nushell-alias-cd-zoxide
description: Description
compatibility: opencode
---

# nushell-alias-cd-zoxide

## Description
Replace `cd` directory change with `z` (zoxide), a smarter directory jumper that learns your most-used paths.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3700)

## Key Rules

- MANDATE: `alias cd = z` MUST be present in `config.nu`.
- SHOULD: Use `zoxide`'s `z` command for directory navigation, which learns from your `cd` history and uses frecency ranking.
- FORBIDDEN: Omitting this alias, which leaves only the literal `cd` with no frecency learning.

## Rationale

Zoxide replaces `cd` with a "frecency" (frequency + recency) algorithm:

- **Fuzzy matching**: `z proj` matches `~/projects/personal/dotfiles`
- **Frecency ranking**: Most-used + most-recent directories bubble to the top
- **Smart substrings**: `z doc` could match `~/Documents` or `~/projects/docs`
- **Interactive mode**: `z -i` shows an interactive selection menu with fzf-style filtering
- **List matching directories**: `z -l proj` lists all matching paths without changing
- **Exclusion**: `z -e path` removes a path from the database

After a few days of use, zoxide learns your project structure and you can
jump across directories with 2-3 keystrokes instead of typing full paths.

Note: Zoxide also requires its initialization in `env.nu` for full
functionality (the `__zoxide_hook` that records `cd` calls).

## Example

```nushell
alias cd = z
```

Usage:
- `cd dotfiles` → jumps to `~/projects/personal/dotfiles` (after visiting it once)
- `cd proj` → jumps to the most frecent directory matching "proj"
- `cd -` → previous directory (same as `cd -` in bash)
