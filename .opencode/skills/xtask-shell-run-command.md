# xtask-shell-run-command

## Description
The `run_command()` utility for strict command execution — any failure is a hard error.

## When to Load
Load this skill when using, modifying, or understanding the `run_command()` function in `xtask/src/utils/shell.rs`.

## Source
STANDARDS.adoc §8.3 (lines 3113–3155)

## Key Rules

- MANDATE: `run_command()` MUST accept exactly three parameters: `program: &str`, `args: &[&str]`, and `error_message: &str`.
- MANDATE: `run_command()` MUST return `anyhow::Result<()>`.
- MANDATE: `run_command()` MUST use `std::process::Command::new(program).args(args).status()` — NOT `.output()` (use `run_command_output` for captured output).
- MANDATE: If the command exits with a non-zero status, the function MUST return an error via `anyhow::bail!()` containing:
  - The `error_message` parameter
  - The full command string (program + args)
  - The exit code
- MANDATE: If spawning the command fails (e.g., program not found), the function MUST use `anyhow::Context` to wrap the error with a descriptive message.
- MANDATE: The first parameter is `program` (not `command`) — always use the `Command` struct from `std::process`.
- SHOULD: Use `run_command` for all external tool invocations in xtask tasks (cargo, asciidoctor, pandoc, rm, etc.).
- SHOULD: Provide descriptive, actionable `error_message` values that tell the user what went wrong and what to do.
- FORBIDDEN: Do NOT use `std::process::Command` directly in task modules — always use this utility.
- FORBIDDEN: Do NOT suppress exit codes or use `|| true` — any failure is a hard error.
- FORBIDDEN: Do NOT capture stdout/stderr automatically — this function uses `.status()` and only reports exit codes.

## Full Implementation (STANDARDS lines 3079–3111)

```rust
/// [PROVED] Run a command, fail hard on any error.
/// Panics only if the system is out of memory (cannot spawn process).
pub fn run_command(
    program: &str,
    args: &[&str],
    error_message: &str,
) -> Result<()> {
    let status = Command::new(program)
        .args(args)
        .status()
        .with_context(|| {
            format!(
                "Failed to execute: {} {}",
                program,
                args.join(" ")
            )
        })?;

    if !status.success() {
        bail!(
            "{}\nCommand: {} {}\nExit code: {}",
            error_message,
            program,
            args.join(" "),
            status.code().unwrap_or(-1)
        );
    }

    Ok(())
}
```

## Usage Examples

```rust
// Simple command
run_command("cargo", &["fmt", "--all", "--check"],
    "Format check failed. Run `just fmt` to fix.")?;

// Multi-arg command
run_command("cargo", &["kani", "--default-unwind", "100", "--output-format", "terse"],
    "Kani proof verification failed.")?;

// Chained from task module
use crate::utils::shell::run_command;
```

## Error Message Best Practices

| Bad Error Message | Good Error Message |
|---|---|
| "Command failed." | "Format check failed. Run `just fmt` to fix." |
| "Error." | "Kani proof verification failed. See Kani output above for details." |
| "Something broke." | "asciidoctor failed: could not convert README.adoc to DocBook." |

## Related Skills
- [xtask-shell-run-command-output](file://.opencode/skills/xtask-shell-run-command-output.md)
- [xtask-task-module-pattern](file://.opencode/skills/xtask-task-module-pattern.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
