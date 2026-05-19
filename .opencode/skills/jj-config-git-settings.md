# jj-config-git-settings

## Description
Configure `~/.jj/config.toml` [git] section: auto-local-branch, rebase-on-push, and push-conflict behavior.

## When to Load
Load this skill when configuring jj's git integration behavior, troubleshooting push failures, or understanding how jj interacts with remote branches.

## Source
STANDARDS.adoc §10.2.3 (lines 3386–3392)

## Key Rules

- MANDATE: Set `[git] auto-local-branch = true` — automatically create a local branch when pushing to a remote whose bookmark matches the current change.
- MANDATE: Set `[git] rebase = true` — rebase onto the target branch when pushing (safe default, no force-push worries).
- MANDATE: Set `[git] push-conflict = false` — FORBIDDEN to push a change that has unresolved conflicts. Resolve all conflicts before attempting a push.
- SHOULD: Keep these settings in global `~/.jj/config.toml` — they apply uniformly across all repositories.

## Example

```toml
# ~/.jj/config.toml — Git backend configuration

[git]
auto-local-branch = true
rebase = true
push-conflict = false
```

## Rationale

- `auto-local-branch = true`: When you `jj git push`, jj creates a local branch tracking the remote branch. This mirrors the intuitive git workflow where `git push` publishes your local branch to the remote.
- `rebase = true`: jj automatically rebases your change onto the latest version of the destination branch before pushing. This is equivalent to `git pull --rebase` before `git push`, but happens atomically and automatically.
- `push-conflict = false`: This is a safety catch. jj's model allows conflicts to exist in commits (they are stored, not blocking), but pushing conflicts to a remote would confuse collaborators and CI systems. Resolve locally, then push.

## Related Skills
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-resolve](file://.opencode/skills/jj-command-resolve.md)
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
