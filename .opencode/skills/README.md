# SKILLS — opencode Agent Skill Definitions

## Overview

This directory contains **247 atomic skill files** for opencode agents working on this repository.
Each skill covers one specific rule, pattern, or convention from `STANDARDS.adoc` (v2.0.0).

## How to Load Skills

Use opencode's skill tool:

```json
<function>skill</function>
{
  "name": "skill-filename-without-extension"
}
```

For example, to load the skill for fuzzy completions:

```json
<function>skill</function>
{
  "name": "nushell-config-completions-fuzzy"
}
```

## Skill Reference

### Nushell Configuration (41 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-config-error-style-fancy` | §11.1 | `error_style: "fancy"` setting |
| `nushell-config-shell-integration-osc2` | §11.1 | OSC 2 window title integration |
| `nushell-config-shell-integration-osc7` | §11.1 | OSC 7 working directory URL |
| `nushell-config-shell-integration-osc133` | §11.1 | OSC 133 semantic prompts |
| `nushell-config-history-sqlite` | §11.1 | `file_format: "sqlite"` for history |
| `nushell-config-history-max-size` | §11.1 | `max_size: 100_000` history limit |
| `nushell-config-history-sync` | §11.1 | `sync_on_each_command: true` |
| `nushell-config-history-isolation` | §11.1 | `isolation: true` for history |
| `nushell-config-completions-fuzzy` | §11.1 | `algorithm: "fuzzy"` for completions |
| `nushell-config-completions-case-sensitive` | §11.1 | `case_sensitive: true` |
| `nushell-config-completions-quick` | §11.1 | `quick: false` setting |
| `nushell-config-completions-partial` | §11.1 | `partial: false` setting |
| `nushell-config-table-mode-rounded` | §11.1 | `mode: "rounded"` for table |
| `nushell-config-table-index-always` | §11.1 | `index_mode: "always"` |
| `nushell-config-table-trim-wrapping` | §11.1 | Trim methodology with `wrapping_try_keep_words` |
| `nushell-alias-ls-eza` | §11.1 | `ls = eza --long --git --icons` |
| `nushell-alias-ll-eza` | §11.1 | `ll = eza --long --git --icons --all` |
| `nushell-alias-lt-eza` | §11.1 | `lt = eza --tree --git --icons` |
| `nushell-alias-cat-bat` | §11.1 | `cat = bat --style=full` |
| `nushell-alias-find-fd` | §11.1 | `find = fd` |
| `nushell-alias-grep-rg` | §11.1 | `grep = rg` |
| `nushell-alias-du-dust` | §11.1 | `du = dust` |
| `nushell-alias-ps-procs` | §11.1 | `ps = procs` |
| `nushell-alias-top-bottom` | §11.1 | `top = btm` (bottom) |
| `nushell-alias-sed-sd` | §11.1 | `sed = sd` |
| `nushell-alias-cd-zoxide` | §11.1 | `cd = z` (zoxide) |
| `nushell-alias-git-jj` | §11.1 | `git = jj` |
| `nushell-alias-diff-delta` | §11.1 | `diff = delta` |
| `nushell-alias-curl-xh` | §11.1 | `curl = xh` |
| `nushell-alias-dig-dog` | §11.1 | `dig = dog` |
| `nushell-alias-ping-gping` | §11.1 | `ping = gping` |
| `nushell-alias-tar-ouch` | §11.1 | `tar = ouch` |
| `nushell-alias-cargo-c` | §11.1 | `c = cargo` |
| `nushell-alias-xtask-cxt` | §11.1 | `cxt = cargo xtask` |
| `nushell-alias-just-j` | §11.1 | `j = just` |
| `nushell-env-editor-hx` | §11.1 | `$env.EDITOR = "hx"` / `$env.VISUAL = "hx"` |
| `nushell-env-rustflags` | §11.1 | `$env.RUSTFLAGS = "-Dwarnings"` |
| `nushell-env-cargo-term-color` | §11.1 | `$env.CARGO_TERM_COLOR = "always"` |
| `nushell-env-proptest-cases` | §11.1 | `$env.PROPTEST_CASES = "100000"` |
| `nushell-env-locale` | §11.1 | `$env.LANG` / `$env.LC_ALL` |
| `nushell-starship-init` | §11.1 | Starship init for Nushell |

