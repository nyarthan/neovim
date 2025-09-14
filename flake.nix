{
  description = "nyarthan's neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      extra_pkg_config = {
        allowUnfree = false;
      };

      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions =
        {
          pkgs,
          ...
        }:
        {
          lspsAndRuntimeDeps = {
            general = [
              pkgs.universal-ctags
              pkgs.ripgrep
              pkgs.fd
              pkgs.stdenv.cc.cc
              pkgs.nix-doc
              pkgs.nixd
              pkgs.stylua
              pkgs.lua-language-server
              pkgs.efm-langserver
              pkgs.typescript-language-server
              pkgs.yaml-language-server
              pkgs.taplo
              pkgs.rust-analyzer
              pkgs.tailwindcss-language-server
              pkgs.vscode-langservers-extracted # html / css /json / eslint
              pkgs.nixfmt-rfc-style
              pkgs.vue-language-server
              pkgs.deno
            ];
          };

          startupPlugins =
            let
              inherit (pkgs) vimPlugins;
            in
            {
              general = [
                vimPlugins.base16-nvim
                vimPlugins.blink-cmp
                vimPlugins.colorful-menu-nvim
                vimPlugins.crates-nvim
                vimPlugins.lazy-nvim
                vimPlugins.lazydev-nvim
                vimPlugins.mini-bracketed
                vimPlugins.mini-diff
                vimPlugins.mini-files
                vimPlugins.mini-hipatterns
                vimPlugins.mini-icons
                vimPlugins.mini-indentscope
                vimPlugins.mini-jump
                vimPlugins.mini-move
                vimPlugins.mini-pairs
                vimPlugins.mini-sessions
                vimPlugins.mini-starter
                vimPlugins.mini-statusline
                vimPlugins.mini-surround
                vimPlugins.nvim-notify
                vimPlugins.nvim-treesitter.withAllGrammars
                vimPlugins.nvim-ts-autotag
                vimPlugins.nvim-ts-context-commentstring
                # vimPlugins.rustaceanvim
                vimPlugins.snacks-nvim
                vimPlugins.trouble-nvim
                (pkgs.callPackage ./nix/packages/nui-nvim.nix { })
              ];
            };
        };

      packageDefinitions = {
        nvim =
          { pkgs, ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [ "vim" ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            categories = {
              general = true;
            };
          };
      };
      defaultPackageName = "nvim";
    in
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };
      }
    )
    // {
      overlays = utils.makeOverlays luaPath {
        inherit nixpkgs dependencyOverlays extra_pkg_config;
      } categoryDefinitions packageDefinitions defaultPackageName;

      inherit utils;
      inherit (utils) templates;
    };
}
