{
  description = "Jannis' Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-root.url = "github:srid/flake-root";

    nvim-flake.url = "github:nyarthan/nvim-flake";
    nvim-flake.inputs.nixpkgs.follows = "nixpkgs";
    nvim-flake.inputs.flake-parts.follows = "flake-parts";
  };

  outputs =
    {
      self,
      flake-parts,
      nixpkgs-stable,
      treefmt-nix,
      flake-root,
      nvim-flake,
      ...
    }@inputs:
    let
      nvimAppName = "nvim-${builtins.substring 7 (builtins.stringLength self.narHash) self.narHash}";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
        flake-root.flakeModule
      ];

      systems = [
        "aarch64-linux"
        "aarch64-darwin"

        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        {
          self',
          pkgs,
          system,
          inputs',
          config,
          ...
        }:
        let
          inherit (pkgs) vimPlugins lib;
          pkgs-stable = nixpkgs-stable.legacyPackages.${system};

          plugins = [
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
            vimPlugins.noice-nvim
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
            vimPlugins.catppuccin-nvim
            vimPlugins.snacks-nvim
            (pkgs.callPackage ./nix/packages/nui-nvim.nix {})
            (pkgs.callPackage ./nix/packages/vesper-nvim.nix { })
          ];

          neovimPlugins = import ./nix/packages/neovim-plugins.nix { inherit pkgs plugins; };

          luaCPath = lib.concatStringsSep ";" [
            "${pkgs.luajitPackages.jsregexp}/lib/lua/5.1/?.so"
            "/Users/jannis/dev/nvim-plugins/anyfmt/lua/anyfmt/?.dylib"
          ];

          luaPath = lib.concatStringsSep ";" ([
            "${vimPlugins.lazy-nvim}/lua/?.lua"
            "${vimPlugins.lazy-nvim}/lua/?/init.lua"
            "${pkgs.luajitPackages.jsregexp}/share/lua/5.1/?.lua"
          ]);

          neovim = import ./nix/packages/neovim.nix {
            inherit
              pkgs
              pkgs-stable
              nvimAppName
              neovimPlugins
              luaPath
              luaCPath
              ;
            treesitter-dependencies = nvim-flake.treesitter-dependencies {
              inherit pkgs;
              grammars = "all";
            };
          };
        in
        {
          treefmt.config = import ./treefmt.nix { inherit pkgs config; };

          packages.default = neovim;

          apps.default = {
            type = "app";
            program = "${self'.packages.default}/bin/nvim";
          };

          devShells.default = import ./nix/shells/env.nix { inherit pkgs; };

          # devShells.default = import ./nix/shells/dev.nix {
          #   inherit
          #     pkgs
          #     nvimAppName
          #     neovimPlugins
          #     luaPath
          #     luaCPath
          #     extraDependencies
          #     treesitterGrammars
          #     ;
          # };

          formatter = config.treefmt.build.wrapper;
        };

    };
}
