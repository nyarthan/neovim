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
        ];

        lazyPathFile =
          pkgs.writeText "lazy-patches.lua"
          /*
          lua
          */
          ''
            local pluginPaths = {
              ${lib.concatStringsSep ",\n" (map (plugin: ''["${plugin.pname}"] = "${plugin}"'') plugins)}
            }

            ${builtins.readFile ./lazy-patches.lua}
          '';

        nixLuaPaths = lib.concatStringsSep ";" ([
            "${vimPlugins.lazy-nvim}/lua/?.lua"
            "${vimPlugins.lazy-nvim}/lua/?/init.lua"
          ]
          ++ ["${lazyPathFile}"]);

        neovim = pkgs.stdenv.mkDerivation {
          inherit (pkgs.neovim) version;

          pname = "neovim";

          dontUnpack = true;

          nativeBuildInputs = [pkgs.makeWrapper];

          buildInputs = [pkgs.neovim pkgs.lua-language-server pkgs.ripgrep pkgs.fd] ++ plugins;

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/config/${nvimAppName}/nvim

            cp ${pkgs.neovim}/bin/nvim $out/bin/nvim
            cp -r ${./nvim}/* $out/config/${nvimAppName}/

            wrapProgram $out/bin/nvim \
              --set NVIM_APPNAME ${nvimAppName} \
              --set XDG_CONFIG_HOME $out/config \
              --set LUA_PATH '${nixLuaPaths}' \
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
