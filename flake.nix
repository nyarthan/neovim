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
  in
    eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) vimPlugins;
        plugins = [
          vimPlugins.lazy-nvim
          vimPlugins.telescope-nvim
          vimPlugins.nvim-treesitter.withAllGrammars
          # Add more plugins here if needed
        ];

        # Construct NIX_PLUGIN_PATHS in Nix
        nixPluginPaths = lib.concatStringsSep ":" (map (plugin: "${plugin}/share/vim-plugins/*") plugins);

        # Construct LUA_PATH in Nix
        nixLuaPaths = lib.concatStringsSep ";" (lib.concatLists (map (plugin: [
            "${plugin}/lua/?.lua"
            "${plugin}/lua/?/init.lua"
          ])
          plugins));
      in {
        packages.default = pkgs.neovim;

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

          shellHook = ''
            export NIX_PLUGIN_PATHS='${nixPluginPaths}'
            export LUA_PATH='${nixLuaPaths}'

            # Set XDG_CONFIG_HOME to the current directory
            export XDG_CONFIG_HOME=$(pwd)

            # Optional: Print the environment variables for debugging
            echo "NIX_PLUGIN_PATHS is set to: $NIX_PLUGIN_PATHS"
            echo "LUA_PATH is set to: $LUA_PATH"
            echo "XDG_CONFIG_HOME is set to: $XDG_CONFIG_HOME"
          '';
        };
      }
    );
}
