{ stdenv, gnumake, luajit, fetchurl }:
stdenv.mkDerivation rec {
  name = "fenne-ls";
  version = "a29cbe496e7c110b304b0119e7d8b91aa0fa713d";

  src = fetchurl {
    url = "https://git.sr.ht/~xerool/fennel-ls/archive/${version}.tar.gz";
    sha256 = "sha256-BW117hgjqKoIPee5Rc0VhgUEA4zVTPn/QM1OyPnuvno=";
  };

  buildInputs = [ luajit ];

  buildPhase = ''
  make
  '';

  installPhase = ''
  make install PREFIX=$out
  '';
}
