# jj-git-no-prepare-commit-msg

## Description
jj's model has no `prepare-commit-msg` hook equivalent because `jj new` creates a change without a commit message — `jj describe` is a separate, explicit step.

## When to Load
Load this skill when migrating from git hooks that leveraged `prepare-commit-msg` (e.g., for automatic ticket number insertion, template generation, or sign-off lines), or when setting up a jj project that previously relied on commit-msg hooks.

## Source
STANDARDS.adoc §10.2.7 (lines 3552–3553)

## Key Rules

- MANDATE: Do NOT install or configure `prepare-commit-msg` git hooks in a jj-managed repository — jj does not trigger this hook because `jj new` does not set a commit message.
- MANDATE: The `describe-commit-message` hook in jj (if configured) is the analog of git's `commit-msg` hook, NOT `prepare-commit-msg`. It runs when `jj describe` is called.
- MANDATE: Workflows that relied on `prepare-commit-msg` to auto-fill templates must be reimplemented using either:
  - jj's `default-description = "wip"` (already configured per standard) with a manual describe step
  - jj's `describe-commit-message` hook for validation/transformation of commit messages at describe time
  - An explicit `jj describe -m "$(make-msg)"` invocation in scripts or aliases
- SHOULD: Use jj hooks (if available) or editor template files (e.g., `hx` snippets) instead of git hooks for commit message automation.
- FORBIDDEN: Do NOT expect git's `prepare-commit-msg` hook to run — it is part of git's commit pipeline, which jj bypasses.

## Example

```bash
# In git, you might have:
# .git/hooks/prepare-commit-msg:
#   #!/bin/sh
#   echo "TICKET-$(ticket-number): " >> "$1"
# This hook runs on every 'git commit', prepending a ticket number.

# In jj, there is no equivalent because:
# jj new        # creates a change, NO commit message, NO hook trigger
# jj describe   # sets the description explicitly, triggers describe-commit-message

# Workaround: use a shell function or alias
function jj-describe-with-ticket() {
  local msg=${1:-$(ticket-number)}
  jj describe -m "$msg"
}

# Or: use jj's describe-commit-message hook
# In .jj/config.toml (repo-level):
# [hooks]
# describe-commit-message = "/path/to/hook/script"
# The hook receives the current description on stdin and can transform it.
```

## Rationale

This is not a deficiency — it's a consequence of jj's improved design. In git, `git commit` combines the creation of a commit object with the setting of its commit message. This forces the `prepare-commit-msg` hook to exist because the two concerns are conflated.

In jj, `jj new` creates a change (with no message), and `jj describe` separately sets the message. This separation means:

- No need for a "prepare" step — there is nothing to prepare
- The `default-description` config replaces simple template hooks
- Commit message validation and transformation belong in `describe-commit-message` hooks, which are conceptually cleaner

## Related Skills
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
- [jj-command-describe](file://.opencode/skills/jj-command-describe.md)
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
