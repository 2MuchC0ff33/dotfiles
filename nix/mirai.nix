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
  cargoHash = "sha256-hvLmtWbJ3T511iAz0LvWKbuuivPjsVuG+LQc705qlQA=";
  doCheck = false;
  nativeBuildInputs = [ toolchain pkgs.cmake pkgs.python3 pkgs.libclang pkgs.patchelf ];
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

  postFixup = ''
    # Bake RPATH into every ELF in bin/ so glibc's ld-linux-x86_64.so.2
    # resolves DT_NEEDED entries via RPATH without touching LD_LIBRARY_PATH.
    #
    # Root cause fixed: the old wrapper set LD_LIBRARY_PATH to a directory
    # containing a GNU ld linker script named "libc.so" (no .6 suffix).
    # glibc's ld.so rejected it as "invalid ELF header". Using --set-rpath
    # routes DT_NEEDED through the ELF RPATH instead; glibc resolves
    # "libc.so.6" (versioned SONAME) to the real ELF in pkgs.glibc/lib,
    # and the linker script named "libc.so" is never touched.
    #
    # --set-rpath is used (not --add-rpath). The --add-rpath form is removed
    # by stdenv's shrink-rpath pass which runs before postFixup. --set-rpath
    # is a full replacement that runs after the shrink pass, so it survives.
    #
    # No libexec/ scanning needed: removing the wrapper means binaries stay
    # in bin/ where cargo placed them. Nothing moves them to libexec/.
    _rpath="${toolchain}/lib:${pkgs.gcc.cc.lib}/lib:${pkgs.glibc}/lib"
    for _f in "$out"/bin/*; do
      if [ -f "$_f" ] && ! head -c2 "$_f" | grep -q '^#!'; then
        patchelf --set-rpath "$_rpath" "$_f" 2>/dev/null || true
      fi
    done
    unset _rpath _f
  '';
}
