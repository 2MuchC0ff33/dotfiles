# nushell-config-error-style-fancy

## Description
Force Nushell to render errors with rich, colorful diagnostics using `error_style: "fancy"`.

## When to Load
Load this skill when creating or reviewing `$env.config.error_style` in `config.nu` or any Nushell configuration file.

## Source
STANDARDS.adoc §11.1 (line 3596)

## Key Rules

- MANDATE: `$env.config.error_style` MUST be set to `"fancy"`.
- SHOULD: No other `error_style` value is acceptable — `"plain"` and `"compact"` are strictly inferior.
- FORBIDDEN: Omitting `error_style` (relies on default) or setting it to `"plain"` / `"compact"`.

## Rationale

Fancy error style produces human-readable diagnostics with syntax highlighting,
underlines, source snippets, and hints. This dramatically speeds up debugging
and is the recommended style for all interactive use. Plain mode strips all
color and formatting; compact mode loses source context.

## Example

```nushell
$env.config = {
    error_style: "fancy"

    # ... other settings ...
}
```

## Related Skills
- [nushell-config-shell-integration-osc2](file://.opencode/skills/nushell-config-shell-integration-osc2.md)
- [nushell-config-table-mode-rounded](file://.opencode/skills/nushell-config-table-mode-rounded.md)
