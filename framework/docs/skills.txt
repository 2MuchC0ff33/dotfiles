# Skills

## Canonical source

`skills/` in this repository is canonical. Each skill is a directory with
`SKILL.md`. The directory name is the skill ID and must match
`^[a-z0-9]+(-[a-z0-9]+)*$`.

## Install

```sh
sh skills/install.sh --dry-run
sh skills/install.sh
```

The default target is `~/.config/opencode/skills`. The installer symlinks
each skill directory. It refuses to replace a non-symlink. Use `--copy` for
a copy, `--remove` to remove installed links, and `--dry-run` to inspect.

## Catalog

| ID | Purpose |
|---|---|
| `posix-framework-overview` | layout, gates, release flow |
| `posix-2017-scope` | what 2017 includes and excludes |
| `posix-shell-discipline` | safe POSIX `sh` patterns |
| `posix-audit-rules` | allowlist and banned-options rules |
| `posix-command-contracts` | per-tool contracts |
| `posix-tool-probing` | version and capability probes |
| `lua54-runtime` | `lua5.4`/`luac5.4` usage |
| `lua54-syntax-policy` | banned 5.5 constructs |
| `lua-literal-proofs` | proof data format |
| `lua-stage-validation` | stage validators and atomicity |
| `lua-bytecode-build` | stripped bytecode and headers |
| `lua-test-harness` | unit/property test harness |
| `lua-property-testing` | deterministic generators |
| `c99-tcc-baseline` | C99 compile and probe rules |
| `c-posix-2017-api` | POSIX 2017 C API surface |
| `c-static-analysis` | cppcheck and astyle |
| `man-page-gate` | mandoc and Lua fallback |
| `checksum-integrity` | `cksum` manifests |
| `sqlite-stage-state` | schema, migrations, queries |
| `wget-edge-contract` | BusyBox wget rules |
| `websocket-plugin` | plugin contract and gate |
| `framework-release-gate` | full verification sequence |
| `framework-file-manifest` | expected tree |
| `framework-troubleshooting` | failure triage |
| `opencode-skills-authoring` | adding and installing skills |

## Repo config

`opencode.json` adds `./skills` as an explicit source:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "skills": ["./skills"]
}
```

Global skills are auto-discovered from `~/.config/opencode/skills`; no MCP
configuration change is required.
