# jj-command-log

## Description
`jj log` — Show the commit DAG graph with change IDs, commit IDs, bookmarks, and descriptions in the configured compact format.

## When to Load
Load this skill when reviewing commit history, understanding the DAG structure, finding change/commit IDs, checking what bookmarks exist, or verifying the result of a rebase/squash/split operation.

## Source
STANDARDS.adoc §10.2.4 (lines 3456–3458)

## Key Rules

- MANDATE: Use `jj log` instead of `git log --graph` for viewing history — it shows the graph, change IDs (stable identifiers), commit IDs (git hashes), bookmarks (branches/tags), and descriptions by default.
- MANDATE: The output format is controlled by the `[templates] log` configuration (see `jj-config-log-template`). Default output per standard: one line per change with `change_id shortest`, `commit_id.shortest`, `bookmarks`, `description`, `empty` indicator.
- SHOULD: Use `jj log -r <revision>` to limit the log to a specific revision and its ancestors.
- SHOULD: Use `jj log --reversed` to show oldest-first ordering.
- SHOULD: Use `jj log --no-graph` for plain output suitable for piping to other tools.

## Example

```bash
# Show default log (compact template)
jj log
# @  yqpqzopv 7a3b8c2f feat-api Add rate limiting  (empty)
# o  xrkzmpqw 9d1e2f3a main      Fix login handler
# o  mplwqxyz 4a5b6c7d           Initial commit

# Show full change IDs and commit IDs
jj log --color=always
# (same format, with colors per [colors] config)

# Log for a specific revision
jj log -r main
# o  xrkzmpqw 9d1e2f3a main Fix login handler
# o  mplwqxyz 4a5b6c7d      Initial commit

# Log with author and date (using --template override)
jj log --template 'change_id " " author.email() " " description "\n"'
```

## Output Field Reference

| Field | Description | Stable across rebase? |
|---|---|---|
| `change_id` | jj's permanent change identifier | Yes — never changes |
| `commit_id` | Git commit hash (SHA-1) | No — changes on rebase |
| `bookmarks` | Branches and tags pointing to this change | No — moves with rebase |
| `description` | Commit message | No — changes on describe |
| `empty` | Shows `(empty)` if change has no file diffs | — |

## Related Skills
- [jj-config-log-template](file://.opencode/skills/jj-config-log-template.md)
- [jj-config-colors](file://.opencode/skills/jj-config-colors.md)
- [jj-command-status](file://.opencode/skills/jj-command-status.md)
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
