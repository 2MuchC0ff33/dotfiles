---
name: xtask-main-structure
description: Description
compatibility: opencode
---

# xtask-main-structure

## Description
The xtask main.rs entry point with clap dispatch for all subcommands.

## When to Load
Load this skill when creating, modifying, or understanding the xtask binary entry point (`xtask/src/main.rs`), or when adding a new subcommand.

## Source
STANDARDS.adoc §8.2 (lines 2922–3002)

## Key Rules

- MANDATE: The xtask binary MUST use `clap` with `#[derive(Parser)]` and `#[derive(Subcommand)]` for argument parsing.
- MANDATE: The CLI struct MUST be named `Cli` with a single `#[command]` field of type `Command`.
- MANDATE: The `Command` enum MUST implement `Subcommand` and include ALL task variants listed below.
- MANDATE: The `main()` function MUST parse CLI args with `Cli::parse()` and dispatch to `tasks::<task>::run()` via match.
- MANDATE: The binary MUST use `anyhow::Result` as the return type from `main()`.
- MANDATE: The required modules are `mod tasks;` and `mod utils;` (not `tasks::mod` — Rust 2024 uses `mod tasks;` with `tasks/mod.rs` or `tasks.rs`).

## Required Command Enum Variants

```rust
enum Command {
    Check,                    // Run all checks (lint + test + proof + docs + audit)
    Lint,                     // Run clippy with strict settings
    Test,                     // Run all tests
    Proof,                    // Run Kani proofs
    Fuzz,                     // Run fuzz targets
    Docs,                     // Build documentation
    Audit,                    // Run security audit
    Release {                 // Prepare release
        #[arg(long)]
        version: String,
        #[arg(long, default_value = "false")]
        dry_run: bool,
    },
    Cross {                   // Cross-compile
        #[arg(long)]
        target: Option<String>,
    },
    NoStd,                    // Verify no_std compliance
    Msrv,                     // Check MSRV compliance
    Verify {                  // Run Kani function contract verification
        #[arg(long)]
        harness: Option<String>,
    },
}
```

## Complete main.rs Dispatch Pattern

```rust
fn main() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Command::Check               => tasks::check::run(),
        Command::Lint                => tasks::lint::run(),
        Command::Test                => tasks::test::run(),
        Command::Proof               => tasks::proof::run(),
        Command::Fuzz                => tasks::fuzz::run(),
        Command::Docs                => tasks::docs::run(),
        Command::Audit               => tasks::audit::run(),
        Command::Release { version, dry_run } => tasks::release::run(&version, dry_run),
        Command::Cross { target }    => tasks::cross::run(target.as_deref()),
        Command::NoStd               => tasks::nostd::run(),
        Command::Msrv                => tasks::msrv::run(),
        Command::Verify { harness }     => tasks::verify::run(harness.as_deref()),
    }
}
```

## Adding a New Subcommand

1. Add variant to `Command` enum with any needed fields.
2. Add a new task module `tasks::new_task` with a `pub fn run() -> Result<()>`.
3. Add match arm in `main()` dispatching to the new task.
4. Add a just recipe in the justfile calling `cargo xtask new-task`.

## Related Skills
- [xtask-task-module-pattern](file://.opencode/skills/xtask-task-module-pattern.md)
- [xtask-shell-run-command](file://.opencode/skills/xtask-shell-run-command.md)
- [xtask-shell-run-command-output](file://.opencode/skills/xtask-shell-run-command-output.md)
- [xtask-release-pipeline](file://.opencode/skills/xtask-release-pipeline.md)
- [just-recipe-check](file://.opencode/skills/just-recipe-check.md)
