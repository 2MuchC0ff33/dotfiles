# jj-git-format-patch-am

## Description
jj has no native email-based workflow (no `jj format-patch` or `jj am`). Use `git format-patch` / `git am` for kernel-style and mailing-list-based patch workflows.

## When to Load
Load this skill when submitting patches to email-based projects (Linux kernel, Git, some open-source projects), applying patches from mailing lists, or participating in patch-based code review workflows.

## Source
STANDARDS.adoc §10.2.7 (lines 3557–3558)

## Key Rules

- MANDATE: Use `git format-patch` to generate patch files from commits — the standard `git` tool works on the underlying git objects that jj manages.
- MANDATE: Use `git am` to apply patch files — jj will see the result as new changes after the next `jj log` or `jj status`.
- MANDATE: Before running `git format-patch`, ensure jj has materialized its changes as git commits (which it does automatically on most operations — if in doubt, run `jj git push --dry-run` or `jj git export` to force materialization).
- SHOULD: After `git am`, run `jj status` to see the newly applied patch as the current change in jj.
- SHOULD: Use `git send-email` for sending patches if the project uses a mail-based workflow.

## Example

```bash
# Generate patches from jj-managed commits
# First, make sure changes are materialized
jj git push --dry-run
# or
jj git export

# Generate patch files from the last 3 commits
git format-patch -3 --stdout > my-patches.mbox
# or individual files:
git format-patch -3
# Creates: 0001-first-commit.patch, 0002-second-commit.patch, ...

# Send patches via email
git send-email --to=project@vger.kernel.org 0001-*.patch

# Apply patches received via email
git am < incoming-patch.mbox
# or
git am 0001-fix-bug.patch

# Verify in jj
jj log
# New change appears with the applied patch content
```

## Why no email workflow in jj

jj's design targets modern software development workflows (GitHub/GitLab pull requests, CI/CD, code review platforms). Email-based patch workflows (kernel-style, GNU-style) predate these platforms and use a fundamentally different collaboration model based on `git format-patch` / `git send-email` / `git am`.

The jj maintainers have chosen not to implement these commands because:

1. The email workflow is a niche use case in modern development
2. Standard `git` commands work transparently on the shared git object store
3. Implementing `jj format-patch` would add maintenance burden without proportional benefit

This is a conscious design decision, not a deficiency — the standard accepts this and falls back to `git` for these rare workflows.

## Related Skills
- [jj-git-direct-commands](file://.opencode/skills/jj-git-direct-commands.md)
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
- [jj-collaboration-gh-cli](file://.opencode/skills/jj-collaboration-gh-cli.md)
