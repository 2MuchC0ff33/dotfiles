# nushell-alias-find-fd

## Description
Replace Nushell's built-in `find` (string search) with `fd` (file search), a fast Rust-native file discovery tool.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3694)

## Key Rules

- MANDATE: `alias find = fd` MUST be present in `config.nu`.
- SHOULD: Use `fd` for finding files by name/pattern. Nushell's built-in `find` searches string content, not filenames — this alias restores the Unix `find` semantics.
- FORBIDDEN: Omitting this alias — calling `find` without the alias invokes Nushell's built-in `find` which does STRING SEARCH, not FILE SEARCH, causing silent confusion.

## Rationale

This alias resolves a critical naming conflict:

| Command | Nushell built-in | Unix external (`^` prefix) |
|---------|-----------------|---------------------------|
| `find` | String content search | File search (`find . -name`) |

Without this alias, `find . -name '*.rs'` calls Nushell's string-search
`find`, which will error or behave unexpectedly. With `alias find = fd`,
the command works as any Unix user expects.

`fd` itself is superior to classic `find`:
- **8-10x faster** than `find` (parallel traversal, regex compilation)
- **Sensible defaults**: Ignores `.gitignore`d files, hidden dirs by default
- **Colorized output**: By file type
- **Regex + glob**: Accepts both patterns
- **Smart case**: Case-insensitive by default, sensitive when pattern is uppercase

## Example

```nushell
alias find = fd
```

Usage: `find '*.rs'` → find all Rust files. `find -e py 'test_'` → find Python files with "test_" in name.

## Related Skills
- [nushell-alias-grep-rg](file://.opencode/skills/nushell-alias-grep-rg.md)
