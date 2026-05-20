# nushell-env-rustflags

## Description
Set `$env.RUSTFLAGS = "-Dwarnings"` to promote all compiler warnings to errors during builds.

## When to Load
Load this skill when reviewing or creating environment variable settings in `config.nu` or `env.nu`.

## Source
STANDARDS.adoc §11.1 (line 3727), §3 (lines 1427–1883)

## Key Rules

- MANDATE: `$env.RUSTFLAGS = "-Dwarnings"` MUST be present in the ENVIRONMENT section of `config.nu`.
- SHOULD: This flag promotes all `#[warn(...)]` diagnostics to hard errors, ensuring CI and local builds fail on any warning.
- FORBIDDEN: Setting `RUSTFLAGS` to empty or omitting `-Dwarnings` — this allows warnings to slip through and accumulate.

## Rationale

`-Dwarnings` is a Rust compiler flag that converts every `warn`-level
diagnostic into an `error`-level diagnostic. This enforces:

- **Zero-warning policy**: Any lint that would produce a warning causes a build failure
- **CI consistency**: Local builds fail on the same issues CI would catch
- **Code quality**: Prevents warning accumulation ("I'll fix it later" warnings pile up)
- **Refactoring safety**: Deprecation warnings, dead code, unused variables — all caught at build time

This is the Rust standard for projects that care about code quality. The
flag is set at the environment level (rather than in `.cargo/config.toml`)
so it applies to ALL cargo invocations, including xtask subcommands.

## Example

```nushell
$env.RUSTFLAGS         = "-Dwarnings"
```

With this set, `cargo build` will fail if any warning is emitted.
