generate-paths:
    nix develop . --command nu ./scripts/generate-env-paths.nu
refresh-paths:
    nix develop . --command nu ./scripts/refresh-nix-paths.nu

# ─────────────────────────────────────────
# CONFIG DEPLOYMENT
# ─────────────────────────────────────────

# Symlink dotfiles configs to ~/.config/
# Idempotent — backs up existing files before overwriting.
deploy:
    nu ./scripts/deploy-configs.nu

# ─────────────────────────────────────────
# LOCAL LLM (OxiLLaMa)
# ─────────────────────────────────────────

# Start the OxiLLaMa OpenAI-compatible server with Qwen3-0.6B Q4_K_M.
# Context: 4096 (safe on 5.8GB RAM; native max 32768 OOMs on this host).
# Tied embeddings: output.weight absent; uses GEMV-accelerated fallback.
# API: http://127.0.0.1:8080/v1
oxillama-serve:
    oxillama serve \
        --model ~/models/qwen3/Qwen3-0.6B-Q4_K_M.gguf \
        --ctx-size 4096 \
        --port 8080

# Download Qwen3-0.6B Q4_K_M from HuggingFace (unsloth — official repo only has Q8_0).
oxillama-download:
    mkdir -p ~/models/qwen3
    curl -L \
        -H "User-Agent: huggingface-cli/0.3.0" \
        "https://huggingface.co/unsloth/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_K_M.gguf" \
        -o ~/models/qwen3/Qwen3-0.6B-Q4_K_M.gguf \
        --progress-bar

# ─────────────────────────────────────────
# VERIFICATION AND PIPELINES
# ─────────────────────────────────────────

# Run MIRAI abstract interpretation
mirai:
    cargo mirai

# Run Verus formal proof
verify:
    cargo xtask verify

# Sort Cargo.toml dependencies (run before every commit)
sort-deps:
    cargo sort --workspace

# Remove unused dependencies
machete:
    cargo machete

# Full pre-commit pipeline
pre-commit:
    cargo sort --workspace
    cargo fmt --all --check
    cargo clippy --all-targets --all-features -- -Dwarnings
    cargo mirai
    cargo audit
    cargo deny check
