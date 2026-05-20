# Nushell Naming: FORBIDDEN — PascalCase in Everything

## Description
PascalCase naming is FORBIDDEN in all Nushell identifiers: commands, variables, parameters, flags, constants, file names, and any other user-defined names.

## When to Load
Load this skill when reviewing any identifier in `.nu` files, auditing naming convention compliance, or when migrating code from languages that use PascalCase (C#, TypeScript classes, etc.).

## Source
STANDARDS.adoc §11.5.1 (lines 4027–4059)

## Key Rules

- FORBIDDEN: PascalCase in commands: `FetchUser`, `BuildProject`.
- FORBIDDEN: PascalCase in variables/parameters: `$UserId`, `$RecordCount`, `$OutputDir`.
- FORBIDDEN: PascalCase in flags: `--OutputDir`, `--DryRun`.
- FORBIDDEN: PascalCase in constants: `const ApiVersion = '1.0'`.
- FORBIDDEN: PascalCase in file names: `FetchUser.nu`, `ConfigValidate.nu`.
- FORBIDDEN: PascalCase in environment variables: `$env.AppVersion`, `$env.DbUrl`.
- FORBIDDEN: PascalCase in sub-commands: `def "User Create" []`, `def "Config Validate" []`.
- MANDATE: All identifiers must use the convention appropriate to their role:
  - Commands/flags/files: kebab-case
  - Variables/parameters: snake_case
  - Constants/env vars: SCREAMING_SNAKE_CASE

## Rationale

1. PascalCase has no semantic role in Nushell — unlike Rust (types/traits) or TypeScript (classes/interfaces), Nushell does not use PascalCase for any built-in construct.
2. All built-in Nushell commands (`sort-by`, `str trim`, `into int`) use kebab-case or lowercase. PascalCase identifiers would visually clash with the language's design.
3. Nushell's module system uses PascalCase-like notation for sub-commands only when they are exported as module names — but the actual definitions still use kebab-case.
4. Using PascalCase introduces ambiguity about whether an identifier is a command, type, or variable, defeating the purpose of convention-based visual cues.

## Examples

### CORRECT

```nu
def fetch-user [user_id: int] { }      # kebab-case command, snake_case param
let display_name = $user_id | get-name # snake_case variable
def "db migrate" [direction: string] { } # kebab-case sub-command
const MAX_RETRIES: int = 3             # SCREAMING_SNAKE_CASE constant
--output-dir (-o)                      # kebab-case flag
utils.nu                               # kebab-case file
```

### INCORRECT

```nu
def FetchUser [userId: int] { }        # PascalCase command — FORBIDDEN
let DisplayName = $userId | GetName    # PascalCase variable — FORBIDDEN
def "Db Migrate" [Direction] { }       # PascalCase sub-command — FORBIDDEN
const MaxRetries = 3                   # PascalCase constant — FORBIDDEN
--OutputDir                            # PascalCase flag — FORBIDDEN
ConfigValidate.nu                      # PascalCase file — FORBIDDEN
```

## Common Pitfalls

- **TypeScript/Python migrants**: Classes and constructors use PascalCase in those languages. In Nushell, there is no class construct; all names are functions or data.
- **C#/Java background**: PascalCase for methods and properties is standard. Nushell uses kebab-case for all callables.
- **Rust background**: Types use PascalCase in Rust; Nushell has no user-defined types in the same sense. Use kebab-case for commands, snake_case for variables.

## Related Skills

- [nushell-naming-commands-kebab](file://.opencode/skills/nushell-naming-commands-kebab.md)
- [nushell-naming-commands-subcommands-kebab](file://.opencode/skills/nushell-naming-commands-subcommands-kebab.md)
- [nushell-naming-variables-snake](file://.opencode/skills/nushell-naming-variables-snake.md)
- [nushell-naming-constants-screaming-snake](file://.opencode/skills/nushell-naming-constants-screaming-snake.md)
- [nushell-naming-env-vars-screaming-snake](file://.opencode/skills/nushell-naming-env-vars-screaming-snake.md)
