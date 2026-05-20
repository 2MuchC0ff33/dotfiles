# jj-command-git-push

## Description
`jj git push` — Push real git commits from jj's changelog to a remote (GitHub/GitLab), respecting the configured [git] settings.

## When to Load
Load this skill when pushing changes to a remote repository, publishing work for code review, or syncing local bookmarks to GitHub/GitLab.

## Source
STANDARDS.adoc §10.2.4 (line 3485)

## Key Rules

- MANDATE: Use `jj git push` instead of `git push` for daily pushes — jj pushes real git commits that are fully compatible with GitHub, GitLab, CI, and code review.
- MANDATE: `jj git push` respects `[git] push-conflict = false` — it will refuse to push if the current change has unresolved conflicts.
- MANDATE: `jj git push` respects `[git] auto-local-bookmark = true` — it automatically creates local tracking bookmarks for remote bookmarks.
- MANDATE: `jj git push` respects `[git] rebase = true` — it automatically rebases the change onto the destination before pushing.
- SHOULD: Use `jj git push --remote <name>` to push to a specific remote (default: "origin").
- SHOULD: Use `jj git push -b <bookmark>` to push a specific bookmark instead of the current change.
- SHOULD: Use `jj git push --dry-run` to preview what would be pushed.
- FORBIDDEN: Do NOT use `git push` directly unless you need to force-push, delete remote branches, or handle edge cases jj cannot.

## Example

```bash
# Push current change (with auto-rebase)
jj git push
# Auto-rebase onto main (if needed)
# Push commits to remote
# Create/update remote tracking branch

# Push a specific bookmark
jj git push -b feat-api

# Push to a specific remote
jj git push --remote upstream

# Push with changes (equivalent to git push --force-with-lease)
jj git push --force-with-lease
# (use when you've rebased a previously-pushed change)

# Dry run to preview
jj git push --dry-run

# Verify after push
jj log
# Remote bookmarks are updated: main@origin, feat-api@origin
```

## What jj git push does

1. **Resolves the current change** to a git commit (if not already materialized)
2. **Checks `push-conflict`** — rejects push if conflicts exist
3. **Auto-rebases** (if `rebase = true`) — rebases onto the latest destination
4. **Creates/updates local bookmarks** (if `auto-local-bookmark = true`)
5. **Pushes git commits** to the remote via the standard git protocol
6. **Updates remote tracking** — `main@origin` bookmarks reflect the new state

The remote (GitHub, GitLab) sees exactly the same commits as if you had used `git push`. All bookmark protection rules, CI checks, and code review workflows work identically.

## Related Skills
- [jj-config-git-settings](file://.opencode/skills/jj-config-git-settings.md)
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-resolve](file://.opencode/skills/jj-command-resolve.md)
- [jj-collaboration-git-fetch](file://.opencode/skills/jj-collaboration-git-fetch.md)
- [jj-collaboration-gh-cli](file://.opencode/skills/jj-collaboration-gh-cli.md)
