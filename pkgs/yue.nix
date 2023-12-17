{ stdenv, gnumake, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "Yuescript";
  version = "8cff6076041f4204a53a177359783d75698ec19f";

  src = fetchFromGitHub {
    owner = "pigpigyyy";
    repo = "Yuescript";
    rev = version;
    sha256 = "sha256-r5mr7yLjOmK3DAXKHPlp/q2vDEZ8kFqgsAEilemaDuI=";
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
