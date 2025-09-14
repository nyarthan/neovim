return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  main = "nvim-treesitter.configs",
  opts = {
    auto_install = false,

    highlight = {
      enable = true,
    },

    indent = {
      enable = true,
    },

    additional_vim_regex_highlighting = false,
  },
}
