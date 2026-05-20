# jj-collaboration-git-fetch

## Description
`jj git fetch` then `jj rebase -d @-` — Pull the latest changes from the remote and auto-rebase the current change onto the updated branch.

## When to Load
Load this skill when syncing with upstream changes before continuing work, updating your branch with the latest main, or at the start of a work session to ensure you're working from the latest state.

## Source
STANDARDS.adoc §10.2.4 (lines 3487–3488)

## Key Rules

- MANDATE: Use `jj git fetch` followed by `jj rebase -d main` (or `jj rebase -d @-`) as the equivalent of `git pull --rebase`.
- MANDATE: `jj git fetch` is the first step — it fetches new commits and updates remote bookmarks without modifying your working changes.
- MANDATE: `jj rebase -d @-` after fetch rebases your current change onto the new version of its parent (typically the updated branch).
- MANDATE: jj's auto-rebase means ALL descendants of the rebased change are automatically rebased — not just the current change.
- SHOULD: Run `jj git fetch && jj rebase -d main` at the start of every work session.
- SHOULD: Check for conflicts after rebase with `jj status`.
- FORBIDDEN: Do NOT use `git pull` (with or without `--rebase`) — it bypasses jj's change tracking and can create confusion between git branches and jj bookmarks.

## Example

```bash
# Full pull workflow
jj git fetch
# Fetching...
# Remote bookmarks updated: main@origin

jj rebase -d main
# Rebased onto main
# All descendants auto-rebased

# Check for conflicts
jj status

# Continue working
jj log
# Your changes now sit on top of the latest remote state

# Alternative one-liner
jj git fetch && jj rebase -d main
```

## What happens step by step

1. `jj git fetch` contacts the remote (origin), downloads new commits, and updates remote-tracking bookmarks (e.g., `main@origin` now points to the latest commit on the remote main).
2. `jj rebase -d main` rebases your current change onto the remote's `main` bookmark (which was just updated by the fetch).
3. All descendant changes are automatically rebased — jj computes the transitive closure.
4. If conflicts arise, they are stored as first-class conflicts in the commits (see `jj-command-resolve`).
5. Your local `main` bookmark may also fast-forward if no local changes were on it.

## Comparison with git pull

| Step | git | jj |
|---|---|---|
| Fetch | `git fetch` (implicit in `git pull`) | `jj git fetch` |
| Merge/Rebase | `git merge` or `git rebase` | `jj rebase -d main` |
| Auto-rebase descendants | Manual for each branch | Automatic (transitive closure) |
| Conflict handling | Blocks the operation | Stored in commits, never blocks |

## Related Skills
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-resolve](file://.opencode/skills/jj-command-resolve.md)
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
- [jj-command-status](file://.opencode/skills/jj-command-status.md)
