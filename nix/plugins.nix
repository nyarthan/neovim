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

    # Why symlink plugin contents instead of dir itself?
    # lazy.nvim does not resolve symlinks without setting dev = true
    # because it really wants to manage plugins itself
    # @see https://github.com/folke/lazy.nvim/issues/1063#issuecomment-1742003114
    installPhase =
      lib.concatMapStringsSep "\n" (plugin: ''
        mkdir -p $out/${plugin.pname}
        ln -s ${plugin}/* $out/${plugin.pname}/
      '')
      plugins;
  }
