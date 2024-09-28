{
  description = "Jannis' Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      eachSystem =
        f:
        lib.foldAttrs lib.mergeAttrs { } (
          map (system: lib.mapAttrs (_: v: { ${system} = v; }) (f system)) systems
        );

      nvimAppName = "nvim-${builtins.substring 7 (builtins.stringLength self.narHash) self.narHash}";
    in
    eachSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) vimPlugins;

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
        ];

        lazyPathFile =
          pkgs.writeText "lazy-patches.lua"
            # lua
            ''
              -- I have no idea why but adding it in LUA_CPATH is not enough...
              package.preload["jsregexp.core"] = package.loadlib("${pkgs.luajitPackages.jsregexp}/lib/lua/5.1/jsregexp/core.so", "luaopen_jsregexp_core");

              local original_require = require

              require = function(module)
                -- luasnip does some preloading shenanigans - this prevents it
                if module == "luasnip.util.jsregexp" then
                  return original_require("jsregexp")
                end
                return original_require(module)
              end
            '';

        luaCPath = lib.concatStringsSep ";" [
          "${pkgs.luajitPackages.jsregexp}/lib/lua/5.1/?.so"
          "/Users/jannis/dev/nvim-plugins/anyfmt/lua/anyfmt/?.dylib"
        ];

        nvimPlugins = import ./nix/plugins.nix { inherit pkgs plugins; };

        luaPath = lib.concatStringsSep ";" ([
          "${vimPlugins.lazy-nvim}/lua/?.lua"
          "${vimPlugins.lazy-nvim}/lua/?/init.lua"
          "${pkgs.luajitPackages.jsregexp}/share/lua/5.1/?.lua"
        ]
        # ++ [ "${lazyPathFile}" ]
        );

        neovim = pkgs.stdenv.mkDerivation {
          inherit (pkgs.neovim) version;

          pname = "neovim";

          dontUnpack = true;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          buildInputs = [
            pkgs.neovim
            nvimPlugins
          ];

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/config/${nvimAppName}/nvim

            cp ${pkgs.neovim}/bin/nvim $out/bin/nvim
            cp -r ${./nvim}/* $out/config/${nvimAppName}/
            cp -r ${./efm-langserver} $out/config/efm-langserver

            wrapProgram $out/bin/nvim \
              --prefix PATH : ${
                lib.makeBinPath [
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
                  # html / css /json / eslint
                  pkgs.vscode-langservers-extracted
                  pkgs.nixfmt-rfc-style
                ]
              } \
              --set NVIM_APPNAME ${nvimAppName} \
              --set XDG_CONFIG_HOME $out/config \
              --set PLUGIN_PATH ${nvimPlugins} \
              --set LUA_PATH '${luaPath}' \
              --set LUA_CPATH '${luaCPath}' \
              # --add-flags "--cmd 'lua require([[lazy-patchs]])'" \
          '';

          meta = {
            description = "Jannis' Neovim config";
            homepage = "https://github.com/nyarthan/neovim";
            license = lib.licenses.asl20;
            platforms = lib.platforms.linux ++ lib.platforms.darwin;
          };
        };
      in
      {
        packages.default = neovim;

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };

        devShells.default = pkgs.mkShell { buildInputs = [ self.packages.${system}.default ] ++ plugins; };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