### Nushell Naming Conventions (9 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-naming-commands-kebab` | §11.5.1 | Commands MUST be kebab-case |
| `nushell-naming-commands-subcommands-kebab` | §11.5.1 | Sub-commands kebab-case with space |
| `nushell-naming-variables-snake` | §11.5.1 | Variables/params snake_case |
| `nushell-naming-env-vars-screaming-snake` | §11.5.1 | Env vars SCREAMING_SNAKE_CASE |
| `nushell-naming-flags-kebab` | §11.5.1 | Flags kebab-case |
| `nushell-naming-constants-screaming-snake` | §11.5.1 | Constants SCREAMING_SNAKE_CASE |
| `nushell-naming-files-kebab` | §11.5.1 | Files/modules kebab-case |
| `nushell-naming-forbidden-pascal-case` | §11.5.1 | FORBIDDEN PascalCase |
| `nushell-naming-no-abbreviations` | §11.5.1 | FORBIDDEN abbreviations |

### Nushell Formatting (7 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-formatting-pipe-spacing` | §11.5.2 | One space before/after pipe |
| `nushell-formatting-no-commas-lists` | §11.5.2 | Omit commas in list literals |
| `nushell-formatting-closure-pipes` | §11.5.2 | `{|x|}` not `{ |x| }` |
| `nushell-formatting-record-colons` | §11.5.2 | One space after `:` in records |
| `nushell-formatting-no-trailing-whitespace` | §11.5.2 | No trailing whitespace |
| `nushell-formatting-multiline-pipelines` | §11.5.2 | Multi-line pipeline formatting |
| `nushell-formatting-multiline-records` | §11.5.2 | Multi-line record formatting |

### Nushell String Rules (3 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-strings-format-priority` | §11.5.3 | String format priority (6 levels) |
| `nushell-strings-no-unnecessary-double-quotes` | §11.5.3 | Single quotes over double |
| `nushell-strings-no-unnecessary-interpolation` | §11.5.3 | No interpolation without variables |

### Nushell Type Annotations (6 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-types-param-annotations` | §11.5.4 | Type annotations on all params |
| `nushell-types-io-signatures` | §11.5.4 | I/O signatures `: input -> output` |
| `nushell-types-const-typed` | §11.5.4 | Constants MUST be typed |
| `nushell-types-return-type-documented` | §11.5.4 | Documented return types |
| `nushell-types-private-annotations` | §11.5.4 | SHOULD annotate private cmds |
| `nushell-types-complex-syntax` | §11.5.4 | Complex type syntax reference |

### Nushell Pipeline Patterns (6 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-pipeline-pipelines-over-imperative` | §11.5.5 | Pipelines over imperative loops |
| `nushell-pipeline-reduce-over-mut` | §11.5.5 | `reduce` over `mut` accumulator |
| `nushell-pipeline-each-over-for` | §11.5.5 | `each` over `for` |
| `nushell-pipeline-where-over-if` | §11.5.5 | `where` over manual `if` filtering |
| `nushell-pipeline-enumerate-over-index` | §11.5.5 | `enumerate` over manual counters |
| `nushell-pipeline-implicit-return` | §11.5.5 | Implicit return over `echo` |

### Nushell Module Patterns (7 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-module-export-minimal` | §11.5.6 | Export only what's needed |
| `nushell-module-export-main` | §11.5.6 | `export def main` pattern |
| `nushell-module-export-env` | §11.5.6 | `export-env` for env setup |
| `nushell-module-const-paths` | §11.5.6 | `const` paths for source/use |
| `nushell-module-submodules` | §11.5.6 | `export module` for namespaces |
| `nushell-module-re-exports` | §11.5.6 | `export use` for re-exports |
| `nushell-module-private-helpers` | §11.5.6 | Private helpers stay un-exported |

