{ stdenv, fetchgit }:
let
  rev = "6fe842ceabe97e389cf00bd1f2da85b45b99a039";
in
stdenv.mkDerivation {
  pname = "vesper.nvim";
  version = rev;

  src = fetchgit {
    url = "https://github.com/datsfilipe/vesper.nvim";
    rev = rev;
    sha256 = "sha256-ozeT/EQIn+rgxOwC8SeIZXxIJGb/QFUVEq2pJ8Kfla0=";
  };

  installPhase = ''
        ls -la .
        mkdir $out
        cp -r . $out
    		'';
}
