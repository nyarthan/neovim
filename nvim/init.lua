require "custom.core.options"
require "custom.core.keymaps"

require("lazy").setup({
  require "custom.plugins.telescope",
  require "custom.plugins.oil",
  require "custom.plugins.baleia",
  require "custom.plugins.gitsigns",
  require "custom.plugins.treesitter",
  require "custom.plugins.colorscheme",
  require "custom.plugins.completion",
  require "custom.plugins.comment",
  require "custom.plugins.lsp",
  require "custom.plugins.autopairs",
  require "custom.plugins.indent",
  require "custom.plugins.lualine",

  -- TODO: dependencies should be handled by nix + lazy patch
  { "plenary.nvim" },
  { "telescope-fzf-native.nvim" },
  { "nvim-web-devicons" },
  { "cmp-path" },
  { "cmp-buffer" },
  { "luasnip" },
  { "nvim-ts-context-commentstring" },
  { "j-hui/fidget.nvim" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "nvim-navic" },
}, {
  defaults = {
    lazy = true,
  },
  install = {
    missing = false,
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