### Nushell Error Handling (6 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-errors-try-catch` | §11.5.7 | `try`/`catch` for fallible ops |
| `nushell-errors-complete-external` | §11.5.7 | `complete` for external commands |
| `nushell-errors-error-make-label` | §11.5.7 | `error make` with `label`/`span` |
| `nushell-errors-default-over-null-check` | §11.5.7 | `default` over manual null checks |
| `nushell-errors-capture-stdin` | §11.5.7 | Capture `$in` with `let` |
| `nushell-errors-optional-field-access` | §11.5.7 | `?` for optional field access |

### Nushell Security (9 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-security-no-code-injection` | §11.5.8 | No code injection patterns |
| `nushell-security-no-shell-injection` | §11.5.8 | No shell command injection |
| `nushell-security-no-hardcoded-secrets` | §11.5.8 | No secrets in source code |
| `nushell-security-path-traversal-guard` | §11.5.8 | Path traversal protection |
| `nushell-security-path-operations-safe` | §11.5.8 | Safe rm/.. operations |
| `nushell-security-glob-validation` | §11.5.8 | Glob pattern validation |
| `nushell-security-temp-files` | §11.5.8 | Secure temp file handling |
| `nushell-security-credential-scoping` | §11.5.8 | Scoped credentials with `with-env` |
| `nushell-security-external-prefix` | §11.5.8 | `^` prefix for external commands |

### Nushell Anti-Patterns (23 skills)

| Skill | STANDARDS § | Anti-Pattern # |
|---|---|---|
| `nushell-antipattern-echo-return` | §11.5.9 | #1: echo for return values |
| `nushell-antipattern-for-final-expression` | §11.5.9 | #2: for as final expression |
| `nushell-antipattern-mut-accumulator` | §11.5.9 | #3: mut accumulator + for |
| `nushell-antipattern-dynamic-source` | §11.5.9 | #4: Dynamic source/use paths |
| `nushell-antipattern-bash-redirect` | §11.5.9 | #5: Bash-style redirection |
| `nushell-antipattern-string-parse-external` | §11.5.9 | #6: String-parsing external output |
| `nushell-antipattern-missing-types` | §11.5.9 | #7: Missing type annotations |
| `nushell-antipattern-closure-pipe-space` | §11.5.9 | #8: Space before \|params\| |
| `nushell-antipattern-env-regular-def` | §11.5.9 | #9: env changes in regular def |
| `nushell-antipattern-unnecessary-interpolation` | §11.5.9 | #10: Unnecessary interpolation |
| `nushell-antipattern-sequential-each` | §11.5.9 | #11: each when par-each works |
| `nushell-antipattern-missing-docs` | §11.5.9 | #12: Missing command docs |
| `nushell-antipattern-manual-null-check` | §11.5.9 | #13: Manual null checks |
| `nushell-antipattern-manual-parse` | §11.5.9 | #14: Manual structured data parse |
| `nushell-antipattern-if-else-chains` | §11.5.9 | #15: if-else chains for branching |
| `nushell-antipattern-shebang-missing-stdin` | §11.5.9 | #16: Missing --stdin in shebang |
| `nushell-antipattern-forgot-export` | §11.5.9 | #17: Forgetting export in modules |
| `nushell-antipattern-pipeline-vs-params` | §11.5.9 | #18: Confusing pipeline vs params |
| `nushell-antipattern-each-single-record` | §11.5.9 | #19: each on single records |
| `nushell-antipattern-missing-field-access` | §11.5.9 | #20: Missing field access without ? |
| `nushell-antipattern-no-hat-external` | §11.5.9 | #21: Not prefixing externals with ^ |
| `nushell-antipattern-ignored-exit-codes` | §11.5.9 | #22: Ignoring external exit codes |
| `nushell-antipattern-length-for-emptiness` | §11.5.9 | #23: Length checks for emptiness |

