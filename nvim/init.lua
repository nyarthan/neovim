--[[
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
]]--

-- require("lazy").setup({})

-- Set leader key
vim.g.mapleader = " "

-- Function to add Nix-installed plugins to runtimepath
local function add_nix_plugins_to_runtimepath()
  local nix_plugin_paths = os.getenv("NIX_PLUGIN_PATHS") or ""
  for path in string.gmatch(nix_plugin_paths, '([^:]+)') do
    vim.opt.runtimepath:append(path)
  end
end

add_nix_plugins_to_runtimepath()

-- Initialize lazy.nvim without installing plugins
require("lazy").setup({
  {
    "lazy.nvim",
    lazy = false,
    config = function()
      -- lazy.nvim configuration if needed
    end,
  },
  {
    "telescope.nvim",
    lazy = false,
    config = function() end,
  },
  {
    "nvim-treesitter",
    main = "nvim-treesitter.configs",
    opts = {},
  },
  -- Add other plugins with `lazy = false`
}, {
  performance = {
    rtp = {
      reset = false, -- Do not reset runtimepath
    },
  },
})

-- Additional Neovim configuration...

require('theme')
