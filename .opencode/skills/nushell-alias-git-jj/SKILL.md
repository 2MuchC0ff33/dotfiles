---
name: nushell-alias-git-jj
description: Description
compatibility: opencode
---

# nushell-alias-git-jj

## Description
Alias `git` to `jj` (Jujutsu), the primary version control tool, which is git-compatible.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3701), §10 (lines 3360–3642)

## Key Rules

- MANDATE: `alias git = jj` MUST be present in `config.nu` with the comment `# jj as primary VCS (git-compatible)`.
- SHOULD: All `git` commands in the shell transparently delegate to `jj` for its superior workflow (undoable operations, auto-squashing, conflict resolution).
- FORBIDDEN: Omitting this alias — standard git workflows lose the undo safety and change-tracking benefits of jj.

## Rationale

Jujutsu (`jj`) is the organization's primary version control tool. It is
git-compatible: `jj` repos ARE git repos (with a `.git/` directory). The
alias ensures:

- **Muscle memory preserved**: Type `git status`, get `jj status` output
- **No retraining**: All standard git subcommands work (via `jj git` bridge)
- **Undo safety**: `jj undo` reverses any operation (not just last commit)
- **Better workflow**: Working-copy-as-a-commit, auto-squashing, conflict resolution
- **Colocated repos**: `jj git init --colocate` maintains both `.jj/` and `.git/`

When you need real git (submodules, `gh` CLI, CI scripts), the `^git`
prefix explicitly calls the git binary, bypassing the alias.

## Example

```nushell
alias git = jj                    # jj as primary VCS (git-compatible)
```

Usage:
- `git status` → `jj status` (shows working copy changes)
- `git log` → `jj log` (graph view with change IDs)
- `git push` → `jj git push` (pushes real git commits to remote)
- `^git push` → bypasses alias, calls real git

## Related Skills
- [nushell-alias-diff-delta](file://.opencode/skills/nushell-alias-diff-delta.md)
