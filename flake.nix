{
  description = "nyarthan's neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      nixpkgs,
      neovim-nightly-overlay,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;

      pkgsFor = system: import nixpkgs { inherit system; };

      nvimFor =
        system:
        let
          pkgs = pkgsFor system;
          neovim-unwrapped = neovim-nightly-overlay.packages.${system}.neovim;

          tsgo = pkgs.typescript-go.overrideAttrs (_: {
            src = pkgs.fetchFromGitHub {
              owner = "microsoft";
              repo = "typescript-go";
              rev = "98545e9a34274cb61b4b521b8f49336e1ddff08a";
              hash = "sha256-IvR7zHSl7kUmamQkGGrzdKJrdypnQe2a0X1YUyRYYTU=";
              fetchSubmodules = false;
            };
          });

          runtimeDeps = with pkgs; [
            deno
            fd
            lua-language-server
            nix-doc
            nixd
            nixfmt
            ripgrep
            rust-analyzer
            stdenv.cc.cc
            stylua
            tailwindcss-language-server
            taplo
            tsgo
            universal-ctags
            vscode-langservers-extracted
            vue-language-server
            yaml-language-server
          ];

          luaConfig = pkgs.runCommand "nvim-lua-config" { } ''
            mkdir -p $out/lua
            cp ${./init.lua} $out/init.lua
            cp -r ${./lua}/. $out/lua/
          '';
        in
        pkgs.wrapNeovimUnstable neovim-unwrapped {
          plugins = with pkgs.vimPlugins; [
            {
              plugin = conform-nvim;
              optional = false;
            }
            {
              plugin = mini-nvim;
              optional = false;
            }
            {
              plugin = nvim-treesitter.withAllGrammars;
              optional = false;
            }
            {
              plugin = nvim-ts-autotag;
              optional = false;
            }
            {
              plugin = nvim-ts-context-commentstring;
              optional = false;
            }
            {
              plugin = snacks-nvim;
              optional = false;
            }
            {
              plugin = trouble-nvim;
              optional = false;
            }
          ];
          withNodeJs = false;
          withRuby = false;
          withPython3 = false;
          vimAlias = true;
          luaRcContent = ''
            vim.opt.rtp:prepend("${luaConfig}")
            vim.cmd.packloadall()
            dofile("${luaConfig}/init.lua")
          '';
          wrapperArgs = [
            "--prefix"
            "PATH"
            ":"
            "${pkgs.lib.makeBinPath runtimeDeps}"
          ];
        };
    in
    {
      packages = forEachSystem (system: {
        default = nvimFor system;
        nvim = nvimFor system;
      });

      devShells = forEachSystem (system: {
        default = (pkgsFor system).mkShell {
          name = "nvim";
          packages = [ (nvimFor system) ];
        };
      });
    };
}
