dotfiles
========

Personal dotfiles and tooling.

Contents
--------

- framework/    POSIX.1-2017 / Lua 5.4 / C99 dataflow framework.
- skills/       Canonical OpenCode skills, installed by skills/install.sh.
- agents/       Canonical Plan agent and eight read-only plan subagents.
- commands/     /plan and /execute-plan commands.
- config/opencode/AGENTS.md  Global canonical rules, installed as
                ~/.config/opencode/AGENTS.md.
- templates/    Managed repository profile blocks (templates/repo).
- prompts/       Plain-text prompts for repeated Plan-mode migrations.
- planmode      Deterministic installer and verifier.
- man/          planmode(1) manual.
- doc/          Plain-text operator guide.

Quickstart
----------

  cd framework
  make verify
  make plugins

OpenCode Plan Mode
------------------

# PATH setup (login shell reads ~/.profile; interactive shells read ~/.ashrc)
# ~/.local/bin is prepended automatically.

sh install.sh --dry-run
./planmode install
./planmode status
opencode reload

Equivalent short commands:

  pm -v     verify
  pm -x     upgrade-check
  pm -b     backup config
  pm -s     status

Repository commands:

  pm resolve-plan                        select the READY handover for this repo
  pm repo-profile --emit                 print the canonical profile block
  pm repo-profile --apply                insert or refresh it in AGENTS.md
  pm cvs-migrate --repo DIR --dry-run    preview a Git-only migration

Then press Tab to enter Plan mode and give only the request. When the
handover is ready, switch to Build and run /execute-plan.

After an upgrade:

  pm -x
  pm -v

Version control
---------------

This repository is CVS-first at /home/twomuchcoffee/CVS/dotfiles. GitHub is
a mirror. See doc/plan-mode.txt for the migration, mirror, signing, and
stale-branch cleanup protocol.

Documentation
-------------

All documentation is plain-text ASCII. Manuals use roff and mandoc. Generated
files are never committed.
