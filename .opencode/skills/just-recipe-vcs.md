# just-recipe-vcs

## Description
Version control recipes wrapping jj (Jujutsu) for common operations.

## When to Load
Load this skill when implementing, modifying, or documenting the `status`, `log`, `diff`, `undo`, `new`, `describe`, or `push` recipes in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2822–2848)

## Key Rules

- MANDATE: All VCS recipes MUST use `jj` commands (not `git`), as the project uses jj as the primary VCS with a git backend.
- MANDATE: `status` MUST run `jj status` — shows working copy status (equivalent to `git status` but with jj semantics).
- MANDATE: `log` MUST run `jj log` — shows the revision graph with change IDs, commit IDs, and bookmarks.
- MANDATE: `diff` MUST run `jj diff` — shows diff of working copy changes (uses `delta` under the hood if configured).
- MANDATE: `undo` MUST run `jj undo` — reverts the last jj operation (commit, rebase, describe, etc.).
- MANDATE: `new BRANCH` MUST run `jj new --insert-after {{BRANCH}}` — creates a new change on top of the specified bookmark.
- MANDATE: `describe MSG` MUST run `jj describe -m {{MSG}}` — sets the description (commit message) on the current change.
- MANDATE: `push` MUST run `jj git push` — pushes all git commits that were exported from jj changes.
- SHOULD: Use `just new <branch>` instead of `jj new` for consistency (just recipe centralizes the flag usage).
- SHOULD: Use `just describe "message"` with quotes around multi-word messages.
- FORBIDDEN: Do NOT use `git` commands in VCS recipes — the project is `jj` primary.
- FORBIDDEN: Do NOT add `--all` or `--remote-only` to `jj log` — the default log is sufficient.
- FORBIDDEN: Do NOT use `jj branch create` — the correct command is `jj new`.

## Examples

```just
# Show repository status
status:
    jj status

# Show log with graph
log:
    jj log

# Show diff
diff:
    jj diff

# Undo last operation
undo:
    jj undo

# Create new change (branch)
new BRANCH:
    jj new --insert-after {{BRANCH}}

# Describe current change (commit message)
describe MSG:
    jj describe -m {{MSG}}

# Push to GitHub
push:
    jj git push
```

Usage:
```sh
just status              # Check current working copy state
just log                 # View revision graph
just diff                # Review unstaged changes
just new my-feature      # Create new change on current commit
just describe "feat: add widget"  # Set commit message
just push                # Push to GitHub via jj git push
just undo                # Undo last jj operation
```

## Related Skills
- [just-recipe-release](file://.opencode/skills/just-recipe-release.md)
