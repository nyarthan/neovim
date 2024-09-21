local Color = require "custom.color"

local function key_desc(desc) return string.format("%s " .. desc, Color.green "[NOICE]") end

local function noice_cmd(cmd)
  return function() return require("noice").cmd(cmd) end
end

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        silent = true,
      },
    },
  },
  keys = {
    {
      "<Leader>nh",
      mode = "n",
      desc = key_desc "[N]oice show message [h]istory",
      noice_cmd "history",
    },
    {
      "<Leader>nl",
      mode = "n",
      desc = key_desc "[N]oice show [l]ast message",
      noice_cmd "last",
    },
    {
      "<Leader>nd",
      mode = "n",
      desc = key_desc "[N]oice [d]ismiss visible messages",
      noice_cmd "dismiss",
    },
    {
      "<Leader>ne",
      mode = "n",
      desc = key_desc "[N]oice show [e]rrors",
      noice_cmd "errors",
    },
    {
      "<Leader>nD",
      mode = "n",
      desc = key_desc "[N]oice [d]isable",
      noice_cmd "disable",
    },
    {
      "<Leader>nE",
      mode = "n",
      desc = key_desc "[N]oice [e]nable",
      noice_cmd "enable",
    },
    {
      "<Leader>ns",
      mode = "n",
      desc = key_desc "[N]oice show debugging [s]tats",
      noice_cmd "stats",
    },
    {
      "<Leader>nt",
      mode = "n",
      desc = key_desc "[N]oice show message history in [t]elescope",
      noice_cmd "telescope",
    },
    {
      -- <S-Enter> / <C-Enter> gets incorrectly passed by zellij
      -- @see https://github.com/zellij-org/zellij/issues/3540
      "<C-y>",
      mode = "c",
      desc = key_desc "[N]oice redirect cmd output to popup",
      function() require("noice").redirect(vim.fn.getcmdline()) end,
    },
    {
      "<C-b>",
      mode = { "n", "i", "s" },
      function()
        if not require("noice.lsp").scroll(-4) then return "<c-b>" end
      end,
    },
    {
      "<C-f>",
      mode = { "n", "i", "s" },
      function()
        if not require("noice.lsp").scroll(4) then return "<c-f>" end
      end,
    },
  },
}
