# xtask-shell-run-command-output

## Description
The `run_command_output()` utility for executing commands and capturing stdout as a string.

## When to Load
Load this skill when using, modifying, or understanding the `run_command_output()` function in `xtask/src/utils/shell.rs`, or when a task needs to capture and process command output.

## Source
STANDARDS.adoc §8.3 (lines 3155–3183)

## Key Rules

- MANDATE: `run_command_output()` MUST accept exactly two parameters: `program: &str` and `args: &[&str]`.
- MANDATE: `run_command_output()` MUST return `anyhow::Result<String>` (the captured stdout as a UTF-8 string).
- MANDATE: `run_command_output()` MUST use `std::process::Command::new(program).args(args).output()` — NOT `.status()` (use `run_command` for fire-and-forget).
- MANDATE: If the command exits with a non-zero status, the function MUST return an error containing:
  - The command string
  - The stderr output (via `String::from_utf8_lossy`)
- MANDATE: If spawning the command fails, the function MUST use `anyhow::Context` to wrap the error.
- MANDATE: After a successful exit, the function MUST decode stdout via `String::from_utf8(output.stdout)` and return an error if the output is not valid UTF-8.
- SHOULD: Use `run_command_output` when you need to capture stdout for further processing (e.g., parsing version strings, listing files, getting command output).
- SHOULD: Use `run_command` (not `run_command_output`) when you don't need the output — it's more efficient.
- FORBIDDEN: Do NOT use `String::from_utf8_lossy` on successful stdout — non-UTF-8 output at that point is a hard error.
- FORBIDDEN: Do NOT use `run_command_output` for commands that produce large binary output — it buffers everything in memory.
- FORBIDDEN: Do NOT ignore the stderr in error messages — always include it for debugging.

## Full Implementation (STANDARDS lines 3113–3141)

```rust
/// [PROVED] Run command and capture output.
/// Fails if command fails OR if output is not valid UTF-8.
pub fn run_command_output(
    program: &str,
    args: &[&str],
) -> Result<String> {
    let output = Command::new(program)
        .args(args)
        .output()
        .with_context(|| {
            format!(
                "Failed to execute: {} {}",
                program,
                args.join(" ")
            )
        })?;

    if !output.status.success() {
        bail!(
            "Command failed: {} {}\nStderr: {}",
            program,
            args.join(" "),
            String::from_utf8_lossy(&output.stderr)
        );
    }

    String::from_utf8(output.stdout)
        .context("Command output was not valid UTF-8")
}
```

## Usage Examples

```rust
// Get current git commit hash
let git_hash = run_command_output("git", &["rev-parse", "HEAD"])?;

// Get Rust toolchain version
let rust_version = run_command_output("rustc", &["--version"])?;

// Parse output
let version_str = git_hash.trim().to_string();
```

## `run_command` vs `run_command_output`

| Function | Returns | Use Case |
|---|---|---|
| `run_command()` | `Result<()>` | Fire-and-forget: build, test, lint, format |
| `run_command_output()` | `Result<String>` | Need stdout: get version, check tool presence, parse output |

## Related Skills
- [xtask-shell-run-command](file://.opencode/skills/xtask-shell-run-command.md)
- [xtask-task-module-pattern](file://.opencode/skills/xtask-task-module-pattern.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
