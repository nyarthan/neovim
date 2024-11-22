-- return {
--   "eventide.nvim",
--   dev = true,
--   lazy = false,
--   priority = 1001,
--   config = function() vim.cmd [[colorscheme eventide]] end,
-- }

return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    compile = true,
    undercurl = true,
    commentStyle = { italic = true },
    background = {
      dark = "dragon",
      light = "lotus",
    },
  },
  config = function() vim.cmd [[colorscheme kanagawa-dragon]] end,
}
