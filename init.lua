require("nixCatsUtils").setup {
  non_nix_value = true,
}

vim.g.have_nerd_font = nixCats "have_nerd_font"

require "custom.core.options"
require "custom.core.keymaps"

local lazyCat = require "nixCatsUtils.lazyCat"

lazyCat.setup(nixCats.pawsible { "allPlugins", "start", "lazy.nvim" }, {
  spec = { import = "custom.plugins" },
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
})

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
