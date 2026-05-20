# jj-git-direct-commands

## Description
Known edge cases where `jj` cannot handle an operation and direct `git` commands must be used as fallback.

## When to Load
Load this skill when encountering an operation that jj does not support, troubleshooting a jj error that mentions using git directly, or managing submodules, signed tags, protocol-specific operations, or email-based patch workflows.

## Source
STANDARDS.adoc §10.1 (lines 3362–3389), §10.2.7 (lines 3544–3559)

## Key Rules

- MANDATE: For the following operations, fall back to direct `git` commands:
  1. **Git submodules**: `git submodule init`, `git submodule update`, `git clone --recurse-submodules`
  2. **Email-based patch workflow**: `git format-patch`, `git send-email`, `git am`
  3. **Force-pushing**: `git push --force-with-lease` when jj's `jj git push --force-with-lease` does not handle the specific case
  4. **Deleting remote branches**: `git push origin --delete <branch>`
  5. **Merging (octopus, recursive strategy)**: `git merge` with specific strategy options not supported by jj
  6. **Bisecting**: `git bisect` for regression hunting
  7. **Low-level git operations**: `git fsck`, `git gc`, `git repack`, `git prune`
  8. **Protocol-specific operations**: `git ls-remote`, `git archive --remote`
- MANDATE: After any direct `git` operation, run `jj status` and `jj log` to ensure jj's view of the repository is consistent.
- MANDATE: The dual-layer architecture (jj on top of git storage) means direct `git` commands are always safe — they operate on the same `.git/` objects that jj uses.
- SHOULD: Before using a direct `git` command, check if there is a `jj` equivalent by reading jj's help: `jj --help`.
- FORBIDDEN: Do NOT use `git checkout`, `git switch`, `git commit`, `git rebase`, `git reset`, `git stash`, `git add`, or other core workflow commands that have direct `jj` equivalents — using them will bypass jj's operation log and change tracking.

## Example

```bash
# BAD: using jj operations when a direct git command is needed
# jj does not handle submodules
# jj status will not show submodule status correctly!

# GOOD: fall back to git for submodules
git submodule update --init --recursive

# GOOD: bisect with git (jj has no bisect)
git bisect start HEAD v1.0.0
git bisect run make test

# GOOD: force-push when jj's mechanism doesn't suffice
git push --force-with-lease origin feat-api:feat-api

# GOOD: delete remote branch
git push origin --delete old-feature-branch

# After any direct git command, verify jj is in sync:
jj status
jj log
# jj should show the changes made by the git command
```

## Quick Reference: git vs jj for edge cases

| Operation | Tool | Command |
|---|---|---|
| Submodules | `git` | `git submodule update` |
| Email patches | `git` | `git format-patch` / `git am` |
| Force-push | `jj` / `git` | `jj git push --force-with-lease` (prefer), `git push --force-with-lease` |
| Delete remote branch | `git` | `git push origin --delete <branch>` |
| Bisect | `git` | `git bisect` |
| Maintenance | `git` | `git fsck`, `git gc`, `git prune` |
| Core workflow | `jj` | `jj new`, `jj describe`, `jj rebase`, `jj squash` |
| Stash | `jj` | `jj edit @-` |
| Log | `jj` | `jj log` |

## Related Skills
- [jj-git-gap-submodules](file://.opencode/skills/jj-git-gap-submodules.md)
- [jj-git-format-patch-am](file://.opencode/skills/jj-git-format-patch-am.md)
- [jj-init-colocate](file://.opencode/skills/jj-init-colocate.md)
