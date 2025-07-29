local Util = require "custom.util"

return {
  "folke/trouble.nvim",
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      Util.make_cmd "Trouble diagnostics toggle",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      Util.make_cmd "Trouble diagnostics toggle filter.buf=0",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>xs",
      Util.make_cmd "Trouble symbols toggle focus=false",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>xl",
      Util.make_cmd "Trouble lsp toggle focus=false win.position=right",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      Util.make_cmd "Trouble loclist toggle",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      Util.make_cmd "Trouble qflist toggle",
      desc = "Quickfix List (Trouble)",
    },
  },
}
