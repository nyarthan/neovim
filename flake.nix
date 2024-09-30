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
          vimPlugins.mini-surround
        ];

        treesitterGrammars = pkgs.symlinkJoin {
          name = "treesitter-dependencies";
          paths = vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };

        neovimPlugins = pkgs.stdenv.mkDerivation {
          inherit (pkgs.neovim) version;
          pname = "neovim-plugins";
          dontUnpack = true;
          buildInputs = plugins;

          # Why symlink plugin contents instead of dir itself?
          # lazy.nvim does not resolve symlinks without setting dev = true
          # because it really wants to manage plugins itself
          # @see https://github.com/folke/lazy.nvim/issues/1063#issuecomment-1742003114
          installPhase = lib.concatMapStringsSep "\n" (plugin: ''
            mkdir -p $out/${plugin.pname}
            ln -s ${plugin}/* $out/${plugin.pname}/
          '') plugins;
        };

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

        luaCPath = lib.concatStringsSep ";" [
          "${pkgs.luajitPackages.jsregexp}/lib/lua/5.1/?.so"
          "/Users/jannis/dev/nvim-plugins/anyfmt/lua/anyfmt/?.dylib"
        ];

        luaPath = lib.concatStringsSep ";" ([
          "${vimPlugins.lazy-nvim}/lua/?.lua"
          "${vimPlugins.lazy-nvim}/lua/?/init.lua"
          "${pkgs.luajitPackages.jsregexp}/share/lua/5.1/?.lua"
        ]);

        neovim = pkgs.stdenv.mkDerivation {
          inherit (pkgs.neovim) version;

          pname = "neovim";

          dontUnpack = true;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          buildInputs = [
            pkgs.neovim
            neovimPlugins
          ];

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/config/${nvimAppName}/nvim

            cp ${pkgs.neovim}/bin/nvim $out/bin/nvim
            cp -r ${./nvim}/* $out/config/${nvimAppName}/
            cp -r ${./efm-langserver} $out/config/efm-langserver

            wrapProgram $out/bin/nvim \
              --prefix PATH : ${lib.makeBinPath extraDependencies} \
              --set NVIM_APPNAME ${nvimAppName} \
              --set XDG_CONFIG_HOME $out/config \
              --set LUA_PATH '${luaPath}' \
              --set LUA_CPATH '${luaCPath}' \
              --set NVIM_NIX_PLUGIN_PATH ${neovimPlugins} \
              --set NVIM_NIX_RTP '${treesitterGrammars}'
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

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.neovim ] ++ extraDependencies;
          shellHook = ''
            temp_config_dir=$(mktemp -d)

            ln -sf /Users/jannis/.config/neovim/nvim $temp_config_dir/nvim

            export NVIM_NIX_PLUGIN_PATH='${neovimPlugins}'
            export NVIM_NIX_RTP='${treesitterGrammars}'

            export LUA_PATH='${luaPath}'
            export LUA_CPATH='${luaCPath}'
            export XDG_CONFIG_HOME=$temp_config_dir

            echo "Starting neovim linked to config $temp_config_dir"

            nvim
          '';
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
