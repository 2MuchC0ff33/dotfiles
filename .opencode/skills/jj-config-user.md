# jj-config-user

## Description
Configure `~/.config/jj/config.toml` with user identity (name, email), default change description, and editor settings.

## When to Load
Load this skill when setting up jj on a new machine, configuring the global user identity, or changing the default editor for commit descriptions and conflict resolution.

## Source
STANDARDS.adoc §10.2.3 (lines 3413–3424)

## Key Rules

- MANDATE: Set `[user] name` and `[user] email` to match your GitHub identity — jj uses these for commit authorship.
- MANDATE: Set `[ui] default-description = "wip"` — every new change starts with "wip" as the default description, forcing explicit description before push.
- MANDATE: Set `[ui] editor = "hx"` (Helix) as the default editor per the toolchain standard.
- MANDATE: Set `[ui] diff-editor = "hx"` for interactive conflict resolution.
- SHOULD: Use a global `~/.config/jj/config.toml` for user-level settings; use repository-level `.jj/config.toml` for project-specific overrides.
- FORBIDDEN: Do NOT omit the `[user]` section — jj will refuse to create commits without a configured user.

## Example

```toml
# ~/.config/jj/config.toml
[user]
name = "A. Developer"
email = "dev@example.com"

[ui]
default-description = "wip"       # New changes start as "wip"
editor = "hx"                      # Helix for commit descriptions
diff-editor = "hx"                 # Helix for merge conflict resolution
```

## Rationale

The `default-description = "wip"` convention encodes the standard's workflow philosophy: create a change first, describe it later. The "wip" placeholder is a clear signal that the change is in progress and needs a proper description before submission. Using Helix (`hx`) for both editing and diff-editing maintains toolchain consistency (see STANDARDS.adoc §1.4).

## Related Skills
- [jj-config-git-settings](file://.opencode/skills/jj-config-git-settings.md)
- [jj-config-colors](file://.opencode/skills/jj-config-colors.md)
- [jj-config-log-template](file://.opencode/skills/jj-config-log-template.md)
- [jj-command-describe](file://.opencode/skills/jj-command-describe.md)
