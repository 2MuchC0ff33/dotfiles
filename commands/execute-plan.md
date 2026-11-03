---
description: Execute the READY handover in ~/.opencode/plan/HANDOVER.md
agent: build
---

Execute the CVS-first canonical plan handover.

## 1. Read the handover

Read:

1. /home/twomuchcoffee/.opencode/plan/HANDOVER.md
2. /home/twomuchcoffee/.opencode/plan/PLAN.md
3. /home/twomuchcoffee/.opencode/plan/WORKORDER.md
4. /home/twomuchcoffee/.opencode/plan/INDEX.md
5. /home/twomuchcoffee/.opencode/plan/RISKS.md
6. /home/twomuchcoffee/.opencode/plan/PROOF.md
7. /home/twomuchcoffee/.opencode/plan/QUESTIONS.md
8. /home/twomuchcoffee/.opencode/plan/GIT.md
9. /home/twomuchcoffee/.opencode/plan/PATCHES.md

If HANDOVER.md is BLOCKED, stop. If any artifact is missing, stop.

## 2. Preflight

```sh
cd /home/twomuchcoffee/.local/src/dotfiles
git status --porcelain
git rev-parse --abbrev-ref HEAD
git rev-list --left-right --count dev...origin/dev
make verify
```

Do not continue unless the tree is clean, dev is aligned, and the gates pass.

## 3. Migrate to CVS

Follow GIT.md exactly. Keep TODO.txt in the new checkout. Move the old Git
repository to an archive; do not delete it. Import current HEAD into
~/CVS/dotfiles. Validate the imported checkout before implementing.

## 4. Implement W0-W8

Follow WORKORDER.md in order. Use `make build`; do not hand-edit generated
`build/` files. Do not commit `.luac` files.

## 5. Verify

Run:

```sh
make verify
make ascii
./planmode verify
./planmode upgrade-check
mandoc -T lint man/planmode.1
```

Any failure stops the build.

## 6. Mirror and cleanup

After CVS is verified, create the Git mirror snapshot, push dev and main, and
verify both refs. Delete only the two stale branches named in GIT.md. Do not
force-push. Verify signatures.

## 7. Final report

Report the CVS import result, the new checkout, the mirror commits, deleted
stale branches, signed releases, gate results, and residual risks.
