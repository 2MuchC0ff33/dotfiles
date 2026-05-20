# jj-collaboration-gh-cli

## Description
Use the `gh` CLI (GitHub CLI) to create pull requests since jj has no native `jj gh submit` command yet.

## When to Load
Load this skill when creating a pull request on GitHub from a jj-managed repository, reviewing PR status from the CLI, or managing GitHub-specific workflows (issues, releases, checks).

## Source
STANDARDS.adoc §10.2.7 (lines 3555–3556)

## Key Rules

- MANDATE: Use `gh pr create` (or the GitHub web UI) to create pull requests — jj does not have a `jj gh submit` command as of version 0.41.0.
- MANDATE: Before creating a PR, push your changes with `jj git push` so they exist on the remote.
- MANDATE: All standard `gh` workflows work because jj pushes real git commits — `gh pr create`, `gh pr review`, `gh pr merge`, `gh pr checks`, `gh issue create`, etc.
- SHOULD: Use `gh pr create --fill` to automatically populate the PR title and body from the change description.
- SHOULD: Use `gh pr create --web` to open the GitHub web UI for PR creation with more editing capabilities.
- FORBIDDEN: Do NOT wait for `jj gh submit` to be implemented — use `gh` CLI today. The gap is known and tracked.

## Example

```bash
# Push changes first
jj git push

# Create a PR from the pushed change
gh pr create --fill
# (PR title and body from change description)

# Create a PR with explicit details
gh pr create \
  --title "Add rate limiting to API" \
  --body "Implements rate limiting using a token bucket algorithm." \
  --base main

# Create a PR in the browser
gh pr create --web

# Review PR status
gh pr status
gh pr checks

# Merge a PR (after approvals)
gh pr merge --squash
```

## Why no jj gh submit?

jj's development has prioritized core VCS operations (rebase, squash, split, conflict resolution) over GitHub-specific integrations. The `jj gh submit` feature is a known gap that may be addressed in future releases. In the meantime:

- The `gh` CLI is the standard GitHub CLI tool, installed and configured per STANDARDS.adoc toolchain
- All `gh` commands work without modification because jj pushes real git commits
- The GitHub web UI is a fully supported alternative for PR creation

## Related Skills
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
- [jj-collaboration-branch-protection](file://.opencode/skills/jj-collaboration-branch-protection.md)
- [jj-git-direct-commands](file://.opencode/skills/jj-git-direct-commands.md)
