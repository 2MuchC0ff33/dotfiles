# nushell-env-editor-hx

## Description
Set `$env.EDITOR` and `$env.VISUAL` to `"hx"` (Helix) as the default terminal editor.

## When to Load
Load this skill when reviewing or creating environment variable settings in `config.nu` or `env.nu`.

## Source
STANDARDS.adoc §11.1 (lines 3673–3674)

## Key Rules

- MANDATE: `$env.EDITOR = "hx"` AND `$env.VISUAL = "hx"` MUST both be present in the ENVIRONMENT section of `config.nu`.
- SHOULD: Both `EDITOR` and `VISUAL` are set to Helix (`hx`) to ensure any tool that respects these variables opens Helix.
- FORBIDDEN: Setting `EDITOR` to `vim`, `nvim`, `nano`, `emacs`, or any other editor. Using different values for `EDITOR` and `VISUAL`.

## Rationale

Helix (`hx`) is the organization's standard terminal editor (see STANDARDS
§11.4.2). Setting both `EDITOR` and `VISUAL` ensures consistent behavior:

- `EDITOR`: Used by tools like `git commit`, `cargo edit`, `jj describe` to open the editor
- `VISUAL`: Historically for "visual" (full-screen) editors, but most modern tools check both

By convention:
- `EDITOR` is the "line" editor (historical: `ed`, `ex`)
- `VISUAL` is the "screen" editor (historical: `vi`)

Modern tools (git, jj, cargo, etc.) typically check `VISUAL` first, then
`EDITOR`. Setting both avoids edge cases where a tool only checks one.

## Example

```nushell
$env.EDITOR            = "hx"
$env.VISUAL            = "hx"
```

With these set, `jj describe` opens Helix for commit message editing.
