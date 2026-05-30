{ stdenv, fetchurl, lib }:
stdenv.mkDerivation rec {
  pname   = "opencode";
  version = "1.15.12";

  src = fetchurl {
    url  = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64-musl.tar.gz";
    sha256 = "sha256-9alTRuMBiiigszuKeXYnSg2DdGihqW5oXfUUvPlCEww=";
  };

  dontUnpack = true;
  dontBuild  = true;
  dontFixup  = true;

  installPhase = ''
    mkdir -p $out/bin
    cd $out/bin
    tar xzf $src
    for f in *; do
      if [ -f "$f" ] && [ -x "$f" ]; then
        mv "$f" opencode-real
        break
      fi
    done
    chmod +x opencode-real
    cat > $out/bin/opencode << 'WRAPPER'
#! /bin/sh
exec /lib/ld-musl-x86_64.so.1 --preload /usr/lib/libucontext.so.1 "$(dirname "$0")/opencode-real" "$@"
WRAPPER
    chmod +x opencode
    ln -sf opencode $out/bin/oc
  '';

  meta = {
    description = "opencode AI coding agent";
    homepage    = "https://opencode.ai";
    license     = lib.licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}
