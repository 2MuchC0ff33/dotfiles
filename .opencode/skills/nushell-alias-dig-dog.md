# nushell-alias-dig-dog

## Description
Replace `dig` (DNS lookup) with `dog`, a Rust-native DNS client with colorized, human-readable output.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3704)

## Key Rules

- MANDATE: `alias dig = dog` MUST be present in `config.nu`.
- SHOULD: Use `dog` for DNS queries instead of `dig`.
- FORBIDDEN: Omitting this alias, leaving the traditional `dig` (colorless, verbose output).

> NOTE: `dog` is low-maintenance (last release 2022); verify before relying on it.

## Rationale

`dog` is a modern DNS lookup tool:

- **Colorized output**: Different colors for different DNS record types, TTLs, and sections
- **Clean formatting**: Human-readable table format, not raw zone file dumps
- **All record types**: A, AAAA, CNAME, MX, NS, SOA, TXT, CAA, DNSKEY, etc.
- **Short mode**: `-s` for concise output (just the answers)
- **DNS over TLS/HTTPS**: Supports DoT and DoH with `--tls` / `--https`
- **Multiple nameservers**: Query specific DNS servers
- **Reverse lookups**: `-x` for PTR records

## Example

```nushell
alias dig = dog
```

Usage:
- `dog example.com` → colorized A record lookup
- `dog example.com MX` → MX record lookup
- `dog example.com --tls` → DNS over TLS
