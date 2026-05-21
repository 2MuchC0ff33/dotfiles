---
name: xtask-task-module-pattern
description: Description
compatibility: opencode
---

# xtask-task-module-pattern

## Description
Standard module pattern for xtask task implementations — one module per subcommand.

## When to Load
Load this skill when creating or modifying a task module under `xtask/src/tasks/`, such as `check.rs`, `lint.rs`, `test.rs`, `proof.rs`, `fuzz.rs`, `docs.rs`, `audit.rs`, `release.rs`, `cross.rs`, `nostd.rs`, `msrv.rs`, or `verify.rs`.

## Source
STANDARDS.adoc §8.2 (lines 3005–3038, 3037–3110)

## Key Rules

- MANDATE: Each task module MUST be a separate file under `xtask/src/tasks/` named after the subcommand (e.g., `check.rs`, `lint.rs`).
- MANDATE: Each task module MUST expose a public `run()` function with signature `pub fn run() -> Result<()>` (for tasks without parameters) or `pub fn run(arg: &str) -> Result<()>` (for parameterized tasks).
- MANDATE: All task modules MUST use `use anyhow::Result;` for the return type.
- MANDATE: All tasks MUST use `crate::utils::shell::run_command` (not `std::process::Command` directly).
- MANDATE: Each task file MUST start with a doc comment describing the task's purpose and requirements.
- SHOULD: Print human-readable progress messages (`println!`) at key phases so the user sees what's happening.
- SHOULD: Print a success message at the end of the task (e.g., "All Kani proofs passed.").
- FORBIDDEN: Do NOT use `unwrap()` or `expect()` in task modules — use `anyhow`'s `?` operator.
- FORBIDDEN: Do NOT put task logic directly in `main.rs` — each task must be in its own module.

## Standard Task Module Template

```rust
//! Task name: one-line description
//!
//! MANDATE: [key requirement from STANDARDS]
//! [Additional context or rationale]

use anyhow::Result;
use crate::utils::shell::run_command;

pub fn run() -> Result<()> {
    println!("Running task...");

    run_command(
        "program",
        &["arg1", "arg2", "--flag", "value"],
        "Human-readable error message explaining what failed.",
    )?;

    println!("Task completed successfully.");
    Ok(())
}
```

## Example: proof.rs (STANDARDS lines 2960–2993)

```rust
//! Proof task: runs Kani verification.
//!
//! MANDATE: All Kani proofs must pass before merge.
//! Kani verifies: no panics, no overflow, no bounds errors, invariants.

use anyhow::Result;
use crate::utils::shell::run_command;

pub fn run() -> Result<()> {
    println!("Running Kani verification...");
    println!("This will take 30-60 minutes for a full proof run.");
    println!("(Use --target to limit to specific proof harness for faster iteration)");

    run_command(
        "cargo",
        &[
            "kani",
            "--default-unwind", "100",
            "--output-format", "terse",
        ],
        "Kani proof verification failed. See Kani output above for details.",
    )?;

    println!("All Kani proofs passed.");
    Ok(())
}
```

## Example: release.rs (STANDARDS lines 2995–3068) — Parameterized Task

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
        // ...
        return Ok(());
    }

    super::check::run()?;
    // ...
    Ok(())
}
```

## Task Module Registration
Each module must be declared in `xtask/src/tasks/mod.rs`:
```rust
pub mod audit;
pub mod check;
pub mod cross;
pub mod docs;
pub mod fuzz;
pub mod lint;
pub mod msrv;
pub mod nostd;
pub mod proof;
pub mod release;
pub mod test;
pub mod verify;
```

## Related Skills
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
- [xtask-shell-run-command](file://.opencode/skills/xtask-shell-run-command.md)
- [xtask-shell-run-command-output](file://.opencode/skills/xtask-shell-run-command-output.md)
- [xtask-release-pipeline](file://.opencode/skills/xtask-release-pipeline.md)
