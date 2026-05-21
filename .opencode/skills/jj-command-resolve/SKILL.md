---
name: jj-command-resolve
description: Description
compatibility: opencode
---

# jj-command-resolve

## Description
`jj resolve` — Interactively resolve merge conflicts in the current change. Conflicts are stored in commits, never blocking other operations.

## When to Load
Load this skill when `jj status` shows files under "Conflicts:", after a rebase or merge produces conflicts, or when preparing to push a change that has conflicts.

## Source
STANDARDS.adoc §10.2.4 (lines 3496–3497)

## Key Rules

- MANDATE: Use `jj resolve` to start the interactive conflict resolution process — it opens the configured `diff-editor` (`hx`) with the conflicted files.
- MANDATE: `push-conflict = false` means you CANNOT push a change with unresolved conflicts. Resolve ALL conflicts before pushing.
- MANDATE: Conflicts are stored in commits as first-class objects — they do NOT block any jj operation (you can rebase, create new changes, describe, even abandon a conflicted change).
- SHOULD: Run `jj status` first to list all conflicted files before starting resolution.
- SHOULD: After resolving all conflicts, run `jj status` again to verify all conflicts are cleared (output shows "No conflicts").
- FORBIDDEN: Do NOT use `git mergetool` or other git conflict resolution tools — use `jj resolve` which understands jj's conflict storage format.

## Example

```bash
# After a rebase produces conflicts
jj rebase -d main
# Rebased onto main
# Conflict: src/api.rs

# Check status
jj status
# Working copy changes:
#   M src/api.rs
# Conflicts:
#   M src/api.rs   (both modified)

# Start interactive resolution
jj resolve
# Opens hx (diff-editor) with conflict markers
# Resolve conflicts in the editor, save and quit

# Verify clean state
jj status
# No conflicts.

# Now safe to push
jj git push
```

## Understanding jj Conflicts

In git, conflicts are blocking — you cannot commit, rebase, or proceed until they are resolved. The repo is in a "detached" merge-conflict state.

In jj, conflicts are first-class objects stored in the commit DAG:

- A conflicted change is a normal change with a conflict marker in its commit data
- You can rebase a conflicted change — jj propagates the conflict forward
- You can describe a conflicted change — the description is independent of conflict state
- You can abandon a conflicted change — no cleanup needed
- Multiple conflicts can exist simultaneously in different changes
- Each conflict is resolved independently with `jj resolve`

This eliminates the "oh no, I'm stuck in a merge conflict" panic that git users experience.

## Related Skills
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-status](file://.opencode/skills/jj-command-status.md)
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
- [jj-config-git-settings](file://.opencode/skills/jj-config-git-settings.md)
