return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  enabled = false,
  event = "BufEnter",
  opts = {
    disabled_filetypes = { "qf", "lazy", "oil" },
  },
}