### Nushell Performance (6 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-performance-par-each` | §11.5.10 | par-each for I/O/CPU-bound work |
| `nushell-performance-each-order` | §11.5.10 | each only when order matters |
| `nushell-performance-cache-let` | §11.5.10 | Cache expensive results in let |
| `nushell-performance-glob-depth` | §11.5.10 | --depth limits on glob |
| `nushell-performance-streaming` | §11.5.10 | Streaming for large files |
| `nushell-performance-builtins-vs-external` | §11.5.10 | Builtins vs externals by scale |

### Nushell Linting (5 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-linting-nu-lint-mandate` | §11.5.11 | nu-lint in CI mandate |
| `nushell-linting-nu-lint-toml` | §11.5.11 | .nu-lint.toml configuration |
| `nushell-linting-nu-lint-toml-reference` | §11.5.11 | Full .nu-lint.toml reference |
| `nushell-linting-topiary` | §11.5.11 | topiary formatting |
| `nushell-linting-ci-integration` | §11.5.11 | CI integration for nu-lint |

### Nushell Testing (5 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `nushell-testing-exported-commands` | §11.5.12 | Tests for exported commands |
| `nushell-testing-test-location` | §11.5.12 | tests/ directory naming |
| `nushell-testing-assert-patterns` | §11.5.12 | assert patterns and @example |
| `nushell-testing-nupm` | §11.5.12 | nupm test usage |
| `nushell-testing-example-attribute` | §11.5.12 | @example doc-test attribute |

### jj Version Control (25 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `jj-install-cargo` | §10.2.1 | Install via `cargo install` |
| `jj-init-colocate` | §10.2.2 | `jj git init --colocate` |
| `jj-config-user` | §10.2.3 | User name, email, editor |
| `jj-config-git-settings` | §10.2.3 | Git backend: auto-local-branch, rebase, push-conflict |
| `jj-config-colors` | §10.2.3 | Diff color configuration |
| `jj-config-log-template` | §10.2.3 | Compact log template |
| `jj-command-new` | §10.2.4 | `jj new [BRANCH]` |
| `jj-command-describe` | §10.2.4 | `jj describe -m "msg"` |
| `jj-command-log` | §10.2.4 | `jj log` |
| `jj-command-status` | §10.2.4 | `jj status` |
| `jj-command-edit` | §10.2.4 | `jj edit HASH` |
| `jj-command-abandon` | §10.2.4 | `jj abandon` |
| `jj-command-undo` | §10.2.4 | `jj undo` |
| `jj-command-rebase` | §10.2.4 | `jj rebase -d` |
| `jj-command-squash` | §10.2.4 | `jj squash` |
| `jj-command-split` | §10.2.4 | `jj split` |
| `jj-command-resolve` | §10.2.4 | `jj resolve` |
| `jj-command-git-push` | §10.2.4 | `jj git push` |
| `jj-collaboration-git-fetch` | §10.2.4 | `jj git fetch` + rebase |
| `jj-collaboration-gh-cli` | §10.2.7 | `gh` CLI for PRs |
| `jj-collaboration-branch-protection` | §10.4 | Branch protection rules |
| `jj-git-gap-submodules` | §10.2.7 | Git submodules fallback |
| `jj-git-format-patch-am` | §10.2.7 | Email workflow with git |
| `jj-git-no-prepare-commit-msg` | §10.2.7 | No prepare-commit-msg hook |
| `jj-git-direct-commands` | §10.2.7 | When to fallback to git |

