# nushell-config-table-mode-rounded

## Description
Render Nushell tables with rounded corners using Unicode box-drawing characters.

## When to Load
Load this skill when configuring `$env.config.table.mode` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3619)

## Key Rules

- MANDATE: `$env.config.table.mode` MUST be `"rounded"`.
- SHOULD: Rounded mode uses `╭───╮` / `╰───╯` style borders that look clean and modern in any terminal that supports Unicode.
- FORBIDDEN: `mode: "basic"` (ASCII-only, `+---+` style), `mode: "compact"` (no borders), `mode: "none"` (no table structure), `mode: "heavy"` (thick borders), `mode: "light"` (thin double-line), `mode: "reinforced"`, etc.

## Rationale

The `"rounded"` table mode provides the best visual experience for terminal
output:
- **Aesthetics**: Rounded corners (`╭ ╮ ╰ ╯`) look polished and modern
- **Readability**: Clear visual cell boundaries without heavy lines
- **Accessibility**: High contrast between table cells and borders
- **Cross-platform**: Unicode box-drawing characters render correctly in
  Alacritty, Kitty, iTerm2, Windows Terminal, VS Code integrated terminal

Other modes are inferior:
- `"basic"`: Looks like 1970s line printers
- `"compact"`: Hard to distinguish rows at a glance
- `"none"`: No visual structure at all
- `"heavy"` / `"light"`: Excessive visual weight or too faint

## Example

```nushell
$env.config = {
    table: {
        mode:       "rounded"
        index_mode: "always"
        trim: {
            methodology:             "wrapping"
            wrapping_try_keep_words: true
        }
    }
}
```

## Related Skills
- [nushell-config-table-index-always](file://.opencode/skills/nushell-config-table-index-always.md)
- [nushell-config-table-trim-wrapping](file://.opencode/skills/nushell-config-table-trim-wrapping.md)
