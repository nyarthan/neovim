{
  pkgs,
  plugins,
}: let
  inherit (pkgs) lib;
in
  pkgs.stdenv.mkDerivation {
    inherit (pkgs.neovim) version;
    pname = "neovim-plugins";

    dontUnpack = true;

    buildInputs = plugins;

    installPhase = ''
      ${lib.concatMapStringsSep "\n" (plugin: ''
          mkdir -p $out
          cp -r ${plugin} $out/${plugin.pname}
        '')
        plugins}
    '';
  }
