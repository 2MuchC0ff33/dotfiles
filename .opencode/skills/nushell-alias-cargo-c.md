# nushell-alias-cargo-c

## Description
Short alias `c` for `cargo` to reduce keystrokes for the most-used Rust build tool.

## When to Load
Load this skill when reviewing or creating project-specific Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3661)

## Key Rules

- MANDATE: `alias c = cargo` MUST be present in `config.nu` in the "PROJECT-SPECIFIC ALIASES" section.
- SHOULD: Use `c` as a shorthand for `cargo` for common operations: `c build`, `c check`, `c test`, `c run`.
- FORBIDDEN: Omitting this alias — `cargo` is the most frequently typed tool in Rust workflows, and the abbreviation saves significant keystrokes over time.

## Rationale

`cargo` is invoked dozens (if not hundreds) of times per day in Rust
development. The `c` alias reduces typing by 60% (5 characters → 1):

- `c build` vs `cargo build`
- `c check` vs `cargo check`
- `c test` vs `cargo test`
- `c run` vs `cargo run`
- `c clippy` vs `cargo clippy`

This is placed in the "PROJECT-SPECIFIC ALIASES" section (not "RUST-NATIVE
UTILITY REPLACEMENTS") because cargo is a build tool, not a system utility
replacement.

## Example

```nushell
alias c   = cargo
```

Usage:
- `c build` → `cargo build`
- `c check` → `cargo check`
- `c test` → `cargo test`

## Related Skills
- [nushell-alias-xtask-cxt](file://.opencode/skills/nushell-alias-xtask-cxt.md)
- [nushell-alias-just-j](file://.opencode/skills/nushell-alias-just-j.md)
