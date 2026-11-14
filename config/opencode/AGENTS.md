# Canonical Development Workflow (global)

This file applies to every OpenCode session. Project instructions are combined
with this file. A project AGENTS.md may pin a toolchain for its own repository
with the exception mechanism below; it must never change another repository.

## Repository identity

Resolve identity before planning or executing:

1. Walk up from the working directory to the nearest ancestor containing .git
   or CVS/Root. That ancestor is the repository root.
2. The repository name is the basename of that root. It is not the dotfiles
   directory unless the root really is the dotfiles checkout.
3. Record Repo, Repo-Name, and VCS in the handover identity block.
4. If no repository root exists, require an explicit plan id. Never guess.

The canonical toolchain lives at /home/twomuchcoffee/.local/src/dotfiles. It
is a toolchain, not the current project. Never use it as the working
directory, the repository root, or a gate target unless the selected plan's
Repo is that checkout.

## Version control

CVS is the canonical local VCS. Git is a mirror to GitHub.

- A repository with CVS/Root is a CVS checkout. Commit with cvs. Push the
  mirror only after CVS verification.
- A repository with .git and no CVS/Root is Git-only. The plan must include a
  CVS migration work package before implementation.
- No force-push. No history rewrite. No deleted history.

## Plan artifacts

Plan directories are ~/.opencode/plan/<repo>/<plan-id>/ and contain:

  HANDOVER.md PLAN.md WORKORDER.md INDEX.md RISKS.md PROOF.md
  QUESTIONS.md GIT.md PATCHES.md MANIFEST.txt TRACEABILITY.md

Flat artifacts directly in ~/.opencode/plan/ are legacy. They are never read
as a default.

Every HANDOVER.md starts with these ASCII key-value lines:

  Repo: <absolute repository root>
  Repo-Name: <basename>
  VCS: cvs|git|none
  CVS-Root: <absolute path or none>
  CVS-Module: <module or none>
  Git-Remote: <url or none>
  Plan-ID: <YYYY-MM-DD-slug>
  Plan-Dir: <absolute plan directory>
  Status: READY|BLOCKED
  Gates: <gate> | <gate> | ...
  Migration: required|not-required
  Stop-After: none|migrate

The identity block is verified before any gate or edit.

## Toolchain defaults

- POSIX.1-2017, POSIX make, Lua 5.4.9 primary. Shell is orchestration only.
- Lua does not spawn processes. Orchestrate from sh.
- Documentation is plain ASCII. Repository docs use .txt except tool-mandated
  .md files.
- Generated files are never committed.
- A project AGENTS.md may declare its exceptions in the Exceptions field of
  its managed profile block. Each exception begins "Toolchain exception:" or
  "Gate exception:" and names the reason. Exceptions govern that repository
  only. Gates declared by the repository then govern that repository only.

## Plan protocol

Phases:

0. Intake: repository root, repository name, VCS, OpenCode version, toolchain,
   plan namespace.
1. Parallel evidence sweep: 3-5 subagents.
2. Batched questions: maximum 7 per call, recommended option first.
3. Assumption verification with locators.
4. Risk register and rollback.
5. Invariants, properties, tests, counterexamples, evidence tiers.
6. Traceability matrix.
7. Handover drafting.
8. Ask once for write consent. Write only to
   ~/.opencode/plan/<repo>/<plan-id>/.
9. Stop. Tell the operator to switch to Build and run /execute-plan.

Rules:

- Maximum 12 subagents per request, including nested calls.
- Subagents never edit and never ask questions.
- Every claim carries a locator or an owner.
- Every MUST maps to a test.
- Never claim proof without naming scope, prover/model, and unmodelled
  assumptions.
- If a blocking ambiguity remains, write a BLOCKED handover.

## Execution

/execute-plan selects a READY handover only from the current repository's plan
namespace. A handover whose Repo differs from the resolved repository root is
not executed. The build-handover-execution skill defines the stop conditions.
