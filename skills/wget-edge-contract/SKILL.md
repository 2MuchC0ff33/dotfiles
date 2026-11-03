---
name: wget Edge Contract
description: Use when changing the HTTPS fetch edge; covers BusyBox wget options, shell retries, fw_timeout, and atomic output.
---

# wget Edge Contract

## Allowed

`-q`, `-S`, `-T SEC`, `-O FILE`, `-U AGENT`.

## Banned

`--tries`, `--timeout`, `-c`, `--post-data`, `--post-file`.

## Rules

- BusyBox wget ignores `--tries`; retry in shell.
- `-T` covers connect/read, not DNS; wrap with `fw_timeout`.
- Write to `OUTPUT.tmp`, then `mv`.
- Never parse `-S` headers.

## Check

```sh
cd ~/.local/src/dotfiles/framework
sh/net/fetch.sh http://127.0.0.1:1/nope work/fetch.out 2 1
# nonzero; work/fetch.out absent
```
