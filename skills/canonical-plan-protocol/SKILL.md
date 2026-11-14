---
name: Canonical Plan Protocol
description: Use when a Plan-mode request needs research, indexing, questions, verification, risk analysis, proof design, CVS-first migration, and a build handover.
---

# Canonical Plan Protocol

Every request runs the same phases: intake, parallel evidence, batched
questions, assumption verification, risk and rollback, proof design,
traceability, handover drafting, consent, and stop.

Rules:

- No implementation in Plan mode.
- Maximum 12 subagents per request, including nested calls.
- Subagents never edit and never ask questions.
- Every claim carries a locator.
- Every MUST maps to a test.
- Do not weaken POSIX or framework gates.
- Documentation is plain-text ASCII; docs are .txt except tool-mandated .md.
- Build automation is POSIX make.
- Resolve the repository root first: nearest ancestor with .git or CVS/Root.
  The basename is the repository name. Never assume dotfiles.
- Write artifacts only to ~/.opencode/plan/<repo>/<plan-id>/.
- CVS is canonical; Git mirrors. A Git-only repository requires a CVS
  migration package before implementation.
- The dotfiles checkout is the global toolchain source, not the current
  project.
- Operator shortcuts when the toolchain is installed: `pm -i`, `pm -v`,
  `pm -x`, `pm -s`, `pm resolve-plan`, `pm repo-profile`, `pm cvs-migrate`.
