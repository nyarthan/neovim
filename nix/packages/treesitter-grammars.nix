{ pkgs }:
let
  inherit (pkgs) vimPlugins;
in
pkgs.symlinkJoin {
  name = "treesitter-dependencies";
  paths = vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
}
