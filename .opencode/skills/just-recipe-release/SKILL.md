---
name: just-recipe-release
description: Description
compatibility: opencode
---

# just-recipe-release

## Description
Release preparation recipe: full check pipeline, README generation, and version bump.

## When to Load
Load this skill when implementing, modifying, or documenting the `release` recipe in the justfile, or when preparing a new project release.

## Source
STANDARDS.adoc §8.1 (lines 2854–2856); xtask release module (lines 3037–3111)

## Key Rules

- MANDATE: `release VERSION` MUST run `cargo xtask release --version {{VERSION}}` — the `VERSION` is a required positional argument.
- MANDATE: The version string MUST follow semantic versioning (semver): `MAJOR.MINOR.PATCH` (e.g., `1.2.3`).
- MANDATE: The release pipeline MUST run phases in this exact order:
  1. Full check pipeline (lint + test + proof + docs + audit) — any failure aborts the release.
  2. README.adoc → README.md conversion via asciidoctor → DocBook → pandoc → Markdown.
  3. Cross-compile for all targets.
  4. Print next steps (review CHANGELOG, commit, tag, publish).
- MANDATE: README conversion MUST use a three-step process:
  1. `asciidoctor --backend=docbook --out-file=README.xml README.adoc`
  2. `pandoc --from=docbook --to=gfm --output=README.md README.xml`
  3. `rm README.xml` (clean up intermediate file)
- MANDATE: The `--dry-run` flag on xtask release MUST print each phase without executing.
- SHOULD: `README.md` is generated from `README.adoc` only at release time and is never committed to the repository (in `.gitignore`).
- SHOULD: After `just release`, manually review CHANGELOG.adoc before committing.
- FORBIDDEN: Do NOT run `cargo publish` as part of the release recipe — publishing is a manual step after review.
- FORBIDDEN: Do NOT auto-create git tags — the recipe prints instructions but does not tag.

## Example

```just
# Prepare release (full check + README generation + version bump)
release VERSION:
    cargo xtask release --version {{VERSION}}
```

The xtask release module (lines 3037–3111) implements:
```rust
pub fn run(version: &str, dry_run: bool) -> Result<()> {
    if dry_run {
        println!("DRY RUN: Release would be prepared with version {version}");
        println!("  Phase 1: Full check pipeline");
        println!("  Phase 2: README.adoc -> README.md conversion");
        println!("  Phase 3: Version bump");
        println!("  Phase 4: Tag and sign");
        return Ok(());
    }
    // Phase 1
    super::check::run()?;
    // Phase 2
    convert_readme()?;
    // Phase 3
    super::cross::run(None)?;
    // Print next steps
    Ok(())
}
```

Usage:
```sh
just release 1.2.3           # Full release preparation
cargo xtask release --version 1.2.3 --dry-run  # Dry run to preview
```

## Manual Release Steps (after `just release`)
1. Review `CHANGELOG.adoc` — ensure all changes are documented.
2. Commit: `git add -A && git commit -m 'release: 1.2.3'` (or `jj describe -m 'release: 1.2.3'`).
3. Tag: `git tag -s v1.2.3 -m 'v1.2.3'` (signed tag with GPG).
4. Publish: `cargo publish` (then push tags).

## Related Skills
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [just-recipe-cross](file://.opencode/skills/just-recipe-cross.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
- [xtask-release-pipeline](file://.opencode/skills/xtask-release-pipeline.md)
- [xtask-shell-run-command](file://.opencode/skills/xtask-shell-run-command.md)
