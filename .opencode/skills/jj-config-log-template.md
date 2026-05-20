# jj-config-log-template

## Description
Configure `~/.config/jj/config.toml` [templates] section with a compact one-line log format showing change_id, commit_id, bookmarks, description, and empty indicator.

## When to Load
Load this skill when setting up jj for the first time, customizing the `jj log` output format, or matching log output to a team standard.

## Source
STANDARDS.adoc §10.2.3 (lines 3442–3446)

## Key Rules

- MANDATE: Define `[templates] log` with the exact format: `change_id shortest " " commit_id.shortest " " bookmarks " " description " " empty`.
- MANDATE: The template MUST be a single-line template (one line per commit) — multi-line log formats violate the standard's compact output philosophy.
- SHOULD: Customize the template further with additional fields like `author` or `timestamp` if the team workflow requires it, but the default MUST include at minimum: change_id, commit_id, bookmarks, description.
- FORBIDDEN: Do NOT use the verbose default jj log format (which shows the full change_id, commit_id, author, date, and description on multiple lines) in standard development workflow.

## Example

```toml
# ~/.config/jj/config.toml — Log template

[templates]
log = """
change_id shortest " " commit_id.shortest " " bookmarks " " description " " empty
"""
```

This produces output like:

```
o yqpqzopv 7a3b8c2f main Fix login handler
o xrkzmpqw 9d1e2f3a wip
o mplwqxyz 4a5b6c7d feat Reorganized modules
```

Where `change_id shortest` is the local unique identifier (stable across rebases), `commit_id.shortest` is the git commit hash, `bookmarks` shows branches/tags, `description` is the commit message, and `empty` shows `(empty)` if the change has no file modifications.

## Related Skills
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
- [jj-config-colors](file://.opencode/skills/jj-config-colors.md)
- [jj-command-log](file://.opencode/skills/jj-command-log.md)
