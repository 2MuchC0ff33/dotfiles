# Nushell Naming: Flags MUST Be kebab-case

## Description
All command flags (both long and short) MUST follow kebab-case naming for the long form and a single lowercase letter for the short form.

## When to Load
Load this skill when defining command signatures with `--flag` parameters, designing CLI interfaces for Nushell commands, or reviewing flag naming in existing command definitions.

## Source
STANDARDS.adoc §11.5.1 (lines 3969–4001)

## Key Rules

- MANDATE: Long-form flags MUST be kebab-case: `--output-dir`, `--dry-run`, `--all-caps`, `--no-color`.
- MANDATE: Short-form flags SHOULD be a single lowercase letter: `-o`, `-n`, `-v`, `-h`.
- MANDATE: Short-form flag aliases MUST be defined in parentheses after the long name: `--verbose (-v)`.
- FORBIDDEN: snake_case in long-form flags: `--output_dir`, `--dry_run`, `--all_caps`.
- FORBIDDEN: camelCase in long-form flags: `--outputDir`, `--dryRun`.
- FORBIDDEN: PascalCase in flags: `--OutputDir`, `--DryRun`.
- FORBIDDEN: Multi-character short flags (e.g., `-vv` for verbose — use `--verbose --verbose` or a count flag instead).
- FORBIDDEN: Using hyphens in flag values that the parser could interpret as additional flags.

## Rationale

1. kebab-case for long flags is the POSIX and GNU convention adopted by virtually all modern CLIs (git, cargo, docker, npm).
2. Nushell's flag parser treats hyphens in `--flag-names` natively; attempting snake_case would be non-idiomatic.
3. Consistent kebab-case flags make Nushell scripts feel familiar to users coming from other CLI ecosystems.
4. Short flags as single lowercase letters follows the universally recognized `-v` for verbose, `-h` for help pattern.

## Examples

### CORRECT

```nu
def fetch-user [
    user_id: int
    --verbose (-v)
    --output-dir (-o): string
    --dry-run (-n)
    --all-caps
    --no-color
] { }

def build-project [
    --target-dir (-t): string
    --release
    --jobs (-j): int
] { }
```

### INCORRECT

```nu
def fetch-user [
    user_id: int
    --verbose (-v)
    --output_dir: string           # snake_case — FORBIDDEN
    --dryRun                      # camelCase — FORBIDDEN
    --AllCaps                     # PascalCase — FORBIDDEN
] { }

def build-project [
    --targetDir: string            # camelCase — FORBIDDEN
    --release
    --jobs (-j): int
] { }
```

## Related Skills

- [nushell-naming-commands-kebab](file://.opencode/skills/nushell-naming-commands-kebab.md)
- [nushell-naming-commands-subcommands-kebab](file://.opencode/skills/nushell-naming-commands-subcommands-kebab.md)
- [nushell-naming-forbidden-pascal-case](file://.opencode/skills/nushell-naming-forbidden-pascal-case.md)
