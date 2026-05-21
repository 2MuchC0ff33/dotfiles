---
name: jj-config-git-settings
description: Description
compatibility: opencode
---

# jj-config-git-settings

## Description
Configure `~/.config/jj/config.toml` [git] section: auto-local-bookmark, rebase-on-push, and push-conflict behavior.

## When to Load
Load this skill when configuring jj's git integration behavior, troubleshooting push failures, or understanding how jj interacts with remote bookmarks.

## Source
STANDARDS.adoc §10.2.3 (lines 3426–3432)

## Key Rules

- MANDATE: Set `[git] auto-local-bookmark = true` — automatically create a local bookmark when pushing to a remote whose bookmark matches the current change.
- MANDATE: Set `[git] rebase = true` — rebase onto the target branch when pushing (safe default, no force-push worries).
- MANDATE: Set `[git] push-conflict = false` — FORBIDDEN to push a change that has unresolved conflicts. Resolve all conflicts before attempting a push.
- SHOULD: Keep these settings in global `~/.config/jj/config.toml` — they apply uniformly across all repositories.

## Example

```toml
# ~/.config/jj/config.toml — Git backend configuration

[git]
auto-local-bookmark = true
rebase = true
push-conflict = false
```

## Rationale

- `auto-local-bookmark = true`: When you `jj git push`, jj creates a local bookmark tracking the remote bookmark. This mirrors the intuitive git workflow where `git push` publishes your local bookmark to the remote.
- `rebase = true`: jj automatically rebases your change onto the latest version of the destination branch before pushing. This is equivalent to `git pull --rebase` before `git push`, but happens atomically and automatically.
- `push-conflict = false`: This is a safety catch. jj's model allows conflicts to exist in commits (they are stored, not blocking), but pushing conflicts to a remote would confuse collaborators and CI systems. Resolve locally, then push.

## Related Skills
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-resolve](file://.opencode/skills/jj-command-resolve.md)
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