### AsciiDoc Documentation (17 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `asciidoc-document-header` | §9.4 | Mandatory header template |
| `asciidoc-section-ids-explicit` | §9.5 | Explicit `[#id]` on every section |
| `asciidoc-file-naming-kebab` | §9.3 | kebab-case file naming |
| `asciidoc-directory-naming` | §9.3 | Singular kebab-case dirs |
| `asciidoc-one-sentence-per-line` | §9.6 | 1 sentence/line, max 80 chars |
| `asciidoc-code-blocks-language` | §9.6 | Language declarations |
| `asciidoc-tables-mandatory-structure` | §9.6 | Column specs + headers + titles |
| `asciidoc-cross-references-explicit` | §9.6 | Explicit xref IDs |
| `asciidoc-external-links-descriptive` | §9.6 | Descriptive link text |
| `asciidoc-attributes-for-repeated-values` | §9.6 | AsciiDoc attributes |
| `asciidoc-admonitions-with-titles` | §9.6 | Admonition formatting |
| `asciidoc-forbidden-language` | §9.6 | Prose restrictions |
| `asciidoc-callouts-vs-inline-comments` | §9.6 | Callouts over inline comments |
| `asciidoc-vale-config` | §9.7 | Vale `.vale.ini` config |
| `asciidoc-vale-styles` | §9.7 | Vale styles and vocabularies |
| `asciidoc-readme-generation-pipeline` | §9.8 | README.adoc → README.md gen |
| `asciidoc-build-failure-level` | §9.1 | `--failure-level=WARN` |

### Build System: justfile (18 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `just-recipe-default` | §8.1 | `default` recipe |
| `just-recipe-check` | §8.1 | `check` recipe |
| `just-recipe-lint` | §8.1 | `lint` recipe |
| `just-recipe-test` | §8.1 | `test` recipes |
| `just-recipe-proof` | §8.1 | `proof` recipe |
| `just-recipe-fmt` | §8.1 | `fmt` / `fmt-check` |
| `just-recipe-clippy` | §8.1 | `clippy` recipe |
| `just-recipe-docs` | §8.1 | `docs` recipes |
| `just-recipe-audit` | §8.1 | `audit` / `outdated` |
| `just-recipe-cross` | §8.1 | `cross` / `cross-one` |
| `just-recipe-vcs` | §8.1 | VCS recipes |
| `just-recipe-release` | §8.1 | `release VERSION` |
| `just-recipe-nix` | §8.1 | Nix environment recipes |
| `just-recipe-ci` | §8.1 | `ci` recipe |
| `just-recipe-clean` | §8.1 | `clean` recipe |
| `just-recipe-setup-legacy` | §8.1 | Legacy setup recipes |
| `just-recipe-proptest` | §8.1 | `proptest` recipe |
| `just-recipe-fuzz` | §8.1 | `fuzz` recipe |

### Build System: xtask (5 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `xtask-main-structure` | §8.2 | clap dispatch structure |
| `xtask-task-module-pattern` | §8.2 | Task module pattern |
| `xtask-shell-run-command` | §8.3 | `run_command()` utility |
| `xtask-shell-run-command-output` | §8.3 | `run_command_output()` utility |
| `xtask-release-pipeline` | §8.2 | Release pipeline phases |

### Rust & Edition 2024 (6 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `rust-unsafe-extern-blocks` | §1.4.4.1 | `unsafe extern "C"` syntax |
| `rust-unsafe-attr-syntax` | §1.4.4.1 | `#[unsafe(no_mangle)]` syntax |
| `rust-unsafe-blocks-in-unsafe-fn` | §1.4.4.1 | Explicit `unsafe {}` blocks |
| `rust-cfg-select-macro` | §1.4.4.1 | `cfg_select!` over `cfg-if` |
| `rust-edition-2024-lints` | §3.1 | Full 2024 lint matrix |
| `rust-edition-2024-features` | §1.4.4.1 | 2024 language features |

### Cargo Configuration (4 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `rust-cargo-config-toml` | §2.4 | `.cargo/config.toml` |
| `rust-cargo-lints-toml` | §3.1 | Lints in Cargo.toml only |
| `rust-cargo-toml-template` | §3.1 | Standard Cargo.toml template |
| `rust-cargo-profiles` | §3.1 | Profile settings |

### Nix Flakes (3 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `rust-nix-flake-structure` | §1.5.1 | `flake.nix` structure |
| `rust-nix-dev-shell` | §1.5.1 | `nix develop .` entry point |
| `rust-nix-flake-check` | §1.5.4 | `nix flake check` CI |

