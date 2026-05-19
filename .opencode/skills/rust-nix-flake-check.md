# Nix Flake Check (Environmental Consistency)

## Description
`nix flake check` SHALL run on every commit to verify the entire Nix environment is consistent. CI SHALL NOT install anything outside the Nix sandbox.

## When to Load
Load this skill when setting up CI pipelines, verifying flake.nix correctness, or enforcing hermetic build guarantees.

## Source
STANDARDS.adoc §1.5.4 (lines 1038–1053), §1.5.6 (lines 1097–1127)

## Key Rules

- **MANDATE**: CI SHALL run `nix flake check` on every commit.
- **MANDATE**: CI SHALL fail if `nix flake check` reports any issue.
- **MANDATE**: CI SHALL NOT install anything outside the Nix sandbox.
- **MANDATE**: Before accepting any non-hermetic build step, prove Nix sandbox cannot express it. If Nix CAN express it, the Nix expression is mandatory.
- **SHOULD**: `nix flake check` runs after `nix build .` in CI pipeline.

## CI Pipeline Commands

```bash
# Step 1: Verify the flake evaluates and all checks pass
nix flake check

# Step 2: Enter the hermetic development shell
nix develop . -c just check

# Step 3: Build the project inside the sandbox
nix build .
```

## What nix flake check Validates

| Check | What It Proves |
|---|---|
| Flake evaluation | The flake.nix parses and evaluates without errors |
| All outputs defined | devShells, packages, checks etc. are well-formed |
| All inputs follow | Followed inputs resolve correctly |
| Nix sandbox consistency | No drifting drv inputs |

## Hermetic Build Guarantee

The Nix sandbox provides these mathematical guarantees:

| Property | Guarantee | Mechanism |
|---|---|---|
| System deps repeatable | ✅ Content-addressed store | `/nix/store` — identical hash = identical bits |
| rustc version stable | ✅ Exact pinned version | `rust-toolchain.toml` + fenix + flake.lock |
| Cargo build hermetic | ✅ No network, no /proc, no /usr | Nix build sandbox |
| All transitive deps pinned | ✅ Complete merkle tree | `flake.lock` = hash of ALL inputs |
| Bit-for-bit reproducibility | ✅ Same lock → same binary | Deterministic builds by default |
| build.rs environment fixed | ✅ Nix sets fixed env vars | build.rs cannot read host state |
| Rollback | ✅ `nix profile rollback` | All past envs remain in store |

## Related Skills
- [rust-nix-flake-structure](file://.opencode/skills/rust-nix-flake-structure.md)
- [rust-nix-dev-shell](file://.opencode/skills/rust-nix-dev-shell.md)
- [rust-flake-lock-committed](file://.opencode/skills/rust-flake-lock-committed.md)
- [rust-toolchain-toml](file://.opencode/skills/rust-toolchain-toml.md)
