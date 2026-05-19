# Skill Name: .gitignore Rules

## Description
Standard `.gitignore` entries for Rust projects: generated `README.md`, build artifacts (`/target/`), IDE files (`.helix/`), fuzz corpus (`fuzz/corpus/`), and OS files (`.DS_Store`, `Thumbs.db`).

## When to Load
Load this skill when creating or modifying `.gitignore`, setting up a new Rust project, or reviewing ignored file patterns.

## Source
STANDARDS.adoc §2.2 (lines 1263–1300)

## Key Rules

- MANDATE: `README.md` is gitignored (generated from `README.adoc` at release time)
- MANDATE: `/target/` is gitignored (Rust build artifacts)
- MANDATE: `.helix/` is gitignored (IDE/editor local configuration)
- MANDATE: `fuzz/corpus/` is gitignored (regenerated fuzz corpus)
- MANDATE: `.DS_Store` is gitignored (macOS filesystem metadata)
- MANDATE: `Thumbs.db` is gitignored (Windows thumbnail cache)
- SHOULD: `**/*.rs.bk` is gitignored (Rust backup files)
- FORBIDDEN: `Cargo.lock` in `.gitignore` (it MUST be committed)
- FORBIDDEN: Commented-out entries in `.gitignore` (remove or keep, never comment out)

## Example

```gitignore
# CORRECT — Standard .gitignore
# ─────────────────────────────────────────
# GENERATED FILES: never manually edited
# ─────────────────────────────────────────
README.md

# ─────────────────────────────────────────
# BUILD ARTIFACTS
# ─────────────────────────────────────────
/target/
**/*.rs.bk

# ─────────────────────────────────────────
# IDE / EDITOR
# ─────────────────────────────────────────
.helix/

# ─────────────────────────────────────────
# FUZZ CORPUS (regenerated)
# ─────────────────────────────────────────
fuzz/corpus/

# ─────────────────────────────────────────
# OS FILES
# ─────────────────────────────────────────
.DS_Store
Thumbs.db
```

```gitignore
# INCORRECT — Problems in .gitignore
Cargo.lock                              # FORBIDDEN: must be committed!
/node_modules/                          # Not a Node project — stale entry
# target/                               # Commented-out: either keep or remove
*.log                                   # Overly broad — could hide useful logs
.DS_Store?                              # Wrong glob pattern
```

## Related Skills
- [standards-gitattributes-rules](file://.opencode/skills/standards-gitattributes-rules.md)
- [standards-directory-root-files](file://.opencode/skills/standards-directory-root-files.md)
