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
  LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "Abstract interpreter for Rust MIR — static byte-grain analysis";
    homepage = "https://github.com/endorlabs/MIRAI";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
