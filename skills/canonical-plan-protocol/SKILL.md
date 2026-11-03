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
- CVS is the local VCS; Git mirrors to GitHub.
