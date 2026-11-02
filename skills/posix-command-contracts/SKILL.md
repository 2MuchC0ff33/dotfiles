---
name: POSIX Command Contracts
description: Use when adding or changing an external tool; requires admitted options, banned options, exit status, and rationale in etc/contracts.
---

# POSIX Command Contracts

## Rule

Every external tool or runtime has a contract in `etc/contracts/`:
`UTILITY`, `ADMITTED`, `BANNED`, `EXIT_STATUS`, `RATIONALE`.

## Current contracts

`sh`, `lua`, `awk`, `sed`, `grep`, `find`, `cksum`, `sqlite3`, `wget`,
`c`, `mandoc`, `make`.

## Check

```sh
cd ~/.local/src/dotfiles/framework
ls etc/contracts
make audit
```

## When adding

1. Add the tool to `etc/posix_allowlist.txt` with a class.
2. Add the contract.
3. Add a version probe to `etc/tool_versions.txt`.
4. Add a negative test if the tool has banned options.
