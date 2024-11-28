return {
  "datsfilipe/vesper.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(opts)
    require("vesper").setup(opts)
    vim.cmd.colorscheme "vesper"
  end,
}
