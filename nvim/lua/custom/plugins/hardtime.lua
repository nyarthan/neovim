return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  event = "BufEnter",
  opts = {
    disabled_filetypes = { "qf", "lazy", "oil" },
  },
}
