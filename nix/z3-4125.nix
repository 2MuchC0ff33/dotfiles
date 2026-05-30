{ pkgs, lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "z3";
  version = "4.12.5";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    rev = "z3-${version}";
    hash = "sha256-Qj9w5s02OSMQ2qA7HG7xNqQGaUacA1d4zbOHynq5k+A=";
  };

  nativeBuildInputs = [ cmake python3 ];

  postPatch = ''
    sed -i 's/\.get(/\.get_elem(/g' src/math/lp/static_matrix.h
    sed -i 's/get_value_of_column_cell(/get_column_cell(/g' src/math/lp/static_matrix_def.h
    sed -i 's/m_low_bound/m_lower_bound/g' src/math/lp/column_info.h
  '';

  cmakeFlags = [
    "-DZ3_BUILD_TEST_EXECUTABLES=OFF"
    "-DZ3_BUILD_DOTNET_BINDINGS=OFF"
    "-DZ3_BUILD_JAVA_BINDINGS=OFF"
    "-DZ3_BUILD_PYTHON_BINDINGS=OFF"
    "-DZ3_INCLUDE_GIT_HASH=OFF"
    "-DZ3_INCLUDE_GIT_DESCRIBE=OFF"
  ];

  meta = with lib; {
    description = "High-performance theorem prover / SMT solver (v4.12.5, pinned for Verus)";
    homepage = "https://github.com/Z3Prover/z3";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