### Toolchain Pinning (3 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `rust-toolchain-toml` | §1.5.2 | Exact version pinning |
| `rust-cargo-install-locked` | §1.4.2 | `--locked` mandate |
| `rust-flake-lock-committed` | §1.5.3 | `flake.lock` in VCS |

### Rust-Native Tool Replacements (3 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `rust-native-tools-core` | §1.4.2 | Core tool replacements |
| `rust-native-tools-utilities` | §1.4.2 | Utility replacements |
| `rust-native-tools-terminal` | §1.4.3 | Shell/terminal replacements |

### Standards: Directory Layout (5 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `standards-directory-config-files` | §2.1 | Config directory layout |
| `standards-directory-scripts` | §2.1 | Scripts directory |
| `standards-directory-root-files` | §2.1 | Root directory files |
| `standards-gitignore-rules` | §2.2 | `.gitignore` rules |
| `standards-gitattributes-rules` | §2.3 | `.gitattributes` rules |

### Standards: Suckless Code Design (9 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `standards-suckless-max-file-size` | §0.1.3 | Max 500 lines per file |
| `standards-suckless-max-function-size` | §0.1.3 | Max 40 lines per function |
| `standards-suckless-one-purpose` | §0.1.3 | One purpose per function |
| `standards-suckless-no-dead-code` | §0.1.3 | No dead/commented-out code |
| `standards-suckless-doc-comments` | §0.1.3 | Doc comments on pub items |
| `standards-suckless-no-builder-overuse` | §0.1.3 | Builder pattern limits |
| `standards-suckless-no-trait-objects-hot` | §0.1.3 | Avoid trait objects hot paths |
| `standards-suckless-inline-over-deps` | §0.1.3 | Inline helpers < 20 lines |
| `standards-suckless-no-cfg-scatter` | §0.1.3 | No cfg scatter, use modules |

### Standards: Proof Tiers (5 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `standards-proof-tier-annotations` | §0.3.3 | Proof tier mandate |
| `standards-proof-tier-proved` | §12.2 | [PROVED] harness pattern |
| `standards-proof-tier-tested` | §12.2 | [TESTED] proptest pattern |
| `standards-proof-tier-linted` | §12.2 | [LINTED] minimum bar |
| `standards-proof-tier-ffi-audited` | §12.2 | [FFI_AUDITED] review |

### Standards: Error Taxonomy (6 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `standards-error-struct-variants` | §12.1 | Struct variant errors |
| `standards-error-source-location` | §12.1 | Source location in errors |
| `standards-error-non-exhaustive` | §12.1 | `#[non_exhaustive]` errors |
| `standards-error-error-implementation` | §12.1 | std::error::Error impl |
| `standards-error-no-anyhow-lib` | §12.1 | No anyhow in library code |
| `standards-error-invariant-violation` | §12.3 | InvariantViolation protocol |

### Standards: Formal Verification (5 skills)

| Skill | STANDARDS § | Description |
|---|---|---|
| `standards-proof-pyramid` | §6.1 | 5-layer proof pyramid |
| `standards-proof-kani-harness-patterns` | §6.2.2 | Kani harness patterns |
| `standards-proof-coding-for-kani` | §6.2.3 | Coding for Kani verification |
| `standards-proof-proptest-mandates` | §6.3 | Property-based test mandates |
| `standards-proof-fuzz-mandates` | §6.4 | Fuzz target mandates |

## Writing New Skills

Each skill file is a standalone markdown document with:

```markdown
# skill-name

## Description
One-line purpose.

## When to Load
Context trigger.

## Source
STANDARDS.adoc §X.Y (lines N–M)

## Key Rules
- MANDATE: ...
- SHOULD: ...
- FORBIDDEN: ...

## Example
```[language]
# Correct and incorrect usage
```

## Related Skills
- [related-skill](file://.opencode/skills/related-skill.md)
```
