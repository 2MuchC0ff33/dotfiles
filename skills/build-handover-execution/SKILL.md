---
name: Build Handover Execution
description: Use when executing a READY handover, including identity verification, CVS-first migration, mirror push, verification, and gpg signing.
---

# Build Handover Execution

Read HANDOVER.md first. Require Status READY. Verify Repo, VCS, and Plan-Dir
against the resolved repository root. Stop on any mismatch before mutation
(SC-3). Read only the selected plan directory.

Run preflight with the detected VCS. Run only the gates declared in the
handover. CVS is canonical. Migrate a Git-only repository with
`pm cvs-migrate --dry-run`, then `--apply` after confirmation. Keep generated
files out of source control. Do not force-push. Verify signatures. Report
evidence and residual risks.
