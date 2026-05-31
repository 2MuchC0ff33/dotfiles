{ lib, fetchzip, stdenv, autoPatchelfHook, gcc, fenix, system }:

let
  version = "0.67.0";
  tag     = "kani-${version}";

  # Kani 0.67.0 was built against rustc 1.93.0-nightly (2025-11-20).
  # We need matching librustc_driver.so from rustc-dev.
  kaniNightly = fenix.packages.${system}.toolchainOf {
    channel = "nightly";
    date    = "2025-11-20";
    sha256  = "sha256-IQUcjhizZsNE1NYkdrwkVNxGpUlujMlfy8tdcbp7NnQ=";
  };

  kaniDev = fenix.packages.${system}.combine [
    kaniNightly.rustc
    kaniNightly.rustc-dev
    kaniNightly.rust-src
  ];
in
stdenv.mkDerivation {
  pname   = "kani";
  inherit version;

  src = fetchzip {
    url    = "https://github.com/model-checking/kani/releases/download/${tag}/${tag}-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "1jsw6hfys4ih4qy8cgv1wgrria3lgn0g8yr3k1igcp4q8ly8mq93";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ gcc.cc.lib kaniDev ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/* $out/bin/
    ln -s $out/bin/kani-driver $out/bin/cargo-kani
    cp -r lib $out/ 2>/dev/null || true
    runHook postInstall
  '';

  # autoPatchelfHook needs to find librustc_driver.so in kaniDev's rustc-dev.
  # The rustc-dev component places librustc_driver.so under
  # .../lib/rustlib/x86_64-unknown-linux-gnu/lib/
  NIX_AUTO_PATCHELF_EXPLICIT_SKIP = "";
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Kani Rust Verifier — Layer 5 mandatory STANDARDS.adoc §0.3.1";
    homepage    = "https://github.com/model-checking/kani";
    license     = with licenses; [ mit asl20 ];
    platforms   = [ "x86_64-linux" ];
    mainProgram = "cargo-kani";
  };
}
