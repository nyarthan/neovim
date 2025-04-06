return {
  "catppuccin-nvim",
  name = "catppuccin-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      flavor = "mocha",
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
      -- integrations = {
      --   telescope = {
      --     enabled = true,
      --     style = "nvchad",
      --   },
      -- },
    }
    vim.cmd.colorscheme "catppuccin"
  end,
}
