{ pkgs, lib, stdenv, fetchFromGitHub, toolchain, z3 }:
stdenv.mkDerivation rec {
  pname = "verus";
  version = "0.2026.05.24";
  src = fetchFromGitHub {
    owner = "verus-lang";
    repo = "verus";
    rev = "release/${version}.ecee80a";
    hash = "sha256-52hjEhUdrpvCVwHw8EbheOOtmNAu68JXweVXJ1HJd6c=";
  };
  nativeBuildInputs = [ toolchain pkgs.pkg-config ];
  buildInputs = [ z3 ];
  VERUS_Z3_PATH = "${z3}/bin/z3";
  preBuild = ''
    export CARGO_HOME="$TMPDIR/cargo-home"
    mkdir -p "$CARGO_HOME"

    # vargo requires rustup to resolve the toolchain location
    # Use no-quote heredoc so ${toolchain} expands; escape \$1 \$2 etc.
    cat > "$CARGO_HOME/rustup" << RUSTUP_EOF
#!/bin/sh
case "\$1" in
  show)
    case "\$2" in
      active-toolchain|host) echo "1.95.0-x86_64-unknown-linux-gnu (default)" ;;
      *) echo "1.95.0-x86_64-unknown-linux-gnu (default)" ;;
    esac ;;
  which)
    echo "${toolchain}/bin/\$2" ;;
  *) exit 0 ;;
esac
RUSTUP_EOF
    chmod +x "$CARGO_HOME/rustup"
    export PATH="$CARGO_HOME:$PATH"

    pushd tools/vargo > /dev/null
    cargo build --release
    popd > /dev/null
    export PATH="$PWD/tools/vargo/target/release:$PATH"
  '';
  buildPhase = ''
    runHook preBuild
    pushd source > /dev/null
    vargo --no-solver-version-check build --release
    popd > /dev/null
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/bin

    # Install full source directory as verusroot
    # (vstd is at source/vstd, not at repo root)
    cp -r source $out/lib/verus-source
    chmod -R +w $out/lib/verus-source

    # Symlink z3 so Verus finds it alongside the verusroot
    ln -sf "${z3}/bin/z3" "$out/lib/verus-source/z3"

    # Locate the verus binary (inside source/target-verus/release/)
    VERUS_BIN="$out/lib/verus-source/target-verus/release/verus"
    if [ ! -f "$VERUS_BIN" ]; then
      echo "ERROR: verus binary not found at $VERUS_BIN" >&2
      find "$out/lib/verus-source" -name verus -type f 2>/dev/null
      exit 1
    fi

    # Detect the toolchain name embedded in the binary
    TOOLCHAIN_NAME="$(
      strings "$VERUS_BIN" \
        | grep -oE '[0-9]+\.[0-9]+\.[0-9]+-x86_64-unknown-linux-gnu' \
        | head -1
    )"

    # vstd.vir, rust_verify, libvstd.rlib live in target-verus/release/,
    # so VERUS_ROOT must point there for the inner binary to find them.
    VERUS_ROOT_DIR="$out/lib/verus-source/target-verus/release"

    # Create verus-root marker file for the outer verus binary lookup
    touch "$VERUS_ROOT_DIR/verus-root"

    # Create wrapper that registers Nix toolchain and sets VERUS_ROOT.
    # Build-time bash vars expand in heredoc; runtime refs escaped with \.
    cat > $out/bin/verus << VERUS_WRAPPER
#!/bin/sh
export VERUS_ROOT="$VERUS_ROOT_DIR"

TOOLCHAIN_NAME="$TOOLCHAIN_NAME"
TOOLCHAIN_PATH="${toolchain}"

if [ -z "\$RUSTUP_HOME" ]; then RUSTUP_HOME="\$HOME/.rustup"; fi
TOOLCHAIN_DIR="\$RUSTUP_HOME/toolchains/\$TOOLCHAIN_NAME"

# rustup toolchain link rejects target-triple names,
# so create a manual symlink into the rustup toolchains directory
if [ ! -L "\$TOOLCHAIN_DIR" ] && [ ! -d "\$TOOLCHAIN_DIR" ]; then
    mkdir -p "\$(dirname "\$TOOLCHAIN_DIR")" 2>/dev/null || true
    ln -sf "\$TOOLCHAIN_PATH" "\$TOOLCHAIN_DIR" 2>/dev/null || true
fi

exec "$VERUS_BIN" "\$@"
VERUS_WRAPPER
    chmod +x $out/bin/verus

    runHook postInstall
  '';
  meta = with lib; {
    description = "Verified Rust using SMT solvers — proof-relevant refinement types";
    homepage = "https://github.com/verus-lang/verus";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
