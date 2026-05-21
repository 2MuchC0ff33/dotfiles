---
name: standards-directory-root-files
description: Description
compatibility: opencode
---

# Skill Name: Root Directory Files

## Description
Standard set of root-level files required in every project: `justfile`, `flake.nix`, `README.adoc`, `STANDARDS.adoc`, `.gitignore`, `.gitattributes`, `Cargo.toml`, `Cargo.lock`, `deny.toml`, `CONTRIBUTING.adoc`, `CHANGELOG.adoc`, `SECURITY.adoc`, `SUPPORT.adoc`.

## When to Load
Load this skill when initializing a new project repository, verifying root directory completeness, or adding missing root-level files.

## Source
STANDARDS.adoc §2.1 (lines 1245–1255)

## Key Rules

- MANDATE: `justfile` is present as the human interface to all tasks
- MANDATE: `Cargo.lock` is ALWAYS committed (never gitignored)
- MANDATE: `README.adoc` is the source of truth (never `README.md` in source)
- MANDATE: `STANDARDS.adoc` is present as the project standards document
- MANDATE: `.gitignore` and `.gitattributes` define repository boundaries and file handling
- MANDATE: `deny.toml` is present for cargo-deny dependency auditing
- SHOULD: `CONTRIBUTING.adoc` documents contribution guidelines
- SHOULD: `CHANGELOG.adoc` tracks version history
- SHOULD: `SECURITY.adoc` documents security policies
- SHOULD: `SUPPORT.adoc` provides support information
- FORBIDDEN: `README.md` as a source file (it is generated and gitignored)
- FORBIDDEN: Missing `Cargo.lock` — it MUST be committed

## Example

```text
# CORRECT — Root directory layout
project/
├── justfile               # Task runner (make replacement)
├── flake.nix              # Nix flake for hermetic dev shell
├── flake.lock             # Nix flake lockfile
├── Cargo.toml             # Rust package manifest
├── Cargo.lock             # ALWAYS committed
├── deny.toml              # cargo-deny dependency audit config
├── .gitignore             # File exclusion rules
├── .gitattributes         # Line ending and diff rules
├── README.adoc            # Source of truth documentation
├── CONTRIBUTING.adoc      # Contribution guidelines
├── CHANGELOG.adoc         # Version changelog
├── SECURITY.adoc          # Security policy
├── SUPPORT.adoc           # Support information
└── STANDARDS.adoc         # The standard itself

# INCORRECT — Missing required files
project/
├── README.md              # FORBIDDEN: should be .adoc
├── Makefile               # Non-standard: use justfile
├── src/
│   └── lib.rs
# Missing: justfile, .gitignore, .gitattributes, STANDARDS.adoc
```

## Related Skills
- [standards-directory-config-files](file://.opencode/skills/standards-directory-config-files.md)
- [standards-directory-scripts](file://.opencode/skills/standards-directory-scripts.md)
