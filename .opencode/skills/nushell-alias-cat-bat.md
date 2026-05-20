# nushell-alias-cat-bat

## Description
Replace Nushell's built-in file reading with `bat`, a `cat` clone with syntax highlighting, git integration, and line numbers.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3693)

## Key Rules

- MANDATE: `alias cat = bat --style=full` MUST be present in `config.nu`.
- SHOULD: Use `bat` instead of the built-in `open` / `cat` equivalent for viewing file contents.
- FORBIDDEN: Omitting this alias, which means Nushell's `open` command would be used for file viewing without syntax highlighting.

## Rationale

`bat` is a `cat` clone with wings:

- **Syntax highlighting**: Automatic language detection based on file extension
- **Line numbers**: Shown in the left gutter (toggles with `-n`)
- **Git integration**: Shows modified/added/deleted markers in the gutter
- **Paging**: Automatically pipes to a pager for long files (if stdout is a terminal)
- **Non-printing characters**: Shows tabs, line endings, etc. with `-A`

The `--style=full` flag enables all visual elements: line numbers, headers,
grid, and git modifications. For a stripped-down view, use `-p` or `--plain`.

## Example

```nushell
alias cat = bat --style=full
```

Usage: `cat file.rs` → renders with syntax highlighting, line numbers, git status.
