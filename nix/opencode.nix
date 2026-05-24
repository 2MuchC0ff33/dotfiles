{ stdenv, fetchurl, lib, makeWrapper }:
stdenv.mkDerivation rec {
  pname   = "opencode";
  version = "1.15.10";

  src = fetchurl {
    url  = "https://github.com/sst/opencode/releases/download/v${version}/opencode-linux-x64-musl.tar.gz";
    hash = "sha256-MoQAI15SOIh0S0Ngxy+Qm0nzKfl3o5cJw3u9TIw8Gcc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild  = true;
  dontFixup  = true;

  installPhase = "
    mkdir -p \$out/bin
    cd \$out/bin
    tar xzf \$src
    ls -la
    for f in *; do
      if [ -f \"\$f\" ] && [ -x \"\$f\" ]; then
        mv \"\$f\" opencode-real
        break
      fi
    done
    chmod +x opencode-real
    makeWrapper opencode-real \$out/bin/opencode --set LD_PRELOAD /usr/lib/libucontext.so.1
    ln -sf opencode \$out/bin/oc
  ";

  meta = {
    description = "opencode AI coding agent";
    homepage    = "https://opencode.ai";
    license     = lib.licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}