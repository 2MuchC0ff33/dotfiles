<!-- canonical-workflow:begin -->
## Canonical workflow (managed block; edit outside the markers)

Repo-Name: dotfiles
VCS: cvs
CVS-Root: /home/twomuchcoffee/CVS/dotfiles
CVS-Module: dotfiles
Git-Remote: none
Plan-Root: ~/.opencode/plan/dotfiles/
Gates: make build | make verify
Toolchain: POSIX.1-2017; POSIX make; Lua 5.4.9
Exceptions: none

Rules:

- CVS is canonical; Git is a mirror. No force-push, no history rewrite.
- Plan artifacts live in Plan-Root with the identity block in HANDOVER.md.
- /execute-plan runs only a handover whose Repo matches this repository.
- Generated files are never committed.
- Exceptions are declared in the Exceptions field, one per line, each
  beginning "Toolchain exception:" or "Gate exception:".
<!-- canonical-workflow:end -->
