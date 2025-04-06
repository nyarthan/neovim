{ stdenv, fetchgit }:
let
  rev = "8d3bce9764e627b62b07424e0df77f680d47ffdb";
in
stdenv.mkDerivation {
  pname = "nui.nvim";
  version = rev;

  src = fetchgit {
    inherit rev;
    url = "https://github.com/MunifTanjim/nui.nvim";
    sha256 = "sha256-BYTY2ezYuxsneAl/yQbwL1aQvVWKSsN3IVqzTlrBSEU=";
  };

  installPhase = ''
    ls -la .
    mkdir $out
    cp -r . $out
  '';
}
