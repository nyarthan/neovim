require "custom.core.options"
require "custom.core.keymaps"

local lazy = require "lazy"

lazy.setup {
  spec = { import = "custom.plugins" },
  root = os.getenv "PLUGIN_PATH",
  defaults = {
    lazy = true,
  },
  install = {
    missing = false,
  },
  dev = {
    path = "~/dev/nvim-plugins",
  },
  performance = {
    rtp = {
      reset = false,
    },
  },
}

local autocmds = require "custom.core.autocmds"

autocmds.GitCheck
  :new({
    function(is_in_git_repo)
      if not is_in_git_repo then return end

      vim.api.nvim_exec_autocmds("User", { pattern = "GitRepoDetected" })
    end,
  })
  :enable()
