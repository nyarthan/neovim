require("nixCatsUtils").setup {
  non_nix_value = true,
}

vim.g.have_nerd_font = nixCats "have_nerd_font"

require "custom.core.standard-plugins"
require "custom.core.providers"

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
