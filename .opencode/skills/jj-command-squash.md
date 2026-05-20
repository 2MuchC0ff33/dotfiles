# jj-command-squash

## Description
`jj squash` — Merge the current change's file diffs into its parent change, then abandon the current change.

## When to Load
Load this skill when you have a small fix or incremental change that you want to combine with its parent, cleaning up the commit history before review or push.

## Source
STANDARDS.adoc §10.2.4 (lines 3475–3476)

## Key Rules

- MANDATE: Use `jj squash` to combine the current change into its parent — equivalent to squashing two commits together in `git rebase -i`.
- MANDATE: After squash, the current change is abandoned and the working copy moves to the parent (now containing the combined diff).
- MANDATE: `jj squash` only squashes into the parent — use `jj squash --into <revision>` to squash into a specific ancestor.
- SHOULD: Use `jj squash --from <source>` to squash a specific non-current change into its parent.
- SHOULD: Run `jj log` and `jj status` after squash to verify the DAG structure is as expected.
- FORBIDDEN: Do NOT squash changes that have been pushed to a shared remote — this rewrites commit IDs and requires force-push.

## Example

```bash
# Start two sequential changes
jj new feat-xyz
# ... make edits ...
jj describe -m "wip"          # change A: some work

jj new
# ... more edits ...
jj describe -m "wip"          # change B: more related work

# Review the two changes
jj log
# @  xyzabc12  wip
# o  qrstuvw9  wip

# Squash change B into A
jj squash
# B's diff is merged into A, B is abandoned
# Working copy is now A (no longer on B)

# Verify
jj log
# @  qrstuvw9  wip        (now contains both changes' diffs)

# Alternative: squash current change into a specific ancestor
jj squash --into main
# Squash current change directly into main

# Alternative: squash from another change
jj squash --from xyzabc12
# Squash xyzabc12 into its parent
```

## Squash vs Git Rebase -i

In git, squashing requires an interactive rebase (`git rebase -i`), where you pick/reword/squash commits in a TODO list. In jj:

- `jj squash` is a single command — no editor, no TODO list
- It always merges into the immediate parent (unless `--into` is used)
- It's safe because `jj undo` fully reverses the operation
- Multiple sequential squashes can achieve the same result as a multi-commit git squash

## Related Skills
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
- [jj-command-split](file://.opencode/skills/jj-command-split.md)
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-undo](file://.opencode/skills/jj-command-undo.md)
