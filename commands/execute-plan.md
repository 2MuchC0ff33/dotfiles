---
description: Execute the READY handover for the current repository
agent: build
---

Execute the canonical, repo-scoped plan handover.

## 1. Resolve the plan

Run:

```sh
pm resolve-plan -- "$ARGUMENTS"
```

- Exit 0 prints the selected plan directory. Use it verbatim.
- Exit 2 means zero or multiple READY handovers. Stop (SC-0 or SC-2).
- Exit 3 means the plan Repo differs from the current repository root. Stop
  before any mutation (SC-3).
- Exit 4 means the handover identity block is invalid. Stop (SC-4).
- Exit 5 means an unsafe plan path or argument. Stop (SC-10).

Do not search flat files in ~/.opencode/plan. Do not change directory to any
path other than the selected handover's Repo.

## 2. Read the handover

Read from the selected plan directory only:

  HANDOVER.md PLAN.md WORKORDER.md INDEX.md RISKS.md PROOF.md
  QUESTIONS.md GIT.md PATCHES.md MANIFEST.txt TRACEABILITY.md

If any is missing, stop (SC-1). If Status is BLOCKED, stop (SC-4).

## 3. Identity and preflight

Verify the identity block:

- Repo equals the resolved repository root.
- VCS matches the detected VCS.
- Plan-Dir equals the selected directory.

Stop on any mismatch (SC-3).

Preflight inside Repo:

- CVS: `cvs -d "$CVS_ROOT" status`, then
  `cvs -d "$CVS_ROOT" update -PAd`, then
  `cvs -d "$CVS_ROOT" diff -u`. The tree must be clean (SC-5).
- Git: `git status --porcelain`, `git rev-parse --abbrev-ref HEAD`,
  `git remote -v`. The tree must be clean (SC-5).

Do not run the Gates during preflight. They are acceptance gates and run
after implementation, because a plan that changes the verifier cannot pass
them before its own work packages are applied. Preflight is read-only apart
from the VCS status and update commands above.

## 4. CVS-first

If VCS is git, or Migration is required, follow GIT.md:

```sh
pm cvs-migrate --repo "$REPO" --dry-run
pm cvs-migrate --repo "$REPO" --apply
```

Run `--apply` only after the operator confirms the dry-run output. Stop after
migration if Stop-After is migrate. Verify the imported CVS checkout before
implementing.

If VCS is cvs, use the CVS root and module from the identity block. Never use
~/CVS/dotfiles unless Repo is the dotfiles checkout.

## 5. Implement

Follow WORKORDER.md in order. Do not skip W0, the migration package, or the
final verification package. Do not commit generated files. Do not edit the
toolchain unless the work order says so.

## 6. Verify

Split the Gates value on the literal ` | ` (space pipe space). A value of
`none` means no gates. Run each command from Repo with `sh -c`. Then run the
work order's verification package. Any missing target, non-zero exit, or
failed check stops the build (SC-7). Do not add gates that the handover does
not declare.

## 7. Mirror

Only if Git-Remote is not none. Follow GIT.md: signed snapshot per branch,
fast-forward push, verify both refs. No force-push (SC-8).

## 8. Report

Report the repo, plan id, VCS, CVS root and module, migration result, gates
with exit codes, mirror commits, and residual risks.
