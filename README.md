# dotfiles

Personal dotfiles and tooling.

## Contents

- `framework/` — POSIX.1-2017 / Lua 5.4 / BusyBox / C99 dataflow framework.
- `skills/` — canonical OpenCode skills, installed globally by
  `skills/install.sh`.
- `opencode.json` — adds `./skills` as an OpenCode skill source.

## Quickstart

```sh
cd framework
make verify
make plugins
```

## Skills

```sh
sh skills/install.sh --dry-run
sh skills/install.sh
```

## Documentation

- `framework/docs/conformance.md`
- `framework/docs/architecture.md`
- `framework/docs/decisions.md`
- `framework/docs/skills.md`
