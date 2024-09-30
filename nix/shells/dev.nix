{
  pkgs,
  extraDependencies,
  neovimPlugins,
  treesitterGrammars,
  luaPath,
  luaCPath,
}:
pkgs.mkShell {
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
}
