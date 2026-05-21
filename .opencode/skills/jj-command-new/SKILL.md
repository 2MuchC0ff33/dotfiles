---
name: jj-command-new
description: Description
compatibility: opencode
---

# jj-command-new

## Description
`jj new [BRANCH]` — Creates a new change on top of the current working copy (`@`), optionally starting from a named branch.

## When to Load
Load this skill when starting work on a new feature or fix, creating a new change in the commit DAG, or branching off from an existing branch.

## Source
STANDARDS.adoc §10.2.4 (lines 3449–3451, 3464–3465)

## Key Rules

- MANDATE: Use `jj new <name>` to create a new change that is a child of the current working-copy change (`@`).
- MANDATE: After describing a change with `jj describe -m "msg"`, use `jj new` to create the next change in sequence (equivalent to creating a new commit after committing in git).
- SHOULD: Pass a branch name as the argument when you want the new change to be associated with a named bookmark (e.g., `jj new feat-xyz`). This creates the change and optionally creates a bookmark.
- SHOULD: Use `jj new <revision>` to create a child of any arbitrary revision (e.g., `jj new main` to branch from main).
- FORBIDDEN: Do NOT use `jj new` without a following `jj describe` to set a meaningful description before considering work complete.

## Example

```bash
# Start new work from current location
jj new feat-email-validation
# Created new change on top of @
# Working copy now points to the new change

# Start from main
jj new main
# Created new change on top of main

# Create sequential changes
jj new         # create change A
# ... make edits ...
jj describe -m "Implement login"  # describe A
jj new         # create change B (child of A)
# ... more edits ...
jj describe -m "Add tests"        # describe B

# See the graph
jj log
# o  qrstuvw  Add tests        (working copy)
# o  pqrstuv  Implement login
# o  mnopqrs  main
```

## Rationale

`jj new` is the primary way to create new work in jj. Unlike `git checkout -b`, it does not require a branch name — jj changes are identified by permanent change IDs, not branch names. The branch name argument is optional and creates a bookmark for convenience. The pattern of `jj new → edit → jj describe → jj new → edit → jj describe` is the standard's recommended workflow loop.

## Related Skills
- [jj-command-describe](file://.opencode/skills/jj-command-describe.md)
- [jj-command-log](file://.opencode/skills/jj-command-log.md)
- [jj-command-rebase](file://.opencode/skills/jj-command-rebase.md)
- [jj-command-abandon](file://.opencode/skills/jj-command-abandon.md)
