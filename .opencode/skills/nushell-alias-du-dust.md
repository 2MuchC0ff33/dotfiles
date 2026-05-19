# nushell-alias-du-dust

## Description
Replace Nushell's built-in disk usage reporting with `dust`, a Rust-native `du` alternative with intuitive visual output.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3638)

## Key Rules

- MANDATE: `alias du = dust` MUST be present in `config.nu`.
- SHOULD: Use `dust` for disk usage analysis instead of Nushell's built-in `du`-equivalent.
- FORBIDDEN: Omitting this alias, which leaves the standard (less intuitive) disk usage commands.

## Rationale

`dust` (du+rust) provides a more intuitive disk usage experience:

- **Bar graph visualization**: Shows a horizontal bar chart of directory sizes
- **Auto-sorting**: Largest directories first
- **No `-h` flag needed**: Human-readable units by default
- **Color-coded output**: Easy to spot large directories
- **Apparent size vs physical size**: Shows both with `--apparent-size`
- **Filtering**: `-d N` for depth, `-s` for specific paths only
- **No X deep traversal**: Shows top-level by default, `-d` to drill down

Traditional `du` output requires mental parsing of numbers; `dust` gives
instant visual understanding of where disk space is going.

## Example

```nushell
alias du = dust
```

Usage: `du` → shows disk usage with bar graphs. `du -d 1` → one level deep.
