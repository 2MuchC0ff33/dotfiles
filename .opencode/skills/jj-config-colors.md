# jj-config-colors

## Description
Configure `~/.jj/config.toml` [colors] section for delta-inspired diff highlighting in jj's output.

## When to Load
Load this skill when customizing jj's terminal output colors, debugging unreadable diffs, or matching jj's visual style to your terminal theme.

## Source
STANDARDS.adoc §10.2.3 (lines 3394–3400)

## Key Rules

- MANDATE: Define `[colors]` section with explicit styles for all four diff categories: header, file-header, context, added, removed.
- MANDATE: Use the exact color scheme specified in the standard:
  - `diff-header = "bold cyan"`
  - `diff-file-header = "bold yellow"`
  - `diff-context = "dim white"`
  - `diff-added = "bold green"`
  - `diff-removed = "bold red"`
- SHOULD: Extend with additional color entries for other jj output elements (e.g., `diff-marker`, `error`, `warning`) as needed — the standard only mandates the five diff colors.
- SHOULD: These colors are designed to approximate `git-delta`'s default theme for consistency across tools.

## Example

```toml
# ~/.jj/config.toml — Color configuration

[colors]
diff-header = "bold cyan"
diff-file-header = "bold yellow"
diff-context = "dim white"
diff-added = "bold green"
diff-removed = "bold red"
```

## Rationale

Consistent color coding across diff tools reduces cognitive load when switching between `jj diff`, `git diff` (via `delta`), and IDE diff views. The bold/dim weights ensure readability on both light and dark terminal themes. The standard deliberately avoids terminal-formatting gimmicks (no `#ffffff` hex codes, no 24-bit color) to maintain broad compatibility.

## Related Skills
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
- [jj-config-log-template](file://.opencode/skills/jj-config-log-template.md)
- [jj-command-log](file://.opencode/skills/jj-command-log.md)
