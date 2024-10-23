return {
  "catppuccin-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "catppuccin"

    vim.api.nvim_set_hl(0, "Normal", { fg = "#CDD6F4", bg = "#101010" })
    vim.api.nvim_set_hl(0, "Pmenu", { fg = "#FFFFFF", bg = "#101010" })
    vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#FFC799", bg = "#232323" })
    vim.api.nvim_set_hl(0, "PmenuSbar", { fg = "NONE", bg = "#101010" })
    vim.api.nvim_set_hl(0, "PmenuThumb", { fg = "NONE", bg = "#343434" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#343434", bg = "#101010" })

    vim.api.nvim_set_hl(
      0,
      "CmpItemAbbrDeprecated",
      { fg = "#7E8294", bg = "NONE", strikethrough = true }
    )
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

    vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#B5585F", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#B5585F", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#B5585F", bg = "NONE" })

    vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9FBD73", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#9FBD73", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#9FBD73", bg = "NONE" })

    vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#D4BB6C", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#D4BB6C", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#D4BB6C", bg = "NONE" })

    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#A377BF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#A377BF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#A377BF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#A377BF", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#A377BF", bg = "NONE" })

    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#7E8294", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#7E8294", bg = "NONE" })

    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#D4A959", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#D4A959", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#D4A959", bg = "NONE" })

    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#6C8ED4", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#6C8ED4", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#6C8ED4", bg = "NONE" })

    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#58B5A8", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#58B5A8", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#58B5A8", bg = "NONE" })
  end,
}
