{
  description = "Jannis' Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      flake-parts,
      nixpkgs-stable,
      ...
    }@inputs:
    let
      nvimAppName = "nvim-${builtins.substring 7 (builtins.stringLength self.narHash) self.narHash}";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
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
            vimPlugins.baleia-nvim
            vimPlugins.gitsigns-nvim
            vimPlugins.catppuccin-nvim
            vimPlugins.nvim-cmp
            vimPlugins.cmp-path
            vimPlugins.cmp-buffer
            vimPlugins.luasnip
            vimPlugins.comment-nvim
            vimPlugins.nvim-ts-context-commentstring
            vimPlugins.nvim-lspconfig
            vimPlugins.fidget-nvim
            vimPlugins.cmp-nvim-lsp
            vimPlugins.guess-indent-nvim
            vimPlugins.lualine-nvim
            vimPlugins.nvim-navic
            vimPlugins.lazydev-nvim
            vimPlugins.lspkind-nvim
            vimPlugins.noice-nvim
            vimPlugins.nui-nvim
            vimPlugins.nvim-notify
            vimPlugins.trouble-nvim
            vimPlugins.render-markdown-nvim
            vimPlugins.telescope-ui-select-nvim
            vimPlugins.mini-pairs
            vimPlugins.mini-move
            vimPlugins.mini-indentscope
            vimPlugins.mini-hipatterns
            vimPlugins.mini-surround
            vimPlugins.obsidian-nvim
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
            # treesitter = {
            #   enable = true;
            #   languages = [
            #     "lua"
            #     "c"
            #     "ada"
            #   ];
            # };
          };
        in
        {
          packages.default = neovim;

          apps.default = {
            type = "app";
            program = "${self'.packages.default}/bin/nvim";
          };

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

          formatter = pkgs.nixfmt-rfc-style;
        };

    };
}
