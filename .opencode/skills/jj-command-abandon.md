# jj-command-abandon

## Description
`jj abandon` — Mark the current change (or specified change) as abandoned. The change's history is preserved in the operation log and can be restored.

## When to Load
Load this skill when discarding a change that is no longer needed, cleaning up experimental branches, or reverting work without losing history.

## Source
STANDARDS.adoc §10.2.4 (lines 3479–3480)

## Key Rules

- MANDATE: Use `jj abandon` instead of `git branch -D` to discard a change — the change is marked abandoned but its full history is preserved in jj's operation log.
- MANDATE: When you `jj abandon` the current working copy, jj automatically switches you to the parent change (it never leaves you on an abandoned change).
- SHOULD: Use `jj abandon <revision>` to abandon a specific change rather than the current working copy.
- SHOULD: Use `jj undo` after `jj abandon` if you change your mind — abandon is not permanent deletion, and undo restores the full state.
- FORBIDDEN: Do NOT use `git branch -D` to delete branches that jj is tracking — use `jj abandon` and then `jj git push --allow-backlog` to sync the branch deletion. Or just let the bookmark disappear locally.

## Example

```bash
# Abandon the current working copy change
jj abandon
# Working copy moves to parent: "moved to parent <parent_id>"

# Abandon a specific change by change ID
jj abandon xrkzmpqw
# Change xrkzmpqw is marked abandoned

# Abandon a change and its descendants
jj abandon xrkzmpqw --this
# Only abandons xrkzmpqw (preserves children)

# Restore an abandoned change
jj undo
# Abandon is reverted, change is active again

# Check log — abandoned changes still appear
jj log
# x  xrkzmpqw  [abandoned] feat Old experiment
# Note: 'x' prefix shows abandoned, 'o' shows active
```

## Understanding Abandon vs Delete

In git, `git branch -D` permanently deletes a branch reference and its commits become eligible for garbage collection. In jj, `jj abandon`:

- Marks the change with an "abandoned" status in the operation log
- Does NOT delete any data — the change's full history, diffs, and metadata remain
- Does NOT garbage-collect — jj's append-only model never destroys data
- The change can be restored with `jj undo` or by referencing it explicitly
- Abandoned changes appear in `jj log` with an `x` prefix (configurable via template)

## Related Skills
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
- [jj-command-undo](file://.opencode/skills/jj-command-undo.md)
- [jj-command-edit](file://.opencode/skills/jj-command-edit.md)
