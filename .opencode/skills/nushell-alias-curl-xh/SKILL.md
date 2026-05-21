---
name: nushell-alias-curl-xh
description: Description
compatibility: opencode
---

# nushell-alias-curl-xh

## Description
Replace `curl` with `xh`, a Rust-native HTTP client with a friendlier, colorized interface.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3703)

## Key Rules

- MANDATE: `alias curl = xh` MUST be present in `config.nu`.
- SHOULD: Use `xh` for HTTP requests instead of `curl`.
- FORBIDDEN: Omitting this alias, which leaves `curl` with its cryptic flags and no colorized output.

## Rationale

`xh` is an HTTP client inspired by HTTPie but written in Rust:

- **Intuitive syntax**: `xh GET /api/foo` not `curl -X GET /api/foo`
- **Colorized output**: Syntax-highlighted JSON responses by default
- **JSON built-in**: `xh POST /api/data name=hello` auto-sends JSON
- **Headers shown**: Response headers in dimmed text, body in full color
- **Formatted output**: Auto-indented JSON, no piping to `jq` needed
- **Download support**: `--download` for file downloads
- **Follow redirects**: `--follow` by default (curl requires `-L`)

The key wins over curl: no `-X`, no `-H "Content-Type: application/json"`,
no pipe to `jq` — everything just works with less typing.

## Example

```nushell
alias curl = xh
```

Usage:
- `curl GET https://api.github.com/repos/2MuchC0ff33/dotfiles` → colorized JSON
- `curl POST https://httpbin.org/post name=hello` → auto-JSON POST
