# Framework

POSIX.1-2017-targeted dataflow framework with Lua 5.4, `sh`, BusyBox, and
C99.

## Requirements

- BusyBox 1.38.0 userland
- `lua5.4`, `luac5.4` 5.4.9
- `luacheck` 1.2.0, `stylua` 2.6.0, `lua-language-server` 3.16.1
- GNU Make 4.4.1
- `sqlite3` 3.54.1
- `tcc` 0.9.28rc, `cppcheck` 2.22.0, `astyle` 3.6.18, musl-dev
- `mandoc` 1.14.6
- `websocat` 1.14.1 (plugin only)

## Quickstart

```sh
cd ~/.local/src/dotfiles/framework
make verify
make plugins
```

## Targets

| Target | Action |
|---|---|
| `verify` | env, audit, shell, parse, lint, format, lsp, test, proof, build, checksum, man, c |
| `env` | tool and POSIX version probe |
| `audit` | banned-option scan |
| `shell` | `sh -n` |
| `parse` | `luac5.4 -p` |
| `lint` | `luacheck --std lua54` |
| `format` | `stylua --syntax Lua54 --check` |
| `lsp` | LuaLS diagnostics |
| `test` | unit, property, contract, integration |
| `proof` | parse and validate `.refine` |
| `build` | stripped bytecode plus header check |
| `checksum` | `cksum` manifest plus verify |
| `man` | mandoc lint/render plus Lua fallback |
| `c` | C99 compile, probes, cppcheck, astyle |
| `plugins` | opt-in plugin gate |

## Layout

```text
etc/    policy, versions, contracts
lib/    Lua core and stage validators
sh/     orchestration, edges, gates
awk/    record transforms
sql/    schema, migrations, queries
c/      C99 parser module
man/    manual page
proofs/ .refine obligations
tests/  unit, property, contract, integration, fixtures
docs/   conformance, architecture, plugins, skills, decisions, ADRs
plugins/ opt-in extensions
```

## Documentation

- `docs/conformance.md` — what is and is not claimed.
- `docs/architecture.md` — layers and dataflow.
- `docs/decisions.md` — waiver elimination matrix.
- `docs/plugins.md` — plugin contract.
- `docs/skills.md` — skill catalog.

## License

Internal dotfiles project. No license is granted for redistribution.
