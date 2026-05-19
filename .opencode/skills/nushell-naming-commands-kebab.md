# Nushell Naming: Commands MUST Be kebab-case

## Description
All Nushell commands (defined with `def`, `extern`, etc.) MUST use kebab-case naming.

## When to Load
Load this skill when defining new Nushell commands, reviewing existing command names, or auditing naming consistency in `.nu` files.

## Source
STANDARDS.adoc §11.5.1 (lines 3969–4001)

## Key Rules

- MANDATE: Commands MUST be kebab-case. Use hyphen (`-`) as the word separator: `fetch-user`, `build-project`, `process-item`.
- MANDATE: Every segment of the command name must be a full, unabbreviated word in lowercase, joined by hyphens.
- FORBIDDEN: camelCase in commands: `fetchUser`, `buildProject`, `processItem`.
- FORBIDDEN: snake_case in commands: `fetch_user`, `build_project`, `process_item`.
- FORBIDDEN: PascalCase in commands: `FetchUser`, `BuildProject`, `ProcessItem`.
- FORBIDDEN: Single-word names that are abbreviations or acronyms unless they are universally understood (e.g., `http`, `json`).

## Rationale

Kebab-case is the standard for Nushell command naming because:
1. Nushell's parser treats hyphens as part of identifiers, making hyphen-separated names first-class citizens.
2. It visually distinguishes commands from variables (which use snake_case), reducing cognitive load.
3. It matches the convention used by built-in Nushell commands (`sort-by`, `where`, `select`, `get`, `str trim`, etc.), ensuring consistency with the ecosystem.
4. Hyphens are easier to type and read than underscores in command positions, especially in pipelines.

## Examples

### CORRECT

```nu
def fetch-user [] { }
def build-project [name: string] { }
def process-item [id: int] { }
def http-request [url: string] { }
def json-parse [] { }
def db-migrate [direction: string] { }
def config-validate [] { }
```

### INCORRECT

```nu
def fetchUser [] { }            # camelCase — FORBIDDEN
def build_project [name] { }    # snake_case — FORBIDDEN
def processItem [id] { }        # camelCase — FORBIDDEN
def FetchUser [] { }            # PascalCase — FORBIDDEN
def fetchuser [] { }            # all lower, no separator — unreadable
def dbMigrate [dir] { }         # camelCase + abbreviation — FORBIDDEN
```

## Interaction With Other Rules

- Sub-commands extend kebab-case with space separation (see `nushell-naming-commands-subcommands-kebab`).
- Variables and parameters use snake_case, not kebab-case (see `nushell-naming-variables-snake`).
- File names for command modules also use kebab-case (see `nushell-naming-files-kebab`).

## Related Skills

- [nushell-naming-commands-subcommands-kebab](file://.opencode/skills/nushell-naming-commands-subcommands-kebab.md)
- [nushell-naming-variables-snake](file://.opencode/skills/nushell-naming-variables-snake.md)
- [nushell-naming-files-kebab](file://.opencode/skills/nushell-naming-files-kebab.md)
- [nushell-naming-forbidden-pascal-case](file://.opencode/skills/nushell-naming-forbidden-pascal-case.md)
- [nushell-naming-no-abbreviations](file://.opencode/skills/nushell-naming-no-abbreviations.md)
