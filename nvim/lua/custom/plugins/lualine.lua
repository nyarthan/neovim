local Symbols = require "custom.symbols"

local components = {
  navic = {
    function()
      local navic = require "nvim-navic"

      local location = navic.get_location()

      if location == "" or not navic.is_available() then
        return string.format("%s Root", Symbols.nf.cod_root_folder)
      end

      return location
    end,
  },
}

local function noice_cmd(cmd)
  return function() return require("noice").cmd(cmd) end
end

return {
  "lualine.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    { "nvim-navic", lazy = false, opts = { highlight = true } },
  },
  opts = function()
    return {
      options = {
        section_separators = { left = "", right = "" },
        globalstatus = true,
        component_separators = {
          left = Symbols.unicode.light_quadruple_dash_vertical,
          right = Symbols.unicode.light_quadruple_dash_vertical,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          {
            require("noice").api.status.command.get,
            cond = require("noice").api.status.command.has,
            color = { fg = "#ff9e64" },
          },
          {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
            color = { fg = "#ff9e64" },
          },
          {
            require("noice").api.status.search.get,
            cond = require("noice").api.status.search.has,
            color = { fg = "#ff9e64" },
          },
        },
        lualine_y = { "fileformat", "filetype" },
        lualine_z = { "location" },
      },
      winbar = {
        lualine_c = {
          components.navic,
        },
      },
      inactive_winbar = {
        lualine_c = {
          components.navic,
        },
      },
    }
  end,
}
