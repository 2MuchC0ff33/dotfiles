---
name: xtask-release-pipeline
description: Description
compatibility: opencode
---

# xtask-release-pipeline

## Description
Release pipeline phases: check → README conversion → cross-compile → version instructions.

## When to Load
Load this skill when implementing, modifying, or understanding the release pipeline in `xtask/src/tasks/release.rs`.

## Source
STANDARDS.adoc §8.2 (lines 3037–3110)

## Key Rules

- MANDATE: The release pipeline MUST execute phases in this exact order:
  1. **Phase 1: Full check pipeline** — calls `super::check::run()` (lint + test + proof + docs + audit).
  2. **Phase 2: README.adoc → README.md conversion** — three-step AsciiDoc-to-Markdown conversion.
  3. **Phase 3: Cross-compile for all targets** — calls `super::cross::run(None)`.
  4. **Print next steps** — review CHANGELOG, commit, tag, publish.
- MANDATE: If `dry_run` is `true`, the function MUST print each phase description WITHOUT executing anything, then return `Ok(())`.
- MANDATE: The README conversion MUST be a three-step process:
  1. `asciidoctor --backend=docbook --out-file=README.xml README.adoc` — AsciiDoc to DocBook XML.
  2. `pandoc --from=docbook --to=gfm --output=README.md README.xml` — DocBook XML to GitHub-Flavored Markdown.
  3. `rm README.xml` — remove the intermediate DocBook file.
- MANDATE: Each step in README conversion MUST use `run_command()` with descriptive error messages.
- MANDATE: After all phases complete, the function MUST print the next steps for the developer.
- SHOULD: `README.md` is NEVER committed to the repository (it is in `.gitignore`); it is generated at release time only.
- SHOULD: The version bump (Cargo.toml) should happen before running `just release` or as part of Phase 3.
- FORBIDDEN: Do NOT run `cargo publish`, `git commit`, or `git tag` in the release pipeline — these are manual review steps.
- FORBIDDEN: Do NOT skip the check pipeline in release — a release without a passing check pipeline is forbidden.

## Full Implementation (STANDARDS lines 2995–3068)

```rust
//! Release task.
//!
//! Runs full check pipeline, generates README.md from README.adoc,
//! and prepares release artifacts.

use anyhow::Result;
use crate::utils::shell::run_command;

pub fn run(version: &str, dry_run: bool) -> Result<()> {
    if dry_run {
        println!("DRY RUN: Release would be prepared with version {version}");
        println!("  Phase 1: Full check pipeline");
        println!("  Phase 2: README.adoc -> README.md conversion");
        println!("  Phase 3: Version bump");
        println!("  Phase 4: Tag and sign");
        return Ok(());
    }

    // Phase 1: Full check must pass before release.
    println!("Phase 1: Running full check pipeline...");
    super::check::run()?;

    // Phase 2: Convert README.adoc to README.md for crates.io.
    println!("Phase 2: Generating README.md from README.adoc...");
    convert_readme()?;

    // Phase 3: Cross-compile for all targets.
    println!("Phase 3: Cross-compiling for all targets...");
    super::cross::run(None)?;

    println!("Release {version} prepared.");
    println!("Next steps:");
    println!("  1. Review CHANGELOG.adoc");
    println!("  2. Commit: git add -A && git commit -m 'release: {version}'");
    println!("  3. Tag:   git tag -s v{version} -m 'v{version}'");
    println!("  4. Publish: cargo publish");
    Ok(())
}

fn convert_readme() -> Result<()> {
    // Step 1: AsciiDoc -> DocBook via asciidoctor.
    run_command(
        "asciidoctor",
        &[
            "--backend=docbook",
            "--out-file=README.xml",
            "README.adoc",
        ],
        "asciidoctor failed: could not convert README.adoc to DocBook.",
    )?;

    // Step 2: DocBook -> Markdown via pandoc.
    run_command(
        "pandoc",
        &[
            "--from=docbook",
            "--to=gfm",
            "--output=README.md",
            "README.xml",
        ],
        "pandoc failed: could not convert README.xml to README.md.",
    )?;

    // Step 3: Remove intermediate DocBook file.
    run_command("rm", &["README.xml"],
        "Failed to remove intermediate README.xml.")?;

    println!("README.md generated from README.adoc.");
    Ok(())
}
```

## Dry Run Output Preview

```
DRY RUN: Release would be prepared with version 1.2.3
  Phase 1: Full check pipeline
  Phase 2: README.adoc -> README.md conversion
  Phase 3: Version bump
  Phase 4: Tag and sign
```

## Usage

```sh
cargo xtask release --version 1.2.3              # Full release
cargo xtask release --version 1.2.3 --dry-run    # Preview only
just release 1.2.3                                # Via just recipe
```

## Manual Release Steps (After `just release`)

1. Review `CHANGELOG.adoc` — verify all changes for this version are documented.
2. Commit the changes (version bump, README.md, CHANGELOG):
   - `jj describe -m "release: 1.2.3"` (or `git commit -m "release: 1.2.3"`)
3. Create a signed tag:
   - `git tag -s v1.2.3 -m "v1.2.3"`
4. Publish to crates.io:
   - `cargo publish`
5. Push the tag and commits:
   - `jj git push` (or `git push && git push --tags`)

## Related Skills
- [just-recipe-release](file://.opencode/skills/just-recipe-release.md)
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
- [just-recipe-cross](file://.opencode/skills/just-recipe-cross.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
- [xtask-task-module-pattern](file://.opencode/skills/xtask-task-module-pattern.md)
- [xtask-shell-run-command](file://.opencode/skills/xtask-shell-run-command.md)
