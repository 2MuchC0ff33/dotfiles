{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname   = "zellij";
  version = "0.44.3";

  src = fetchurl {
    url  = "https://github.com/zellij-org/zellij/releases/download/v${version}/zellij-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-D3w0Z4hif1BsCigpZRd2hjPP8k/IIqc5+CZLZA7K11E=";
  };

  dontUnpack = true;
  dontBuild  = true;
  dontFixup  = true;

  installPhase = ''
    mkdir -p $out/bin
    cd $out/bin
    tar xzf $src
    chmod +x zellij
  '';

  meta = {
    description = "Zellij terminal workspace (hermetic musl binary)";
    homepage    = "https://github.com/zellij-org/zellij";
    license     = lib.licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}
