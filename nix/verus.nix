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
  nativeBuildInputs = [ toolchain ];
  buildInputs = [ z3 ];
  VERUS_Z3_PATH = "${z3}/bin/z3";
  preBuild = ''
    export CARGO_HOME="$TMPDIR/cargo-home"
    mkdir -p "$CARGO_HOME"
    cat > "$CARGO_HOME/rustup" << RUSTUP_EOF
    #!${pkgs.runtimeShell}
    case "\$1" in
      show)
        case "\$2" in
          active-toolchain) echo "1.95.0-x86_64-unknown-linux-gnu (default)" ;;
          *) echo "rustup stub: ignoring \$@" >&2; exit 0 ;;
        esac ;;
      which)
        case "\$2" in
          rustc) echo "${toolchain}/bin/rustc" ;;
          cargo) echo "${toolchain}/bin/cargo" ;;
          rustfmt) echo "${toolchain}/bin/rustfmt" ;;
          rustdoc) echo "${toolchain}/bin/rustdoc" ;;
          *) echo "${toolchain}/bin/\$2" ;;
        esac ;;
      *) echo "rustup stub: ignoring \$@" >&2; exit 0 ;;
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
    install -D source/target-verus/release/verus $out/bin/verus
  '';
  meta = with lib; {
    description = "Verified Rust using SMT solvers — proof-relevant refinement types";
    homepage = "https://github.com/verus-lang/verus";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
