# jj-command-split

## Description
`jj split` — Interactively split the current change into two changes at the file level, allowing granular commit organization.

## When to Load
Load this skill when a single change contains unrelated modifications that should be separate commits, or when preparing a clean PR with distinct logical changes.

## Source
STANDARDS.adoc §10.2.4 (lines 3441–3442)

## Key Rules

- MANDATE: Use `jj split` on the current working change to interactively split it into two changes — the first containing selected files/diffs and the second containing the remainder.
- MANDATE: When `jj split` is invoked, jj opens the configured diff editor (`hx` per the standard `diff-editor` config) allowing you to select which diffs go into the first change vs the second.
- MANDATE: After split, the current change (the original) is replaced by two changes: the first becomes the parent of the second, and the working copy moves to the second change.
- SHOULD: Use `jj split --interactive` to guarantee interactive mode even if non-interactive fallback is configured.
- SHOULD: Use `jj split <revision>` to split a change that is not the current working copy.
- FORBIDDEN: Do NOT split changes that have already been pushed to a shared remote — splitting rewrites commit IDs.

## Example

```bash
# Create a change with mixed edits
jj new
# ... edit src/api.rs and src/db.rs ...
# ... make unrelated changes in the same work session ...

# Split into two logical changes
jj split
# Interactive diff editor opens (hx):
# - Select diffs from src/api.rs for first change
# - Deselect diffs from src/db.rs (they stay in second change)

# Result:
jj log
# @  yzabcd01  wip       (contains db.rs changes only)
# o  wxzyzx90  wip       (contains api.rs changes only)

# Each can now be described independently
jj describe -m "Add database connection pool"
jj new
# ... (now working on a new change)
```

## Split Workflow Detail

1. Run `jj split` — jj computes the diff of the current change vs its parent
2. The configured `diff-editor` (`hx`) opens with an interactive diff interface
3. In the editor, you select hunks/lines to include in the first (new parent) change
4. Save and exit — jj creates two changes:
   - Change 1 (new parent): contains the selected diffs
   - Change 2 (new working copy): contains the remaining diffs
5. Both changes retain the same description as the original

## Related Skills
- [jj-command-squash](file://.opencode/skills/jj-command-squash.md)
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
- [jj-command-describe](file://.opencode/skills/jj-command-describe.md)
- [jj-command-undo](file://.opencode/skills/jj-command-undo.md)
