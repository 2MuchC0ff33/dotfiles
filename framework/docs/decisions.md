# Decisions and waiver elimination

No waiver remains. Each old waiver is replaced by a rule, a gate, or a
removed dependency.

| Old waiver | Resolution | Evidence |
|---|---|---|
| W-001 `bc -s` | `bc` removed; use awk or Lua | `SH_BC` audit rule; no `bc/` |
| W-002 `grep -r` | banned; use `find ... -exec grep` | `GREP_RECURSIVE` |
| W-003 `sha256sum` | POSIX `cksum`; CRC32 integrity only | `lib/checksum.lua`, `sh/checksum.sh` |
| W-004 `local` | banned; prefixed globals | `SH_LOCAL` |
| W-005 `timeout` / 200809 | target 2017; `fw_timeout` watchdog | `sh/lib/timeout.sh`, `SH_TIMEOUT` |
| W-006 `mktemp -d` | banned; `mkdir -p` under `work/` | `SH_MKTEMP` |
| W-007 man not rendered | `mandoc` lint+render plus Lua fallback | `sh/tests/man_gate.sh` |
| W-008 bare `lua`/`luac` | banned; versioned binaries only | `LUA_BARE` |
| W-009 tcc C99+partial C11 | C99 only; compile-time probes | `c/tests/stdver.c` |
| W-010 Lua 5.5 syntax | target 5.4; 5.5-only constructs banned | `LUA_GLOBAL_DECL` etc. |
| W-011 `websocat` optional | plugin, excluded from verify | `plugins/websocket/` |

## Consequence

The framework can now say exactly what it supports:

- POSIX.1-2017 shell and libc;
- C99;
- Lua 5.4.9;
- CRC32 integrity;
- opt-in WebSocket transport.

It cannot say:

- POSIX.1-2024;
- C11/C17;
- cryptographic integrity;
- live network guarantees.
