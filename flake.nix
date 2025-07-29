{
  description = "nyarthan's neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # flake-parts.url = "github:hercules-ci/flake-parts";

    # treefmt-nix.url = "github:numtide/treefmt-nix";
    # flake-root.url = "github:srid/flake-root";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      neovim-nightly-overlay,
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
          settings,
          categories,
          extra,
          name,
          mkPlugin,
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
              pkgs.lua-language-server
              pkgs.nixd
              pkgs.stylua
            ];
          };

          startupPlugins =
            let
              inherit (pkgs) vimPlugins;
            in
            {
              general = [
                vimPlugins.lazy-nvim
                vimPlugins.telescope-nvim
                vimPlugins.telescope-fzf-native-nvim
                vimPlugins.nvim-treesitter.withAllGrammars
                vimPlugins.plenary-nvim
                vimPlugins.oil-nvim
                vimPlugins.mini-icons
                vimPlugins.nvim-cmp
                vimPlugins.cmp-path
                vimPlugins.cmp-buffer
                vimPlugins.luasnip
                vimPlugins.comment-nvim
                vimPlugins.nvim-ts-context-commentstring
                vimPlugins.nvim-lspconfig
                vimPlugins.cmp-nvim-lsp
                vimPlugins.guess-indent-nvim
                vimPlugins.lazydev-nvim
                vimPlugins.nvim-notify
                vimPlugins.trouble-nvim
                vimPlugins.render-markdown-nvim
                vimPlugins.telescope-ui-select-nvim
                vimPlugins.mini-pairs
                vimPlugins.mini-move
                vimPlugins.mini-indentscope
                vimPlugins.mini-hipatterns
                vimPlugins.mini-surround
                vimPlugins.mini-statusline
                vimPlugins.mini-bracketed
                vimPlugins.mini-diff
                vimPlugins.mini-jump
                vimPlugins.mini-starter
                vimPlugins.mini-sessions
                vimPlugins.obsidian-nvim
                vimPlugins.hardtime-nvim
                vimPlugins.rustaceanvim
                vimPlugins.nvim-ts-autotag
                vimPlugins.crates-nvim
                vimPlugins.blink-cmp
                vimPlugins.colorful-menu-nvim
                vimPlugins.base16-nvim
                vimPlugins.snacks-nvim
                (pkgs.callPackage ./nix/packages/nui-nvim.nix { })
                (pkgs.callPackage ./nix/packages/vesper-nvim.nix { })
              ];
            };
        };

      packageDefinitions = {
        nvim =
          { pkgs, name, ... }:
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

        /* devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        }; */
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
