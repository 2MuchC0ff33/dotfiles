# nushell-alias-diff-delta

## Description
Replace `diff` with `delta`, a syntax-highlighting, side-by-side pager for diffs.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3644)

## Key Rules

- MANDATE: `alias diff = delta` MUST be present in `config.nu`.
- SHOULD: Use `delta` for viewing file differences instead of plain `diff`.
- FORBIDDEN: Omitting this alias, leaving the bare `diff` (colorless, no side-by-side, no syntax highlighting).

## Rationale

`delta` (formerly `git-delta`) is a diff viewer that elevates the diff
experience:

- **Syntax highlighting**: Language-aware coloring of code in diffs
- **Side-by-side view**: `--side-by-side` for line-by-line comparison
- **Word-level diff**: Highlights changed words, not just lines
- **Line numbers**: Both left (old) and right (new) line numbers
- **Git integration**: Configured as git's diff/pager tool via `.gitconfig`
- **Themes**: Multiple color themes (Dark+, Monokai, etc.)
- **Navigation**: Plus/minus markers for quick scanning

`diff` alone is nearly unusable for modern development — colorless terminal
output with no syntax awareness. `delta` makes diffs actually pleasant to read.

## Example

```nushell
alias diff = delta
```

Usage: `diff file1.rs file2.rs` → syntax-highlighted, side-by-side diff.
