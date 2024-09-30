{
  description = "Jannis' Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
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
          ...
        }:
        let
          inherit (pkgs) vimPlugins lib;

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
          ];

          extraDependencies = [
            pkgs.ripgrep
            pkgs.fd
            pkgs.lua-language-server
            pkgs.efm-langserver
            pkgs.nil
            pkgs.typescript-language-server
            pkgs.yaml-language-server
            pkgs.taplo
            pkgs.rust-analyzer
            pkgs.tailwindcss-language-server
            pkgs.vscode-langservers-extracted # html / css /json / eslint
            pkgs.nixfmt-rfc-style
          ];

          treesitterGrammars = import ./nix/packages/treesitter-grammars.nix { inherit pkgs; };
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
              nvimAppName
              neovimPlugins
              luaPath
              luaCPath
              extraDependencies
              treesitterGrammars
              ;
          };
        in
        {
          packages.default = neovim;

          apps.default = {
            type = "app";
            program = "${self'.packages.default}/bin/nvim";
          };

          devShells.default = import ./nix/shells/dev.nix {
            inherit
              pkgs
              nvimAppName
              neovimPlugins
              luaPath
              luaCPath
              extraDependencies
              treesitterGrammars
              ;
          };

          formatter = pkgs.nixfmt-rfc-style;
        };

    };
}
