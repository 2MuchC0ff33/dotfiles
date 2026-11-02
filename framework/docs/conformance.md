# Conformance statement

## Target

- POSIX.1-2017 (IEEE Std 1003.1-2017), `_POSIX_VERSION=200809`.
- C99 (`__STDC_VERSION__=199901L`) with tcc 0.9.28rc.
- Lua 5.4.9 (`lua5.4`, `luac5.4`).
- BusyBox 1.38.0 userland.

No POSIX.1-2024 API or utility is required. `timeout(1)` is not used.

## Claim matrix

| Surface | Claim | Positive evidence | Negative evidence |
|---|---|---|---|
| Shell utilities | POSIX.1-2017 | `etc/posix_allowlist.txt` | `etc/banned_options.txt` audit |
| Shell syntax | POSIX `sh` | `sh -n` | `SH_BASHISM`, `SH_LOCAL` |
| libc | POSIX.1-2017 | `_POSIX_VERSION=200809` | `c/tests/posix_level.c` |
| C language | C99 | `__STDC_VERSION__=199901L` | `c/tests/stdver.c` |
| Lua | 5.4.9 | `luac5.4 -p` | Lua 5.5 syntax audit |
| Man pages | mdoc/man | `mandoc -T lint`, `-T ascii` | `lib/manlint.lua` |
| Integrity | POSIX `cksum` | recompute and compare | edited file fails |

## What is not claimed

- POSIX.1-2024 libc or utility conformance.
- C11 or C17 conformance.
- Cryptographic integrity, signatures, or tamper evidence.
- Live network availability.
- WebSocket liveness; the plugin is opt-in.
- Windows or non-POSIX hosts.

## Integrity note

`cksum` computes CRC32. It detects accidental corruption and accidental
edits. It is **not** a cryptographic hash and must not be used to resist an
adversary who can rewrite both the file and the manifest.

## Reproduce

```sh
cd ~/.local/src/dotfiles/framework
make verify
getconf _POSIX_VERSION
lua5.4 -v
tcc -std=c99 -D_POSIX_C_SOURCE=200809L c/tests/stdver.c -o /tmp/stdver && /tmp/stdver
```

Expected: `make verify` exits 0, `200809`, `Lua 5.4.9`, `199901`.

## Waivers

None. `docs/decisions.md` records how each old waiver was eliminated.
