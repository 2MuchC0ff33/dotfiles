# just-recipe-cross

## Description
Cross-compilation recipes: build for all configured targets or a single target.

## When to Load
Load this skill when implementing, modifying, or documenting the `cross` or `cross-one` recipes in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2810–2816)

## Key Rules

- MANDATE: `cross` MUST run `cargo xtask cross` (builds for all configured targets with a single command).
- MANDATE: `cross-one TARGET` MUST run `cargo xtask cross --target {{TARGET}}` (accepts a target triple as argument).
- MANDATE: The `TARGET` parameter in `cross-one` is a required positional argument (not optional).
- SHOULD: Use `cross-one TARGET` during development iteration to test a specific target without building all.
- SHOULD: Target triples follow the standard Rust format: `aarch64-unknown-linux-gnu`, `x86_64-pc-windows-gnu`, `x86_64-apple-darwin`, etc.
- SHOULD: The xtask `cross` subcommand should use `cargo-zigbuild` for cross-compilation (as specified in toolchain: see STANDARDS Part 1).
- FORBIDDEN: Do NOT inline `cargo build --target` in the just `cross` recipe — delegate to xtask.
- FORBIDDEN: Do NOT commit target-specific build artifacts — clean before cross-compilation.

## Examples

```just
# Cross-compile for all configured targets
cross:
    cargo xtask cross

# Cross-compile for a single target
cross-one TARGET:
    cargo xtask cross --target {{TARGET}}
```

Usage:
```sh
just cross                              # Build for all targets
just cross-one aarch64-unknown-linux-gnu # Build only for ARM64 Linux
just cross-one x86_64-pc-windows-gnu     # Build only for Windows 64-bit
```

## Related Skills
- [just-recipe-release](file://.opencode/skills/just-recipe-release.md)
- [xtask-main-structure](file://.opencode/skills/xtask-main-structure.md)
- [xtask-task-module-pattern](file://.opencode/skills/xtask-task-module-pattern.md)
- [xtask-release-pipeline](file://.opencode/skills/xtask-release-pipeline.md)
