{ pkgs, config, ... }:
{
  inherit (config.flake-root) projectRootFile;
  package = pkgs.treefmt;
  settings = {
    global.excludes = [
      ".direnv"
      ".envrc"
    ];
  };
  programs = {
    nixfmt.enable = true;
    yamlfmt.enable = true;
    stylua.enable = true;
    mdformat.enable = true;
    taplo.enable = true;
  };

}
