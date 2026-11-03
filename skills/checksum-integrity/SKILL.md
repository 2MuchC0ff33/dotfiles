---
name: Checksum Integrity
description: Use when generating or verifying manifests; covers POSIX cksum output, CRC32 limits, sidecars, and the no-sha256sum rule.
---

# Checksum Integrity

## Format

`cksum` emits `CRC32 octets pathname`:

```text
1234567890 42 etc/framework.conf
```

There is no `-c`; verify by recomputing and string-comparing.

## Rules

- CRC32 is integrity, not cryptography.
- No `sha256sum`.
- Manifests use relative paths only.
- Exclude `etc/framework.local.conf`.
- Sort by pathname with `LC_ALL=C`.

## Check

```sh
cd ~/.local/src/dotfiles/framework
make checksum
head -1 work/checksums.cksum
```

## References

- `etc/contracts/cksum.contract`
- `lib/checksum.lua`
