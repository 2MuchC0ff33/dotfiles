# Creusot v0.11.0 — deductive verification of Rust code
# Builds against pinned nightly-2026-02-27 (from Creusot's rust-toolchain)
{ pkgs, lib, rustPlatform, fetchFromGitHub, toolchain }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-creusot";
  version = "0.11.0";
  src = fetchFromGitHub {
    owner = "creusot-rs";
    repo = "creusot";
    rev = "refs/tags/v${version}";
    hash = "sha256-UDXNCMn8RGYs5NznbGcBZfTHpcCyssg1mk2NVNjctl0=";
  };
  cargoHash = "sha256-k1ueZjrBesmcMzZUka/DVXfnKGNuX/sNJ4rrzt7d3+Q=";
  doCheck = false;
  nativeBuildInputs = [ toolchain ];
  LD_LIBRARY_PATH = "${toolchain}/lib";
  LIBRARY_PATH = "${toolchain}/lib";
  RUSTC_BOOTSTRAP = 1;
  meta = with lib; {
    description = "Deductive verification of Rust code — translates MIR to WhyML for Why3";
    homepage = "https://github.com/creusot-rs/creusot";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
