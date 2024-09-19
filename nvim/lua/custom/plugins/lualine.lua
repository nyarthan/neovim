local Symbols = require "custom.symbols"

return {
  "lualine.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      section_separators = { left = "", right = "" },
      component_separators = {
        left = Symbols.unicode.light_quadruple_dash_vertical,
        right = Symbols.unicode.light_quadruple_dash_vertical,
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "searchcount" },
      lualine_y = { "fileformat", "filetype" },
      lualine_z = { "location" },
    },
  },
}
