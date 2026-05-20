# just-recipe-clean

## Description
Clean build artifacts recipe for a fresh workspace state.

## When to Load
Load this skill when implementing, modifying, or documenting the `clean` recipe in the justfile.

## Source
STANDARDS.adoc §8.1 (lines 2902–2905)

## Key Rules

- MANDATE: `clean` MUST run `cargo clean && rm -rf build/` — both cargo's target directory AND the project's build/ directory.
- MANDATE: The `&&` operator ensures that if `cargo clean` fails, `rm -rf build/` is NOT executed (fail-fast).
- MANDATE: `build/` is a project-specific directory for generated artifacts (not cargo's `target/`).
- SHOULD: Run `just clean` before switching branches or when experiencing strange build errors.
- SHOULD: Run `just clean` before cross-compilation to ensure no host-architecture artifacts interfere.
- FORBIDDEN: Do NOT use `rm -rf target/` instead of `cargo clean` — `cargo clean` is safer and respects build profiles.
- FORBIDDEN: Do NOT add `sudo` or `--force` flags — cleanup should not require privileges.
- FORBIDDEN: Do NOT include `rm -rf .cache/` or other caches — only build artifacts should be removed.

## Example

```just
# Clean build artifacts
clean:
    cargo clean
    rm -rf build/
```

## What Gets Removed
| Path | Reason |
|---|---|
| `target/` | All cargo compilation artifacts (via `cargo clean`) |
| `build/` | Generated documentation, release artifacts, intermediate files |

## Related Skills
- [just-recipe-cross](file://.opencode/skills/just-recipe-cross.md)
- [just-recipe-release](file://.opencode/skills/just-recipe-release.md)
