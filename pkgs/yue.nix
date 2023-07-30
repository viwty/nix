{ stdenv, gnumake, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "Yuescript";
  version = "00c4bee811b3c92d9885959db30790b01f8cb3e2";

  src = fetchFromGitHub {
    owner = "pigpigyyy";
    repo = "Yuescript";
    rev = "${version}";
    sha256 = "sha256-pVnq0V0qv3qUlCRimyf3SAjK3ElZCbKV9+SEDa54sPU=";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  buildPhase = ''
    sed -i "s/\/bin\/bash/\/bin\/sh/g" makefile
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release/yue $out/bin
  '';
}
