# nushell-alias-sed-sd

## Description
Replace `sed` (stream editor) with `sd`, a Rust-native find-and-replace tool with intuitive syntax.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3699)

## Key Rules

- MANDATE: `alias sed = sd` MUST be present in `config.nu`.
- SHOULD: Use `sd` for string replacement operations instead of `sed`.
- FORBIDDEN: Omitting this alias; relying on `sed` which requires BSD/macOS vs GNU flag differences.

## Rationale

`sd` is a modern replacement for `sed` that eliminates the pain points of
classic stream editors:

- **Intuitive syntax**: `sd before after` not `sed 's/before/after/g'`
- **No flag schizophrenia**: Same flags on Linux and macOS (no `sed -i` vs `sed -i ''` distinction)
- **In-place editing**: `sd -f` for in-place file modification
- **PCRE2 regex**: Full Perl-compatible regex support
- **String literal mode**: No escaping confusion with `--string-mode`
- **No special delimiter rules**: Use any character without escaping
- **Previews**: `--preview` flag shows changes without applying them

This eliminates the most common `sed` footguns: the BSD/GNU `-i` flag
difference and the arcane `s/.../.../g` syntax.

## Example

```nushell
alias sed = sd
```

Usage: `sed 'foo' 'bar' file.txt` → replaces first occurrence of "foo" with "bar" in file.txt.
`sd -s 'foo' 'bar' file.txt` → same, but string literal mode (no regex).
