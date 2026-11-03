---
name: Framework File Manifest
description: Use when checking for missing or unexpected framework files; lists the canonical tree and generated paths that must never be committed.
---

# Framework File Manifest

## Canonical

`Makefile`, `.editorconfig`, `.gitignore`, `.cvsignore`, `.luacheckrc`,
`.luarc.json`, `stylua.toml`, `README.txt`, `AGENTS.md`, `etc/`, `lib/`,
`sh/`, `awk/`, `sed/`, `sql/`, `c/`, `man/`, `proofs/`, `stages/`, `tests/`,
`docs/`, `plugins/`.

## Generated

`work/`, `build/`, `srv/`, `spool/`, `etc/framework.local.conf`.

## Check

```sh
cd ~/.local/src/dotfiles/framework
cvs status
find . -type f -not -path './CVS/*' -not -path './work/*' -not -path './build/*' | sort
```

## Reference

- `docs/architecture.txt`
- `docs/skills.txt`
