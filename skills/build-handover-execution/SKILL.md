---
name: Build Handover Execution
description: Use when executing a READY handover, including CVS import, mirror push, verification, and gpg signing.
---

# Build Handover Execution

Read HANDOVER.md first. Check READY. Run preflight. Execute WORKORDER.md in
order. Verify before executing with `pm verify` and `pm upgrade-check`. Keep
generated files out of source control. Stop on any failed gate.
Do not force-push. Verify signatures. Report evidence and residual risks.
