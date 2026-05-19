# jj-command-rebase

## Description
`jj rebase -d <destination>` — Rebase the current change (or specified change) onto a new destination. All descendants are automatically rebased.

## When to Load
Load this skill when moving a change to a newer base, updating feature branches after changes to main, pulling updates from a remote, or restructuring the commit DAG.

## Source
STANDARDS.adoc §10.2.4 (lines 3436–3437)

## Key Rules

- MANDATE: Use `jj rebase -d <destination>` instead of `git rebase <branch>` — rebase the current change onto the specified destination.
- MANDATE: ALL descendants of the rebased change are automatically rebased — jj handles the transitive closure. You do NOT need to rebase each child individually.
- MANDATE: After `jj git fetch`, use `jj rebase -d main` to rebase your working changes onto the latest remote state (see `jj-collaboration-git-fetch` for the full pull workflow).
- SHOULD: Use `jj rebase -d @-` after `jj git fetch` to rebase onto the remote's version of the current branch.
- SHOULD: Verify the result with `jj log` and `jj status` after rebase — the graph should show your change correctly positioned under the new destination.
- FORBIDDEN: Do NOT use `jj rebase` on changes that have already been pushed to a shared remote without coordinating with your team — rebase rewrites commit IDs.

## Example

```bash
# Rebase current change onto main
jj rebase -d main
# Rebased onto main
# All descendants automatically rebased

# Rebase a specific change onto main
jj rebase -d main --source xrkzmpqw
# Change xrkzmpqw and all descendants rebased onto main

# Rebase after fetching (the pull workflow)
jj git fetch
jj rebase -d main
# Now your changes sit on top of the latest main

# Rebase onto @- (remote tracking branch)
jj git fetch
jj rebase -d @-       # @- = parent of current change (remote update)

# Abort a rebase
jj undo
# Rebase is fully undone, including all descendant rebases
```

## Understanding Auto-rebase

When you rebase change A onto main, jj automatically finds all descendants of A and rebases them onto the new position of A. This is fundamentally different from git, where each descendant must be manually rebased.

```text
Before:           After:
main              main → A'
  |                 |
  A → B → C         A' → B' → C'
```

All of B and C are transparently rebased. If any descendant has conflicts, jj records them as first-class conflicts in the commit (see `jj-command-resolve`).

## Related Skills
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
- [jj-command-resolve](file://.opencode/skills/jj-command-resolve.md)
- [jj-command-squash](file://.opencode/skills/jj-command-squash.md)
- [jj-command-undo](file://.opencode/skills/jj-command-undo.md)
- [jj-collaboration-git-fetch](file://.opencode/skills/jj-collaboration-git-fetch.md)
