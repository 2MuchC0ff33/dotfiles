# jj-command-status

## Description
`jj status` — Show the current working-copy state: parent change, working-copy change, conflicts, and working-copy modifications.

## When to Load
Load this skill when you need to understand the current state of your working copy, check for conflicts, see what files are modified, or verify which parent change you're working on top of.

## Source
STANDARDS.adoc §10.2.4 (lines 3417–3418)

## Key Rules

- MANDATE: Use `jj status` instead of `git status` — jj status provides richer information including the working-copy parent, conflict status, and change description.
- MANDATE: Before starting any operation, run `jj status` to confirm you are on the correct change and there are no unexpected conflicts.
- SHOULD: Run `jj status` after `jj rebase`, `jj squash`, or `jj split` to verify the operation produced the expected state.
- FORBIDDEN: Do NOT ignore files listed under "Conflicts:" in `jj status` output — they must be resolved before pushing (per `push-conflict = false` config).

## Example

```bash
$ jj status
Parent commit: qrstuvw9 main | Fix login handler
Working copy : xyzabc12 feat-api | Add rate limiting
Working copy changes:
  A src/api/rate_limiter.rs
  M src/api/mod.rs
  D src/legacy/ratelimit_old.rs
No conflicts.
(The working copy is clean)
```

The output shows:
1. **Parent commit**: The change your working copy is based on (with change ID, bookmarks, description).
2. **Working copy**: Your current change (with change ID, bookmarks, description).
3. **Working copy changes**: List of files added (A), modified (M), deleted (D), or with conflicts.
4. **Conflict status**: Either "No conflicts" or a list of conflicted files.

## Comparison with git status

| Aspect | `git status` | `jj status` |
|---|---|---|
| Staged vs unstaged | Shows both stages | No staging area — all changes are "unstaged" |
| Parent information | Shows upstream branch | Shows exact parent change ID and description |
| Conflict display | Shows "both modified" | Lists conflicted files with markers |
| Branch tracking | Shows ahead/behind | Shows bookmark position relative to parent |

## Related Skills
- [jj-command-log](file://.opencode/skills/jj-command-log.md)
- [jj-command-resolve](file://.opencode/skills/jj-command-resolve.md)
- [jj-command-undo](file://.opencode/skills/jj-command-undo.md)
