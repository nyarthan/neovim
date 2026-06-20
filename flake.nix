{
  description = "nyarthan's neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      neovim-nightly-overlay,
      nvim-lspconfig,
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
              rev = "f4a1d2a1d0d5df4333f2440500e3a6c4b4702d9a";
              hash = "sha256-LR87VhTPqkCtes5L2yhbrlbKg5PVavNPy620RLwrOB0=";
              fetchSubmodules = false;
            };
          });

          runtimeDeps = with pkgs; [
            # tsgo
            deno
            fd
            lua-language-server
            nix-doc
            nixd
            nixfmt
            oxfmt
            ripgrep
            rust-analyzer
            sql-formatter
            sqls
            stdenv.cc.cc
            stylua
            tailwindcss-language-server
            taplo
            typescript-language-server
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
              plugin = otter-nvim;
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
            {
              plugin = pkgs.vimUtils.buildVimPlugin {
                name = "nvim-lspconfig";
                src = nvim-lspconfig;
              };
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
