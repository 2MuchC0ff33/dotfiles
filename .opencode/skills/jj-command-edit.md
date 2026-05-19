# jj-command-edit

## Description
`jj edit HASH` — Set the working copy to an arbitrary commit, making it editable as if it were the current change.

## When to Load
Load this skill when you need to inspect or modify an old commit, check out a specific historical state, or perform "stash"-like operations by switching to another change.

## Source
STANDARDS.adoc §10.2.4 (lines 3446–3447)

## Key Rules

- MANDATE: Use `jj edit <revision>` to make any existing revision the working copy — equivalent to `git checkout HASH` but with full editability.
- MANDATE: When you edit a change and make modifications, jj automatically creates a new working-copy change (the edit becomes a parent).
- SHOULD: Use `jj edit @-` as a stash-like operation — `@-` refers to the parent of the current working copy, so switching to it effectively "stashes" your current work.
- SHOULD: Use `jj edit <change_id>` rather than `jj edit <commit_id>` when you want stable references that survive rebases.
- FORBIDDEN: Do NOT use `jj edit` on a change that has already been pushed and shared with others — changes made under edit may rewrite history.

## Example

```bash
# Check out an old commit by commit hash
jj edit 9d1e2f3a
# Working copy now points to that commit

# Check out by change ID (stable across rebases)
jj edit xrkzmpqw
# Working copy now points to that change

# "Stash" current work — switch to parent
jj edit @-
# Current change is abandoned / parent becomes working copy
# To return: jj edit @- again (original change is descendant)

# Make changes to old commit
jj describe -m "Update old commit message"
# jj creates a new working copy on top automatically

# Return to main
jj edit main
```

## Rationale

In jj, any revision can be edited — there is no concept of "detached HEAD" or "read-only commits." When you `jj edit` a revision and make changes, jj creates a new working-copy change that has the edited revision as its parent. This is safe because jj's change-oriented model tracks identity by change ID, not by position in the DAG.

The `jj edit @-` pattern replaces `git stash` entirely: instead of stashing, you just switch to the parent change. Your original change remains in the DAG as a descendant.

## Related Skills
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
- [jj-command-undo](file://.opencode/skills/jj-command-undo.md)
- [jj-command-abandon](file://.opencode/skills/jj-command-abandon.md)
