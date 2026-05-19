# nushell-alias-grep-rg

## Description
Replace Nushell's built-in `grep` with `rg` (ripgrep), a hyper-fast Rust-native recursive search tool.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3637)

## Key Rules

- MANDATE: `alias grep = rg` MUST be present in `config.nu`.
- SHOULD: Use `rg` for content searching. Nushell's built-in `grep` works but lacks the performance, .gitignore awareness, and feature set of ripgrep.
- FORBIDDEN: Omitting this alias, leaving Nushell's built-in `grep` (slower, no .gitignore awareness, fewer output options).

## Rationale

`rg` (ripgrep) is the gold standard for recursive content search:

- **Speed**: 5-10x faster than GNU grep, 2-5x faster than Nushell's built-in grep
- **.gitignore-aware**: Automatically skips files matched by `.gitignore`
- **Smart defaults**: Recursive by default, skips hidden/binary files, respects ignore files
- **PCRE2 regex**: Full Perl-compatible regex support
- **JSON output**: Machine-parseable output with `--json`
- **Column numbers**: `--column` for editor integration
- **Context lines**: `-C N` for before/after context, `-B`/`-A` for directional

## Example

```nushell
alias grep = rg
```

Usage: `grep 'pattern' src/` → search recursively in `src/`, respecting `.gitignore`.
