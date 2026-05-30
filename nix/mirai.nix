# MIRAI v1.1.12 (endorlabs fork) — static byte-grain analysis of Rust MIR
# Builds against pinned nightly-2025-01-10 (from endorlabs/MIRAI's rust-toolchain.toml)
{ pkgs, lib, rustPlatform, fetchFromGitHub, toolchain }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-mirai";
  version = "1.1.12";
  src = fetchFromGitHub {
    owner = "endorlabs";
    repo = "MIRAI";
    rev = "refs/tags/v${version}";
    hash = "sha256-+H0JIbrwxMi3uMuxBqgVBzNkDYom8X616rH9y7YqIXg=";
  };
  cargoHash = "sha256-QXQjbxZo0LfDyO4IpfiXvPum5THJq6apgWWLd0vcBAs=";
  doCheck = false;
  nativeBuildInputs = [ toolchain pkgs.cmake pkgs.python3 pkgs.libclang ];
  buildInputs = [ pkgs.gcc ];
  LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
  LD_LIBRARY_PATH = "${toolchain}/lib";
  LIBRARY_PATH = "${toolchain}/lib";
  RUSTC_BOOTSTRAP = 1;
  meta = with lib; {
    description = "Abstract interpreter for Rust MIR — static byte-grain analysis";
    homepage = "https://github.com/endorlabs/MIRAI";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };

  # Ensure runtime can find the rustc_driver and LLVM libs from the
  # fenix toolchain: add the toolchain lib dir to RPATH of installed
  # executables so they can run outside the build sandbox.
  postFixup = ''
    # Wrap binaries to ensure runtime LD_LIBRARY_PATH contains the toolchain
    # and the host gcc library directory so libstdc++ and LLVM are found.
    mkdir -p "$out/libexec"
    for f in "$out"/bin/*; do
      if [ -f "$f" ] && file "$f" | grep -q ELF; then
        base=$(basename "$f")
        mv "$f" "$out/libexec/$base-real" || true
        printf '%s\n' '#!/bin/sh' \
          "# add fenix toolchain and any gcc-lib directories to LD_LIBRARY_PATH" \
          "LD_LIBRARY_PATH=\"${toolchain}/lib\"" \
          "for d in /nix/store/*-gcc-*-lib/lib; do if [ -d \"\$d\" ]; then LD_LIBRARY_PATH=\"\$d:\$LD_LIBRARY_PATH\"; fi; done" \
          "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH\"" \
          "exec \"$out/libexec/$base-real\" \"\\\$@\"" > "$out/bin/$base"
        chmod +x "$out/bin/$base" || true
      fi
    done
  '';
}
