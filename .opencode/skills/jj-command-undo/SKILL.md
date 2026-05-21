---
name: jj-command-undo
description: Description
compatibility: opencode
---

# jj-command-undo

## Description
`jj undo` — Revert the last operation (or a specified operation) atomically, restoring the entire repo state to before that operation.

## When to Load
Load this skill after any unintended operation — accidental abandon, wrong rebase, incorrect squash, mistaken describe, or any other modification to the repo state.

## Source
STANDARDS.adoc §10.2.4 (lines 3467–3468)

## Key Rules

- MANDATE: Use `jj undo` instead of `git reset` or reflog-based recovery — jj undo is a single atomic operation that restores the full repo state.
- MANDATE: `jj undo` undoes the most recent operation by default. Use `jj undo --operation <op-id>` to undo a specific historical operation.
- MANDATE: Undo is non-destructive — it creates a new operation that reverses the previous one, preserving a complete audit trail in the operation log.
- SHOULD: Run `jj status` after `jj undo` to verify the state is restored as expected.
- SHOULD: Use `jj undo` repeatedly to walk backwards through the operation history (each call undoes one more earlier operation).
- FORBIDDEN: Do NOT use `jj undo` on operations that have been pushed to a shared remote — the undo would create divergent history on the remote.

## Example

```bash
# Accidentally abandoned a change
jj abandon
# (change is marked abandoned)

# Undo the abandon
jj undo
# Change is restored, working copy returns to previous state

# Undo a wrong rebase
jj rebase -d main
# (rebase went wrong)

jj undo
# Rebase is reversed, change returns to original parent

# Undo multiple operations
jj undo   # undo operation 3
jj undo   # undo operation 2
jj undo   # undo operation 1

# Undo a specific operation by ID
jj operation log
# @  3a2b1c0d rebase feat-api onto main
jj undo --operation 3a2b1c0d
# Only that rebase is undone

# Verify the state
jj status
jj log
```

## Rationale

jj's operation log is an append-only log of every repo mutation. Each `jj undo` pushes a new "undo" operation onto this log, effectively creating a reverse of the target operation. This design means:

- Undo is always available and always safe — it's just adding data, never deleting it
- Multiple undos navigate the operation history like an immutable stack
- The operation log provides a complete audit trail of every state the repo has been in
- No equivalent of `git reflog` surgery or `ORIG_HEAD` gymnastics is needed

This aligns with STANDARDS.adoc §0.2 (Data-oriented): the operation log is append-only data, and undo is just adding more data.

## Related Skills
- [jj-command-abandon](file://.opencode/skills/jj-command-abandon.md)
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-status](file://.opencode/skills/jj-command-status.md)
- [jj-command-resolve](file://.opencode/skills/jj-command-resolve.md)
