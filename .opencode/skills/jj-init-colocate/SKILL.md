---
name: jj-init-colocate
description: Description
compatibility: opencode
---

# jj-init-colocate

## Description
Initialize jj in an existing git repository using `jj git init`. Since jj 0.41+, `--colocate` is the default behavior — `jj git init` alone creates both `.jj/` and `.git/`, keeping `.git/` intact for GitHub/GitLab interop.

## When to Load
Load this skill when starting to use jj on an existing project, onboarding a team to jj, or adding jj to a repo that already has git history.

## Source
STANDARDS.adoc §10.2.2 (lines 3402–3413)

## Key Rules

- MANDATE: Use `jj git init` inside an existing git repository. Since jj 0.41+, `--colocate` is the default — both `.jj/` and `.git/` are created. For older jj versions (< 0.41), use `jj git init --colocate` explicitly.
- MANDATE: The colocated backend (default since jj 0.41+) creates `.jj/` alongside `.git/`, preserving full git compatibility. GitHub, GitLab, CI, and code review pipelines see nothing different.
- MANDATE: Every `jj` operation creates real git commits — jj does not maintain a separate object store.
- SHOULD: Run `jj git init` from the repository root directory.
- FORBIDDEN: Do NOT run `jj init` (without `git`) on an existing git repo — it creates a standalone jj repo with no git backend, breaking all remote workflows.

## Example

```bash
# Already inside an existing git repo
cd my-project/
git status
# On branch main

# Initialize jj with colocated backend (default since jj 0.41+)
jj git init
# Initialized jj repo in "."
# (creates .jj/ alongside .git/)

# Verify — jj sees the git history
jj log
# Shows existing git commits

# Git commands still work
git status
# Still works normally
```

## Rationale

The colocated backend (default since jj 0.41+) creates a `.jj/` directory that references the existing `.git/` directory for object storage. This means you can use `jj` for daily development while `git` remains available for edge cases (submodules, `git am`, protocol operations). There is no migration step — your existing branches, tags, and history are immediately available.

## Related Skills
- [jj-config-user](file://.opencode/skills/jj-config-user.md)
- [jj-command-log](file://.opencode/skills/jj-command-log.md)
- [jj-git-direct-commands](file://.opencode/skills/jj-git-direct-commands.md)
