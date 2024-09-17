{
  description = "Jannis' Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs) lib;

    systems = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    eachSystem = f:
      lib.foldAttrs lib.mergeAttrs {}
      (map (system: lib.mapAttrs (_: v: {${system} = v;}) (f system)) systems);

    nvimAppName = "nvim-${builtins.substring 7 (builtins.stringLength self.narHash) self.narHash}";
  in
    eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) vimPlugins;

        plugins = [
          vimPlugins.lazy-nvim
          vimPlugins.telescope-nvim
          vimPlugins.telescope-fzf-native-nvim
          vimPlugins.nvim-treesitter.withAllGrammars
          vimPlugins.plenary-nvim
          vimPlugins.oil-nvim
          vimPlugins.nvim-web-devicons
          vimPlugins.baleia-nvim
          vimPlugins.gitsigns-nvim
          vimPlugins.catppuccin-nvim
          vimPlugins.nvim-cmp
          vimPlugins.cmp-path
          vimPlugins.cmp-buffer
          vimPlugins.luasnip
        ];

        lazyPathFile =
          pkgs.writeText "lazy-patches.lua"
          /*
          lua
          */
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

            local pluginPaths = {
              ${lib.concatStringsSep ",\n" (map (plugin: ''["${plugin.pname}"] = "${plugin}"'') plugins)}
            }

            ${builtins.readFile ./lazy-patches.lua}
          '';

        luaPath = lib.concatStringsSep ";" ([
            "${vimPlugins.lazy-nvim}/lua/?.lua"
            "${vimPlugins.lazy-nvim}/lua/?/init.lua"
            "${pkgs.luajitPackages.jsregexp}/share/lua/5.1/?.lua"
          ]
          ++ ["${lazyPathFile}"]);

        luaCPath = lib.concatStringsSep ";" [
          "${pkgs.luajitPackages.jsregexp}/lib/lua/5.1/?.so"
        ];

        neovim = pkgs.stdenv.mkDerivation {
          inherit (pkgs.neovim) version;

          pname = "neovim";

          dontUnpack = true;

          nativeBuildInputs = [pkgs.makeWrapper];

          buildInputs =
            [
              pkgs.neovim
              pkgs.lua-language-server
              pkgs.ripgrep
              pkgs.fd
            ]
            ++ plugins;

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/config/${nvimAppName}/nvim

            cp ${pkgs.neovim}/bin/nvim $out/bin/nvim
            cp -r ${./nvim}/* $out/config/${nvimAppName}/

            wrapProgram $out/bin/nvim \
              --set NVIM_APPNAME ${nvimAppName} \
              --set XDG_CONFIG_HOME $out/config \
              --set LUA_PATH '${luaPath}' \
              --set LUA_CPATH '${luaCPath}' \
              --add-flags "--cmd 'lua require([[lazy-patch]])'" \
          '';

          meta = {
            description = "Jannis' Neovim config";
            homepage = "https://github.com/nyarthan/neovim";
            license = lib.licenses.asl20;
            platforms = lib.platforms.linux ++ lib.platforms.darwin;
          };
        };
      in {
        packages.default = neovim;

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            [
              self.packages.${system}.default
            ]
            ++ plugins;
        };
      }
    );
}
