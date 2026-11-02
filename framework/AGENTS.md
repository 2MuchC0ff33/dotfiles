# AGENTS.md — framework rules

## Non-negotiables

- POSIX.1-2017 only. Do not add POSIX.1-2024 utilities.
- Lua 5.4.9 only. Use `lua5.4` and `luac5.4`; never bare `lua`.
- C99 only. Do not add C11/C17 features or `-std=c17`.
- No `local`, `timeout`, `mktemp`, `bc`, `sha256sum`, `grep -r`, or `jq`
  in shell source.
- Proofs are data. Never execute a `.refine` file.
- `make verify` must pass. Do not weaken a gate to make it pass.
- Plugins stay out of `make verify`.

## Before editing

```sh
cd ~/.local/src/dotfiles/framework
make verify
```

## After editing

```sh
make verify
make plugins
```

If a gate fails, fix the cause. If a requirement is ambiguous, ask; do not
add a waiver.

## File rules

- Shell: `set -eu`, `printf`, prefixed globals, no arrays.
- Lua: 5.4 syntax, no dynamic loading in `lib/`, no clock/random in core.
- awk: no `system()`, no pipe `getline`.
- SQL: no `.shell`, `.system`, or `.load`.
- Man: mdoc/man macros only; run `make man`.
- C: C99, K&R formatting, two-space indent.

## Generated paths

Never commit `work/`, `build/`, `srv/`, `spool/`, or
`etc/framework.local.conf`.
