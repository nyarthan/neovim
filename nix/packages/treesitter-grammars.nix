{ pkgs, languages }:
let
  inherit (pkgs.vimPlugins) nvim-treesitter;

  grammars =
    if languages == "all" then
      nvim-treesitter.withAllGrammars
    else
      nvim-treesitter.withPlugins (grammars: map (language: grammars.${language}) languages);
in
pkgs.symlinkJoin {
  name = "treesitter-dependencies";
  paths = grammars.dependencies;
}
