# jj-git-gap-submodules

## Description
Git submodules are not supported in jj. Use direct `git submodule` commands for submodule operations, working around jj's lack of native submodule tracking.

## When to Load
Load this skill when a project uses git submodules and you need to clone, update, commit, or otherwise manage submodule state within a jj-managed repository.

## Source
STANDARDS.adoc §10.2.7 (lines 3549–3550)

## Key Rules

- MANDATE: Use `git submodule` commands directly for all submodule operations — jj (as of 0.41.0) does not support submodules.
- MANDATE: After any `git submodule update` or `git submodule init` operation, the submodule state change appears in jj as file modifications (the `.gitmodules` file or submodule pointer changes).
- MANDATE: Treat submodule changes as normal file diffs in jj — describe and push them through jj's normal workflow.
- SHOULD: Clone repositories with submodules using `git clone --recurse-submodules` instead of jj's clone, then initialize jj with `jj git init --colocate`.
- SHOULD: Use `git submodule update --remote` outside of jj's workflow when updating submodule pointers.

## Example

```bash
# Clone a repo with submodules (use git, not jj)
git clone --recurse-submodules https://github.com/org/repo.git
cd repo/
jj git init --colocate

# Update submodules later
git submodule update --remote
# Now jj sees changes to the submodule pointer:
jj status
# Working copy changes:
#  M vendor/third-party-lib  (submodule)

# Commit the submodule update through jj
jj describe -m "Update third-party-lib to latest"
jj git push
# Pushes the updated submodule pointer as a normal git commit

# Note: jj cannot recursively show logs or diff submodule contents
# Use git directly for that:
git diff --submodule
```

## Why submodules are a gap

Submodules in git are implemented as a special pointer (a tree entry with a specific mode) combined with a `.gitmodules` configuration file and independent object storage in `.git/modules/`. jj's internal data model does not understand this special pointer format, so it treats submodule changes as opaque file modifications (the commit hash stored in the tree entry changes, but jj doesn't know it's a submodule reference).

This is a known limitation of jj's git compatibility layer. The jj maintainers are aware of it, but it requires significant engineering to fully support.

## Related Skills
- [jj-git-direct-commands](file://.opencode/skills/jj-git-direct-commands.md)
- [jj-init-colocate](file://.opencode/skills/jj-init-colocate.md)
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
