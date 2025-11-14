{
  pkgs,
  neovimPlugins,
  nvimAppName,
  luaPath,
  luaCPath,
  treesitter-dependencies,
  ...
}:
let
  inherit (pkgs) lib;

  extraDependencies = [
  ];
in

pkgs.stdenv.mkDerivation {
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
    cp -r ${../../nvim}/* $out/config/${nvimAppName}/

    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath extraDependencies} \
      --set NVIM_APPNAME ${nvimAppName} \
      --set XDG_CONFIG_HOME $out/config \
      --set LUA_PATH '${luaPath}' \
      --set LUA_CPATH '${luaCPath}' \
      --set NVIM_NIX_PLUGIN_PATH '${neovimPlugins}' \
      --set NVIM_NIX_RTP '${treesitter-dependencies}'
  '';

  meta = {
    description = "Jannis' Neovim config";
    homepage = "https://github.com/nyarthan/neovim";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
