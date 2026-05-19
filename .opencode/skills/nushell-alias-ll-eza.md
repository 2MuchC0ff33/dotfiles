# nushell-alias-ll-eza

## Description
Define `ll` alias for a detailed eza listing including hidden files: `eza --long --git --icons --all --group-directories-first`.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3633)

## Key Rules

- MANDATE: `alias ll = eza --long --git --icons --all --group-directories-first` MUST be present.
- SHOULD: `ll` is the "long listing" variant that includes dotfiles (`--all`), mirroring the Unix convention of `ls -la` but with eza's rich output.
- FORBIDDEN: Omitting this alias, or aliasing `ll` to Nushell's built-in `ls`.

## Rationale

`ll` is a near-universal Unix convention meaning "long listing with hidden
files." This alias provides:

- **Everything from `ls`**: `--long`, `--git`, `--icons`, `--group-directories-first`
- **Plus hidden files**: `--all` shows `.gitignore`, `.env`, `.config`, `.nu`, etc.
- **No `..` / `.` clutter**: Unlike `ls -a`, eza's `--all` shows dotfiles but not `.` and `..` by default

This is the go-to command for exploring any directory — you see everything
at a glance without needing to remember which dotfiles exist.

## Example

```nushell
alias ll = eza --long --git --icons --all --group-directories-first
```

Usage: `ll` → shows all files including hidden ones, with git status, icons, and detailed metadata.

## Related Skills
- [nushell-alias-ls-eza](file://.opencode/skills/nushell-alias-ls-eza.md)
- [nushell-alias-lt-eza](file://.opencode/skills/nushell-alias-lt-eza.md)
