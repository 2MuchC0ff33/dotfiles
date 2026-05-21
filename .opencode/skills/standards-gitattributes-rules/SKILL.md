---
name: standards-gitattributes-rules
description: Description
compatibility: opencode
---

# Skill Name: .gitattributes Rules

## Description
Strict `.gitattributes` rules enforced by git: LF line endings for all source files, binary type markers for non-text files, semantic diff drivers for Rust/TOML/YAML, and `export-ignore` for non-release directories.

## When to Load
Load this skill when creating or modifying `.gitattributes`, setting up a new Rust project, or reviewing line ending and export behavior.

## Source
STANDARDS.adoc §2.3 (lines 1296–1356)

## Key Rules

- MANDATE: Default `* text=auto eol=lf` for all files — never CRLF
- MANDATE: All source code files (`*.rs`, `*.toml`, `*.yaml`, `*.yml`, `*.json`, `*.adoc`, `*.md`, `*.nu`, `*.sh`, `*.just`, `justfile`, `Makefile`, `*.asn1`) use `text eol=lf`
- MANDATE: Binary files use `binary` marker (never diff, never convert): `*.png`, `*.jpg`, `*.jpeg`, `*.gif`, `*.ico`, `*.pdf`, `*.zip`, `*.tar`, `*.gz`, `*.zst`, `*.der`
- MANDATE: Diff drivers for structured files: `*.rs diff=rust`, `*.toml diff=toml`, `*.yaml diff=yaml`
- MANDATE: `export-ignore` on: `.gitattributes`, `.gitignore`, `scripts/`, `xtask/`, `proofs/`, `fuzz/`, `cross/`
- FORBIDDEN: CRLF line endings in any committed file
- FORBIDDEN: Missing binary markers for non-text files

## Example

```gitattributes
# CORRECT — Standard .gitattributes
# DEFAULT: All files use LF. Never CRLF.
*               text=auto eol=lf

# SOURCE CODE: Always LF, always text
*.rs            text eol=lf
*.toml          text eol=lf
*.yaml          text eol=lf
*.yml           text eol=lf
*.json          text eol=lf
*.adoc          text eol=lf
*.md            text eol=lf
*.nu            text eol=lf
*.sh            text eol=lf
*.just          text eol=lf
justfile        text eol=lf
Makefile        text eol=lf
*.asn1          text eol=lf

# BINARY: Never diff, never convert
*.png           binary
*.jpg           binary
*.jpeg          binary
*.gif           binary
*.ico           binary
*.pdf           binary
*.zip           binary
*.tar           binary
*.gz            binary
*.zst           binary
*.der           binary

# DIFF DRIVERS: Semantic diff for structured files
*.rs            diff=rust
*.toml          diff=toml
*.yaml          diff=yaml

# EXPORT IGNORE: Not in release archives
.gitattributes  export-ignore
.gitignore      export-ignore
scripts/        export-ignore
xtask/          export-ignore
proofs/         export-ignore
fuzz/           export-ignore
cross/          export-ignore
```

```gitattributes
# INCORRECT — Missing or wrong rules
*               text=auto              # Missing eol=lf — CRLF possible on Windows
*.rs            text                   # Missing eol=lf
*.png           text                   # FORBIDDEN: PNG marked as text!
*.rs            diff=python            # Wrong diff driver
.gitignore      # no export-ignore     # Export includes CI-only files
```

## Related Skills
- [standards-gitignore-rules](file://.opencode/skills/standards-gitignore-rules.md)
- [standards-directory-root-files](file://.opencode/skills/standards-directory-root-files.md)
