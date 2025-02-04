require "custom.core.startup"
require "custom.core.options"
require "custom.core.keymaps"

local lazy = require "lazy"

lazy.setup {
  spec = { import = "custom.plugins" },
  root = os.getenv "NVIM_NIX_PLUGIN_PATH",
  defaults = {
    lazy = true,
  },
  install = {
    missing = false,
  },
  dev = {
    path = "~/dev/support/nvim-plugins",
  },
  performance = {
    rtp = {
      reset = false,
    },
  },
}

require("custom.statuscolumn").setup()

local autocmds = require "custom.core.autocmds"

autocmds.GitCheck
  :new({
    function(is_in_git_repo)
      if not is_in_git_repo then return end

      vim.api.nvim_exec_autocmds("User", { pattern = "GitRepoDetected" })
    end,
  })
  :enable()

autocmds.ObsidianCheck
  :new({
    function(is_in_vault)
      if not is_in_vault then return end

      vim.api.nvim_exec_autocmds("User", { pattern = "ObsidianVaultDetected" })
    end,
  }, "/Users/jannis/second-brain/")
  :enable()
