# justfile — human interface to all project tasks.
# All complex logic lives in xtask (Rust) — added when a Rust crate exists.
# ALPINE/MUSL NOTE: 'nix develop' is blocked (stdenv glibc bash builder).
# All cargo commands use host ~/.cargo/bin tools which are truly static musl.
# Nix-only commands (nix flake check, nix build) work directly on Alpine.

CARGO := "/home/galloa/.cargo/bin/cargo"
JJ    := "/home/galloa/.cargo/bin/jj"

# Show available recipes.
default:
    @just --list --unsorted

# ─────────────────────────────────────────
# ENVIRONMENT
# ─────────────────────────────────────────

# Enter hermetic dev shell with Nushell.
shell:
    nix develop --command nu

# Verify environment integrity (nix flake check — no shell needed).
deps:
    nix flake check

# Build for current platform.
build:
    nix build .

# Enter sh via nix develop (blocked on Alpine — prints message).
shell-sh:
    @echo "nix develop interactive is blocked on Alpine/musl."
    @echo "Use host tools from ~/.cargo/bin/ instead."

# CI check (full pipeline).
ci:
    {{CARGO}} clippy --all-targets --all-features -- -Dwarnings && {{CARGO}} fmt --all --check && {{CARGO}} test --all-targets --all-features

# ─────────────────────────────────────────
# DEVELOPMENT
# ─────────────────────────────────────────

# Run complete check pipeline (lint + test).
check:
    {{CARGO}} clippy --all-targets --all-features -- -Dwarnings && {{CARGO}} fmt --all --check && {{CARGO}} test --all-targets --all-features

# Run lint only (clippy + fmt check).
lint:
    {{CARGO}} clippy --all-targets --all-features -- -Dwarnings && {{CARGO}} fmt --all --check

# Run tests only.
test:
    {{CARGO}} test --all-targets --all-features

# Run tests with output shown.
test-verbose:
    {{CARGO}} test --all-targets --all-features -- --nocapture

# Run a single test by name.
test-one NAME:
    {{CARGO}} test --all-targets --all-features -- '{{NAME}}' --nocapture

# ─────────────────────────────────────────
# FORMAL VERIFICATION
# ─────────────────────────────────────────

# Run all Kani proofs (requires proofs/ crate).
proof:
    @echo "proof: add proofs/ crate to enable"

# Run property tests with high iteration count.
proptest:
    PROPTEST_CASES=100000 {{CARGO}} test proptest -- --nocapture

# Run fuzz targets (requires fuzz/ crate).
fuzz:
    @echo "fuzz: add fuzz/ crate to enable"

# ─────────────────────────────────────────
# CODE QUALITY
# ─────────────────────────────────────────

# Format all code.
fmt:
    {{CARGO}} fmt --all

# Format check without modifying.
fmt-check:
    {{CARGO}} fmt --all --check

# Run clippy strict.
clippy:
    {{CARGO}} clippy --all-targets --all-features -- -Dwarnings

# ─────────────────────────────────────────
# DOCUMENTATION
# ─────────────────────────────────────────

# Build all documentation.
docs:
    {{CARGO}} doc --all-features --no-deps

# Build and open Rust API docs.
docs-open:
    {{CARGO}} doc --all-features --no-deps --open

# Build AsciiDoc documentation (requires asciidoctor).
docs-adoc:
    @if command -v asciidoctor >/dev/null 2>&1; then \
      asciidoctor --failure-level=WARN README.adoc; \
    else \
      echo "docs-adoc: install asciidoctor or use nix build"; \
    fi

# ─────────────────────────────────────────
# SECURITY
# ─────────────────────────────────────────

# Run security audit (requires cargo-audit).
audit:
    @echo "audit: install cargo-audit to enable (cargo install cargo-audit)"

# Check for outdated dependencies (requires cargo-outdated).
outdated:
    @echo "outdated: install cargo-outdated to enable (cargo install cargo-outdated)"

# ─────────────────────────────────────────
# CROSS-COMPILATION
# ─────────────────────────────────────────

# Cross-compile for all configured targets via Nix.
cross:
    nix build .#all 2>/dev/null || echo "cross: configure flake.nix output 'all'"

# Cross-compile for a single target via cargo.
cross-one TARGET:
    {{CARGO}} build --target '{{TARGET}}'

# Cross-compile via Nix (primary).
cross-nix:
    nix build .#all

# Cross-compile one target via Nix.
cross-nix-one TARGET:
    nix build .#{{TARGET}}

# ─────────────────────────────────────────
# VERSION CONTROL (jj with git backend)
# ─────────────────────────────────────────

# Show repository status.
status:
    {{JJ}} status

# Show log with graph.
log:
    {{JJ}} log

# Show diff.
diff:
    {{JJ}} diff

# Undo last operation.
undo:
    {{JJ}} undo

# Create new change (bookmark).
new BOOKMARK:
    {{JJ}} new --insert-after {{BOOKMARK}}

# Describe current change (commit message).
describe MSG:
    {{JJ}} describe -m '{{MSG}}'

# Push to GitHub.
push:
    {{JJ}} git push --bookmark dev

# ─────────────────────────────────────────
# RELEASE
# ─────────────────────────────────────────

# Prepare release (requires xtask crate).
release VERSION:
    @echo "release: add xtask crate to enable"

# ─────────────────────────────────────────
# NIX ENVIRONMENT (PRIMARY)
# ─────────────────────────────────────────

# Verify all nix store tools accessible via PATH (P10 decommission).
deps-check:
    @nu -c " \
      source /home/galloa/projects/personal/dotfiles/config/nushell/env.nu; \
      let tools = [rg fd bat sd delta eza dust procs btm xh zoxide just hx]; \
      let results = (\$tools | each {|t| \
        let r = (^which \$t o+e>| complete); \
        {tool: \$t, pass: (\$r.exit_code == 0)} \
      }); \
      \$results | table; \
      let failures = (\$results | where not pass); \
      if (\$failures | length) > 0 { \
        error make {msg: \$\"FAIL: (\$failures | get tool | str join ', ')\"} \
      } else { print 'All tools accessible via nix store PATH' } \
    "

# ─────────────────────────────────────────
# SETUP (LEGACY)
# ─────────────────────────────────────────

# Install/verify tools via Nix (legacy wrapper).
setup-legacy:
    /home/galloa/.cargo/bin/nu scripts/dev-setup.nu

# Verify all required tools present (legacy wrapper).
deps-legacy:
    /home/galloa/.cargo/bin/nu scripts/check-deps.nu

# ─────────────────────────────────────────
# CLEANUP
# ─────────────────────────────────────────

# Clean build artifacts.
clean:
    {{CARGO}} clean
    rm -rf build/
