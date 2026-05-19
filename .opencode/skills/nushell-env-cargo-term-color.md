# nushell-env-cargo-term-color

## Description
Force Cargo to always emit colorized output, even when output is piped or redirected.

## When to Load
Load this skill when reviewing or creating environment variable settings in `config.nu` or `env.nu`.

## Source
STANDARDS.adoc §11.1 (line 3670)

## Key Rules

- MANDATE: `$env.CARGO_TERM_COLOR = "always"` MUST be present in the ENVIRONMENT section of `config.nu`.
- SHOULD: Cargo always outputs colored diagnostics, even when piping to a pager, redirecting to a file, or running in CI.
- FORBIDDEN: `CARGO_TERM_COLOR = "auto"` (default — disables color when stdout is not a TTY) or `CARGO_TERM_COLOR = "never"`.

## Rationale

Setting `CARGO_TERM_COLOR = "always"` ensures that:

- **Piped output retains color**: `cargo build 2>&1 | less -R` shows colored output
- **CI logs are colored**: Makes build logs in GitHub Actions, etc., more readable
- **Redirection preserves color**: `cargo build > build.log 2>&1` captures terminal colors
- **Consistent developer experience**: No surprise when colors disappear in paged output

The default `"auto"` mode disables color when stdout is not a TTY, which
makes piped and redirected output harder to parse visually. Since most
modern terminals and pagers support ANSI color codes, `"always"` is the
correct setting.

## Example

```nushell
$env.CARGO_TERM_COLOR  = "always"
```

With this set, `cargo build 2>&1 | tail -20` retains colored error messages.
