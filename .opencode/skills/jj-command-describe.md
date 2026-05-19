# jj-command-describe

## Description
`jj describe -m "msg"` — Set or update the description (commit message) of the current change. Idempotent — running it multiple times just updates the message.

## When to Load
Load this skill when setting the commit message for a change, amending a commit message, or adding detail to a change before pushing.

## Source
STANDARDS.adoc §10.2.4 (lines 3425–3426, 3433–3434)

## Key Rules

- MANDATE: Use `jj describe -m "message"` to set the description of the current change — this is the equivalent of `git commit -m "msg"`.
- MANDATE: `jj describe` is idempotent — you can run it as many times as needed. Each run updates the description in place (equivalent to `git commit --amend` but without the mental overhead of amend vs commit).
- MANDATE: After describing a change, create the next working change with `jj new` — do NOT continue editing in the same described change.
- SHOULD: Use `jj describe` without `-m` to open the configured editor (`hx` per standard) for multi-line descriptions.
- SHOULD: Replace the default "wip" description with a meaningful message before pushing to a shared remote.
- FORBIDDEN: Do NOT use `jj describe` on changes that have already been pushed to a shared remote — this rewrites the git commit, requiring force-push.

## Example

```bash
# Start new work
jj new feat-api
# (description defaults to "wip" from config)

# Set description inline
jj describe -m "Add rate limiting to API endpoints"

# Amend description (idempotent)
jj describe -m "Add rate limiting to API endpoints (429 handling)"

# Open editor for multi-line description
jj describe
# (opens hx, write detailed message, save and quit)

# Verify
jj log
# o  abcdef12  Add rate limiting to API endpoints (429 handling)  feat-api
```

## Rationale

jj's model separates "creating a change" (`jj new`) from "describing a change" (`jj describe`). This is fundamentally different from git, where `git commit` does both. The separation means you can create many small working changes, test them, and describe them later. The idempotent nature of `jj describe` eliminates the `git commit --amend` vs `git commit` confusion — it always does the right thing.

## Related Skills
- [jj-command-new](file://.opencode/skills/jj-command-new.md)
- [jj-command-log](file://.opencode/skills/jj-command-log.md)
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
