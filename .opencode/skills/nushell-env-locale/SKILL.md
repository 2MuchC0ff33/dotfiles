---
name: nushell-env-locale
description: Description
compatibility: opencode
---

# nushell-env-locale

## Description
Set `$env.LANG` and `$env.LC_ALL` to `"en_US.UTF-8"` for consistent UTF-8 locale handling.

## When to Load
Load this skill when reviewing or creating environment variable settings in `config.nu` or `env.nu`.

## Source
STANDARDS.adoc §11.1 (lines 3729–3730)

## Key Rules

- MANDATE: `$env.LANG = "en_US.UTF-8"` AND `$env.LC_ALL = "en_US.UTF-8"` MUST both be present.
- SHOULD: Both variables force UTF-8 encoding across all locale categories (collation, character classification, numeric formatting, monetary, time).
- FORBIDDEN: Setting `LANG` to a non-UTF-8 locale (e.g., `en_US` without `.UTF-8`). Omitting `LC_ALL` while setting `LANG` — individual `LC_*` categories may override `LANG`.

## Rationale

Setting the locale ensures consistent behavior across all tools:

- **UTF-8 everywhere**: All text processing assumes UTF-8 encoding, which is
  the standard for modern software development
- **`LC_ALL` > `LC_*` > `LANG`**: `LC_ALL` overrides all individual locale
  category variables (`LC_COLLATE`, `LC_CTYPE`, `LC_MONETARY`, `LC_NUMERIC`,
  `LC_TIME`, `LC_MESSAGES`, `LC_PAPER`, `LC_NAME`, `LC_ADDRESS`,
  `LC_TELEPHONE`, `LC_MEASUREMENT`, `LC_IDENTIFICATION`).
- **Prevents "invalid UTF-8" errors**: Many Rust tools (and CLI tools in
  general) assume UTF-8; wrong locale settings cause cryptic errors.
- **Sort order**: `en_US.UTF-8` provides dictionary-order collation.
- **Date formatting**: 12-hour clock, month/day/year ordering.

Without explicit locale settings, the system default may vary (e.g., POSIX/C
locale on minimal Docker images, or a non-UTF-8 locale on some Linux distros).

## Example

```nushell
$env.LANG              = "en_US.UTF-8"
$env.LC_ALL            = "en_US.UTF-8"
```

With these set, `ls` (eza) output uses UTF-8, `sort` uses dictionary order, and Rust tools don't emit "invalid UTF-8" warnings.
